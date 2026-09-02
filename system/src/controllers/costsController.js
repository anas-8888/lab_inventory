const { pool } = require('../database/db');
const { normalizeRawNumeric, buildRawNumericMap, parseRawNumericMap, rawOrValue } = require('../utils/rawNumbers');
const Excel = require('exceljs');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const { generatePdfWithMetrics } = require('../utils/pdf');
const { applyWasteMarkup } = require('../utils/costCalculations');

const QUOTATION_OUTPUT_FIELDS = [
    'client_info', 'sale_description', 'payment_method', 'quotation_notes',
    'row_number', 'material_number', 'material_name', 'material_type', 'packaging_unit',
    'packaging_weight', 'pieces_per_package', 'package_cost', 'profit_percentage',
    'final_price', 'quantity', 'total_price', 'item_notes', 'totals'
];
const ORDER_OUTPUT_FIELDS = [
    'client_info', 'recipient_name', 'dates', 'preparation_info', 'shipping_info', 'order_notes',
    'material_number', 'material_name', 'packaging_unit', 'packaging_weight',
    'pieces_per_package', 'gross_weight', 'requested_quantity', 'unit_price', 'total_price',
    'item_notes', 'totals'
];

const parseOutputFields = (rawValue, allowedFields) => {
    const allowed = new Set(allowedFields);
    const requested = String(rawValue || '').split(',').map((field) => field.trim()).filter((field) => allowed.has(field));
    return requested.length ? [...new Set(requested)] : [...allowedFields];
};

const getPackagingUnitOptions = async (db, { includeInactive = false } = {}) => {
    const [rows] = await db.query(`
        SELECT id, name, kilograms_per_unit, is_active
        FROM packaging_units
        ${includeInactive ? '' : 'WHERE is_active = 1'}
        ORDER BY name ASC, kilograms_per_unit ASC
    `);
    return rows;
};

const getMaterialPackagingMap = async (db, materialIds) => {
    const ids = [...new Set((materialIds || []).map(Number).filter(Number.isInteger))];
    if (ids.length === 0) return new Map();
    const [rows] = await db.query(`
        SELECT mpu.material_id, mpu.unit_role, pu.id, pu.name, pu.kilograms_per_unit, pu.is_active
        FROM material_packaging_units mpu
        INNER JOIN packaging_units pu ON pu.id = mpu.packaging_unit_id
        WHERE mpu.material_id IN (${ids.map(() => '?').join(',')})
        ORDER BY FIELD(mpu.unit_role, 'primary', 'secondary')
    `, ids);
    const map = new Map();
    rows.forEach((row) => {
        if (!map.has(row.material_id)) map.set(row.material_id, []);
        map.get(row.material_id).push(row);
    });
    return map;
};

const attachPackagingUnits = async (db, materials) => {
    const map = await getMaterialPackagingMap(db, materials.map((material) => material.id));
    return materials.map((material) => {
        const packagingUnits = map.get(material.id) || [];
        const primary = packagingUnits.find((unit) => unit.unit_role === 'primary') || null;
        const secondary = packagingUnits.find((unit) => unit.unit_role === 'secondary') || null;
        return {
            ...material,
            packaging_units: packagingUnits,
            primary_packaging_unit_id: primary ? primary.id : null,
            secondary_packaging_unit_id: secondary ? secondary.id : null,
            primary_packaging_unit: primary,
            secondary_packaging_unit: secondary
        };
    });
};

const validateMaterialNumber = async (db, value, excludeId = null) => {
    const materialNumber = String(value ?? '').trim();
    if (!materialNumber) {
        throw Object.assign(new Error('رقم المادة مطلوب'), { statusCode: 400 });
    }
    if (materialNumber.length > 255) {
        throw Object.assign(new Error('رقم المادة يجب ألا يتجاوز 255 خانة'), { statusCode: 400 });
    }
    const params = [materialNumber];
    let excludeSql = '';
    if (excludeId !== null) {
        excludeSql = 'AND id <> ?';
        params.push(excludeId);
    }
    const [rows] = await db.query(
        `SELECT id FROM materials WHERE material_number = ? ${excludeSql} LIMIT 1`,
        params
    );
    if (rows.length > 0) {
        throw Object.assign(new Error('رقم المادة مستخدم لمادة أخرى'), { statusCode: 409 });
    }
    return materialNumber;
};

const resolvePackagingSelection = async (db, primaryId, secondaryId) => {
    const primaryUnitId = Number.parseInt(primaryId, 10);
    const secondaryUnitId = secondaryId ? Number.parseInt(secondaryId, 10) : null;
    if (!Number.isInteger(primaryUnitId) || (secondaryId && !Number.isInteger(secondaryUnitId))) {
        throw Object.assign(new Error('يرجى اختيار وحدة تعبئة أساسية صالحة'), { statusCode: 400 });
    }
    if (secondaryUnitId && secondaryUnitId === primaryUnitId) {
        throw Object.assign(new Error('يجب أن تختلف الوحدة الثانوية عن الوحدة الأساسية'), { statusCode: 400 });
    }
    const ids = secondaryUnitId ? [primaryUnitId, secondaryUnitId] : [primaryUnitId];
    const [rows] = await db.query(
        `SELECT id, name, kilograms_per_unit, is_active FROM packaging_units WHERE id IN (${ids.map(() => '?').join(',')})`,
        ids
    );
    const primary = rows.find((row) => row.id === primaryUnitId);
    const secondary = secondaryUnitId ? rows.find((row) => row.id === secondaryUnitId) : null;
    if (!primary || !primary.is_active || (secondaryUnitId && (!secondary || !secondary.is_active))) {
        throw Object.assign(new Error('وحدة التعبئة المختارة غير موجودة أو معطلة'), { statusCode: 400 });
    }
    return { primary, secondary };
};

const syncMaterialPackagingUnits = async (db, materialId, selection) => {
    await db.query('DELETE FROM material_packaging_units WHERE material_id = ?', [materialId]);
    await db.query(
        `INSERT INTO material_packaging_units (material_id, packaging_unit_id, unit_role)
         VALUES (?, ?, 'primary')`,
        [materialId, selection.primary.id]
    );
    if (selection.secondary) {
        await db.query(
            `INSERT INTO material_packaging_units (material_id, packaging_unit_id, unit_role)
             VALUES (?, ?, 'secondary')`,
            [materialId, selection.secondary.id]
        );
    }
};

const resolveItemPackagingUnit = async (db, materialId, packagingUnitId) => {
    const parsedMaterialId = Number.parseInt(materialId, 10);
    const parsedUnitId = Number.parseInt(packagingUnitId, 10);
    if (!Number.isInteger(parsedMaterialId)) return null;
    const params = [parsedMaterialId];
    let unitFilter = "AND mpu.unit_role = 'primary'";
    if (Number.isInteger(parsedUnitId)) {
        unitFilter = 'AND pu.id = ?';
        params.push(parsedUnitId);
    }
    const [rows] = await db.query(`
        SELECT pu.id, pu.name, pu.kilograms_per_unit, mpu.unit_role, m.pieces_per_package, m.material_number
        FROM material_packaging_units mpu
        INNER JOIN packaging_units pu ON pu.id = mpu.packaging_unit_id
        INNER JOIN materials m ON m.id = mpu.material_id
        WHERE mpu.material_id = ? ${unitFilter}
        LIMIT 1
    `, params);
    if (rows.length === 0) {
        throw Object.assign(new Error('وحدة التعبئة المختارة غير مرتبطة بالمادة'), { statusCode: 400 });
    }
    return rows[0];
};

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
const VALID_COST_INPUT_BASES = new Set(['per_kg', 'total']);

const normalizeCostInputBasis = (value) => (VALID_COST_INPUT_BASES.has(value) ? value : null);

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
    mapped.cost_input_basis = normalizeCostInputBasis(rawMap.cost_input_basis) || mapped.cost_input_basis;

    return mapped;
};

const inferMaterialCostInputBasis = (material) => {
    if (!material || typeof material !== 'object' || material.material_origin === 'external') {
        return null;
    }

    const rawMap = parseRawNumericMap(material.numeric_raw);
    const explicitBasis = normalizeCostInputBasis(rawMap.cost_input_basis);
    if (explicitBasis) {
        return explicitBasis;
    }

    const grossWeight = parseFloat(rawOrValue(rawMap, 'gross_weight', material.gross_weight)) || 0;
    const packagingWeight = parseFloat(rawOrValue(rawMap, 'packaging_weight', material.packaging_weight)) || 0;
    const priceBeforeWaste = parseFloat(rawOrValue(rawMap, 'price_before_waste', material.price_before_waste)) || 0;
    const wastePercentage = parseFloat(rawOrValue(rawMap, 'waste_percentage', material.waste_percentage)) || 0;
    const emptyPackagePrice = parseFloat(rawOrValue(rawMap, 'empty_package_price', material.empty_package_price)) || 0;
    const stickerPrice = parseFloat(rawOrValue(rawMap, 'sticker_price', material.sticker_price)) || 0;
    const additionalExpenses = parseFloat(rawOrValue(rawMap, 'additional_expenses', material.additional_expenses)) || 0;
    const laborCost = parseFloat(rawOrValue(rawMap, 'labor_cost', material.labor_cost)) || 0;
    const preservativesCost = parseFloat(rawOrValue(rawMap, 'preservatives_cost', material.preservatives_cost)) || 0;
    const cartonPrice = parseFloat(rawOrValue(rawMap, 'carton_price', material.carton_price)) || 0;
    const palletPrice = parseFloat(rawOrValue(rawMap, 'pallet_price', material.pallet_price)) || 0;
    const piecesPerPackage = parseFloat(rawOrValue(rawMap, 'pieces_per_package', material.pieces_per_package)) || 0;
    const packagesPerPallet = parseFloat(rawOrValue(rawMap, 'packages_per_pallet', material.packages_per_pallet)) || 0;
    const storedUnitCost = parseFloat(material.unit_cost) || 0;
    const storedPackageCost = parseFloat(material.package_cost) || 0;

    if (grossWeight <= 0 || packagingWeight <= 0) {
        return null;
    }

    const evaluateBasis = (basis) => {
        const normalized = normalizeAuxiliaryCostsByBasis({
            basis,
            usd: {
                sticker_price: stickerPrice,
                additional_expenses: additionalExpenses,
                labor_cost: laborCost,
                preservatives_cost: preservativesCost,
                carton_price: cartonPrice,
                pallet_price: palletPrice
            },
            syp: {
                sticker_price: stickerPrice,
                additional_expenses: additionalExpenses,
                labor_cost: laborCost,
                preservatives_cost: preservativesCost,
                carton_price: cartonPrice,
                pallet_price: palletPrice
            },
            grossWeight,
            packagingWeight
        }).usd;

        const pricePerKgBeforeWaste = grossWeight > 0 ? (priceBeforeWaste / grossWeight) : 0;
        const pricePerKgAfterWaste = applyWasteMarkup(pricePerKgBeforeWaste, wastePercentage);
        const materialCostInUnit = pricePerKgAfterWaste * packagingWeight;
        const unitCost = materialCostInUnit + emptyPackagePrice + normalized.sticker_price + normalized.additional_expenses + normalized.labor_cost + normalized.preservatives_cost;
        const palletShare = packagesPerPallet > 0 ? (normalized.pallet_price / packagesPerPallet) : 0;
        const packageCost = (unitCost * piecesPerPackage) + normalized.carton_price + palletShare;

        return { unitCost, packageCost };
    };

    const perKgCandidate = evaluateBasis('per_kg');
    const totalCandidate = evaluateBasis('total');
    const perKgScore = Math.abs(perKgCandidate.unitCost - storedUnitCost) + Math.abs(perKgCandidate.packageCost - storedPackageCost);
    const totalScore = Math.abs(totalCandidate.unitCost - storedUnitCost) + Math.abs(totalCandidate.packageCost - storedPackageCost);

    if (!Number.isFinite(perKgScore) || !Number.isFinite(totalScore)) {
        return null;
    }

    if (Math.abs(perKgScore - totalScore) < 0.01) {
        return null;
    }

    return perKgScore < totalScore ? 'per_kg' : 'total';
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
        const [materialRows] = await req.db.query(`
            SELECT * FROM materials 
            WHERE deleted_at IS NULL
            ORDER BY created_at DESC
        `);
        const materials = await attachPackagingUnits(req.db, materialRows);
        
        const [quotations] = await req.db.query(`
            SELECT q.*, b.brand_name, COUNT(qi.id) as items_count
            FROM quotations q 
            LEFT JOIN brands b ON b.id = q.brand_id
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
        const [materialRows] = await req.db.query(`
            SELECT * FROM materials 
            WHERE deleted_at IS NULL
            ORDER BY created_at DESC
        `);
        const materials = await attachPackagingUnits(req.db, materialRows);
        const packagingUnits = await getPackagingUnitOptions(req.db);
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
            ,packagingUnits
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
            material_number,
            customs_number,
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
        const validatedMaterialNumber = await validateMaterialNumber(req.db, material_number);
        const normalizedCustomsNumber = String(customs_number ?? '').trim() || null;
        const materialOrigin = material_origin === 'external' ? 'external' : 'internal';
        const packagingSelection = await resolvePackagingSelection(
            req.db,
            req.body.primary_packaging_unit_id,
            req.body.secondary_packaging_unit_id
        );
        const selectedPackagingUnit = packagingSelection.primary.name;
        const selectedPackagingWeight = packagingSelection.primary.kilograms_per_unit;

        if (materialOrigin === 'external') {
            const externalMaterialType = (material_type || '').trim();
            const name = (material_name || '').trim();
            const packagingUnit = selectedPackagingUnit;
            const netWeight = parseFloat(external_net_weight ?? selectedPackagingWeight) || selectedPackagingWeight;
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
                    material_origin, material_number, customs_number, material_type, material_name, external_notes, calculation_method,
                    price_before_waste, price_before_waste_syp, gross_weight, waste_percentage,
                    packaging_unit, packaging_weight, packaging_unit_weight,
                    empty_package_price, empty_package_price_syp, sticker_price, sticker_price_syp,
                    additional_expenses, additional_expenses_syp, labor_cost, labor_cost_syp,
                    preservatives_cost, preservatives_cost_syp, carton_price, carton_price_syp,
                    pieces_per_package, pallet_price, pallet_price_syp, packages_per_pallet,
                    unit_cost, unit_cost_syp, package_cost, package_cost_syp,
                    extra_weights, gross_package_weight, additional_expense_items, numeric_raw
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `, [
                'external', validatedMaterialNumber, normalizedCustomsNumber, externalMaterialType, name, notes, 'traditional',
                costPerKg, costPerKgSyp, netWeight, 0,
                packagingUnit, netWeight, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                1, 0, 0, 1,
                unitCost, unitCostSyp, packageCost, packageCostSyp,
                JSON.stringify([]), netWeight, JSON.stringify([]), JSON.stringify(externalRawMap)
            ]);
            await syncMaterialPackagingUnits(req.db, result.insertId, packagingSelection);

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
        const packaging_weight_for_calc = Number(selectedPackagingWeight) || 0;
        const packaging_unit_weight_num = parseFloat(packaging_unit_weight) || 0;
        const pieces_per_package_num = parseInt(pieces_per_package) || 0;
        const packages_per_pallet_num = parseInt(packages_per_pallet) || 0;
        const costInputBasis = 'total';


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
        
        const price_per_kg_after_waste = applyWasteMarkup(price_per_kg_before_waste, waste_percentage_num);
        const price_per_kg_after_waste_syp = applyWasteMarkup(price_per_kg_before_waste_syp, waste_percentage_num);
        
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
        internalRawMap.cost_input_basis = costInputBasis;


        // حفظ المادة
        const [result] = await req.db.query(`
            INSERT INTO materials (
                material_origin, material_number, customs_number, material_type, material_name, external_notes, calculation_method, price_before_waste, price_before_waste_syp,
                gross_weight, waste_percentage, packaging_unit, packaging_weight,
                packaging_unit_weight,
                empty_package_price, empty_package_price_syp, sticker_price, sticker_price_syp,
                additional_expenses, additional_expenses_syp, labor_cost, labor_cost_syp,
                preservatives_cost, preservatives_cost_syp, carton_price, carton_price_syp,
                pieces_per_package, pallet_price, pallet_price_syp, packages_per_pallet,
                unit_cost, unit_cost_syp, package_cost, package_cost_syp,
                extra_weights, gross_package_weight, additional_expense_items, numeric_raw
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            'internal', validatedMaterialNumber, normalizedCustomsNumber, material_type, material_name, null, calculation_method || 'traditional', (usd.price_before_waste || 0), (syp.price_before_waste || 0),
            gross_weight_num, waste_percentage_num, selectedPackagingUnit, selectedPackagingWeight,
            packaging_unit_weight_num,
            (usd.empty_package_price || 0), (syp.empty_package_price || 0), (usd.sticker_price || 0), (syp.sticker_price || 0),
            (usd.additional_expenses || 0), (syp.additional_expenses || 0), (usd.labor_cost || 0), (syp.labor_cost || 0),
            (usd.preservatives_cost || 0), (syp.preservatives_cost || 0), (usd.carton_price || 0), (syp.carton_price || 0),
            pieces_per_package_num, (usd.pallet_price || 0), (syp.pallet_price || 0), packages_per_pallet_num,
            unit_cost, unit_cost_syp, package_cost, package_cost_syp,
            JSON.stringify(extraWeightsArr || []), gross_package_weight, JSON.stringify(additionalExpenseItemsArr || []), JSON.stringify(internalRawMap)
        ]);
        await syncMaterialPackagingUnits(req.db, result.insertId, packagingSelection);

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
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({ success: false, message: 'رقم المادة مستخدم لمادة أخرى' });
        }
        res.status(error.statusCode || 500).json({
            success: false, 
            message: error.statusCode ? error.message : 'حدث خطأ في حفظ المادة',
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
            material_number,
            customs_number,
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
        const validatedMaterialNumber = await validateMaterialNumber(req.db, material_number, id);
        const normalizedCustomsNumber = String(customs_number ?? '').trim() || null;

        const [materialRows] = await req.db.query(`SELECT id, material_origin, numeric_raw FROM materials WHERE id = ?`, [id]);
        if (materialRows.length === 0) {
            return res.status(404).json({ success: false, message: 'المادة غير موجودة' });
        }
        const existingOrigin = materialRows[0].material_origin === 'external' ? 'external' : 'internal';
        const existingRawMap = parseRawNumericMap(materialRows[0].numeric_raw);
        const packagingSelection = await resolvePackagingSelection(
            req.db,
            req.body.primary_packaging_unit_id,
            req.body.secondary_packaging_unit_id
        );
        const selectedPackagingUnit = packagingSelection.primary.name;
        const selectedPackagingWeight = packagingSelection.primary.kilograms_per_unit;

        if (existingOrigin === 'external') {
            const externalMaterialType = (material_type || '').trim();
            const name = (material_name || '').trim();
            const packagingUnit = selectedPackagingUnit;
            const netWeight = parseFloat(external_net_weight ?? selectedPackagingWeight) || selectedPackagingWeight;
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
                    material_origin = 'external', material_number = ?, customs_number = ?, material_type = ?, material_name = ?, external_notes = ?,
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
                validatedMaterialNumber, normalizedCustomsNumber, externalMaterialType, name, notes, costPerKg, costPerKgSyp,
                netWeight, packagingUnit, netWeight, unitCost, unitCostSyp, packageCost, packageCostSyp,
                JSON.stringify([]), netWeight, JSON.stringify([]), JSON.stringify(externalRawMap), id
            ]);
            await syncMaterialPackagingUnits(req.db, id, packagingSelection);
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
        const existingCostInputBasis = normalizeCostInputBasis(existingRawMap.cost_input_basis);
        const costInputBasis = existingCostInputBasis || 'normalized';
        // نحفظ packaging_weight كما هو (نص) للحفاظ على الدقة
        const packaging_weight_for_calc = Number(selectedPackagingWeight) || 0;
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
        const price_per_kg_after_waste_usd = applyWasteMarkup(price_per_kg_before_waste_usd, waste_percentage_num);
        const material_cost_in_unit_usd = price_per_kg_after_waste_usd * packaging_weight_for_calc;
        const total_packaging_costs_usd =
            (usd.empty_package_price || 0) + (usd.sticker_price || 0) + (usd.additional_expenses || 0) +
            (usd.labor_cost || 0) + (usd.preservatives_cost || 0);
        const unit_cost = roundToDecimal(material_cost_in_unit_usd + total_packaging_costs_usd, 2);
        const pallet_share_usd = roundToDecimal((usd.pallet_price || 0) / packages_per_pallet_num, 2);
        const package_cost = roundToDecimal((unit_cost * pieces_per_package_num) + (usd.carton_price || 0) + pallet_share_usd, 2);

        // حساب كلفة القطعة والطرد بالليرة باستخدام قيم SYP المدخلة
        const price_per_kg_before_waste_syp = (gross_weight_num > 0) ? ((syp.price_before_waste || 0) / gross_weight_num) : 0;
        const price_per_kg_after_waste_syp = applyWasteMarkup(price_per_kg_before_waste_syp, waste_percentage_num);
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
        if (existingCostInputBasis) {
            internalRawMap.cost_input_basis = costInputBasis;
        } else {
            delete internalRawMap.cost_input_basis;
        }

        // تحديث المادة
        await req.db.query(`
            UPDATE materials SET
                material_origin = 'internal', material_number = ?, customs_number = ?, material_type = ?, material_name = ?, external_notes = NULL, calculation_method = ?, price_before_waste = ?, price_before_waste_syp = ?,
                gross_weight = ?, waste_percentage = ?, packaging_unit = ?, packaging_weight = ?, packaging_unit_weight = ?,
                empty_package_price = ?, empty_package_price_syp = ?, sticker_price = ?, sticker_price_syp = ?,
                additional_expenses = ?, additional_expenses_syp = ?, labor_cost = ?, labor_cost_syp = ?,
                preservatives_cost = ?, preservatives_cost_syp = ?, carton_price = ?, carton_price_syp = ?,
                pieces_per_package = ?, pallet_price = ?, pallet_price_syp = ?, packages_per_pallet = ?,
                unit_cost = ?, unit_cost_syp = ?, package_cost = ?, package_cost_syp = ?,
                extra_weights = ?, gross_package_weight = ?, additional_expense_items = ?, numeric_raw = ?
            WHERE id = ?
        `, [
            validatedMaterialNumber, normalizedCustomsNumber, material_type, material_name, calculation_method || 'traditional', (usd.price_before_waste || 0), (syp.price_before_waste || 0),
            gross_weight_num, waste_percentage_num, selectedPackagingUnit, selectedPackagingWeight, packaging_unit_weight_num,
            (usd.empty_package_price || 0), (syp.empty_package_price || 0), (usd.sticker_price || 0), (syp.sticker_price || 0),
            (usd.additional_expenses || 0), (syp.additional_expenses || 0), (usd.labor_cost || 0), (syp.labor_cost || 0),
            (usd.preservatives_cost || 0), (syp.preservatives_cost || 0), (usd.carton_price || 0), (syp.carton_price || 0),
            pieces_per_package_num, (usd.pallet_price || 0), (syp.pallet_price || 0), packages_per_pallet_num,
            unit_cost, unit_cost_syp, package_cost, package_cost_syp,
            JSON.stringify(extraWeightsArr || []), gross_package_weight, JSON.stringify(additionalExpenseItemsArr || []), JSON.stringify(internalRawMap), id
        ]);
        await syncMaterialPackagingUnits(req.db, id, packagingSelection);

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
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({ success: false, message: 'رقم المادة مستخدم لمادة أخرى' });
        }
        res.status(error.statusCode || 500).json({ success: false, message: error.statusCode ? error.message : 'حدث خطأ في تحديث المادة' });
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
        
        const [materialRows] = await req.db.query(`
            SELECT * FROM materials WHERE deleted_at IS NULL ORDER BY material_name
        `);
        const materials = await attachPackagingUnits(req.db, materialRows);

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

        const [brands] = await req.db.query('SELECT id, brand_name FROM brands ORDER BY brand_name');
        const brandMaterialRows = brands.length
            ? (await req.db.query(`
                SELECT bm.brand_id, bm.material_id
                FROM brand_materials bm
                INNER JOIN materials m ON m.id = bm.material_id AND m.deleted_at IS NULL
                WHERE bm.brand_id IN (${brands.map(() => '?').join(',')})
            `, brands.map((brand) => brand.id)))[0]
            : [];

        res.render('costs/quotations', {
            title: 'عروض الأسعار',
            quotations: displayQuotations,
            materials: displayMaterials,
            formatDate,
            exchangeRate: exchangeRateValue,
            brands,
            brandMaterials: brandMaterialRows
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
        const { client_name, client_phone, client_address, notes, sale_description, payment_method, items, brand_id } = req.body;

        // التحقق من البيانات المطلوبة
        if (!client_name || !client_name.trim()) {
            return res.status(400).json({ 
                success: false, 
                message: 'اسم العميل مطلوب' 
            });
        }
        for (const item of (Array.isArray(items) ? items : [])) {
            item._selectedPackagingUnit = await resolveItemPackagingUnit(req.db, item.material_id, item.packaging_unit_id);
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
            `UPDATE quotations SET client_name = ?, client_phone = ?, client_address = ?, notes = ?, sale_description = ?, payment_method = ?, brand_id = ?, numeric_raw = ? WHERE id = ?`,
            [client_name, client_phone, client_address, notes, normalizedSaleDescription, normalizedPaymentMethod, Number(brand_id) || null, JSON.stringify(quotationHeaderRawMap), id]
        );

        // حذف البنود القديمة
        await req.db.query(`DELETE FROM quotation_items WHERE quotation_id = ?`, [id]);

        // إعادة الحساب والحفظ
        let totalAmount = 0;
        let totalAmountSyp = 0;
        if (items && Array.isArray(items)) {
            for (const item of items) {
                const selectedPackagingUnit = item._selectedPackagingUnit;
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
                        quotation_id, material_id, material_number, packaging_unit_id, material_name, unit_cost, unit_cost_syp, profit_percentage, final_price, final_price_syp, quantity, total_price, total_price_syp,
                        material_type, packaging_unit, packaging_weight, pieces_per_package, package_cost, item_notes, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                    [
                        id, item.material_id || null, selectedPackagingUnit ? selectedPackagingUnit.material_number : (item.material_number || null), selectedPackagingUnit ? selectedPackagingUnit.id : null, item.material_name || '',
                        unitCostUSD || 0, unitCostSYP || 0, profitPercentage,
                        finalPriceUSD, finalPriceSYP, quantity, totalPriceUSD, totalPriceSYP,
                        item.material_type || null, selectedPackagingUnit ? selectedPackagingUnit.name : (item.packaging_unit || null),
                        selectedPackagingUnit ? selectedPackagingUnit.kilograms_per_unit : (typeof item.packaging_weight === 'string' ? item.packaging_weight : (item.packaging_weight || null)),
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
        res.status(error.statusCode || 500).json({
            success: false, 
            message: error.statusCode ? error.message : 'حدث خطأ في تحديث عرض السعر',
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
            items,
            brand_id
        } = req.body;

        // التحقق من البيانات المطلوبة
        if (!client_name || !client_name.trim()) {
            return res.status(400).json({ 
                success: false, 
                message: 'اسم العميل مطلوب' 
            });
        }
        for (const item of (Array.isArray(items) ? items : [])) {
            item._selectedPackagingUnit = await resolveItemPackagingUnit(req.db, item.material_id, item.packaging_unit_id);
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
            INSERT INTO quotations (quotation_number, client_name, client_phone, client_address, notes, sale_description, payment_method, brand_id, general_profit_percentage, total_amount, total_amount_syp, numeric_raw)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?)
        `, [quotationNumber, client_name, client_phone, client_address, notes, normalizedSaleDescription, normalizedPaymentMethod, Number(brand_id) || null, general_profit_percentage || 0, JSON.stringify(quotationHeaderRawMap)]);

        let totalAmount = 0;
        let totalAmountSyp = 0;

        // حفظ بنود العرض
        if (items && Array.isArray(items)) {
            for (const item of items) {
                const selectedPackagingUnit = item._selectedPackagingUnit;
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
                        quotation_id, material_id, material_number, packaging_unit_id, material_name, unit_cost, unit_cost_syp, profit_percentage, final_price, final_price_syp, quantity, total_price, total_price_syp,
                        material_type, packaging_unit, packaging_weight, pieces_per_package, package_cost, item_notes, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                `, [
                    quotationResult.insertId, item.material_id || null, selectedPackagingUnit ? selectedPackagingUnit.material_number : (item.material_number || null), selectedPackagingUnit ? selectedPackagingUnit.id : null, item.material_name || '',
                    unitCostUSD || 0, unitCostSYP || 0, profitPercentage, finalPriceUSD, finalPriceSYP,
                    quantity, totalPriceUSD, totalPriceSYP, item.material_type || null, selectedPackagingUnit ? selectedPackagingUnit.name : (item.packaging_unit || null),
                    selectedPackagingUnit ? selectedPackagingUnit.kilograms_per_unit : (typeof item.packaging_weight === 'string' ? item.packaging_weight : (item.packaging_weight || null)),
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
        res.status(error.statusCode || 500).json({
            success: false, 
            message: error.statusCode ? error.message : 'حدث خطأ في إنشاء عرض السعر',
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
        const outputFields = parseOutputFields(req.query.fields, QUOTATION_OUTPUT_FIELDS);
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
            outputFields,
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
        const outputFields = parseOutputFields(req.query.fields, QUOTATION_OUTPUT_FIELDS);
        const requestedDiscountedTotal = parseFloat(req.query.discounted_total);
        const discountedTotalQuery = Number.isFinite(requestedDiscountedTotal)
            ? `&discounted_total=${encodeURIComponent(requestedDiscountedTotal)}`
            : '';
        const fieldsQuery = `&fields=${encodeURIComponent(outputFields.join(','))}`;
        const url = `${process.env.BASE_URL}/costs/quotations/${id}/print-pdf-raw?lang=${encodeURIComponent(printLang)}${fieldsQuery}${discountedTotalQuery}`;
        const options = { format: 'A4' };
        const file = { url };
        const fileName = `${uuidv4()}.pdf`;
        const savePath = path.join(__dirname, '../public/quotations_pdf', fileName);
        const pdfBuffer = await generatePdfWithMetrics(pdf, file, options, `quotation:${id}`);
        fs.mkdirSync(path.dirname(savePath), { recursive: true });
        await fs.promises.writeFile(savePath, pdfBuffer);
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
        const outputFields = parseOutputFields(req.query.fields, QUOTATION_OUTPUT_FIELDS);
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
            outputFields,
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
        const materialWithUnits = await attachPackagingUnits(req.db, materials);
        const material = applyMaterialRaw(materialWithUnits[0]);
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
            SELECT o.*, b.brand_name,
                   COALESCE(SUM(oi.total_price), 0) as total_amount,
                   COALESCE(SUM(oi.total_price_syp), 0) as total_amount_syp
            FROM orders o
            LEFT JOIN brands b ON b.id = o.brand_id
            LEFT JOIN order_items oi ON o.id = oi.order_id
            GROUP BY o.id
            ORDER BY o.created_at DESC
        `);
        const [materialRows] = await req.db.query(`
            SELECT id, material_name, packaging_unit, packaging_weight, gross_package_weight, package_cost, package_cost_syp, numeric_raw 
            FROM materials WHERE deleted_at IS NULL ORDER BY material_name
        `);
        const materials = await attachPackagingUnits(req.db, materialRows);

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
        const [brands] = await req.db.query('SELECT id, brand_name FROM brands ORDER BY brand_name');
        const brandMaterialRows = brands.length
            ? (await req.db.query(`
                SELECT bm.brand_id, bm.material_id
                FROM brand_materials bm
                INNER JOIN materials m ON m.id = bm.material_id AND m.deleted_at IS NULL
                WHERE bm.brand_id IN (${brands.map(() => '?').join(',')})
            `, brands.map((brand) => brand.id)))[0]
            : [];

        res.render('costs/orders', {
            title: 'الطلبيات',
            orders: displayOrders,
            materials: displayMaterials,
            formatDate,
            defaultCurrency: req.defaultCurrency || null,
            exchangeRate: exchangeRateValue,
            brands,
            brandMaterials: brandMaterialRows
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
            recipient_name,
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
            items,
            brand_id
        } = req.body;

        // التحقق من الحقول المطلوبة
        if (!client_name || !client_name.trim()) {
            return res.status(400).json({ 
                success: false, 
                message: 'اسم الزبون مطلوب' 
            });
        }
        for (const item of (Array.isArray(items) ? items : [])) {
            item._selectedPackagingUnit = await resolveItemPackagingUnit(req.db, item.material_id, item.packaging_unit_id);
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
                order_number, client_name, recipient_name, order_date, delivery_date,
                responsible_worker, quality_controller, pallets_count, container_number,
                packages_count, waybill_number, accreditation_number, notes, brand_id, numeric_raw
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            orderNumber, client_name || null, recipient_name || null, orderDateSql, deliveryDateSql,
            responsible_worker || null, quality_controller || null, pallets_count || null, container_number || null,
            packages_count || null, waybill_number || null, accreditation_number || null, notes || null, Number(brand_id) || null, JSON.stringify(orderHeaderRawMap)
        ]);

        // حفظ بنود الطلبية إن وُجدت
        if (items && Array.isArray(items)) {
            for (const item of items) {
                const selectedPackagingUnit = item._selectedPackagingUnit;
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
                        order_id, material_id, material_number, packaging_unit_id, material_name, unit, packaging_weight, pieces_per_package, requested_quantity, weight, volume,
                        unit_price, unit_price_syp, total_price, total_price_syp, notes, net_weight, gross_weight, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                `, [
                    orderResult.insertId,
                    item.material_id || null,
                    selectedPackagingUnit ? selectedPackagingUnit.material_number : (item.material_number || null),
                    selectedPackagingUnit ? selectedPackagingUnit.id : null,
                    item.material_name || '',
                    selectedPackagingUnit ? selectedPackagingUnit.name : (item.unit || null),
                    selectedPackagingUnit ? selectedPackagingUnit.kilograms_per_unit : null,
                    selectedPackagingUnit ? selectedPackagingUnit.pieces_per_package : null,
                    quantity,
                    item.weight || null,
                    item.volume || null,
                    unitPriceUSD,
                    unitPriceSYP,
                    totalPriceUSD,
                    totalPriceSYP,
                    item.notes || null,
                    item.net_weight || null,
                    item.gross_weight ?? null,
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
        res.status(error.statusCode || 500).json({
            success: false, 
            message: error.statusCode ? error.message : 'حدث خطأ في إنشاء الطلبية',
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
        
        const materialWithUnits = await attachPackagingUnits(req.db, materials);
        const material = applyMaterialRaw(materialWithUnits[0]);
        material.cost_input_basis = normalizeCostInputBasis(material.cost_input_basis) || null;
        res.json({ success: true, material });
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
        const [materialRows] = await req.db.query(`
            SELECT * FROM materials
            WHERE deleted_at IS NOT NULL
            ORDER BY deleted_at DESC
        `);
        const materials = await attachPackagingUnits(req.db, materialRows);
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
        const [materialRows] = await req.db.query(
            `SELECT * FROM materials WHERE id IN (${placeholders}) AND deleted_at IS NULL ORDER BY created_at DESC`,
            ids
        );
        const materials = await attachPackagingUnits(req.db, materialRows);

        if (!materials.length) {
            return res.status(404).json({ success: false, message: 'لا توجد مواد صالحة للتصدير' });
        }

        const workbook = new Excel.Workbook();
        const worksheet = workbook.addWorksheet('مواد محددة');
        worksheet.views = [{ rightToLeft: true }];

        const columns = [
            { header: '#', key: 'row_number', width: 8 },
            { header: 'رقم المادة', key: 'material_number', width: 20 },
            { header: 'الرقم الجمركي', key: 'customs_number', width: 20 },
            { header: 'اسم المادة', key: 'material_name', width: 34 },
            { header: 'وحدة التعبئة', key: 'packaging_unit', width: 16 },
            { header: 'الوحدة الثانوية', key: 'secondary_packaging_unit', width: 20 },
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
                material_number: row.material_number || '-',
                customs_number: row.customs_number || '-',
                material_name: row.material_name || '-',
                packaging_unit: row.primary_packaging_unit ? row.primary_packaging_unit.name : (row.packaging_unit || '-'),
                secondary_packaging_unit: row.secondary_packaging_unit ? row.secondary_packaging_unit.name : '-',
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
        const [materialRows] = await req.db.query(
            `SELECT * FROM materials WHERE id IN (${placeholders}) AND deleted_at IS NULL ORDER BY created_at DESC`,
            ids
        );
        const materials = await attachPackagingUnits(req.db, materialRows);

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
            const pdfBuffer = await generatePdfWithMetrics(pdf, { content: html }, options, 'materials-list-render');
            const fileName = `${uuidv4()}.pdf`;
            const savePath = path.join(__dirname, '../public/materials_list_pdf', fileName);
            fs.mkdirSync(path.dirname(savePath), { recursive: true });
            await fs.promises.writeFile(savePath, pdfBuffer);

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
            recipient_name,
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
            items,
            brand_id
        } = req.body;
        
        // التحقق من الحقول المطلوبة
        if (!client_name || !client_name.trim()) {
            return res.status(400).json({ 
                success: false, 
                message: 'اسم العميل مطلوب' 
            });
        }
        for (const item of (Array.isArray(items) ? items : [])) {
            item._selectedPackagingUnit = await resolveItemPackagingUnit(req.db, item.material_id, item.packaging_unit_id);
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
                client_name = ?, recipient_name = ?, order_date = ?, delivery_date = ?,
                responsible_worker = ?, quality_controller = ?, pallets_count = ?, container_number = ?,
                packages_count = ?, waybill_number = ?, accreditation_number = ?, notes = ?, brand_id = ?, numeric_raw = ?
            WHERE id = ?
        `, [
            client_name || null, recipient_name || null, orderDateSql, deliveryDateSql,
            responsible_worker || null, quality_controller || null, pallets_count || null, container_number || null,
            packages_count || null, waybill_number || null, accreditation_number || null, notes || null, Number(brand_id) || null, JSON.stringify(orderHeaderRawMap), id
        ]);

        // حدّث البنود
        await req.db.query('DELETE FROM order_items WHERE order_id = ?', [id]);
        if (items && Array.isArray(items)) {
            for (const item of items) {
                const selectedPackagingUnit = item._selectedPackagingUnit;
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
                        order_id, material_id, material_number, packaging_unit_id, material_name, unit, packaging_weight, pieces_per_package, requested_quantity, weight, volume,
                        unit_price, unit_price_syp, total_price, total_price_syp, notes, net_weight, gross_weight, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                `, [
                    id,
                    item.material_id || null,
                    selectedPackagingUnit ? selectedPackagingUnit.material_number : (item.material_number || null),
                    selectedPackagingUnit ? selectedPackagingUnit.id : null,
                    item.material_name || '',
                    selectedPackagingUnit ? selectedPackagingUnit.name : (item.unit || null),
                    selectedPackagingUnit ? selectedPackagingUnit.kilograms_per_unit : null,
                    selectedPackagingUnit ? selectedPackagingUnit.pieces_per_package : null,
                    quantity,
                    item.weight || null,
                    item.volume || null,
                    unitPriceUSD,
                    unitPriceSYP,
                    totalPriceUSD,
                    totalPriceSYP,
                    item.notes || null,
                    item.net_weight || null,
                    item.gross_weight ?? null,
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
        res.status(error.statusCode || 500).json({
            success: false, 
            message: error.statusCode ? error.message : 'حدث خطأ في تحديث الطلبية',
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
        const printLang = String(req.query.lang || 'ar').toLowerCase() === 'en' ? 'en' : 'ar';
        const outputFields = parseOutputFields(req.query.fields, ORDER_OUTPUT_FIELDS);
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
                'recipient_name',
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
            title: `طباعة طلبية ${orders[0].order_number}`,
            order: displayOrder,
            items: pricedItems,
            totals,
            discountedTotal,
            discountAmount,
            outputFields,
            printLang,
            defaultCurrency: req.defaultCurrency || null,
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
        const printLang = String(req.query.lang || 'ar').toLowerCase() === 'en' ? 'en' : 'ar';
        const outputFields = parseOutputFields(req.query.fields, ORDER_OUTPUT_FIELDS);
        const requestedDiscountedTotal = parseFloat(req.query.discounted_total);
        const queryParts = [];
        queryParts.push(`lang=${encodeURIComponent(printLang)}`);
        queryParts.push(`fields=${encodeURIComponent(outputFields.join(','))}`);
        if (Number.isFinite(requestedDiscountedTotal)) queryParts.push(`discounted_total=${encodeURIComponent(requestedDiscountedTotal)}`);
        const queryString = queryParts.length ? `?${queryParts.join('&')}` : '';
        const url = `${process.env.BASE_URL}/costs/orders/${id}/print-pdf-raw${queryString}`;
        const options = { format: 'A4' };
        const file = { url };
        const fileName = `${uuidv4()}.pdf`;
        const savePath = path.join(__dirname, '../public/orders_pdf', fileName);
        const pdfBuffer = await generatePdfWithMetrics(pdf, file, options, `order:${id}`);
        fs.mkdirSync(path.dirname(savePath), { recursive: true });
        await fs.promises.writeFile(savePath, pdfBuffer);
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

const getBrands = async (req, res) => {
    try {
        const [brands] = await req.db.query(`
            SELECT b.*, COUNT(m.id) AS materials_count
            FROM brands b
            LEFT JOIN brand_materials bm ON bm.brand_id = b.id
            LEFT JOIN materials m ON m.id = bm.material_id AND m.deleted_at IS NULL
            GROUP BY b.id
            ORDER BY b.brand_name ASC
        `);
        const [materials] = await req.db.query(`
            SELECT id, material_number, material_name, material_type
            FROM materials WHERE deleted_at IS NULL ORDER BY material_name ASC
        `);
        const brandIds = brands.map((brand) => brand.id);
        let links = [];
        if (brandIds.length) {
            const [rows] = await req.db.query(
                `SELECT bm.brand_id, bm.material_id
                 FROM brand_materials bm
                 INNER JOIN materials m ON m.id = bm.material_id AND m.deleted_at IS NULL
                 WHERE bm.brand_id IN (${brandIds.map(() => '?').join(',')})`,
                brandIds
            );
            links = rows;
        }
        res.render('costs/brands', {
            title: 'الماركات',
            brands,
            materials,
            brandMaterials: links
        });
    } catch (error) {
        console.error('خطأ في عرض الماركات:', error);
        req.flash('error_msg', 'حدث خطأ في عرض الماركات');
        res.redirect('/costs');
    }
};

const createBrand = async (req, res) => {
    try {
        const { brand_name, owner_name, address, contact_number, material_ids } = req.body;
        const name = String(brand_name || '').trim();
        if (!name) return res.status(400).json({ success: false, message: 'اسم الماركة مطلوب' });
        const ids = [...new Set((Array.isArray(material_ids) ? material_ids : []).map(Number).filter(Number.isInteger))];
        const [result] = await req.db.query(
            'INSERT INTO brands (brand_name, owner_name, address, contact_number) VALUES (?, ?, ?, ?)',
            [name, String(owner_name || '').trim() || null, String(address || '').trim() || null, String(contact_number || '').trim() || null]
        );
        if (ids.length) {
            await req.db.query(
                `INSERT INTO brand_materials (brand_id, material_id) SELECT ?, id FROM materials WHERE id IN (${ids.map(() => '?').join(',')}) AND deleted_at IS NULL`,
                [result.insertId, ...ids]
            );
        }
        res.json({ success: true, id: result.insertId, message: 'تمت إضافة الماركة بنجاح' });
    } catch (error) {
        console.error('خطأ في إضافة الماركة:', error);
        res.status(error.code === 'ER_DUP_ENTRY' ? 409 : 500).json({ success: false, message: error.code === 'ER_DUP_ENTRY' ? 'اسم الماركة مستخدم مسبقًا' : 'حدث خطأ في إضافة الماركة' });
    }
};

const getBrand = async (req, res) => {
    try {
        const [brands] = await req.db.query('SELECT * FROM brands WHERE id = ?', [req.params.id]);
        if (!brands.length) return res.status(404).json({ success: false, message: 'الماركة غير موجودة' });
        const [links] = await req.db.query('SELECT material_id FROM brand_materials WHERE brand_id = ?', [req.params.id]);
        res.json({ success: true, brand: brands[0], material_ids: links.map((link) => link.material_id) });
    } catch (error) {
        res.status(500).json({ success: false, message: 'حدث خطأ في جلب الماركة' });
    }
};

const updateBrand = async (req, res) => {
    try {
        const { brand_name, owner_name, address, contact_number, material_ids } = req.body;
        const name = String(brand_name || '').trim();
        if (!name) return res.status(400).json({ success: false, message: 'اسم الماركة مطلوب' });
        const ids = [...new Set((Array.isArray(material_ids) ? material_ids : []).map(Number).filter(Number.isInteger))];
        await req.db.query(
            'UPDATE brands SET brand_name = ?, owner_name = ?, address = ?, contact_number = ? WHERE id = ?',
            [name, String(owner_name || '').trim() || null, String(address || '').trim() || null, String(contact_number || '').trim() || null, req.params.id]
        );
        await req.db.query('DELETE FROM brand_materials WHERE brand_id = ?', [req.params.id]);
        if (ids.length) {
            await req.db.query(
                `INSERT INTO brand_materials (brand_id, material_id) SELECT ?, id FROM materials WHERE id IN (${ids.map(() => '?').join(',')}) AND deleted_at IS NULL`,
                [req.params.id, ...ids]
            );
        }
        res.json({ success: true, message: 'تم تعديل الماركة بنجاح' });
    } catch (error) {
        res.status(error.code === 'ER_DUP_ENTRY' ? 409 : 500).json({ success: false, message: error.code === 'ER_DUP_ENTRY' ? 'اسم الماركة مستخدم مسبقًا' : 'حدث خطأ في تعديل الماركة' });
    }
};

const deleteBrand = async (req, res) => {
    try {
        await req.db.query('DELETE FROM brands WHERE id = ?', [req.params.id]);
        res.json({ success: true, message: 'تم حذف الماركة بنجاح' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'حدث خطأ في حذف الماركة' });
    }
};

const deleteBrandsMultiple = async (req, res) => {
    try {
        const ids = [...new Set((Array.isArray(req.body.ids) ? req.body.ids : []).map(Number).filter(Number.isInteger))];
        if (!ids.length) return res.status(400).json({ success: false, message: 'لم يتم تحديد أي ماركات' });
        const [result] = await req.db.query(`DELETE FROM brands WHERE id IN (${ids.map(() => '?').join(',')})`, ids);
        res.json({ success: true, message: `تم حذف ${result.affectedRows} ماركة` });
    } catch (error) {
        res.status(500).json({ success: false, message: 'حدث خطأ في حذف الماركات المحددة' });
    }
};

const exportBrandsExcel = async (req, res) => {
    try {
        const ids = [...new Set((Array.isArray(req.body?.ids) ? req.body.ids : []).map(Number).filter(Number.isInteger))];
        const [rows] = await req.db.query(`
            SELECT b.brand_name, b.owner_name, b.address, b.contact_number,
                   GROUP_CONCAT(m.material_name ORDER BY m.material_name SEPARATOR '، ') AS materials
            FROM brands b LEFT JOIN brand_materials bm ON bm.brand_id = b.id
            LEFT JOIN materials m ON m.id = bm.material_id
            ${ids.length ? `WHERE b.id IN (${ids.map(() => '?').join(',')})` : ''}
            GROUP BY b.id ORDER BY b.brand_name
        `, ids);
        const workbook = new Excel.Workbook();
        const sheet = workbook.addWorksheet('الماركات');
        sheet.columns = [
            { header: 'اسم الماركة', key: 'brand_name', width: 28 },
            { header: 'اسم صاحبها', key: 'owner_name', width: 25 },
            { header: 'العنوان', key: 'address', width: 35 },
            { header: 'رقم التواصل', key: 'contact_number', width: 20 },
            { header: 'المواد', key: 'materials', width: 60 }
        ];
        rows.forEach((row) => sheet.addRow(row));
        const fileName = `${uuidv4()}.xlsx`;
        const dir = path.join(__dirname, '../public/brands_excel');
        fs.mkdirSync(dir, { recursive: true });
        await workbook.xlsx.writeFile(path.join(dir, fileName));
        res.json({ success: true, url: `${process.env.BASE_URL}/public/brands_excel/${fileName}` });
    } catch (error) {
        res.status(500).json({ success: false, message: 'حدث خطأ في تصدير الماركات' });
    }
};

const exportBrandsPdf = async (req, res) => {
    try {
        const ids = [...new Set((Array.isArray(req.body.ids) ? req.body.ids : []).map(Number).filter(Number.isInteger))];
        if (!ids.length) return res.status(400).json({ success: false, message: 'يرجى تحديد ماركات للتصدير' });
        const [brands] = await req.db.query(`
            SELECT b.*, GROUP_CONCAT(m.material_name ORDER BY m.material_name SEPARATOR '، ') AS materials
            FROM brands b LEFT JOIN brand_materials bm ON bm.brand_id = b.id
            LEFT JOIN materials m ON m.id = bm.material_id AND m.deleted_at IS NULL
            WHERE b.id IN (${ids.map(() => '?').join(',')}) GROUP BY b.id ORDER BY b.brand_name
        `, ids);
        req.app.render('costs/brands-print', { title: 'قائمة الماركات', brands, layout: false }, async (error, html) => {
            if (error) return res.status(500).json({ success: false, message: 'تعذر تجهيز ملف PDF' });
            try {
                const pdf = require('html-pdf-node');
                const fileName = `${uuidv4()}.pdf`;
                const dir = path.join(__dirname, '../public/brands_pdf');
                fs.mkdirSync(dir, { recursive: true });
                const pdfBuffer = await generatePdfWithMetrics(pdf, { content: html }, { format: 'A4', printBackground: true, preferCSSPageSize: true, margin: { top: '10mm', right: '10mm', bottom: '10mm', left: '10mm' }, puppeteerArgs: { args: ['--no-sandbox', '--disable-setuid-sandbox'] } }, 'brands-list');
                await fs.promises.writeFile(path.join(dir, fileName), pdfBuffer);
                res.json({ success: true, url: `${process.env.BASE_URL}/public/brands_pdf/${fileName}` });
            } catch (pdfError) { res.status(500).json({ success: false, message: 'حدث خطأ أثناء إنشاء ملف PDF' }); }
        });
    } catch (error) { res.status(500).json({ success: false, message: 'حدث خطأ في تصدير الماركات' }); }
};

const writeDynamicExcel = async ({ req, res, kind }) => {
    const isQuotation = kind === 'quotation';
    const id = Number.parseInt(req.params.id, 10);
    const allowedFields = isQuotation ? QUOTATION_OUTPUT_FIELDS : ORDER_OUTPUT_FIELDS;
    const fields = parseOutputFields(req.query.fields, allowedFields);
    const [parents] = await req.db.query(
        `SELECT * FROM ${isQuotation ? 'quotations' : 'orders'} WHERE id = ?`, [id]
    );
    if (!parents.length) return res.status(404).json({ success: false, message: isQuotation ? 'عرض السعر غير موجود' : 'الطلبية غير موجودة' });
    const parent = parents[0];
    const [items] = await req.db.query(
        `SELECT * FROM ${isQuotation ? 'quotation_items' : 'order_items'} WHERE ${isQuotation ? 'quotation_id' : 'order_id'} = ?`, [id]
    );
    const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
    const symbol = req.defaultCurrency?.symbol || '$';
    const workbook = new Excel.Workbook();
    const sheet = workbook.addWorksheet(isQuotation ? 'عرض السعر' : 'الطلبية', { views: [{ rightToLeft: true }] });
    const metadata = isQuotation
        ? [
            ['client_info', 'رقم عرض السعر', parent.quotation_number], ['client_info', 'اسم العميل', parent.client_name],
            ['client_info', 'هاتف العميل', parent.client_phone], ['client_info', 'عنوان العميل', parent.client_address],
            ['sale_description', 'صفة البيع', parent.sale_description], ['payment_method', 'طريقة الدفع', parent.payment_method],
            ['quotation_notes', 'ملاحظات العرض', parent.notes]
        ]
        : [
            ['client_info', 'رقم الطلبية', parent.order_number], ['client_info', 'اسم العميل', parent.client_name],
            ['client_info', 'هاتف العميل', parent.client_phone], ['client_info', 'عنوان العميل', parent.client_address],
            ['recipient_name', 'اسم المستلم', parent.recipient_name], ['dates', 'تاريخ الطلبية', parent.order_date],
            ['dates', 'تاريخ التسليم', parent.delivery_date], ['preparation_info', 'المسؤول', parent.responsible_worker],
            ['preparation_info', 'مراقب الجودة', parent.quality_controller], ['shipping_info', 'رقم الحاوية', parent.container_number],
            ['shipping_info', 'رقم البوليصة', parent.waybill_number], ['order_notes', 'ملاحظات الطلبية', parent.notes]
        ];
    metadata.filter(([key]) => fields.includes(key)).forEach(([, label, value]) => sheet.addRow([label, value ?? '-']));
    if (sheet.rowCount) sheet.addRow([]);
    const definitions = isQuotation ? {
        row_number: ['#', (_, i) => i + 1], material_number: ['رقم المادة', r => r.material_number], material_name: ['اسم المادة', r => r.material_name],
        material_type: ['نوع المادة', r => r.material_type], packaging_unit: ['وحدة التعبئة', r => r.packaging_unit], packaging_weight: ['وزن التعبئة', r => r.packaging_weight],
        pieces_per_package: ['عدد القطع', r => r.pieces_per_package], package_cost: ['كلفة الطرد', r => isSyp ? (r.package_cost_syp || r.package_cost) : r.package_cost],
        profit_percentage: ['نسبة الربح', r => r.profit_percentage], final_price: ['سعر البيع', r => isSyp ? (r.final_price_syp || r.final_price) : r.final_price],
        quantity: ['الكمية', r => r.quantity], total_price: ['الإجمالي', r => isSyp ? (r.total_price_syp || r.total_price) : r.total_price], item_notes: ['ملاحظات', r => r.item_notes]
    } : {
        row_number: ['#', (_, i) => i + 1], material_number: ['رقم المادة', r => r.material_number], material_name: ['اسم المادة', r => r.material_name],
        packaging_unit: ['وحدة التعبئة', r => r.unit], requested_quantity: ['الكمية', r => r.requested_quantity], packaging_weight: ['الوزن', r => r.packaging_weight],
        pieces_per_package: ['عدد القطع', r => r.pieces_per_package], gross_weight: ['وزن الطرد القائم', r => r.gross_weight],
        unit_price: ['السعر الإفرادي', r => isSyp ? (r.unit_price_syp || r.unit_price) : r.unit_price], total_price: ['السعر الإجمالي', r => isSyp ? (r.total_price_syp || r.total_price) : r.total_price], item_notes: ['الملاحظات', r => r.notes]
    };
    const columns = fields.filter(field => definitions[field]);
    if (columns.length) {
        const header = sheet.addRow(columns.map(field => definitions[field][0]));
        header.font = { bold: true, color: { argb: 'FFFFFFFF' } };
        header.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF198754' } };
        items.forEach((item, index) => sheet.addRow(columns.map(field => definitions[field][1](item, index) ?? '-')));
        if (fields.includes('totals')) {
            const total = items.reduce((sum, item) => sum + (parseFloat(isSyp ? (item.total_price_syp || item.total_price) : item.total_price) || 0), 0);
            const totalRowValues = isQuotation
                ? columns.map((field, index) => field === 'total_price' ? `${total} ${symbol}` : (index === 0 ? 'الإجماليات' : ''))
                : columns.map((field) => {
                    if (field === 'packaging_weight') return items.reduce((sum, item) => sum + ((parseFloat(item.packaging_weight) || 0) * (parseFloat(item.requested_quantity) || 0)), 0);
                    if (field === 'gross_weight') return items.reduce((sum, item) => sum + ((parseFloat(item.gross_weight) || 0) * (parseFloat(item.requested_quantity) || 0)), 0);
                    if (field === 'requested_quantity') return items.reduce((sum, item) => sum + (parseFloat(item.requested_quantity) || 0), 0);
                    if (field === 'total_price') return `${total} ${symbol}`;
                    const labelField = columns.find(column => !['packaging_weight', 'pieces_per_package', 'gross_weight', 'requested_quantity', 'unit_price', 'total_price'].includes(column));
                    if (field === labelField) return 'الإجماليات';
                    return '';
                });
            sheet.addRow(totalRowValues).font = { bold: true };
        }
    }
    sheet.columns.forEach(column => { column.width = Math.min(40, Math.max(14, ...column.values.map(value => String(value ?? '').length + 2))); });
    const dir = path.join(__dirname, `../public/${isQuotation ? 'quotations' : 'orders'}_excel`);
    fs.mkdirSync(dir, { recursive: true });
    const fileName = `${uuidv4()}.xlsx`;
    await workbook.xlsx.writeFile(path.join(dir, fileName));
    return res.json({ success: true, url: `${process.env.BASE_URL}/public/${isQuotation ? 'quotations' : 'orders'}_excel/${fileName}` });
};

const exportQuotationExcel = (req, res) => writeDynamicExcel({ req, res, kind: 'quotation' }).catch((error) => {
    console.error('Error exporting quotation Excel:', error);
    res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير عرض السعر إلى Excel' });
});
const exportOrderExcel = (req, res) => writeDynamicExcel({ req, res, kind: 'order' }).catch((error) => {
    console.error('Error exporting order Excel:', error);
    res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير الطلبية إلى Excel' });
});

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
        
        const materialWithUnits = await attachPackagingUnits(req.db, materials);
        const material = applyMaterialRaw(materialWithUnits[0]);
        
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
    getBrands,
    getBrand,
    createBrand,
    updateBrand,
    deleteBrand,
    deleteBrandsMultiple,
    exportBrandsExcel,
    exportBrandsPdf,
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
    exportQuotationExcel,
    getMaterialPrintPage,
    createOrder,
    updateOrder,
    updateOrderStatus,
    deleteMaterial,
    deleteQuotation,
    deleteOrder,
    exportOrderPDF,
    exportOrderExcel,
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
            const [materialRows] = await req.db.query(`SELECT * FROM materials WHERE deleted_at IS NULL ORDER BY material_name ASC, created_at DESC`);
            const materials = await attachPackagingUnits(req.db, materialRows);
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
