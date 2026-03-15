const { pool } = require('../database/db');
const { normalizeRawNumeric, buildRawNumericMap, parseRawNumericMap, rawOrValue } = require('../utils/rawNumbers');
const Excel = require('exceljs');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

// دالة لتقريب الأرقام العشرية بشكل صحيح
const roundToDecimal = (value, decimals = 2) => {
    if (typeof value !== 'number' || isNaN(value)) {
        return 0;
    }
    const factor = Math.pow(10, decimals);
    const result = Math.round(value * factor) / factor;
    return result;
};

const ARABIC_TEXT_REGEX = /[\u0600-\u06FF]/;
const translationCache = new Map();

const translateArabicToEnglish = async (value) => {
    const text = (value === null || value === undefined) ? '' : String(value).trim();
    if (!text || !ARABIC_TEXT_REGEX.test(text)) return value;
    if (translationCache.has(text)) return translationCache.get(text);

    try {
        const endpoint = `https://translate.googleapis.com/translate_a/single?client=gtx&sl=ar&tl=en&dt=t&q=${encodeURIComponent(text)}`;
        const response = await fetch(endpoint, { method: 'GET' });
        if (!response.ok) throw new Error(`Translate HTTP ${response.status}`);
        const data = await response.json();
        const translated = Array.isArray(data?.[0])
            ? data[0].map((chunk) => (Array.isArray(chunk) ? (chunk[0] || '') : '')).join('')
            : text;
        const safeResult = translated && translated.trim() ? translated.trim() : text;
        translationCache.set(text, safeResult);
        return safeResult;
    } catch (_) {
        translationCache.set(text, text);
        return text;
    }
};

const translateObjectFieldsToEnglish = async (obj, fields) => {
    if (!obj || typeof obj !== 'object') return obj;
    for (const field of fields) {
        if (Object.prototype.hasOwnProperty.call(obj, field) && obj[field] !== null && obj[field] !== undefined && obj[field] !== '') {
            obj[field] = await translateArabicToEnglish(obj[field]);
        }
    }
    return obj;
};

const normalizeAuxiliaryCostsByBasis = ({
    basis,
    usd,
    syp,
    grossWeight,
    packagingWeight
}) => {
    const unitWeightKg = packagingWeight > 0 ? packagingWeight : 0;

    const totalUnits = unitWeightKg > 0 ? (grossWeight / unitWeightKg) : 0;

    const divOrZero = (value, denom) => (denom > 0 ? (value / denom) : 0);

    const normalizedUsd = { ...usd };
    const normalizedSyp = { ...syp };

    const perUnitFields = ['sticker_price', 'additional_expenses', 'labor_cost', 'preservatives_cost'];
    if (basis === 'per_kg') {
        perUnitFields.forEach((field) => {
            normalizedUsd[field] = (usd[field] || 0) * unitWeightKg;
            normalizedSyp[field] = (syp[field] || 0) * unitWeightKg;
        });
    } else if (basis === 'total') {
        perUnitFields.forEach((field) => {
            normalizedUsd[field] = divOrZero((usd[field] || 0), totalUnits);
            normalizedSyp[field] = divOrZero((syp[field] || 0), totalUnits);
        });
    }

    return { usd: normalizedUsd, syp: normalizedSyp };
};

const parseAdditionalExpenseItems = (value) => {
    let arr = [];
    try {
        if (Array.isArray(value)) arr = value;
        else if (typeof value === 'string' && value.trim()) arr = JSON.parse(value);
    } catch (_) {
        arr = [];
    }
    if (!Array.isArray(arr)) return [];
    return arr
        .map((item) => {
            const name = (item && typeof item.name === 'string') ? item.name.trim() : '';
            const rawPrice = normalizeRawNumeric(item && item.price);
            const parsedPrice = parseFloat(item && item.price);
            const numericPrice = Number.isFinite(parsedPrice) ? parsedPrice : 0;
            return {
                name,
                // Keep the original numeric text (e.g. 1.500) when available.
                price: rawPrice !== null ? rawPrice : String(numericPrice)
            };
        })
        .filter((item) => item.name || (parseFloat(item.price) || 0) > 0);
};

const MATERIAL_RAW_FIELDS = [
    'price_before_waste',
    'price_before_waste_syp',
    'gross_weight',
    'waste_percentage',
    'packaging_weight',
    'packaging_unit_weight',
    'empty_package_price',
    'empty_package_price_syp',
    'sticker_price',
    'sticker_price_syp',
    'additional_expenses',
    'additional_expenses_syp',
    'labor_cost',
    'labor_cost_syp',
    'preservatives_cost',
    'preservatives_cost_syp',
    'carton_price',
    'carton_price_syp',
    'pieces_per_package',
    'pallet_price',
    'pallet_price_syp',
    'packages_per_pallet',
    'external_unit_cost',
    'external_package_cost',
    'external_net_weight',
    'external_cost_per_kg',
    'external_unit_cost_syp',
    'external_package_cost_syp',
    'external_cost_per_kg_syp'
];

const QUOTATION_HEADER_RAW_FIELDS = [
    'general_profit_percentage',
    'total_amount',
    'total_amount_syp'
];
const QUOTATION_ITEM_RAW_FIELDS = [
    'unit_cost',
    'profit_percentage',
    'final_price',
    'quantity',
    'total_price',
    'packaging_weight',
    'pieces_per_package',
    'package_cost'
];

const ORDER_HEADER_RAW_FIELDS = ['pallets_count', 'packages_count'];
const ORDER_ITEM_RAW_FIELDS = [
    'requested_quantity',
    'weight',
    'volume',
    'unit_price',
    'total_price',
    'net_weight',
    'gross_weight'
];
const COMPONENT_RAW_FIELDS = ['weight_grams', 'price_per_kg', 'price_per_kg_syp'];
const COST_LOG_RAW_FIELDS = ['unit_cost', 'unit_cost_syp', 'package_cost', 'package_cost_syp'];

const applyMaterialRaw = (material) => {
    if (!material || typeof material !== 'object') return material;
    const rawMap = parseRawNumericMap(material.numeric_raw);
    const mapped = { ...material };

    MATERIAL_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });

    mapped.unit_cost = rawOrValue(rawMap, 'external_unit_cost', mapped.unit_cost);
    mapped.package_cost = rawOrValue(rawMap, 'external_package_cost', mapped.package_cost);
    mapped.unit_cost_syp = rawOrValue(rawMap, 'external_unit_cost_syp', mapped.unit_cost_syp);
    mapped.package_cost_syp = rawOrValue(rawMap, 'external_package_cost_syp', mapped.package_cost_syp);
    mapped.price_before_waste = rawOrValue(rawMap, 'external_cost_per_kg', mapped.price_before_waste);
    mapped.packaging_weight = rawOrValue(rawMap, 'external_net_weight', mapped.packaging_weight);
    mapped.gross_weight = rawOrValue(rawMap, 'external_net_weight', mapped.gross_weight);
    mapped.gross_package_weight = rawOrValue(rawMap, 'external_net_weight', mapped.gross_package_weight);

    return mapped;
};

const applyQuotationRaw = (quotation) => {
    if (!quotation || typeof quotation !== 'object') return quotation;
    const rawMap = parseRawNumericMap(quotation.numeric_raw);
    const mapped = { ...quotation };
    QUOTATION_HEADER_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });
    return mapped;
};

const applyQuotationItemRaw = (item) => {
    if (!item || typeof item !== 'object') return item;
    const rawMap = parseRawNumericMap(item.numeric_raw);
    const mapped = { ...item };
    QUOTATION_ITEM_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });
    return mapped;
};

const applyOrderRaw = (order) => {
    if (!order || typeof order !== 'object') return order;
    const rawMap = parseRawNumericMap(order.numeric_raw);
    const mapped = { ...order };
    ORDER_HEADER_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });
    return mapped;
};

const applyOrderItemRaw = (item) => {
    if (!item || typeof item !== 'object') return item;
    const rawMap = parseRawNumericMap(item.numeric_raw);
    const mapped = { ...item };
    ORDER_ITEM_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });
    return mapped;
};

const applyMaterialComponentRaw = (component) => {
    if (!component || typeof component !== 'object') return component;
    const rawMap = parseRawNumericMap(component.numeric_raw);
    const mapped = { ...component };
    COMPONENT_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });
    return mapped;
};

const applyCostLogRaw = (log) => {
    if (!log || typeof log !== 'object') return log;
    const rawMap = parseRawNumericMap(log.numeric_raw);
    const mapped = { ...log };
    COST_LOG_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });
    return mapped;
};

// عرض صفحة التكاليف الرئيسية
const getCosts = async (req, res) => {
    try {
        const [materials] = await req.db.query(`
            SELECT * FROM materials 
            WHERE deleted_at IS NULL
            ORDER BY created_at DESC
        `);
        
        const [quotations] = await req.db.query(`
            SELECT q.*, COUNT(qi.id) as items_count 
            FROM quotations q 
            LEFT JOIN quotation_items qi ON q.id = qi.quotation_id 
            GROUP BY q.id 
            ORDER BY q.created_at DESC
        `);
        
        const [orders] = await req.db.query(`
            SELECT * FROM orders 
            ORDER BY created_at DESC
        `);

        // اختيار القيم حسب العملة المحددة
        const displayMaterials = materials.map((material) => {
            const rawMaterial = applyMaterialRaw(material);
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                return {
                    ...rawMaterial,
                    unit_cost: rawMaterial.unit_cost_syp || rawMaterial.unit_cost,
                    package_cost: rawMaterial.package_cost_syp || rawMaterial.package_cost
                };
            } else {
                return rawMaterial;
            }
        });

        const displayQuotations = quotations.map((quotation) => {
            const rawQuotation = applyQuotationRaw(quotation);
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                return {
                    ...rawQuotation,
                    total_amount: rawQuotation.total_amount_syp || rawQuotation.total_amount
                };
            } else {
                return rawQuotation;
            }
        });

        res.render('costs/index', {
            title: 'إدارة التكاليف',
            materials: displayMaterials,
            quotations: displayQuotations,
            orders,
            formatDate
        });
    } catch (error) {
        console.error('خطأ في عرض صفحة التكاليف:', error);
        req.flash('error_msg', 'حدث خطأ في عرض صفحة التكاليف');
        res.redirect('/');
    }
};

// عرض صفحة بيان الكلفة
const getCostStatement = async (req, res) => {
    try {
        const [materials] = await req.db.query(`
            SELECT * FROM materials 
            WHERE deleted_at IS NULL
            ORDER BY created_at DESC
        `);
        // جلب سعر الصرف الحالي لعرضه في الواجهة واستخدامه في التحويلات على الواجهة
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;
        
        // اختيار القيم حسب العملة المحددة
        const displayMaterials = materials.map((material) => {
            const rawMaterial = applyMaterialRaw(material);
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                return {
                    ...rawMaterial,
                    unit_cost: rawMaterial.unit_cost_syp || rawMaterial.unit_cost,
                    package_cost: rawMaterial.package_cost_syp || rawMaterial.package_cost
                };
            } else {
                return rawMaterial;
            }
        });
        
        res.render('costs/cost-statement', {
            title: 'بيان الكلفة',
            materials: displayMaterials,
            formatDate,
            exchangeRate: exchangeRateValue
        });
    } catch (error) {
        console.error('خطأ في عرض صفحة بيان الكلفة:', error);
        req.flash('error_msg', 'حدث خطأ في عرض صفحة بيان الكلفة');
        res.redirect('/costs');
    }
};

// حفظ مادة جديدة
const createMaterial = async (req, res) => {
    try {
        
        const {
            material_origin,
            material_type,
            material_name,
            calculation_method,
            price_before_waste,
            external_packaging_unit,
            external_unit_cost,
            external_package_cost,
            external_net_weight,
            external_cost_per_kg,
            gross_weight,
            waste_percentage,
            packaging_unit,
            packaging_weight,
            packaging_unit_weight,
            empty_package_price,
            sticker_price,
            additional_expenses,
            labor_cost,
            preservatives_cost,
            carton_price,
            pieces_per_package,
            pallet_price,
            packages_per_pallet,
            cost_input_basis,
            extra_weights,
            additional_expense_items,
            external_notes,
            components
        } = req.body;
        const materialOrigin = material_origin === 'external' ? 'external' : 'internal';

        if (materialOrigin === 'external') {
            const externalMaterialType = (material_type || '').trim();
            const name = (material_name || '').trim();
            const packagingUnit = (external_packaging_unit || '').trim();
            const netWeight = parseFloat(external_net_weight ?? gross_weight) || 0;
            const unitCost = parseFloat(external_unit_cost) || 0;
            const packageCost = parseFloat(external_package_cost) || 0;
            const costPerKg = parseFloat(external_cost_per_kg ?? price_before_waste) || 0;
            const notes = (typeof external_notes === 'string' && external_notes.trim()) ? external_notes.trim() : null;
            if (!externalMaterialType || !name || !packagingUnit || netWeight <= 0 || unitCost <= 0 || packageCost <= 0 || costPerKg <= 0) {
                return res.status(400).json({
                    success: false,
                    message: 'بيانات المادة الخارجية غير مكتملة'
                });
            }

            const [exchangeRate] = await req.db.query(`
                SELECT rate FROM exchange_rates 
                WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
                AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
            `);
            const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;
            const unitCostSyp = roundToDecimal(unitCost * exchangeRateValue, 0);
            const packageCostSyp = roundToDecimal(packageCost * exchangeRateValue, 0);
            const costPerKgSyp = roundToDecimal(costPerKg * exchangeRateValue, 0);
            const externalRawMap = buildRawNumericMap(req.body, [
                'external_unit_cost',
                'external_package_cost',
                'external_net_weight',
                'external_cost_per_kg',
                'external_unit_cost_syp',
                'external_package_cost_syp',
                'external_cost_per_kg_syp'
            ]);

            const [result] = await req.db.query(`
                INSERT INTO materials (
                    material_origin, material_type, material_name, external_notes, calculation_method,
                    price_before_waste, price_before_waste_syp, gross_weight, waste_percentage,
                    packaging_unit, packaging_weight, packaging_unit_weight,
                    empty_package_price, empty_package_price_syp, sticker_price, sticker_price_syp,
                    additional_expenses, additional_expenses_syp, labor_cost, labor_cost_syp,
                    preservatives_cost, preservatives_cost_syp, carton_price, carton_price_syp,
                    pieces_per_package, pallet_price, pallet_price_syp, packages_per_pallet,
                    unit_cost, unit_cost_syp, package_cost, package_cost_syp,
                    extra_weights, gross_package_weight, additional_expense_items, numeric_raw
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `, [
                'external', externalMaterialType, name, notes, 'traditional',
                costPerKg, costPerKgSyp, netWeight, 0,
                packagingUnit, netWeight, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                1, 0, 0, 1,
                unitCost, unitCostSyp, packageCost, packageCostSyp,
                JSON.stringify([]), netWeight, JSON.stringify([]), JSON.stringify(externalRawMap)
            ]);

            const externalCostLogRawMap = buildRawNumericMap(
                { unit_cost: unitCost, unit_cost_syp: unitCostSyp, package_cost: packageCost, package_cost_syp: packageCostSyp },
                COST_LOG_RAW_FIELDS
            );
            await req.db.query(`
                INSERT INTO cost_logs (material_id, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp, numeric_raw)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            `, [result.insertId, name, unitCost, unitCostSyp, packageCost, packageCostSyp, JSON.stringify(externalCostLogRawMap)]);

            return res.json({ success: true, message: 'تم حفظ المادة الخارجية بنجاح' });
        }

        // التحقق من البيانات المطلوبة
        if (!material_type || !material_name || !gross_weight) {
            return res.status(400).json({ 
                success: false, 
                message: 'البيانات المطلوبة غير مكتملة' 
            });
        }

        // التحقق من صحة طريقة الحساب
        const isComponentsMethod = calculation_method === 'components';
        
        if (isComponentsMethod) {
            // للطريقة الجديدة: التحقق من وجود عناصر
            if (!components || !Array.isArray(components) || components.length === 0) {
                return res.status(400).json({ 
                    success: false, 
                    message: 'يرجى إضافة عنصر واحد على الأقل للمادة' 
                });
            }
        } else {
            // للطريقة التقليدية: التحقق من وجود السعر
            if (!price_before_waste) {
                return res.status(400).json({ 
                    success: false, 
                    message: 'السعر قبل الهدر مطلوب للطريقة التقليدية' 
                });
            }
        }

        // جلب سعر الصرف الحالي
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;

        // تحويل البيانات إلى أرقام مع معالجة الأخطاء
        const gross_weight_num = parseFloat(gross_weight) || 0;
        const waste_percentage_num = parseFloat(waste_percentage) || 0;
        // نحفظ packaging_weight كما هو (نص) للحفاظ على الدقة
        const packaging_weight_for_calc = parseFloat(packaging_weight) || 0;
        const packaging_unit_weight_num = parseFloat(packaging_unit_weight) || 0;
        const pieces_per_package_num = parseInt(pieces_per_package) || 0;
        const packages_per_pallet_num = parseInt(packages_per_pallet) || 0;
        const costInputBasis = (cost_input_basis === 'per_kg' || cost_input_basis === 'total') ? cost_input_basis : 'total';


        // تجهيز الحقول المرتبطة بالعملة
        const currencyFields = [
            'price_before_waste', 'empty_package_price', 'sticker_price',
            'additional_expenses', 'labor_cost', 'preservatives_cost',
            'carton_price', 'pallet_price'
        ];

        const usd = {};
        const syp = {};
        
        currencyFields.forEach((field) => {
            const usdVal = parseFloat(req.body[field]);
            const sypBody = req.body[`${field}_syp`];
            const sypVal = sypBody !== undefined ? parseFloat(sypBody) : NaN;
            if (!Number.isNaN(usdVal)) {
                usd[field] = usdVal;
            } else if (!Number.isNaN(sypVal)) {
                usd[field] = sypVal / exchangeRateValue;
            } else {
                usd[field] = 0;
            }
            if (!Number.isNaN(sypVal)) {
                syp[field] = sypVal;
            } else {
                syp[field] = (usd[field] || 0) * exchangeRateValue;
            }
        });

        const additionalExpenseItemsArr = parseAdditionalExpenseItems(additional_expense_items);
        const additionalExpenseItemsTotalUsd = additionalExpenseItemsArr.reduce((sum, item) => sum + (parseFloat(item.price) || 0), 0);
        usd.additional_expenses = (usd.additional_expenses || 0) + additionalExpenseItemsTotalUsd;
        syp.additional_expenses = (syp.additional_expenses || 0) + (additionalExpenseItemsTotalUsd * exchangeRateValue);

        const normalizedCosts = normalizeAuxiliaryCostsByBasis({
            basis: costInputBasis,
            usd,
            syp,
            grossWeight: gross_weight_num,
            packagingWeight: packaging_weight_for_calc
        });
        Object.assign(usd, normalizedCosts.usd);
        Object.assign(syp, normalizedCosts.syp);

        // معالجة الأوزان الإضافية
        let extraWeightsArr = [];
        if (extra_weights && Array.isArray(extra_weights)) {
            extraWeightsArr = extra_weights.map(item => ({
                name: item.name || '',
                weight: normalizeRawNumeric(item.weight) ?? String(parseFloat(item.weight) || 0)
            }));
        }

        // حساب الوزن الإجمالي للطرد القائم
        const extraWeightsTotal = extraWeightsArr.reduce((sum, item) => sum + (parseFloat(item.weight) || 0), 0);
        const gross_package_weight = ((packaging_unit_weight_num + packaging_weight_for_calc) * pieces_per_package_num) + extraWeightsTotal;

        // الحسابات الأساسية
        const price_per_kg_before_waste = gross_weight_num > 0 ? (usd.price_before_waste || 0) / gross_weight_num : 0;
        const price_per_kg_before_waste_syp = gross_weight_num > 0 ? (syp.price_before_waste || 0) / gross_weight_num : 0;
        
        const denom = 1 - (waste_percentage_num / 100);
        const denomSyp = denom;
        
        const price_per_kg_after_waste = denom > 0 ? price_per_kg_before_waste / denom : 0;
        const price_per_kg_after_waste_syp = denomSyp > 0 ? price_per_kg_before_waste_syp / denomSyp : 0;
        
        const material_cost_in_unit = price_per_kg_after_waste * packaging_weight_for_calc;
        const material_cost_in_unit_syp = price_per_kg_after_waste_syp * packaging_weight_for_calc;
        
        const total_packaging_costs = 
            (usd.empty_package_price || 0) + (usd.sticker_price || 0) + (usd.additional_expenses || 0) +
            (usd.labor_cost || 0) + (usd.preservatives_cost || 0);
        const total_packaging_costs_syp = 
            (syp.empty_package_price || 0) + (syp.sticker_price || 0) + (syp.additional_expenses || 0) +
            (syp.labor_cost || 0) + (syp.preservatives_cost || 0);
        
        const unit_cost = material_cost_in_unit + total_packaging_costs;
        const unit_cost_syp = material_cost_in_unit_syp + total_packaging_costs_syp;
        
        const pallet_share = packages_per_pallet_num > 0 ? (usd.pallet_price || 0) / packages_per_pallet_num : 0;
        const pallet_share_syp = packages_per_pallet_num > 0 ? (syp.pallet_price || 0) / packages_per_pallet_num : 0;
        
        const package_cost = (unit_cost * pieces_per_package_num) + (usd.carton_price || 0) + pallet_share;
        const package_cost_syp = (unit_cost_syp * pieces_per_package_num) + (syp.carton_price || 0) + pallet_share_syp;
        const internalRawMap = buildRawNumericMap(req.body, MATERIAL_RAW_FIELDS);


        // حفظ المادة
        const [result] = await req.db.query(`
            INSERT INTO materials (
                material_origin, material_type, material_name, external_notes, calculation_method, price_before_waste, price_before_waste_syp,
                gross_weight, waste_percentage, packaging_unit, packaging_weight,
                packaging_unit_weight,
                empty_package_price, empty_package_price_syp, sticker_price, sticker_price_syp,
                additional_expenses, additional_expenses_syp, labor_cost, labor_cost_syp,
                preservatives_cost, preservatives_cost_syp, carton_price, carton_price_syp,
                pieces_per_package, pallet_price, pallet_price_syp, packages_per_pallet,
                unit_cost, unit_cost_syp, package_cost, package_cost_syp,
                extra_weights, gross_package_weight, additional_expense_items, numeric_raw
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            'internal', material_type, material_name, null, calculation_method || 'traditional', (usd.price_before_waste || 0), (syp.price_before_waste || 0),
            gross_weight_num, waste_percentage_num, packaging_unit, packaging_weight,
            packaging_unit_weight_num,
            (usd.empty_package_price || 0), (syp.empty_package_price || 0), (usd.sticker_price || 0), (syp.sticker_price || 0),
            (usd.additional_expenses || 0), (syp.additional_expenses || 0), (usd.labor_cost || 0), (syp.labor_cost || 0),
            (usd.preservatives_cost || 0), (syp.preservatives_cost || 0), (usd.carton_price || 0), (syp.carton_price || 0),
            pieces_per_package_num, (usd.pallet_price || 0), (syp.pallet_price || 0), packages_per_pallet_num,
            unit_cost, unit_cost_syp, package_cost, package_cost_syp,
            JSON.stringify(extraWeightsArr || []), gross_package_weight, JSON.stringify(additionalExpenseItemsArr || []), JSON.stringify(internalRawMap)
        ]);

        // حفظ العناصر الفرعية إذا كانت الطريقة هي العناصر
        if (isComponentsMethod && components && Array.isArray(components)) {
            for (const component of components) {
                if (component.component_name && component.weight_grams && component.price_per_kg) {
                    // حساب السعر بالليرة السورية
                    const price_per_kg_syp = parseFloat(component.price_per_kg) * exchangeRateValue;
                    
                    const componentRawMap = buildRawNumericMap(
                        { ...component, price_per_kg_syp },
                        COMPONENT_RAW_FIELDS
                    );
                    await req.db.query(`
                        INSERT INTO material_components (
                            material_id, component_name, weight_grams, price_per_kg, price_per_kg_syp, numeric_raw
                        ) VALUES (?, ?, ?, ?, ?, ?)
                    `, [
                        result.insertId, 
                        component.component_name, 
                        parseFloat(component.weight_grams), 
                        parseFloat(component.price_per_kg),
                        price_per_kg_syp,
                        JSON.stringify(componentRawMap)
                    ]);
                }
            }
        }

        // حفظ في سجل التكاليف
        const createdCostLogRawMap = buildRawNumericMap(
            { unit_cost, unit_cost_syp, package_cost, package_cost_syp },
            COST_LOG_RAW_FIELDS
        );
        await req.db.query(`
            INSERT INTO cost_logs (material_id, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp, numeric_raw)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `, [result.insertId, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp, JSON.stringify(createdCostLogRawMap)]);

        res.json({ success: true, message: 'تم حفظ المادة بنجاح' });
    } catch (error) {
        console.error('خطأ في حفظ المادة:', error);
        console.error('Error stack:', error.stack);
        res.status(500).json({ 
            success: false, 
            message: 'حدث خطأ في حفظ المادة',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// جلب العناصر الفرعية للمادة
const getMaterialComponents = async (req, res) => {
    try {
        const { id } = req.params;
        
        const [components] = await req.db.query(`
            SELECT * FROM material_components 
            WHERE material_id = ? 
            ORDER BY component_name
        `, [id]);
        
        res.json({ 
            success: true, 
            components: components.map(applyMaterialComponentRaw)
        });
    } catch (error) {
        console.error('خطأ في جلب العناصر الفرعية:', error);
        res.status(500).json({ 
            success: false, 
            message: 'حدث خطأ في جلب العناصر الفرعية' 
        });
    }
};

// تحديث مادة موجودة
const updateMaterial = async (req, res) => {
    try {
        const { id } = req.params;
        const {
            material_origin,
            material_type,
            material_name,
            calculation_method,
            price_before_waste,
            external_packaging_unit,
            external_unit_cost,
            external_package_cost,
            external_net_weight,
            external_cost_per_kg,
            gross_weight,
            waste_percentage,
            packaging_unit,
            packaging_weight,
            packaging_unit_weight,
            empty_package_price,
            sticker_price,
            additional_expenses,
            labor_cost,
            preservatives_cost,
            carton_price,
            pieces_per_package,
            pallet_price,
            packages_per_pallet,
            cost_input_basis,
            extra_weights,
            additional_expense_items,
            external_notes,
            components
        } = req.body;

        const [materialRows] = await req.db.query(`SELECT id, material_origin FROM materials WHERE id = ?`, [id]);
        if (materialRows.length === 0) {
            return res.status(404).json({ success: false, message: 'المادة غير موجودة' });
        }
        const existingOrigin = materialRows[0].material_origin === 'external' ? 'external' : 'internal';

        if (existingOrigin === 'external') {
            const externalMaterialType = (material_type || '').trim();
            const name = (material_name || '').trim();
            const packagingUnit = (external_packaging_unit || '').trim();
            const netWeight = parseFloat(external_net_weight ?? gross_weight) || 0;
            const unitCost = parseFloat(external_unit_cost) || 0;
            const packageCost = parseFloat(external_package_cost) || 0;
            const costPerKg = parseFloat(external_cost_per_kg ?? price_before_waste) || 0;
            const notes = (typeof external_notes === 'string' && external_notes.trim()) ? external_notes.trim() : null;
            if (!externalMaterialType || !name || !packagingUnit || netWeight <= 0 || unitCost <= 0 || packageCost <= 0 || costPerKg <= 0) {
                return res.status(400).json({ success: false, message: 'بيانات المادة الخارجية غير مكتملة' });
            }

            const [exchangeRate] = await req.db.query(`
                SELECT rate FROM exchange_rates 
                WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
                AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
            `);
            const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;
            const unitCostSyp = roundToDecimal(unitCost * exchangeRateValue, 0);
            const packageCostSyp = roundToDecimal(packageCost * exchangeRateValue, 0);
            const costPerKgSyp = roundToDecimal(costPerKg * exchangeRateValue, 0);
            const externalRawMap = buildRawNumericMap(req.body, [
                'external_unit_cost',
                'external_package_cost',
                'external_net_weight',
                'external_cost_per_kg'
            ]);

            await req.db.query(`
                UPDATE materials SET
                    material_origin = 'external', material_type = ?, material_name = ?, external_notes = ?,
                    calculation_method = 'traditional', price_before_waste = ?, price_before_waste_syp = ?,
                    gross_weight = ?, waste_percentage = 0, packaging_unit = ?, packaging_weight = ?, packaging_unit_weight = 0,
                    empty_package_price = 0, empty_package_price_syp = 0, sticker_price = 0, sticker_price_syp = 0,
                    additional_expenses = 0, additional_expenses_syp = 0, labor_cost = 0, labor_cost_syp = 0,
                    preservatives_cost = 0, preservatives_cost_syp = 0, carton_price = 0, carton_price_syp = 0,
                    pieces_per_package = 1, pallet_price = 0, pallet_price_syp = 0, packages_per_pallet = 1,
                    unit_cost = ?, unit_cost_syp = ?, package_cost = ?, package_cost_syp = ?,
                    extra_weights = ?, gross_package_weight = ?, additional_expense_items = ?, numeric_raw = ?
                WHERE id = ?
            `, [
                externalMaterialType, name, notes, costPerKg, costPerKgSyp,
                netWeight, packagingUnit, netWeight, unitCost, unitCostSyp, packageCost, packageCostSyp,
                JSON.stringify([]), netWeight, JSON.stringify([]), JSON.stringify(externalRawMap), id
            ]);
            await req.db.query(`DELETE FROM material_components WHERE material_id = ?`, [id]);
            const updatedExternalCostLogRawMap = buildRawNumericMap(
                { unit_cost: unitCost, unit_cost_syp: unitCostSyp, package_cost: packageCost, package_cost_syp: packageCostSyp },
                COST_LOG_RAW_FIELDS
            );
            await req.db.query(`
                INSERT INTO cost_logs (material_id, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp, numeric_raw)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            `, [id, name, unitCost, unitCostSyp, packageCost, packageCostSyp, JSON.stringify(updatedExternalCostLogRawMap)]);

            return res.json({ success: true, message: 'تم تحديث المادة الخارجية بنجاح' });
        }

        // التحقق من صحة طريقة الحساب
        const isComponentsMethod = calculation_method === 'components';
        
        if (isComponentsMethod) {
            // للطريقة الجديدة: التحقق من وجود عناصر
            if (!components || !Array.isArray(components) || components.length === 0) {
                return res.status(400).json({ 
                    success: false, 
                    message: 'يرجى إضافة عنصر واحد على الأقل للمادة' 
                });
            }
        }

        // جلب سعر الصرف الحالي
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;

        // تجهيز الحقول المرتبطة بالعملة مع قبول *_syp إن وُجد للحفاظ على إدخال المستخدم بدقة
        const currencyFields = [
            'price_before_waste', 'empty_package_price', 'sticker_price',
            'additional_expenses', 'labor_cost', 'preservatives_cost',
            'carton_price', 'pallet_price'
        ];
        const usd = {};
        const syp = {};
        currencyFields.forEach((field) => {
            const usdVal = parseFloat(req.body[field]);
            const sypBody = req.body[`${field}_syp`];
            const sypVal = sypBody !== undefined ? parseFloat(sypBody) : NaN;
            if (!Number.isNaN(usdVal)) {
                usd[field] = roundToDecimal(usdVal, 2);
            } else if (!Number.isNaN(sypVal)) {
                usd[field] = roundToDecimal(sypVal / exchangeRateValue, 2);
            } else {
                usd[field] = 0;
            }
            if (!Number.isNaN(sypVal)) {
                syp[field] = roundToDecimal(sypVal, 0);
            } else {
                syp[field] = roundToDecimal((usd[field] || 0) * exchangeRateValue, 0);
            }
        });

        const additionalExpenseItemsArr = parseAdditionalExpenseItems(additional_expense_items);
        const additionalExpenseItemsTotalUsd = additionalExpenseItemsArr.reduce((sum, item) => sum + (parseFloat(item.price) || 0), 0);
        usd.additional_expenses = (usd.additional_expenses || 0) + additionalExpenseItemsTotalUsd;
        syp.additional_expenses = (syp.additional_expenses || 0) + (additionalExpenseItemsTotalUsd * exchangeRateValue);

        // تحويل القيم العامة إلى أرقام
        const gross_weight_num = parseFloat(gross_weight) || 0;
        const waste_percentage_num = parseFloat(waste_percentage) || 0;
        const pieces_per_package_num = parseInt(pieces_per_package) || 1;
        const packages_per_pallet_num = parseInt(packages_per_pallet) || 1;
        const costInputBasis = (cost_input_basis === 'per_kg' || cost_input_basis === 'total' || cost_input_basis === 'normalized')
            ? cost_input_basis
            : 'normalized';
        // نحفظ packaging_weight كما هو (نص) للحفاظ على الدقة
        const packaging_weight_for_calc = parseFloat(packaging_weight) || 0;
        const packaging_unit_weight_num = parseFloat(packaging_unit_weight) || 0;

        if (costInputBasis === 'per_kg' || costInputBasis === 'total') {
            const normalizedCosts = normalizeAuxiliaryCostsByBasis({
                basis: costInputBasis,
                usd,
                syp,
                grossWeight: gross_weight_num,
                packagingWeight: packaging_weight_for_calc
            });
            Object.assign(usd, normalizedCosts.usd);
            Object.assign(syp, normalizedCosts.syp);
        }

        // الأوزان الإضافية وحساب وزن الطرد القائم
        let extraWeightsArr = [];
        try {
            if (Array.isArray(extra_weights)) extraWeightsArr = extra_weights;
            else if (typeof extra_weights === 'string' && extra_weights.trim()) extraWeightsArr = JSON.parse(extra_weights);
        } catch (_) { extraWeightsArr = []; }
        const extraWeightsTotal = (extraWeightsArr || []).reduce((sum, ew) => sum + (parseFloat(ew.weight) || 0), 0);
        const gross_package_weight = ((packaging_unit_weight_num + packaging_weight_for_calc) * pieces_per_package_num) + extraWeightsTotal;

        // السعر قبل الهدر أصبح سعراً كلياً للوزن الجمالي
        const price_per_kg_before_waste_usd = (gross_weight_num > 0) ? ((usd.price_before_waste || 0) / gross_weight_num) : 0;
        const price_per_kg_after_waste_usd = price_per_kg_before_waste_usd / (1 - waste_percentage_num / 100 || 1);
        const material_cost_in_unit_usd = price_per_kg_after_waste_usd * packaging_weight_for_calc;
        const total_packaging_costs_usd =
            (usd.empty_package_price || 0) + (usd.sticker_price || 0) + (usd.additional_expenses || 0) +
            (usd.labor_cost || 0) + (usd.preservatives_cost || 0);
        const unit_cost = roundToDecimal(material_cost_in_unit_usd + total_packaging_costs_usd, 2);
        const pallet_share_usd = roundToDecimal((usd.pallet_price || 0) / packages_per_pallet_num, 2);
        const package_cost = roundToDecimal((unit_cost * pieces_per_package_num) + (usd.carton_price || 0) + pallet_share_usd, 2);

        // حساب كلفة القطعة والطرد بالليرة باستخدام قيم SYP المدخلة
        const price_per_kg_before_waste_syp = (gross_weight_num > 0) ? ((syp.price_before_waste || 0) / gross_weight_num) : 0;
        const price_per_kg_after_waste_syp = price_per_kg_before_waste_syp / (1 - waste_percentage_num / 100 || 1);
        const material_cost_in_unit_syp = price_per_kg_after_waste_syp * packaging_weight_for_calc;
        const total_packaging_costs_syp =
            (syp.empty_package_price || 0) + (syp.sticker_price || 0) + (syp.additional_expenses || 0) +
            (syp.labor_cost || 0) + (syp.preservatives_cost || 0);
        const unit_cost_syp = roundToDecimal(material_cost_in_unit_syp + total_packaging_costs_syp, 0);
        const pallet_share_syp = roundToDecimal((syp.pallet_price || 0) / packages_per_pallet_num, 0);
        const package_cost_syp = roundToDecimal((unit_cost_syp * pieces_per_package_num) + (syp.carton_price || 0) + pallet_share_syp, 0);
        const internalRawMap = buildRawNumericMap(req.body, [
            'price_before_waste',
            'gross_weight',
            'waste_percentage',
            'packaging_weight',
            'packaging_unit_weight',
            'empty_package_price',
            'sticker_price',
            'additional_expenses',
            'labor_cost',
            'preservatives_cost',
            'carton_price',
            'pieces_per_package',
            'pallet_price',
            'packages_per_pallet'
        ]);

        // تحديث المادة
        await req.db.query(`
            UPDATE materials SET
                material_origin = 'internal', material_type = ?, material_name = ?, external_notes = NULL, calculation_method = ?, price_before_waste = ?, price_before_waste_syp = ?,
                gross_weight = ?, waste_percentage = ?, packaging_unit = ?, packaging_weight = ?, packaging_unit_weight = ?,
                empty_package_price = ?, empty_package_price_syp = ?, sticker_price = ?, sticker_price_syp = ?,
                additional_expenses = ?, additional_expenses_syp = ?, labor_cost = ?, labor_cost_syp = ?,
                preservatives_cost = ?, preservatives_cost_syp = ?, carton_price = ?, carton_price_syp = ?,
                pieces_per_package = ?, pallet_price = ?, pallet_price_syp = ?, packages_per_pallet = ?,
                unit_cost = ?, unit_cost_syp = ?, package_cost = ?, package_cost_syp = ?,
                extra_weights = ?, gross_package_weight = ?, additional_expense_items = ?, numeric_raw = ?
            WHERE id = ?
        `, [
            material_type, material_name, calculation_method || 'traditional', (usd.price_before_waste || 0), (syp.price_before_waste || 0),
            gross_weight_num, waste_percentage_num, packaging_unit, packaging_weight, packaging_unit_weight_num,
            (usd.empty_package_price || 0), (syp.empty_package_price || 0), (usd.sticker_price || 0), (syp.sticker_price || 0),
            (usd.additional_expenses || 0), (syp.additional_expenses || 0), (usd.labor_cost || 0), (syp.labor_cost || 0),
            (usd.preservatives_cost || 0), (syp.preservatives_cost || 0), (usd.carton_price || 0), (syp.carton_price || 0),
            pieces_per_package_num, (usd.pallet_price || 0), (syp.pallet_price || 0), packages_per_pallet_num,
            unit_cost, unit_cost_syp, package_cost, package_cost_syp,
            JSON.stringify(extraWeightsArr || []), gross_package_weight, JSON.stringify(additionalExpenseItemsArr || []), JSON.stringify(internalRawMap), id
        ]);

        // تحديث العناصر الفرعية
        if (isComponentsMethod && components && Array.isArray(components)) {
            // حذف العناصر الفرعية القديمة
            await req.db.query(`DELETE FROM material_components WHERE material_id = ?`, [id]);
            
            // إضافة العناصر الفرعية الجديدة
            for (const component of components) {
                if (component.component_name && component.weight_grams && component.price_per_kg) {
                    // حساب السعر بالليرة السورية
                    const price_per_kg_syp = parseFloat(component.price_per_kg) * exchangeRateValue;
                    
                    const componentRawMap = buildRawNumericMap(
                        { ...component, price_per_kg_syp },
                        COMPONENT_RAW_FIELDS
                    );
                    await req.db.query(`
                        INSERT INTO material_components (
                            material_id, component_name, weight_grams, price_per_kg, price_per_kg_syp, numeric_raw
                        ) VALUES (?, ?, ?, ?, ?, ?)
                    `, [
                        id, 
                        component.component_name, 
                        parseFloat(component.weight_grams), 
                        parseFloat(component.price_per_kg),
                        price_per_kg_syp,
                        JSON.stringify(componentRawMap)
                    ]);
                }
            }
        } else if (!isComponentsMethod) {
            // إذا تم تغيير الطريقة من العناصر إلى التقليدية، احذف العناصر
            await req.db.query(`DELETE FROM material_components WHERE material_id = ?`, [id]);
        }

        // حفظ في سجل التكاليف
        const updatedCostLogRawMap = buildRawNumericMap(
            { unit_cost, unit_cost_syp, package_cost, package_cost_syp },
            COST_LOG_RAW_FIELDS
        );
        await req.db.query(`
            INSERT INTO cost_logs (material_id, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp, numeric_raw)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `, [id, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp, JSON.stringify(updatedCostLogRawMap)]);

        res.json({ success: true, message: 'تم تحديث المادة بنجاح' });
    } catch (error) {
        console.error('خطأ في تحديث المادة:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في تحديث المادة' });
    }
};

// عرض صفحة عروض الأسعار
const getQuotations = async (req, res) => {
    try {
        const [quotations] = await req.db.query(`
            SELECT q.*, COUNT(qi.id) as items_count 
            FROM quotations q 
            LEFT JOIN quotation_items qi ON q.id = qi.quotation_id 
            GROUP BY q.id 
            ORDER BY q.created_at DESC
        `);
        
        const [materials] = await req.db.query(`
            SELECT * FROM materials ORDER BY material_name
        `);

        // جلب سعر الصرف الحالي
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;

        // اختيار القيم حسب العملة المحددة
        const displayQuotations = quotations.map((quotation) => {
            const rawQuotation = applyQuotationRaw(quotation);
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                const totalAmount = rawQuotation.total_amount_syp || rawQuotation.total_amount;
                return {
                    ...rawQuotation,
                    total_amount: totalAmount
                };
            }
            return rawQuotation;
        });

        const displayMaterials = materials.map((material) => {
            const rawMaterial = applyMaterialRaw(material);
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                return {
                    ...rawMaterial,
                    unit_cost: rawMaterial.unit_cost_syp || rawMaterial.unit_cost,
                    package_cost: rawMaterial.package_cost_syp || rawMaterial.package_cost
                };
            }
            return rawMaterial;
        });

        res.render('costs/quotations', {
            title: 'عروض الأسعار',
            quotations: displayQuotations,
            materials: displayMaterials,
            formatDate,
            exchangeRate: exchangeRateValue
        });
    } catch (error) {
        console.error('خطأ في عرض عروض الأسعار:', error);
        req.flash('error_msg', 'حدث خطأ في عرض عروض الأسعار');
        res.redirect('/costs');
    }
};

// جلب تفاصيل عرض السعر JSON للاستخدام في المودال
const getQuotationJson = async (req, res) => {
    try {
        const { id } = req.params;
        const [quotationRows] = await req.db.query(`SELECT * FROM quotations WHERE id = ?`, [id]);
        if (quotationRows.length === 0) {
            return res.status(404).json({ success: false, message: 'عرض السعر غير موجود' });
        }
        const quotation = applyQuotationRaw(quotationRows[0]);
        const [items] = await req.db.query(`SELECT * FROM quotation_items WHERE quotation_id = ?`, [id]);
        
        // تحويل البيانات حسب العملة المحددة
        const displayQuotation = {
            ...quotation,
            total_amount: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (quotation.total_amount_syp || quotation.total_amount)
                : quotation.total_amount
        };
        
        
        const displayItems = items.map((item) => {
            const rawItem = applyQuotationItemRaw(item);
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                const unitCost = rawItem.unit_cost_syp || rawItem.unit_cost;
                const finalPrice = rawItem.final_price_syp || rawItem.final_price;
                const totalPrice = rawItem.total_price_syp || rawItem.total_price;

                return {
                    ...rawItem,
                    unit_cost: unitCost,
                    final_price: finalPrice,
                    total_price: totalPrice
                };
            }
            return rawItem;
        });
        
        res.json({ success: true, quotation: displayQuotation, items: displayItems });
    } catch (error) {
        console.error('خطأ في جلب عرض السعر JSON:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في جلب عرض السعر' });
    }
};

// تحديث عرض سعر
const updateQuotation = async (req, res) => {
    try {
        const { id } = req.params;
        const { client_name, client_phone, client_address, notes, sale_description, payment_method, items } = req.body;

        // التحقق من البيانات المطلوبة
        if (!client_name || !client_name.trim()) {
            return res.status(400).json({ 
                success: false, 
                message: 'اسم العميل مطلوب' 
            });
        }

        // جلب سعر الصرف الحالي
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;
        
        // التأكد من أن سعر الصرف رقم صحيح
        if (isNaN(exchangeRateValue) || exchangeRateValue <= 0) {
            return res.status(400).json({ success: false, message: 'سعر الصرف غير صحيح' });
        }

        const normalizedSaleDescription = (typeof sale_description === 'string' && sale_description.trim())
            ? sale_description.trim()
            : null;
        const normalizedPaymentMethod = (typeof payment_method === 'string' && payment_method.trim())
            ? payment_method.trim()
            : null;
        const quotationHeaderRawMap = buildRawNumericMap(req.body, [
            'general_profit_percentage'
        ]);

        // تحديث رأس العرض (بدون نسبة ربح عامة)
        await req.db.query(
            `UPDATE quotations SET client_name = ?, client_phone = ?, client_address = ?, notes = ?, sale_description = ?, payment_method = ?, numeric_raw = ? WHERE id = ?`,
            [client_name, client_phone, client_address, notes, normalizedSaleDescription, normalizedPaymentMethod, JSON.stringify(quotationHeaderRawMap), id]
        );

        // حذف البنود القديمة
        await req.db.query(`DELETE FROM quotation_items WHERE quotation_id = ?`, [id]);

        // إعادة الحساب والحفظ
        let totalAmount = 0;
        let totalAmountSyp = 0;
        if (items && Array.isArray(items)) {
            for (const item of items) {
                // تحويل البيانات إلى أرقام مع معالجة الأخطاء
                const unitCost = parseFloat(item.unit_cost) || 0;
                const profitPercentage = parseFloat(item.profit_percentage) || 0;
                const quantity = parseFloat(item.quantity) || 1;
                
                // حساب القيم بالعملتين بناءً على العملة المدخلة
                let unitCostUSD, unitCostSYP, finalPriceUSD, finalPriceSYP, totalPriceUSD, totalPriceSYP;
                
                if (req.body.currency === 'SYP') {
                    // إذا كانت العملة المدخلة هي الليرة السورية
                    unitCostSYP = roundToDecimal(unitCost, 0);
                    unitCostUSD = roundToDecimal(unitCost / exchangeRateValue, 2);
                    
                    // حساب السعر النهائي بالليرة السورية مباشرة
                    finalPriceSYP = roundToDecimal(unitCost * (1 + profitPercentage / 100), 0);
                    totalPriceSYP = roundToDecimal(finalPriceSYP * quantity, 0);
                    
                    // تحويل السعر النهائي والإجمالي إلى الدولار
                    finalPriceUSD = roundToDecimal(finalPriceSYP / exchangeRateValue, 2);
                    totalPriceUSD = roundToDecimal(totalPriceSYP / exchangeRateValue, 2);
                } else {
                    // إذا كانت العملة المدخلة هي الدولار (الافتراضي)
                    unitCostUSD = roundToDecimal(unitCost, 2);
                    unitCostSYP = roundToDecimal(unitCost * exchangeRateValue, 0);
                    
                    // حساب السعر النهائي بالدولار مباشرة
                    finalPriceUSD = roundToDecimal(unitCost * (1 + profitPercentage / 100), 2);
                    totalPriceUSD = roundToDecimal(finalPriceUSD * quantity, 2);
                    
                    // تحويل السعر النهائي والإجمالي إلى الليرة السورية
                    finalPriceSYP = roundToDecimal(finalPriceUSD * exchangeRateValue, 0);
                    totalPriceSYP = roundToDecimal(totalPriceUSD * exchangeRateValue, 0);
                }

                await req.db.query(
                    `INSERT INTO quotation_items (
                        quotation_id, material_id, material_name, unit_cost, unit_cost_syp, profit_percentage, final_price, final_price_syp, quantity, total_price, total_price_syp,
                        material_type, packaging_unit, packaging_weight, pieces_per_package, package_cost, item_notes, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                    [
                        id, item.material_id || null, item.material_name || '',
                        unitCostUSD || 0, unitCostSYP || 0, profitPercentage,
                        finalPriceUSD, finalPriceSYP, quantity, totalPriceUSD, totalPriceSYP,
                        item.material_type || null, item.packaging_unit || null, 
                        typeof item.packaging_weight === 'string' ? item.packaging_weight : (item.packaging_weight || null),
                        item.pieces_per_package || null, item.package_cost || null, item.item_notes || null, JSON.stringify(buildRawNumericMap(item, [
                            'unit_cost',
                            'profit_percentage',
                            'final_price',
                            'quantity',
                            'total_price',
                            'packaging_weight',
                            'pieces_per_package',
                            'package_cost'
                        ]))
                    ]
                );

                totalAmount += totalPriceUSD;
                totalAmountSyp += totalPriceSYP;
            }
        }

        await req.db.query(`UPDATE quotations SET total_amount = ?, total_amount_syp = ? WHERE id = ?`, [totalAmount, totalAmountSyp, id]);

        res.json({ success: true, message: 'تم تحديث عرض السعر بنجاح' });
    } catch (error) {
        console.error('خطأ في تحديث عرض السعر:', error);
        console.error('Error stack:', error.stack);
        res.status(500).json({ 
            success: false, 
            message: 'حدث خطأ في تحديث عرض السعر',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// إنشاء عرض سعر جديد
const createQuotation = async (req, res) => {
    try {
        const {
            client_name,
            client_phone,
            client_address,
            notes,
            sale_description,
            payment_method,
            general_profit_percentage,
            items
        } = req.body;

        // التحقق من البيانات المطلوبة
        if (!client_name || !client_name.trim()) {
            return res.status(400).json({ 
                success: false, 
                message: 'اسم العميل مطلوب' 
            });
        }

        // توليد رقم العرض
        const [lastQuotation] = await req.db.query(`
            SELECT quotation_number FROM quotations 
            ORDER BY id DESC LIMIT 1
        `);
        
        let quotationNumber = 'QT-001';
        if (lastQuotation.length > 0) {
            const lastNumber = parseInt(lastQuotation[0].quotation_number.split('-')[1]);
            quotationNumber = `QT-${String(lastNumber + 1).padStart(3, '0')}`;
        }

        // جلب سعر الصرف الحالي
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;
        
        // التأكد من أن سعر الصرف رقم صحيح
        if (isNaN(exchangeRateValue) || exchangeRateValue <= 0) {
            return res.status(400).json({ success: false, message: 'سعر الصرف غير صحيح' });
        }

        const normalizedSaleDescription = (typeof sale_description === 'string' && sale_description.trim())
            ? sale_description.trim()
            : null;
        const normalizedPaymentMethod = (typeof payment_method === 'string' && payment_method.trim())
            ? payment_method.trim()
            : null;
        const quotationHeaderRawMap = buildRawNumericMap(req.body, [
            'general_profit_percentage'
        ]);

        // حفظ العرض
        const [quotationResult] = await req.db.query(`
            INSERT INTO quotations (quotation_number, client_name, client_phone, client_address, notes, sale_description, payment_method, general_profit_percentage, total_amount, total_amount_syp, numeric_raw)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?)
        `, [quotationNumber, client_name, client_phone, client_address, notes, normalizedSaleDescription, normalizedPaymentMethod, general_profit_percentage || 0, JSON.stringify(quotationHeaderRawMap)]);

        let totalAmount = 0;
        let totalAmountSyp = 0;

        // حفظ بنود العرض
        if (items && Array.isArray(items)) {
            for (const item of items) {
                // تحويل البيانات إلى أرقام مع معالجة الأخطاء
                const unitCost = parseFloat(item.unit_cost) || 0;
                const profitPercentage = parseFloat(item.profit_percentage) || 0;
                const quantity = parseFloat(item.quantity) || 1;
                
                // حساب القيم بالعملتين بناءً على العملة المدخلة
                let unitCostUSD, unitCostSYP, finalPriceUSD, finalPriceSYP, totalPriceUSD, totalPriceSYP;
                
                if (req.body.currency === 'SYP') {
                    // إذا كانت العملة المدخلة هي الليرة السورية
                    unitCostSYP = roundToDecimal(unitCost, 0);
                    unitCostUSD = roundToDecimal(unitCost / exchangeRateValue, 2);
                    
                    // حساب السعر النهائي بالليرة السورية مباشرة
                    finalPriceSYP = roundToDecimal(unitCost * (1 + profitPercentage / 100), 0);
                    totalPriceSYP = roundToDecimal(finalPriceSYP * quantity, 0);
                    
                    // تحويل السعر النهائي والإجمالي إلى الدولار
                    finalPriceUSD = roundToDecimal(finalPriceSYP / exchangeRateValue, 2);
                    totalPriceUSD = roundToDecimal(totalPriceSYP / exchangeRateValue, 2);
                } else {
                    // إذا كانت العملة المدخلة هي الدولار (الافتراضي)
                    unitCostUSD = roundToDecimal(unitCost, 2);
                    unitCostSYP = roundToDecimal(unitCost * exchangeRateValue, 0);
                    
                    // حساب السعر النهائي بالدولار مباشرة
                    finalPriceUSD = roundToDecimal(unitCost * (1 + profitPercentage / 100), 2);
                    totalPriceUSD = roundToDecimal(finalPriceUSD * quantity, 2);
                    
                    // تحويل السعر النهائي والإجمالي إلى الليرة السورية
                    finalPriceSYP = roundToDecimal(finalPriceUSD * exchangeRateValue, 0);
                    totalPriceSYP = roundToDecimal(totalPriceUSD * exchangeRateValue, 0);
                }

                await req.db.query(`
                    INSERT INTO quotation_items (
                        quotation_id, material_id, material_name, unit_cost, unit_cost_syp, profit_percentage, final_price, final_price_syp, quantity, total_price, total_price_syp,
                        material_type, packaging_unit, packaging_weight, pieces_per_package, package_cost, item_notes, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                `, [
                    quotationResult.insertId, item.material_id || null, item.material_name || '',
                    unitCostUSD || 0, unitCostSYP || 0, profitPercentage, finalPriceUSD, finalPriceSYP,
                    quantity, totalPriceUSD, totalPriceSYP, item.material_type || null, item.packaging_unit || null,
                    typeof item.packaging_weight === 'string' ? item.packaging_weight : (item.packaging_weight || null), 
                    item.pieces_per_package || null, item.package_cost || null, item.item_notes || null, JSON.stringify(buildRawNumericMap(item, [
                        'unit_cost',
                        'profit_percentage',
                        'final_price',
                        'quantity',
                        'total_price',
                        'packaging_weight',
                        'pieces_per_package',
                        'package_cost'
                    ]))
                ]);

                totalAmount += totalPriceUSD;
                totalAmountSyp += totalPriceSYP;
            }
        }

        // تحديث المبلغ الإجمالي
        await req.db.query(`
            UPDATE quotations SET total_amount = ?, total_amount_syp = ? WHERE id = ?
        `, [totalAmount, totalAmountSyp, quotationResult.insertId]);

        res.json({ success: true, message: 'تم إنشاء عرض السعر بنجاح' });
    } catch (error) {
        console.error('خطأ في إنشاء عرض السعر:', error);
        console.error('Error stack:', error.stack);
        res.status(500).json({ 
            success: false, 
            message: 'حدث خطأ في إنشاء عرض السعر',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// عرض تفاصيل عرض السعر
const getQuotationDetails = async (req, res) => {
    try {
        const { id } = req.params;
        
        const [quotation] = await req.db.query(`
            SELECT * FROM quotations WHERE id = ?
        `, [id]);

        if (quotation.length === 0) {
            req.flash('error_msg', 'عرض السعر غير موجود');
            return res.redirect('/costs/quotations');
        }

        const [items] = await req.db.query(`
            SELECT * FROM quotation_items WHERE quotation_id = ?
        `, [id]);

        // اجلب بيانات المواد لاستخدامها كقيمة احتياطية للحقل المفقود
        const materialIds = items.map(i => i.material_id).filter(Boolean);
        let materialsMap = new Map();
        if (materialIds.length > 0) {
            const [materials] = await req.db.query(
                `SELECT id, material_type, packaging_unit, packaging_weight, pieces_per_package, package_cost, package_cost_syp 
                 FROM materials WHERE id IN (${materialIds.map(()=>'?').join(',')})`,
                materialIds
            );
            materials.forEach(m => materialsMap.set(m.id, m));
        }

        // اختيار القيم حسب العملة المحددة
        const quotationRow = applyQuotationRaw(quotation[0]);
        const displayQuotation = {
            ...quotationRow,
            total_amount: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (quotationRow.total_amount_syp || quotationRow.total_amount)
                : quotationRow.total_amount
        };

        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayItems = items.map((item) => {
            const rawItem = applyQuotationItemRaw(item);
            const mat = rawItem.material_id ? materialsMap.get(rawItem.material_id) : null;
            const packageCostFromMat = mat ? (isSyp ? (mat.package_cost_syp || mat.package_cost || 0) : (mat.package_cost || 0)) : 0;
            const packageCost = (isSyp ? (rawItem.package_cost_syp || rawItem.package_cost) : rawItem.package_cost);
            const resolvedPackageCost = (packageCost != null ? packageCost : packageCostFromMat);
            
            
                return {
                    ...rawItem,
                unit_cost: isSyp ? (rawItem.unit_cost_syp || rawItem.unit_cost) : rawItem.unit_cost,
                final_price: isSyp ? (rawItem.final_price_syp || rawItem.final_price) : rawItem.final_price,
                total_price: isSyp ? (rawItem.total_price_syp || rawItem.total_price) : rawItem.total_price,
                package_cost: resolvedPackageCost,
                material_type: rawItem.material_type || (mat ? mat.material_type : null),
                packaging_unit: rawItem.packaging_unit || (mat ? mat.packaging_unit : null),
                packaging_weight: rawItem.packaging_weight != null ? rawItem.packaging_weight : (mat ? mat.packaging_weight : null),
                pieces_per_package: rawItem.pieces_per_package != null ? rawItem.pieces_per_package : (mat ? mat.pieces_per_package : null)
            };
        });

        res.render('costs/quotation-details', {
            title: `عرض السعر ${quotation[0].quotation_number}`,
            quotation: displayQuotation,
            items: displayItems,
            formatDate
        });
    } catch (error) {
        console.error('خطأ في عرض تفاصيل عرض السعر:', error);
        req.flash('error_msg', 'حدث خطأ في عرض تفاصيل عرض السعر');
        res.redirect('/costs/quotations');
    }
};

// طباعة عرض سعر
const getQuotationPrintPage = async (req, res) => {
    try {
        const { id } = req.params;
        const printLang = String(req.query.lang || 'ar').toLowerCase() === 'en' ? 'en' : 'ar';
        const printMode = req.query.mode === 'full' ? 'full' : 'normal';
        const showFullQuotationColumns = printMode === 'full';
        const requestedDiscountedTotal = parseFloat(req.query.discounted_total);
        const [qRows] = await req.db.query(`SELECT * FROM quotations WHERE id = ?`, [id]);
        if (qRows.length === 0) {
            req.flash('error_msg', 'عرض السعر غير موجود');
            return res.redirect('/costs/quotations');
        }
        const quotation = applyQuotationRaw(qRows[0]);
        const [items] = await req.db.query(`SELECT * FROM quotation_items WHERE quotation_id = ?`, [id]);

        // اجلب حقول التغليف من materials عند نقصها في عناصر العرض
        const materialIds = items.map(i => i.material_id).filter(Boolean);
        let materialsMap = new Map();
        if (materialIds.length > 0) {
            const [materials] = await req.db.query(
                `SELECT id, material_type, packaging_unit, packaging_weight, pieces_per_package, package_cost, package_cost_syp 
                 FROM materials WHERE id IN (${materialIds.map(()=>'?').join(',')})`,
                materialIds
            );
            materials.forEach(m => materialsMap.set(m.id, m));
        }

        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayItems = items.map((item) => {
            const rawItem = applyQuotationItemRaw(item);
            const mat = rawItem.material_id ? materialsMap.get(rawItem.material_id) : null;
            const final = isSyp ? (rawItem.final_price_syp || rawItem.final_price || 0) : (rawItem.final_price || 0);
            const total = isSyp ? (rawItem.total_price_syp || rawItem.total_price || (final * (rawItem.quantity || 1))) : (rawItem.total_price || (final * (rawItem.quantity || 1)));
            const packageCostFromMat = mat ? (isSyp ? (mat.package_cost_syp || mat.package_cost || 0) : (mat.package_cost || 0)) : 0;
            const packageCost = (isSyp ? (rawItem.package_cost_syp || rawItem.package_cost) : rawItem.package_cost);
            const resolvedPackageCost = (packageCost != null ? packageCost : packageCostFromMat);
            return {
                ...rawItem,
                final_price: final,
                total_price: total,
                package_cost: resolvedPackageCost,
                material_type: rawItem.material_type || (mat ? mat.material_type : null),
                packaging_unit: rawItem.packaging_unit || (mat ? mat.packaging_unit : null),
                packaging_weight: rawItem.packaging_weight != null ? rawItem.packaging_weight : (mat ? mat.packaging_weight : null),
                pieces_per_package: rawItem.pieces_per_package != null ? rawItem.pieces_per_package : (mat ? mat.pieces_per_package : null)
            };
        });
        const grandTotal = displayItems.reduce((s, it) => s + (parseFloat(it.total_price) || 0), 0);
        const discountedTotal = Number.isFinite(requestedDiscountedTotal)
            ? Math.max(0, Math.min(grandTotal, requestedDiscountedTotal))
            : grandTotal;
        const discountAmount = Math.max(0, grandTotal - discountedTotal);

        if (printLang === 'en') {
            await translateObjectFieldsToEnglish(quotation, [
                'client_name', 'client_address', 'notes', 'sale_description', 'payment_method'
            ]);
            for (const item of displayItems) {
                await translateObjectFieldsToEnglish(item, [
                    'material_name', 'material_type', 'packaging_unit', 'item_notes'
                ]);
            }
        }

        res.render('costs/quotation-print', {
            title: `طباعة عرض السعر ${quotation.quotation_number}`,
            quotation,
            items: displayItems,
            grandTotal,
            discountedTotal,
            discountAmount,
            printMode,
            showFullQuotationColumns,
            printLang,
            defaultCurrency: req.defaultCurrency || null,
            layout: false
        });
    } catch (error) {
        console.error('خطأ في طباعة عرض السعر:', error);
        req.flash('error_msg', 'حدث خطأ في طباعة عرض السعر');
        res.redirect('/costs/quotations');
    }
};

// تصدير عرض سعر PDF
const exportQuotationPDF = async (req, res) => {
    const pdf = require('html-pdf-node');
    const path = require('path');
    const fs = require('fs');
    const { v4: uuidv4 } = require('uuid');
    try {
        const { id } = req.params;
        const printLang = String(req.query.lang || 'ar').toLowerCase() === 'en' ? 'en' : 'ar';
        const printMode = req.query.mode === 'full' ? 'full' : 'normal';
        const requestedDiscountedTotal = parseFloat(req.query.discounted_total);
        const discountedTotalQuery = Number.isFinite(requestedDiscountedTotal)
            ? `&discounted_total=${encodeURIComponent(requestedDiscountedTotal)}`
            : '';
        const url = `${process.env.BASE_URL}/costs/quotations/${id}/print-pdf-raw?mode=${printMode}&lang=${encodeURIComponent(printLang)}${discountedTotalQuery}`;
        const options = { format: 'A4' };
        const file = { url };
        const fileName = `${uuidv4()}.pdf`;
        const savePath = path.join(__dirname, '../public/quotations_pdf', fileName);
        const pdfBuffer = await pdf.generatePdf(file, options);
        fs.mkdirSync(path.dirname(savePath), { recursive: true });
        fs.writeFileSync(savePath, pdfBuffer);
        const fileUrl = `${process.env.BASE_URL}/public/quotations_pdf/${fileName}`;
        res.json({ success: true, url: fileUrl });
    } catch (error) {
        console.error('Error exporting quotation PDF:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير عرض السعر كـ PDF' });
    }
};

// طباعة عرض سعر بدون حماية (للتوليد)
const getQuotationPrintRaw = async (req, res) => {
    try {
        const { id } = req.params;
        const printLang = String(req.query.lang || 'ar').toLowerCase() === 'en' ? 'en' : 'ar';
        const printMode = req.query.mode === 'full' ? 'full' : 'normal';
        const showFullQuotationColumns = printMode === 'full';
        const requestedDiscountedTotal = parseFloat(req.query.discounted_total);
        const [qRows] = await req.db.query(`SELECT * FROM quotations WHERE id = ?`, [id]);
        if (qRows.length === 0) {
            return res.status(404).send('عرض السعر غير موجود');
        }
        const quotation = applyQuotationRaw(qRows[0]);
        const [items] = await req.db.query(`SELECT * FROM quotation_items WHERE quotation_id = ?`, [id]);

        // اجلب حقول التغليف من materials عند نقصها في عناصر العرض
        const materialIds = items.map(i => i.material_id).filter(Boolean);
        let materialsMap = new Map();
        if (materialIds.length > 0) {
            const [materials] = await req.db.query(
                `SELECT id, material_type, packaging_unit, packaging_weight, pieces_per_package, package_cost, package_cost_syp 
                 FROM materials WHERE id IN (${materialIds.map(()=>'?').join(',')})`,
                materialIds
            );
            materials.forEach(m => materialsMap.set(m.id, m));
        }

        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayItems = items.map((item) => {
            const rawItem = applyQuotationItemRaw(item);
            const mat = rawItem.material_id ? materialsMap.get(rawItem.material_id) : null;
            const final = isSyp ? (rawItem.final_price_syp || rawItem.final_price || 0) : (rawItem.final_price || 0);
            const total = isSyp ? (rawItem.total_price_syp || rawItem.total_price || (final * (rawItem.quantity || 1))) : (rawItem.total_price || (final * (rawItem.quantity || 1)));
            const packageCostFromMat = mat ? (isSyp ? (mat.package_cost_syp || mat.package_cost || 0) : (mat.package_cost || 0)) : 0;
            const packageCost = (isSyp ? (rawItem.package_cost_syp || rawItem.package_cost) : rawItem.package_cost);
            const resolvedPackageCost = (packageCost != null ? packageCost : packageCostFromMat);
            return {
                ...rawItem,
                final_price: final,
                total_price: total,
                package_cost: resolvedPackageCost,
                material_type: rawItem.material_type || (mat ? mat.material_type : null),
                packaging_unit: rawItem.packaging_unit || (mat ? mat.packaging_unit : null),
                packaging_weight: rawItem.packaging_weight != null ? rawItem.packaging_weight : (mat ? mat.packaging_weight : null),
                pieces_per_package: rawItem.pieces_per_package != null ? rawItem.pieces_per_package : (mat ? mat.pieces_per_package : null)
            };
        });
        const grandTotal = displayItems.reduce((s, it) => s + (parseFloat(it.total_price) || 0), 0);
        const discountedTotal = Number.isFinite(requestedDiscountedTotal)
            ? Math.max(0, Math.min(grandTotal, requestedDiscountedTotal))
            : grandTotal;
        const discountAmount = Math.max(0, grandTotal - discountedTotal);

        if (printLang === 'en') {
            await translateObjectFieldsToEnglish(quotation, [
                'client_name', 'client_address', 'notes', 'sale_description', 'payment_method'
            ]);
            for (const item of displayItems) {
                await translateObjectFieldsToEnglish(item, [
                    'material_name', 'material_type', 'packaging_unit', 'item_notes'
                ]);
            }
        }

        res.render('costs/quotation-print', {
            title: `طباعة عرض السعر ${quotation.quotation_number}`,
            quotation,
            items: displayItems,
            grandTotal,
            discountedTotal,
            discountAmount,
            printMode,
            showFullQuotationColumns,
            printLang,
            defaultCurrency: req.defaultCurrency || null,
            layout: false
        });
    } catch (error) {
        console.error('خطأ في طباعة عرض السعر:', error);
        res.status(500).send('حدث خطأ في طباعة عرض السعر');
    }
};

// طباعة مادة
const getMaterialPrintPage = async (req, res) => {
    try {
        const { id } = req.params;
        const [materials] = await req.db.query(`SELECT * FROM materials WHERE id = ?`, [id]);
        if (materials.length === 0) {
            req.flash('error_msg', 'المادة غير موجودة');
            return res.redirect('/costs/cost-statement');
        }
        const material = applyMaterialRaw(materials[0]);
        let components = [];
        if (material.calculation_method === 'components') {
            const [componentsResult] = await req.db.query(`
                SELECT * FROM material_components
                WHERE material_id = ?
                ORDER BY component_name
            `, [id]);
            components = componentsResult.map(applyMaterialComponentRaw);
        }
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;

        // اختيار القيم حسب العملة المحددة
        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayMaterial = {
            ...material,
            unit_cost: isSyp ? (material.unit_cost_syp || material.unit_cost) : material.unit_cost,
            package_cost: isSyp ? (material.package_cost_syp || material.package_cost) : material.package_cost,
            price_before_waste: isSyp ? (material.price_before_waste_syp || material.price_before_waste) : material.price_before_waste,
            empty_package_price: isSyp ? (material.empty_package_price_syp || material.empty_package_price) : material.empty_package_price,
            sticker_price: isSyp ? (material.sticker_price_syp || material.sticker_price) : material.sticker_price,
            additional_expenses: isSyp ? (material.additional_expenses_syp || material.additional_expenses) : material.additional_expenses,
            labor_cost: isSyp ? (material.labor_cost_syp || material.labor_cost) : material.labor_cost,
            preservatives_cost: isSyp ? (material.preservatives_cost_syp || material.preservatives_cost) : material.preservatives_cost,
            carton_price: isSyp ? (material.carton_price_syp || material.carton_price) : material.carton_price,
            pallet_price: isSyp ? (material.pallet_price_syp || material.pallet_price) : material.pallet_price,
        };

        res.render('costs/material-print', {
            title: `طباعة مادة ${displayMaterial.material_name}`,
            material: displayMaterial,
            components,
            defaultCurrency: req.defaultCurrency || null,
            exchangeRate: exchangeRateValue,
            layout: false
        });
    } catch (error) {
        console.error('خطأ في طباعة المادة:', error);
        req.flash('error_msg', 'حدث خطأ في طباعة المادة');
        res.redirect('/costs/cost-statement');
    }
};
// دالة تنسيق التاريخ
const formatDate = (dateString) => {
    if (!dateString) return '-';
    const date = new Date(dateString);
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
};

// عرض صفحة الطلبيات
const getOrders = async (req, res) => {
    try {
        const [orders] = await req.db.query(`
            SELECT o.*, 
                   COALESCE(SUM(oi.total_price), 0) as total_amount,
                   COALESCE(SUM(oi.total_price_syp), 0) as total_amount_syp
            FROM orders o
            LEFT JOIN order_items oi ON o.id = oi.order_id
            GROUP BY o.id
            ORDER BY o.created_at DESC
        `);
        const [materials] = await req.db.query(`
            SELECT id, material_name, packaging_unit, packaging_weight, gross_package_weight, package_cost, package_cost_syp, numeric_raw 
            FROM materials ORDER BY material_name
        `);

        // جلب سعر الصرف الحالي
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;

        // اختيار القيم حسب العملة المحددة
        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayOrders = orders.map(order => {
            const rawOrder = applyOrderRaw(order);
            return {
                ...rawOrder,
                total_amount: isSyp ? (rawOrder.total_amount_syp || rawOrder.total_amount) : rawOrder.total_amount
            };
        });

        const displayMaterials = materials.map((material) => applyMaterialRaw(material));

        res.render('costs/orders', {
            title: 'الطلبيات',
            orders: displayOrders,
            materials: displayMaterials,
            formatDate,
            defaultCurrency: req.defaultCurrency || null,
            exchangeRate: exchangeRateValue
        });
    } catch (error) {
        console.error('خطأ في عرض الطلبيات:', error);
        req.flash('error_msg', 'حدث خطأ في عرض الطلبيات');
        res.redirect('/costs');
    }
};



// إنشاء طلبية جديدة
const createOrder = async (req, res) => {
    try {
        
        const {
            client_name,
            order_date,
            delivery_date,
            responsible_worker,
            quality_controller,
            pallets_count,
            container_number,
            packages_count,
            waybill_number,
            accreditation_number,
            notes,
            currency,
            items
        } = req.body;

        // التحقق من الحقول المطلوبة
        if (!client_name || !client_name.trim()) {
            return res.status(400).json({ 
                success: false, 
                message: 'اسم الزبون مطلوب' 
            });
        }

        // جلب سعر الصرف الحالي
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;
        
        // التأكد من أن سعر الصرف رقم صحيح
        if (isNaN(exchangeRateValue) || exchangeRateValue <= 0) {
            return res.status(400).json({ success: false, message: 'سعر الصرف غير صحيح' });
        }

        // تحويل التواريخ من DD/MM/YYYY إلى YYYY-MM-DD
        const parseDmy = (dmy) => {
            if (!dmy) return null;
            const [d, m, y] = dmy.split('/');
            return `${y}-${m}-${d}`;
        };
        const orderDateSql = parseDmy(order_date) || new Date().toISOString().slice(0, 10);
        const deliveryDateSql = parseDmy(delivery_date);

        // توليد رقم الطلبية
        const [lastOrder] = await req.db.query(`
            SELECT order_number FROM orders 
            ORDER BY id DESC LIMIT 1
        `);
        
        let orderNumber = 'ORD-001';
        if (lastOrder.length > 0) {
            const lastNumber = parseInt(lastOrder[0].order_number.split('-')[1]);
            orderNumber = `ORD-${String(lastNumber + 1).padStart(3, '0')}`;
        }
        const orderHeaderRawMap = buildRawNumericMap(req.body, [
            'pallets_count',
            'packages_count'
        ]);

        const [orderResult] = await req.db.query(`
            INSERT INTO orders (
                order_number, client_name, order_date, delivery_date,
                responsible_worker, quality_controller, pallets_count, container_number,
                packages_count, waybill_number, accreditation_number, notes, numeric_raw
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            orderNumber, client_name || null, orderDateSql, deliveryDateSql,
            responsible_worker || null, quality_controller || null, pallets_count || null, container_number || null,
            packages_count || null, waybill_number || null, accreditation_number || null, notes || null, JSON.stringify(orderHeaderRawMap)
        ]);

        // حفظ بنود الطلبية إن وُجدت
        if (items && Array.isArray(items)) {
            for (const item of items) {
                // تحويل البيانات إلى أرقام مع معالجة الأخطاء
                const unitPrice = parseFloat(item.unit_price) || 0;
                const quantity = parseFloat(item.requested_quantity) || 1;
                
                // حساب القيم بالعملتين بناءً على العملة المدخلة
                let unitPriceUSD, unitPriceSYP, totalPriceUSD, totalPriceSYP;
                
                if (currency === 'SYP') {
                    // إذا كانت العملة المدخلة هي الليرة السورية
                    unitPriceSYP = roundToDecimal(unitPrice, 0);
                    unitPriceUSD = roundToDecimal(unitPrice / exchangeRateValue, 2);
                    
                    // حساب السعر الإجمالي بالليرة السورية مباشرة
                    totalPriceSYP = roundToDecimal(unitPrice * quantity, 0);
                    totalPriceUSD = roundToDecimal(totalPriceSYP / exchangeRateValue, 2);
                } else {
                    // إذا كانت العملة المدخلة هي الدولار (الافتراضي)
                    unitPriceUSD = roundToDecimal(unitPrice, 2);
                    unitPriceSYP = roundToDecimal(unitPrice * exchangeRateValue, 0);
                    
                    // حساب السعر الإجمالي بالدولار مباشرة
                    totalPriceUSD = roundToDecimal(unitPrice * quantity, 2);
                    totalPriceSYP = roundToDecimal(totalPriceUSD * exchangeRateValue, 0);
                }
                
                await req.db.query(`
                    INSERT INTO order_items (
                        order_id, material_id, material_name, unit, requested_quantity, weight, volume, 
                        unit_price, unit_price_syp, total_price, total_price_syp, notes, net_weight, gross_weight, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                `, [
                    orderResult.insertId,
                    item.material_id || null,
                    item.material_name || '',
                    item.unit || null,
                    quantity,
                    item.weight || null,
                    item.volume || null,
                    unitPriceUSD,
                    unitPriceSYP,
                    totalPriceUSD,
                    totalPriceSYP,
                    item.notes || null,
                    item.net_weight || null,
                    item.gross_weight || null,
                    JSON.stringify(buildRawNumericMap(item, [
                        'requested_quantity',
                        'weight',
                        'volume',
                        'unit_price',
                        'total_price',
                        'net_weight',
                        'gross_weight'
                    ]))
                ]);
            }
        }

        res.json({ success: true, message: 'تم إنشاء الطلبية بنجاح' });
    } catch (error) {
        console.error('خطأ في إنشاء الطلبية:', error);
        console.error('Error stack:', error.stack);
        res.status(500).json({ 
            success: false, 
            message: 'حدث خطأ في إنشاء الطلبية',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// جلب مادة واحدة
const getMaterial = async (req, res) => {
    try {
        const { id } = req.params;
        
        const [materials] = await req.db.query(`
            SELECT * FROM materials WHERE id = ? AND deleted_at IS NULL
        `, [id]);
        
        if (materials.length === 0) {
            return res.status(404).json({ success: false, message: 'المادة غير موجودة' });
        }
        
        res.json({ success: true, material: applyMaterialRaw(materials[0]) });
    } catch (error) {
        console.error('خطأ في جلب بيانات المادة:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في جلب بيانات المادة' });
    }
};

// جلب سجل التكاليف لمادة معينة
const getMaterialCostLogs = async (req, res) => {
    try {
        const { id } = req.params;
        
        const [logs] = await req.db.query(`
            SELECT * FROM cost_logs 
            WHERE material_id = ? 
            ORDER BY calculation_date DESC
        `, [id]);
        
        // تحويل القيم حسب العملة المحددة
        const displayLogs = logs.map((rawLog) => {
            const log = applyCostLogRaw(rawLog);
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                return {
                    ...log,
                    unit_cost: log.unit_cost_syp || log.unit_cost,
                    package_cost: log.package_cost_syp || log.package_cost
                };
            } else {
                return log;
            }
        });
        
        res.json({ success: true, logs: displayLogs });
    } catch (error) {
        console.error('خطأ في جلب سجل التكاليف:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في جلب سجل التكاليف' });
    }
};

// حذف مادة
const deleteMaterial = async (req, res) => {
    try {
        const { id } = req.params;
        await req.db.query(
            'UPDATE materials SET deleted_at = NOW() WHERE id = ? AND deleted_at IS NULL',
            [id]
        );
        res.json({ success: true, message: 'تم نقل المادة إلى سلة المحذوفات' });
    } catch (error) {
        console.error('خطأ في حذف المادة:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في حذف المادة' });
    }
};

const parseIds = (ids) => {
    if (!Array.isArray(ids)) return [];
    return ids
        .map((id) => parseInt(id, 10))
        .filter((id) => Number.isInteger(id) && id > 0);
};

const trashMaterialsMultiple = async (req, res) => {
    try {
        const ids = parseIds(req.body.ids);
        if (!ids.length) {
            return res.status(400).json({ success: false, message: 'لم يتم تحديد أي مواد' });
        }
        const placeholders = ids.map(() => '?').join(',');
        const [result] = await req.db.query(
            `UPDATE materials SET deleted_at = NOW() WHERE id IN (${placeholders}) AND deleted_at IS NULL`,
            ids
        );
        res.json({ success: true, message: `تم نقل ${result.affectedRows} مادة إلى سلة المحذوفات` });
    } catch (error) {
        console.error('خطأ في نقل المواد إلى السلة:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء نقل المواد إلى السلة' });
    }
};

const deleteMaterialsMultiple = async (req, res) => {
    try {
        const ids = parseIds(req.body.ids);
        if (!ids.length) {
            return res.status(400).json({ success: false, message: 'لم يتم تحديد أي مواد' });
        }
        const placeholders = ids.map(() => '?').join(',');
        const [result] = await req.db.query(
            `DELETE FROM materials WHERE id IN (${placeholders})`,
            ids
        );
        res.json({ success: true, message: `تم حذف ${result.affectedRows} مادة نهائياً` });
    } catch (error) {
        console.error('خطأ في الحذف النهائي للمواد:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء الحذف النهائي' });
    }
};

const getDeletedMaterials = async (req, res) => {
    try {
        const [materials] = await req.db.query(`
            SELECT * FROM materials
            WHERE deleted_at IS NOT NULL
            ORDER BY deleted_at DESC
        `);
        res.render('costs/materials-deleted', {
            title: 'سلة محذوفات المواد',
            materials: materials.map(applyMaterialRaw),
            formatDate
        });
    } catch (error) {
        console.error('خطأ في عرض سلة محذوفات المواد:', error);
        req.flash('error_msg', 'حدث خطأ في عرض سلة المحذوفات');
        res.redirect('/costs/cost-statement');
    }
};

const restoreMaterialsMultiple = async (req, res) => {
    try {
        const ids = parseIds(req.body.ids);
        if (!ids.length) {
            return res.status(400).json({ success: false, message: 'لم يتم تحديد أي مواد' });
        }
        const placeholders = ids.map(() => '?').join(',');
        const [result] = await req.db.query(
            `UPDATE materials SET deleted_at = NULL WHERE id IN (${placeholders}) AND deleted_at IS NOT NULL`,
            ids
        );
        res.json({ success: true, message: `تمت استعادة ${result.affectedRows} مادة` });
    } catch (error) {
        console.error('خطأ في استعادة المواد:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء الاستعادة' });
    }
};

const emptyMaterialsTrash = async (req, res) => {
    try {
        const [result] = await req.db.query('DELETE FROM materials WHERE deleted_at IS NOT NULL');
        res.json({ success: true, message: `تم تفريغ السلة وحذف ${result.affectedRows} مادة` });
    } catch (error) {
        console.error('خطأ في تفريغ سلة المواد:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء تفريغ السلة' });
    }
};

const exportSelectedMaterialsExcel = async (req, res) => {
    try {
        const ids = parseIds(req.body.ids);
        if (!ids.length) {
            return res.status(400).json({ success: false, message: 'يرجى تحديد مواد للتصدير' });
        }

        const placeholders = ids.map(() => '?').join(',');
        const [materials] = await req.db.query(
            `SELECT * FROM materials WHERE id IN (${placeholders}) AND deleted_at IS NULL ORDER BY created_at DESC`,
            ids
        );

        if (!materials.length) {
            return res.status(404).json({ success: false, message: 'لا توجد مواد صالحة للتصدير' });
        }

        const workbook = new Excel.Workbook();
        const worksheet = workbook.addWorksheet('مواد محددة');
        worksheet.views = [{ rightToLeft: true }];

        const columns = [
            { header: '#', key: 'row_number', width: 8 },
            { header: 'اسم المادة', key: 'material_name', width: 34 },
            { header: 'وحدة التعبئة', key: 'packaging_unit', width: 16 },
            { header: 'كلفة القطعة', key: 'unit_cost', width: 14 },
            { header: 'كلفة الطرد', key: 'package_cost', width: 14 },
            { header: 'وزن الطرد القائم', key: 'gross_package_weight', width: 16 },
            { header: 'الوزن الصافي', key: 'packaging_weight', width: 14 },
            { header: 'شد الكرتون', key: 'pieces_per_package', width: 12 },
            { header: 'كلفة الكيلو', key: 'cost_per_kg', width: 14 },
            { header: 'تاريخ الإضافة', key: 'created_at', width: 14 }
        ];
        worksheet.columns = columns;

        const formatDate = (dateValue) => {
            if (!dateValue) return '-';
            const d = new Date(dateValue);
            if (Number.isNaN(d.getTime())) return '-';
            const day = String(d.getDate()).padStart(2, '0');
            const month = String(d.getMonth() + 1).padStart(2, '0');
            const year = d.getFullYear();
            return `${day}/${month}/${year}`;
        };

        const formatNum = (value, decimals = 2) => {
            if (value === null || value === undefined || value === '') return '-';
            if (typeof value === 'string' && /^-?\d+(\.\d+)?$/.test(value.trim())) {
                return value.trim();
            }
            const n = typeof value === 'number' ? value : parseFloat(value);
            if (!Number.isFinite(n)) return '-';
            if (Number.isInteger(n)) return String(n);
            const fixed = n.toFixed(Math.max(0, decimals));
            return fixed.replace(/\.?0+$/, '');
        };

        const currencySymbol = (req.defaultCurrency && req.defaultCurrency.symbol) ? req.defaultCurrency.symbol : '$';
        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';

        materials.forEach((material, index) => {
            const row = applyMaterialRaw(material);
            const unitCostValue = isSyp ? (row.unit_cost_syp || row.unit_cost) : row.unit_cost;
            const packageCostValue = isSyp ? (row.package_cost_syp || row.package_cost) : row.package_cost;
            const netWeightNum = parseFloat(row.packaging_weight);
            const unitCostNum = parseFloat(unitCostValue);
            const computedCostPerKg = (Number.isFinite(netWeightNum) && netWeightNum > 0 && Number.isFinite(unitCostNum))
                ? (unitCostNum / netWeightNum)
                : null;
            const storedCostPerKg = isSyp
                ? (row.price_before_waste_syp ?? row.price_before_waste)
                : row.price_before_waste;
            const costPerKgValue = (storedCostPerKg !== null && storedCostPerKg !== undefined && String(storedCostPerKg).trim() !== '')
                ? storedCostPerKg
                : computedCostPerKg;

            worksheet.addRow({
                row_number: index + 1,
                material_name: row.material_name || '-',
                packaging_unit: row.packaging_unit || '-',
                unit_cost: `${formatNum(unitCostValue, isSyp ? 0 : 2)} ${currencySymbol}`.trim(),
                package_cost: `${formatNum(packageCostValue, isSyp ? 0 : 2)} ${currencySymbol}`.trim(),
                gross_package_weight: `${formatNum(row.gross_package_weight, 3)} كجم`,
                packaging_weight: `${formatNum(row.packaging_weight, 3)} كجم`,
                pieces_per_package: formatNum(row.pieces_per_package, 0),
                cost_per_kg: `${(costPerKgValue === null ? '-' : formatNum(costPerKgValue, isSyp ? 0 : 2))} ${currencySymbol}`.trim(),
                created_at: formatDate(row.created_at)
            });
        });

        worksheet.getRow(1).font = { bold: true };
        worksheet.getRow(1).alignment = { horizontal: 'center', vertical: 'middle' };
        worksheet.eachRow((row, rowNumber) => {
            if (rowNumber === 1) return;
            row.alignment = { vertical: 'middle', horizontal: 'center' };
            row.getCell('material_name').alignment = { vertical: 'middle', horizontal: 'right' };
        });

        const fileName = `${uuidv4()}.xlsx`;
        const savePath = path.join(__dirname, '../public/materials_list_excel', fileName);
        fs.mkdirSync(path.dirname(savePath), { recursive: true });
        await workbook.xlsx.writeFile(savePath);

        const baseUrl = process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}`;
        const fileUrl = `${baseUrl}/public/materials_list_excel/${fileName}`;
        res.json({ success: true, url: fileUrl });
    } catch (error) {
        console.error('خطأ في تصدير المواد المحددة إلى Excel:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير ملف Excel' });
    }
};

const exportSelectedMaterialsPdf = async (req, res) => {
    try {
        const ids = parseIds(req.body.ids);
        if (!ids.length) {
            return res.status(400).json({ success: false, message: 'يرجى تحديد مواد للتصدير' });
        }

        const placeholders = ids.map(() => '?').join(',');
        const [materials] = await req.db.query(
            `SELECT * FROM materials WHERE id IN (${placeholders}) AND deleted_at IS NULL ORDER BY created_at DESC`,
            ids
        );

        if (!materials.length) {
            return res.status(404).json({ success: false, message: 'لا توجد مواد صالحة للتصدير' });
        }

        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayMaterials = materials.map((material) => {
            const rawMaterial = applyMaterialRaw(material);
            return {
                ...rawMaterial,
                unit_cost: isSyp ? (rawMaterial.unit_cost_syp || rawMaterial.unit_cost) : rawMaterial.unit_cost,
                package_cost: isSyp ? (rawMaterial.package_cost_syp || rawMaterial.package_cost) : rawMaterial.package_cost
            };
        });

        const pdf = require('html-pdf-node');
        const baseUrl = process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}`;
        const path = require('path');
        const fs = require('fs');
        const { v4: uuidv4 } = require('uuid');

        req.app.render('costs/materials-print-list', {
            title: 'طباعة المواد المحددة',
            materials: displayMaterials,
            defaultCurrency: req.defaultCurrency || null,
            baseUrl,
            layout: false
        }, async (err, html) => {
            if (err) {
                console.error('Render selected materials PDF failed:', err);
                return res.status(500).json({ success: false, message: 'تعذر إنشاء ملف PDF' });
            }

            const options = {
                format: 'A4',
                preferCSSPageSize: true,
                printBackground: true,
                margin: {
                    top: '14mm',
                    right: '14mm',
                    bottom: '14mm',
                    left: '14mm'
                }
            };
            const pdfBuffer = await pdf.generatePdf({ content: html }, options);
            const fileName = `${uuidv4()}.pdf`;
            const savePath = path.join(__dirname, '../public/materials_list_pdf', fileName);
            fs.mkdirSync(path.dirname(savePath), { recursive: true });
            fs.writeFileSync(savePath, pdfBuffer);

            return res.json({
                success: true,
                url: `${baseUrl}/public/materials_list_pdf/${fileName}`
            });
        });
    } catch (error) {
        console.error('خطأ في تصدير المواد المحددة إلى PDF:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير ملف PDF' });
    }
};

// حذف عرض سعر
const deleteQuotation = async (req, res) => {
    try {
        const { id } = req.params;
        
        await req.db.query('DELETE FROM quotations WHERE id = ?', [id]);
        
        res.json({ success: true, message: 'تم حذف عرض السعر بنجاح' });
    } catch (error) {
        console.error('خطأ في حذف عرض السعر:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في حذف عرض السعر' });
    }
};

// تحديث حالة الطلبية
const updateOrderStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        
        await req.db.query('UPDATE orders SET status = ? WHERE id = ?', [status, id]);
        
        res.json({ success: true, message: 'تم تحديث حالة الطلبية بنجاح' });
    } catch (error) {
        console.error('خطأ في تحديث حالة الطلبية:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في تحديث حالة الطلبية' });
    }
};

// جلب بيانات طلبية واحدة
const getOrder = async (req, res) => {
    try {
        const { id } = req.params;
        
        const [orders] = await req.db.query(`
            SELECT * FROM orders WHERE id = ?
        `, [id]);
        
        if (orders.length === 0) {
            return res.status(404).json({ success: false, message: 'الطلبية غير موجودة' });
        }
        const [items] = await req.db.query(`
            SELECT * FROM order_items WHERE order_id = ?
        `, [id]);

        // اختيار القيم حسب العملة المحددة
        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayOrder = applyOrderRaw(orders[0]);
        const displayItems = items.map((it) => {
            const rawItem = applyOrderItemRaw(it);
            return {
                ...rawItem,
                unit_price: isSyp ? (rawItem.unit_price_syp || rawItem.unit_price) : rawItem.unit_price,
                total_price: isSyp ? (rawItem.total_price_syp || rawItem.total_price) : rawItem.total_price
            };
        });
        
        res.json({ success: true, order: displayOrder, items: displayItems });
    } catch (error) {
        console.error('خطأ في جلب بيانات الطلبية:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في جلب بيانات الطلبية' });
    }
};

// تحديث طلبية
const updateOrder = async (req, res) => {
    try {
        
        const { id } = req.params;
        const {
            client_name,
            order_date,
            delivery_date,
            responsible_worker,
            quality_controller,
            pallets_count,
            container_number,
            packages_count,
            waybill_number,
            accreditation_number,
            notes,
            currency,
            items
        } = req.body;
        
        // التحقق من الحقول المطلوبة
        if (!client_name || !client_name.trim()) {
            return res.status(400).json({ 
                success: false, 
                message: 'اسم العميل مطلوب' 
            });
        }
        
        // جلب سعر الصرف الحالي
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;
        
        // التأكد من أن سعر الصرف رقم صحيح
        if (isNaN(exchangeRateValue) || exchangeRateValue <= 0) {
            return res.status(400).json({ success: false, message: 'سعر الصرف غير صحيح' });
        }
        
        const parseDmy = (dmy) => {
            if (!dmy) return null;
            const [d, m, y] = dmy.split('/');
            return `${y}-${m}-${d}`;
        };
        const orderDateSql = parseDmy(order_date);
        const deliveryDateSql = parseDmy(delivery_date);
        const orderHeaderRawMap = buildRawNumericMap(req.body, [
            'pallets_count',
            'packages_count'
        ]);
        
        await req.db.query(`
            UPDATE orders SET
                client_name = ?, order_date = ?, delivery_date = ?,
                responsible_worker = ?, quality_controller = ?, pallets_count = ?, container_number = ?,
                packages_count = ?, waybill_number = ?, accreditation_number = ?, notes = ?, numeric_raw = ?
            WHERE id = ?
        `, [
            client_name || null, orderDateSql, deliveryDateSql,
            responsible_worker || null, quality_controller || null, pallets_count || null, container_number || null,
            packages_count || null, waybill_number || null, accreditation_number || null, notes || null, JSON.stringify(orderHeaderRawMap), id
        ]);

        // حدّث البنود
        await req.db.query('DELETE FROM order_items WHERE order_id = ?', [id]);
        if (items && Array.isArray(items)) {
            for (const item of items) {
                // تحويل البيانات إلى أرقام مع معالجة الأخطاء
                const unitPrice = parseFloat(item.unit_price) || 0;
                const quantity = parseFloat(item.requested_quantity) || 1;
                
                // حساب القيم بالعملتين بناءً على العملة المدخلة
                let unitPriceUSD, unitPriceSYP, totalPriceUSD, totalPriceSYP;
                
                if (currency === 'SYP') {
                    // إذا كانت العملة المدخلة هي الليرة السورية
                    unitPriceSYP = roundToDecimal(unitPrice, 0);
                    unitPriceUSD = roundToDecimal(unitPrice / exchangeRateValue, 2);
                    
                    // حساب السعر الإجمالي بالليرة السورية مباشرة
                    totalPriceSYP = roundToDecimal(unitPrice * quantity, 0);
                    totalPriceUSD = roundToDecimal(totalPriceSYP / exchangeRateValue, 2);
                } else {
                    // إذا كانت العملة المدخلة هي الدولار (الافتراضي)
                    unitPriceUSD = roundToDecimal(unitPrice, 2);
                    unitPriceSYP = roundToDecimal(unitPrice * exchangeRateValue, 0);
                    
                    // حساب السعر الإجمالي بالدولار مباشرة
                    totalPriceUSD = roundToDecimal(unitPrice * quantity, 2);
                    totalPriceSYP = roundToDecimal(totalPriceUSD * exchangeRateValue, 0);
                }
                
                await req.db.query(`
                    INSERT INTO order_items (
                        order_id, material_id, material_name, unit, requested_quantity, weight, volume, 
                        unit_price, unit_price_syp, total_price, total_price_syp, notes, net_weight, gross_weight, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                `, [
                    id,
                    item.material_id || null,
                    item.material_name || '',
                    item.unit || null,
                    quantity,
                    item.weight || null,
                    item.volume || null,
                    unitPriceUSD,
                    unitPriceSYP,
                    totalPriceUSD,
                    totalPriceSYP,
                    item.notes || null,
                    item.net_weight || null,
                    item.gross_weight || null,
                    JSON.stringify(buildRawNumericMap(item, [
                        'requested_quantity',
                        'weight',
                        'volume',
                        'unit_price',
                        'total_price',
                        'net_weight',
                        'gross_weight'
                    ]))
                ]);
            }
        }
        
        res.json({ success: true, message: 'تم تحديث الطلبية بنجاح' });
    } catch (error) {
        console.error('خطأ في تحديث الطلبية:', error);
        console.error('Error stack:', error.stack);
        res.status(500).json({ 
            success: false, 
            message: 'حدث خطأ في تحديث الطلبية',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// عرض تفاصيل الطلبية
const getOrderDetailsPage = async (req, res) => {
    try {
        const { id } = req.params;
        const [orders] = await req.db.query('SELECT * FROM orders WHERE id = ?', [id]);
        if (orders.length === 0) {
            req.flash('error_msg', 'الطلبية غير موجودة');
            return res.redirect('/costs/orders');
        }
        const [items] = await req.db.query('SELECT * FROM order_items WHERE order_id = ?', [id]);

        // جلب بيانات المواد لحساب الوزن الصافي بعد الهدر
        const materialIds = items.map(i => i.material_id).filter(Boolean);
        let materialsMap = new Map();
        if (materialIds.length > 0) {
            const [materials] = await req.db.query(
                `SELECT id, gross_weight, waste_percentage, packaging_weight, pieces_per_package FROM materials WHERE id IN (${materialIds.map(()=>'?').join(',')})`,
                materialIds
            );
            materials.forEach(m => materialsMap.set(m.id, m));
        }

        // اختيار القيم حسب العملة المحددة
        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayOrder = applyOrderRaw(orders[0]);
        const displayItems = items.map(it => {
            const rawItem = applyOrderItemRaw(it);
            const unitPrice = isSyp ? (rawItem.unit_price_syp || rawItem.unit_price) : rawItem.unit_price;
            const totalPrice = isSyp ? (rawItem.total_price_syp || rawItem.total_price) : rawItem.total_price;
            const mat = rawItem.material_id ? materialsMap.get(rawItem.material_id) : null;
            
            // لا نكسر تنسيق الإدخال الخام إن كان موجودًا.
            let netWeight = rawItem.net_weight;
            if ((netWeight === null || netWeight === undefined || netWeight === '') && rawItem.material_id && materialsMap.has(rawItem.material_id)) {
                const material = materialsMap.get(rawItem.material_id);
                const grossWeight = parseFloat(material.gross_weight) || 0;
                const wastePercentage = parseFloat(material.waste_percentage) || 0;
                netWeight = grossWeight * (1 - wastePercentage / 100);
            }
            
            return { 
                ...rawItem, 
                unit_price: unitPrice != null ? unitPrice : null, 
                total_price: totalPrice != null ? totalPrice : null,
                net_weight: netWeight,
                packaging_weight: rawItem.packaging_weight != null ? rawItem.packaging_weight : (mat ? mat.packaging_weight : null),
                pieces_per_package: rawItem.pieces_per_package != null ? rawItem.pieces_per_package : (mat ? mat.pieces_per_package : null)
            };
        });
        const totals = {
            totalRequestedQuantity: displayItems.reduce((s, it) => s + (parseFloat(it.requested_quantity) || 0), 0),
            totalNetWeight: displayItems.reduce((s, it) => s + (parseFloat(it.net_weight) || 0), 0),
            totalPackagingWeight: displayItems.reduce((s, it) => {
                const qty = parseFloat(it.requested_quantity) || 0;
                const packagingWeight = parseFloat(it.packaging_weight) || 0;
                return s + (packagingWeight * qty);
            }, 0),
            totalPiecesPerPackage: displayItems.reduce((s, it) => s + (parseFloat(it.pieces_per_package) || 0), 0),
            totalGrossWeight: displayItems.reduce((s, it) => {
                const qty = parseFloat(it.requested_quantity) || 0;
                const grossWeight = parseFloat(it.gross_weight) || 0;
                return s + (grossWeight * qty);
            }, 0),
            grandTotal: displayItems.reduce((s, it) => s + (it.total_price != null ? parseFloat(it.total_price) : 0), 0)
        };

        res.render('costs/order-details', {
            title: `تفاصيل الطلبية ${orders[0].order_number}`,
            order: displayOrder,
            items: displayItems,
            totals,
            defaultCurrency: req.defaultCurrency || null
        });
    } catch (error) {
        console.error('خطأ في عرض تفاصيل الطلبية:', error);
        req.flash('error_msg', 'حدث خطأ في عرض تفاصيل الطلبية');
        res.redirect('/costs/orders');
    }
};

// طباعة تفاصيل الطلبية
const getOrderPrintPage = async (req, res) => {
    try {
        const { id } = req.params;
        const { type } = req.query; // invoice أو order (افتراضي)
        const printLang = String(req.query.lang || 'ar').toLowerCase() === 'en' ? 'en' : 'ar';
        const requestedDiscountedTotal = parseFloat(req.query.discounted_total);
        
        const [orders] = await req.db.query('SELECT * FROM orders WHERE id = ?', [id]);
        if (orders.length === 0) {
            req.flash('error_msg', 'الطلبية غير موجودة');
            return res.redirect('/costs/orders');
        }
        const [items] = await req.db.query('SELECT * FROM order_items WHERE order_id = ?', [id]);

        // جلب بيانات المواد لحساب الوزن الصافي بعد الهدر
        const materialIds = items.map(i => i.material_id).filter(Boolean);
        let materialsMap = new Map();
        if (materialIds.length > 0) {
            const [materials] = await req.db.query(
                `SELECT id, gross_weight, waste_percentage, packaging_weight, pieces_per_package FROM materials WHERE id IN (${materialIds.map(()=>'?').join(',')})`,
                materialIds
            );
            materials.forEach(m => materialsMap.set(m.id, m));
        }

        // اختيار القيم حسب العملة المحددة
        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayOrder = applyOrderRaw(orders[0]);
        const pricedItems = items.map(it => {
            const rawItem = applyOrderItemRaw(it);
            const unitPrice = isSyp ? (rawItem.unit_price_syp || rawItem.unit_price) : rawItem.unit_price;
            const totalPrice = isSyp ? (rawItem.total_price_syp || rawItem.total_price) : rawItem.total_price;
            const mat = rawItem.material_id ? materialsMap.get(rawItem.material_id) : null;
            
            // لا نكسر تنسيق الإدخال الخام إن كان موجودًا.
            let netWeight = rawItem.net_weight;
            if ((netWeight === null || netWeight === undefined || netWeight === '') && rawItem.material_id && materialsMap.has(rawItem.material_id)) {
                const material = materialsMap.get(rawItem.material_id);
                const grossWeight = parseFloat(material.gross_weight) || 0;
                const wastePercentage = parseFloat(material.waste_percentage) || 0;
                netWeight = grossWeight * (1 - wastePercentage / 100);
            }
            
            return { 
                ...rawItem, 
                unit_price: unitPrice != null ? unitPrice : null, 
                total_price: totalPrice != null ? totalPrice : null,
                net_weight: netWeight,
                packaging_weight: rawItem.packaging_weight != null ? rawItem.packaging_weight : (mat ? mat.packaging_weight : null),
                pieces_per_package: rawItem.pieces_per_package != null ? rawItem.pieces_per_package : (mat ? mat.pieces_per_package : null)
            };
        });

        const totals = {
            totalRequestedQuantity: pricedItems.reduce((s, it) => s + (parseFloat(it.requested_quantity) || 0), 0),
            totalNetWeight: pricedItems.reduce((s, it) => s + (parseFloat(it.net_weight) || 0), 0),
            totalPackagingWeight: pricedItems.reduce((s, it) => {
                const qty = parseFloat(it.requested_quantity) || 0;
                const packagingWeight = parseFloat(it.packaging_weight) || 0;
                return s + (packagingWeight * qty);
            }, 0),
            totalPiecesPerPackage: pricedItems.reduce((s, it) => s + (parseFloat(it.pieces_per_package) || 0), 0),
            totalGrossWeight: pricedItems.reduce((s, it) => {
                const qty = parseFloat(it.requested_quantity) || 0;
                const grossWeight = parseFloat(it.gross_weight) || 0;
                return s + (grossWeight * qty);
            }, 0),
            grandTotal: pricedItems.reduce((s, it) => s + (it.total_price != null ? parseFloat(it.total_price) : 0), 0)
        };
        const discountedTotal = Number.isFinite(requestedDiscountedTotal)
            ? Math.max(0, Math.min(totals.grandTotal, requestedDiscountedTotal))
            : totals.grandTotal;
        const discountAmount = Math.max(0, totals.grandTotal - discountedTotal);

        if (printLang === 'en') {
            await translateObjectFieldsToEnglish(displayOrder, [
                'client_name',
                'client_address',
                'notes',
                'responsible_worker',
                'quality_controller'
            ]);
            for (const item of pricedItems) {
                await translateObjectFieldsToEnglish(item, ['material_name', 'unit', 'notes']);
            }
        }

        res.render('costs/order-print', {
            title: type === 'invoice' ? `طلبية شحن ${orders[0].order_number}` : `طباعة طلبية ${orders[0].order_number}`,
            order: displayOrder,
            items: pricedItems,
            totals,
            discountedTotal,
            discountAmount,
            printLang,
            defaultCurrency: req.defaultCurrency || null,
            printType: type || 'order', // order أو invoice
            layout: false
        });
    } catch (error) {
        console.error('خطأ في طباعة تفاصيل الطلبية:', error);
        req.flash('error_msg', 'حدث خطأ في طباعة تفاصيل الطلبية');
        res.redirect('/costs/orders');
    }
};

// تصدير طلبية PDF
const exportOrderPDF = async (req, res) => {
    const pdf = require('html-pdf-node');
    const path = require('path');
    const fs = require('fs');
    const { v4: uuidv4 } = require('uuid');
    try {
        const { id } = req.params;
        const { type } = req.query; // invoice أو order (افتراضي)
        const printLang = String(req.query.lang || 'ar').toLowerCase() === 'en' ? 'en' : 'ar';
        const requestedDiscountedTotal = parseFloat(req.query.discounted_total);
        const queryParts = [];
        if (type) queryParts.push(`type=${encodeURIComponent(type)}`);
        queryParts.push(`lang=${encodeURIComponent(printLang)}`);
        if (Number.isFinite(requestedDiscountedTotal)) queryParts.push(`discounted_total=${encodeURIComponent(requestedDiscountedTotal)}`);
        const queryString = queryParts.length ? `?${queryParts.join('&')}` : '';
        const url = `${process.env.BASE_URL}/costs/orders/${id}/print-pdf-raw${queryString}`;
        const options = { format: 'A4' };
        const file = { url };
        const fileName = `${uuidv4()}.pdf`;
        const savePath = path.join(__dirname, '../public/orders_pdf', fileName);
        const pdfBuffer = await pdf.generatePdf(file, options);
        fs.mkdirSync(path.dirname(savePath), { recursive: true });
        fs.writeFileSync(savePath, pdfBuffer);
        const fileUrl = `${process.env.BASE_URL}/public/orders_pdf/${fileName}`;
        res.json({ success: true, url: fileUrl });
    } catch (error) {
        console.error('Error exporting order PDF:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير الطلبية كـ PDF' });
    }
};

// طباعة طلبية بدون حماية (للتوليد)
const getOrderPrintRaw = async (req, res) => {
    return getOrderPrintPage(req, res);
};

// حذف طلبية
const deleteOrder = async (req, res) => {
    try {
        const { id } = req.params;
        
        await req.db.query('DELETE FROM orders WHERE id = ?', [id]);
        
        res.json({ success: true, message: 'تم حذف الطلبية بنجاح' });
    } catch (error) {
        console.error('خطأ في حذف الطلبية:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في حذف الطلبية' });
    }
};

// دالة معاينة المادة
const getMaterialPreview = async (req, res) => {
    try {
        const { id } = req.params;
        
        const [materials] = await req.db.query(`
            SELECT * FROM materials WHERE id = ? AND deleted_at IS NULL
        `, [id]);
        
        if (materials.length === 0) {
            req.flash('error_msg', 'المادة غير موجودة');
            return res.redirect('/costs/cost-statement');
        }
        
        const material = applyMaterialRaw(materials[0]);
        
        // جلب العناصر الفرعية إذا كانت الطريقة هي العناصر
        let components = [];
        if (material.calculation_method === 'components') {
            const [componentsResult] = await req.db.query(`
                SELECT * FROM material_components 
                WHERE material_id = ? 
                ORDER BY component_name
            `, [id]);
            components = componentsResult.map(applyMaterialComponentRaw);
        }
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;
        
        // اختيار القيم حسب العملة المحددة
        const displayMaterial = {
            ...material,
            unit_cost: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.unit_cost_syp || material.unit_cost)
                : material.unit_cost,
            package_cost: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.package_cost_syp || material.package_cost)
                : material.package_cost,
            price_before_waste: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.price_before_waste_syp || material.price_before_waste)
                : material.price_before_waste,
            empty_package_price: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.empty_package_price_syp || material.empty_package_price)
                : material.empty_package_price,
            sticker_price: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.sticker_price_syp || material.sticker_price)
                : material.sticker_price,
            carton_price: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.carton_price_syp || material.carton_price)
                : material.carton_price,
            pallet_price: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.pallet_price_syp || material.pallet_price)
                : material.pallet_price,
            additional_expenses: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.additional_expenses_syp || material.additional_expenses)
                : material.additional_expenses,
            labor_cost: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.labor_cost_syp || material.labor_cost)
                : material.labor_cost,
            preservatives_cost: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (material.preservatives_cost_syp || material.preservatives_cost)
                : material.preservatives_cost
        };
        
        res.render('costs/material-preview', {
            title: 'معاينة المادة',
            material: displayMaterial,
            components: components,
            user: req.session.user,
            formatDate: formatDate,
            exchangeRate: exchangeRateValue
        });
    } catch (error) {
        console.error('خطأ في معاينة المادة:', error);
        req.flash('error_msg', 'حدث خطأ في معاينة المادة');
        res.redirect('/costs/cost-statement');
    }
};

module.exports = {
    getCosts,
    getCostStatement,
    createMaterial,
    getMaterial,
    getMaterialComponents,
    getMaterialCostLogs,
    getMaterialPreview,
    updateMaterial,
    getQuotations,
    getQuotationJson,
    createQuotation,
    getQuotationDetails,
    updateQuotation,
    getOrders,
    getOrder,
    getOrderDetailsPage,
    getOrderPrintPage,
    getQuotationPrintPage,
    getQuotationPrintRaw,
    exportQuotationPDF,
    getMaterialPrintPage,
    createOrder,
    updateOrder,
    updateOrderStatus,
    deleteMaterial,
    deleteQuotation,
    deleteOrder,
    exportOrderPDF,
    getOrderPrintRaw,
    exportSelectedMaterialsExcel,
    exportSelectedMaterialsPdf,
    trashMaterialsMultiple,
    deleteMaterialsMultiple,
    getDeletedMaterials,
    restoreMaterialsMultiple,
    emptyMaterialsTrash,
    async getMaterialsListPrintPage(req, res) {
        try {
            const [materials] = await req.db.query(`SELECT * FROM materials WHERE deleted_at IS NULL ORDER BY material_name ASC, created_at DESC`);
            // احترام العملة الافتراضية
            const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
            const displayMaterials = materials.map((m) => {
                const rawMaterial = applyMaterialRaw(m);
                return {
                    ...rawMaterial,
                    unit_cost: isSyp ? (rawMaterial.unit_cost_syp || rawMaterial.unit_cost) : rawMaterial.unit_cost,
                    package_cost: isSyp ? (rawMaterial.package_cost_syp || rawMaterial.package_cost) : rawMaterial.package_cost
                };
            });
            res.render('costs/materials-print-list', {
                title: 'طباعة قائمة المواد',
                materials: displayMaterials,
                defaultCurrency: req.defaultCurrency || null,
                baseUrl: process.env.BASE_URL,
                layout: false
            });
        } catch (e) {
            console.error('خطأ في طباعة قائمة المواد:', e);
            res.status(500).send('حدث خطأ في طباعة قائمة المواد');
        }
    }
}; 
