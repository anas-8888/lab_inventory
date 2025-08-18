const { pool } = require('../database/db');

// دالة لتقريب الأرقام العشرية بشكل صحيح
const roundToDecimal = (value, decimals = 2) => {
    if (typeof value !== 'number' || isNaN(value)) {
        return 0;
    }
    const factor = Math.pow(10, decimals);
    const result = Math.round(value * factor) / factor;
    console.log(`roundToDecimal(${value}, ${decimals}) = ${result}`);
    return result;
};

// عرض صفحة التكاليف الرئيسية
const getCosts = async (req, res) => {
    try {
        const [materials] = await req.db.query(`
            SELECT * FROM materials 
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
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                return {
                    ...material,
                    unit_cost: material.unit_cost_syp || material.unit_cost,
                    package_cost: material.package_cost_syp || material.package_cost
                };
            } else {
                return material;
            }
        });

        const displayQuotations = quotations.map((quotation) => {
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                return {
                    ...quotation,
                    total_amount: quotation.total_amount_syp || quotation.total_amount
                };
            } else {
                return quotation;
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
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                return {
                    ...material,
                    unit_cost: material.unit_cost_syp || material.unit_cost,
                    package_cost: material.package_cost_syp || material.package_cost
                };
            } else {
                return material;
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
        console.log('Received request body:', JSON.stringify(req.body, null, 2));
        
        const {
            material_type,
            material_name,
            price_before_waste,
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
            extra_weights
        } = req.body;

        // التحقق من البيانات المطلوبة
        if (!material_type || !material_name || !price_before_waste || !gross_weight) {
            return res.status(400).json({ 
                success: false, 
                message: 'البيانات المطلوبة غير مكتملة' 
            });
        }

        // جلب سعر الصرف الحالي
        const [exchangeRate] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = (SELECT id FROM currencies WHERE code = 'USD')
            AND to_currency_id = (SELECT id FROM currencies WHERE code = 'SYP')
        `);
        
        const exchangeRateValue = exchangeRate.length > 0 ? parseFloat(exchangeRate[0].rate) : 13000;
        console.log('Exchange rate:', exchangeRateValue);

        // تحويل البيانات إلى أرقام مع معالجة الأخطاء
        const gross_weight_num = parseFloat(gross_weight) || 0;
        const waste_percentage_num = parseFloat(waste_percentage) || 0;
        const packaging_weight_num = parseFloat(packaging_weight) || 0;
        const packaging_unit_weight_num = parseFloat(packaging_unit_weight) || 0;
        const pieces_per_package_num = parseInt(pieces_per_package) || 0;
        const packages_per_pallet_num = parseInt(packages_per_pallet) || 0;

        console.log('Parsed numeric values:', {
            gross_weight_num,
            waste_percentage_num,
            packaging_weight_num,
            packaging_unit_weight_num,
            pieces_per_package_num,
            packages_per_pallet_num
        });

        // تجهيز الحقول المرتبطة بالعملة
        const currencyFields = [
            'price_before_waste', 'empty_package_price', 'sticker_price',
            'additional_expenses', 'labor_cost', 'preservatives_cost',
            'carton_price', 'pallet_price'
        ];

        const usd = {};
        const syp = {};
        
        currencyFields.forEach((field) => {
            const usdVal = parseFloat(req.body[field]) || 0;
            usd[field] = usdVal;
            syp[field] = usdVal * exchangeRateValue;
            console.log(`${field}: USD=${usdVal}, SYP=${syp[field]}`);
        });

        // معالجة الأوزان الإضافية
        let extraWeightsArr = [];
        if (extra_weights && Array.isArray(extra_weights)) {
            extraWeightsArr = extra_weights.map(item => ({
                name: item.name || '',
                weight: parseFloat(item.weight) || 0
            }));
        }
        console.log('Extra weights:', extraWeightsArr);

        // حساب الوزن الإجمالي للعبوة
        const gross_package_weight = packaging_weight_num + 
            extraWeightsArr.reduce((sum, item) => sum + (item.weight || 0), 0);

        // الحسابات الأساسية
        const price_per_kg_before_waste = gross_weight_num > 0 ? (usd.price_before_waste || 0) / gross_weight_num : 0;
        const price_per_kg_before_waste_syp = gross_weight_num > 0 ? (syp.price_before_waste || 0) / gross_weight_num : 0;
        
        const denom = 1 - (waste_percentage_num / 100);
        const denomSyp = denom;
        
        const price_per_kg_after_waste = denom > 0 ? price_per_kg_before_waste / denom : 0;
        const price_per_kg_after_waste_syp = denomSyp > 0 ? price_per_kg_before_waste_syp / denomSyp : 0;
        
        const material_cost_in_unit = price_per_kg_after_waste * packaging_weight_num;
        const material_cost_in_unit_syp = price_per_kg_after_waste_syp * packaging_weight_num;
        
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

        console.log('Calculated costs:', {
            unit_cost,
            unit_cost_syp,
            package_cost,
            package_cost_syp
        });

        // حفظ المادة
        const [result] = await req.db.query(`
            INSERT INTO materials (
                material_type, material_name, price_before_waste, price_before_waste_syp,
                gross_weight, waste_percentage, packaging_unit, packaging_weight,
                packaging_unit_weight,
                empty_package_price, empty_package_price_syp, sticker_price, sticker_price_syp,
                additional_expenses, additional_expenses_syp, labor_cost, labor_cost_syp,
                preservatives_cost, preservatives_cost_syp, carton_price, carton_price_syp,
                pieces_per_package, pallet_price, pallet_price_syp, packages_per_pallet,
                unit_cost, unit_cost_syp, package_cost, package_cost_syp,
                extra_weights, gross_package_weight
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            material_type, material_name, (usd.price_before_waste || 0), (syp.price_before_waste || 0),
            gross_weight_num, waste_percentage_num, packaging_unit, packaging_weight_num,
            packaging_unit_weight_num,
            (usd.empty_package_price || 0), (syp.empty_package_price || 0), (usd.sticker_price || 0), (syp.sticker_price || 0),
            (usd.additional_expenses || 0), (syp.additional_expenses || 0), (usd.labor_cost || 0), (syp.labor_cost || 0),
            (usd.preservatives_cost || 0), (syp.preservatives_cost || 0), (usd.carton_price || 0), (syp.carton_price || 0),
            pieces_per_package_num, (usd.pallet_price || 0), (syp.pallet_price || 0), packages_per_pallet_num,
            unit_cost, unit_cost_syp, package_cost, package_cost_syp,
            JSON.stringify(extraWeightsArr || []), gross_package_weight
        ]);

        // حفظ في سجل التكاليف
        await req.db.query(`
            INSERT INTO cost_logs (material_id, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp)
            VALUES (?, ?, ?, ?, ?, ?)
        `, [result.insertId, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp]);

        console.log('Material saved successfully with ID:', result.insertId);
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

// تحديث مادة موجودة
const updateMaterial = async (req, res) => {
    try {
        const { id } = req.params;
        const {
            material_type,
            material_name,
            price_before_waste,
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
            extra_weights
        } = req.body;

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

        // تحويل القيم العامة إلى أرقام
        const gross_weight_num = parseFloat(gross_weight) || 0;
        const waste_percentage_num = parseFloat(waste_percentage) || 0;
        const pieces_per_package_num = parseInt(pieces_per_package) || 1;
        const packages_per_pallet_num = parseInt(packages_per_pallet) || 1;
        const packaging_weight_num = parseFloat(packaging_weight) || 0;
        const packaging_unit_weight_num = parseFloat(packaging_unit_weight) || 0;

        // الأوزان الإضافية وحساب وزن الطرد القائم
        let extraWeightsArr = [];
        try {
            if (Array.isArray(extra_weights)) extraWeightsArr = extra_weights;
            else if (typeof extra_weights === 'string' && extra_weights.trim()) extraWeightsArr = JSON.parse(extra_weights);
        } catch (_) { extraWeightsArr = []; }
        const extraWeightsTotal = (extraWeightsArr || []).reduce((sum, ew) => sum + (parseFloat(ew.weight) || 0), 0);
        const gross_package_weight = ((packaging_unit_weight_num + packaging_weight_num) * pieces_per_package_num) + extraWeightsTotal;

        // السعر قبل الهدر أصبح سعراً كلياً للوزن الجمالي
        const price_per_kg_before_waste_usd = (gross_weight_num > 0) ? ((usd.price_before_waste || 0) / gross_weight_num) : 0;
        const price_per_kg_after_waste_usd = price_per_kg_before_waste_usd / (1 - waste_percentage_num / 100 || 1);
        const material_cost_in_unit_usd = price_per_kg_after_waste_usd * packaging_weight_num;
        const total_packaging_costs_usd =
            (usd.empty_package_price || 0) + (usd.sticker_price || 0) + (usd.additional_expenses || 0) +
            (usd.labor_cost || 0) + (usd.preservatives_cost || 0);
        const unit_cost = roundToDecimal(material_cost_in_unit_usd + total_packaging_costs_usd, 2);
        const pallet_share_usd = roundToDecimal((usd.pallet_price || 0) / packages_per_pallet_num, 2);
        const package_cost = roundToDecimal(unit_cost + pallet_share_usd, 2);

        // حساب كلفة القطعة والطرد بالليرة باستخدام قيم SYP المدخلة
        const price_per_kg_before_waste_syp = (gross_weight_num > 0) ? ((syp.price_before_waste || 0) / gross_weight_num) : 0;
        const price_per_kg_after_waste_syp = price_per_kg_before_waste_syp / (1 - waste_percentage_num / 100 || 1);
        const material_cost_in_unit_syp = price_per_kg_after_waste_syp * packaging_weight_num;
        const total_packaging_costs_syp =
            (syp.empty_package_price || 0) + (syp.sticker_price || 0) + (syp.additional_expenses || 0) +
            (syp.labor_cost || 0) + (syp.preservatives_cost || 0);
        const unit_cost_syp = roundToDecimal(material_cost_in_unit_syp + total_packaging_costs_syp, 0);
        const pallet_share_syp = roundToDecimal((syp.pallet_price || 0) / packages_per_pallet_num, 0);
        const package_cost_syp = roundToDecimal((unit_cost_syp * pieces_per_package_num) + (syp.carton_price || 0) + pallet_share_syp, 0);

        // تحديث المادة
        await req.db.query(`
            UPDATE materials SET
                material_type = ?, material_name = ?, price_before_waste = ?, price_before_waste_syp = ?,
                gross_weight = ?, waste_percentage = ?, packaging_unit = ?, packaging_weight = ?, packaging_unit_weight = ?,
                empty_package_price = ?, empty_package_price_syp = ?, sticker_price = ?, sticker_price_syp = ?,
                additional_expenses = ?, additional_expenses_syp = ?, labor_cost = ?, labor_cost_syp = ?,
                preservatives_cost = ?, preservatives_cost_syp = ?, carton_price = ?, carton_price_syp = ?,
                pieces_per_package = ?, pallet_price = ?, pallet_price_syp = ?, packages_per_pallet = ?,
                unit_cost = ?, unit_cost_syp = ?, package_cost = ?, package_cost_syp = ?,
                extra_weights = ?, gross_package_weight = ?
            WHERE id = ?
        `, [
            material_type, material_name, (usd.price_before_waste || 0), (syp.price_before_waste || 0),
            gross_weight_num, waste_percentage_num, packaging_unit, packaging_weight_num, packaging_unit_weight_num,
            (usd.empty_package_price || 0), (syp.empty_package_price || 0), (usd.sticker_price || 0), (syp.sticker_price || 0),
            (usd.additional_expenses || 0), (syp.additional_expenses || 0), (usd.labor_cost || 0), (syp.labor_cost || 0),
            (usd.preservatives_cost || 0), (syp.preservatives_cost || 0), (usd.carton_price || 0), (syp.carton_price || 0),
            pieces_per_package_num, (usd.pallet_price || 0), (syp.pallet_price || 0), packages_per_pallet_num,
            unit_cost, unit_cost_syp, package_cost, package_cost_syp,
            JSON.stringify(extraWeightsArr || []), gross_package_weight, id
        ]);

        // حفظ في سجل التكاليف
        await req.db.query(`
            INSERT INTO cost_logs (material_id, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp)
            VALUES (?, ?, ?, ?, ?, ?)
        `, [id, material_name, unit_cost, unit_cost_syp, package_cost, package_cost_syp]);

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
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                const totalAmount = quotation.total_amount_syp || quotation.total_amount;
                console.log(`getQuotations - Quotation ${quotation.id}:`);
                console.log(`  total_amount_syp: ${quotation.total_amount_syp}, total_amount: ${quotation.total_amount}`);
                console.log(`  Display total: ${totalAmount}`);
                return {
                    ...quotation,
                    total_amount: totalAmount
                };
            } else {
                return quotation;
            }
        });

        const displayMaterials = materials.map((material) => {
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                return {
                    ...material,
                    unit_cost: material.unit_cost_syp || material.unit_cost,
                    package_cost: material.package_cost_syp || material.package_cost
                };
            } else {
                return material;
            }
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
        const quotation = quotationRows[0];
        const [items] = await req.db.query(`SELECT * FROM quotation_items WHERE quotation_id = ?`, [id]);
        
        // تحويل البيانات حسب العملة المحددة
        const displayQuotation = {
            ...quotation,
            total_amount: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (quotation.total_amount_syp || quotation.total_amount)
                : quotation.total_amount
        };
        
        // إضافة رسائل تتبع للعرض الرئيسي
        if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
            console.log(`getQuotationJson - Quotation ${quotation.id}:`);
            console.log(`  total_amount_syp: ${quotation.total_amount_syp}, total_amount: ${quotation.total_amount}`);
            console.log(`  Display total: ${displayQuotation.total_amount}`);
        }
        
        const displayItems = items.map((item) => {
            if (req.defaultCurrency && req.defaultCurrency.code === 'SYP') {
                // استخدام القيم المحفوظة بالليرة السورية مع التأكد من صحتها
                const unitCost = item.unit_cost_syp || item.unit_cost;
                const finalPrice = item.final_price_syp || item.final_price;
                const totalPrice = item.total_price_syp || item.total_price;
                
                // إضافة رسائل تتبع للتشخيص
                console.log(`getQuotationJson - Item ${item.id}:`);
                console.log(`  unit_cost_syp: ${item.unit_cost_syp}, unit_cost: ${item.unit_cost}`);
                console.log(`  final_price_syp: ${item.final_price_syp}, final_price: ${item.final_price}`);
                console.log(`  total_price_syp: ${item.total_price_syp}, total_price: ${item.total_price}`);
                console.log(`  quantity: ${item.quantity}`);
                
                return {
                    ...item,
                    unit_cost: unitCost,
                    final_price: finalPrice,
                    total_price: totalPrice
                };
            } else {
                return item;
            }
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
        console.log('Received quotation update request body:', JSON.stringify(req.body, null, 2));
        
        const { id } = req.params;
        const { client_name, client_phone, client_address, notes, items } = req.body;

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
        console.log('Exchange rate:', exchangeRateValue);
        
        // التأكد من أن سعر الصرف رقم صحيح
        if (isNaN(exchangeRateValue) || exchangeRateValue <= 0) {
            return res.status(400).json({ success: false, message: 'سعر الصرف غير صحيح' });
        }

        // تحديث رأس العرض (بدون نسبة ربح عامة)
        await req.db.query(
            `UPDATE quotations SET client_name = ?, client_phone = ?, client_address = ?, notes = ? WHERE id = ?`,
            [client_name, client_phone, client_address, notes, id]
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
                
                console.log(`Processing update item: unitCost=${unitCost}, profitPercentage=${profitPercentage}, quantity=${quantity}`);
                
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
                        material_type, packaging_unit, packaging_weight, pieces_per_package, package_cost, item_notes
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                    [
                        id, item.material_id || null, item.material_name || '',
                        unitCostUSD || 0, unitCostSYP || 0, profitPercentage,
                        finalPriceUSD, finalPriceSYP, quantity, totalPriceUSD, totalPriceSYP,
                        item.material_type || null, item.packaging_unit || null, item.packaging_weight || null,
                        item.pieces_per_package || null, item.package_cost || null, item.item_notes || null
                    ]
                );

                totalAmount += totalPriceUSD;
                totalAmountSyp += totalPriceSYP;
            }
        }

        await req.db.query(`UPDATE quotations SET total_amount = ?, total_amount_syp = ? WHERE id = ?`, [totalAmount, totalAmountSyp, id]);

        console.log('Quotation updated successfully with ID:', id);
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
        console.log('Received quotation request body:', JSON.stringify(req.body, null, 2));
        
        const {
            client_name,
            client_phone,
            client_address,
            notes,
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
        console.log('Exchange rate:', exchangeRateValue);
        
        // التأكد من أن سعر الصرف رقم صحيح
        if (isNaN(exchangeRateValue) || exchangeRateValue <= 0) {
            return res.status(400).json({ success: false, message: 'سعر الصرف غير صحيح' });
        }

        // حفظ العرض
        const [quotationResult] = await req.db.query(`
            INSERT INTO quotations (quotation_number, client_name, client_phone, client_address, notes, general_profit_percentage, total_amount, total_amount_syp)
            VALUES (?, ?, ?, ?, ?, ?, 0, 0)
        `, [quotationNumber, client_name, client_phone, client_address, notes, general_profit_percentage || 0]);

        let totalAmount = 0;
        let totalAmountSyp = 0;

        // حفظ بنود العرض
        if (items && Array.isArray(items)) {
            for (const item of items) {
                // تحويل البيانات إلى أرقام مع معالجة الأخطاء
                const unitCost = parseFloat(item.unit_cost) || 0;
                const profitPercentage = parseFloat(item.profit_percentage) || 0;
                const quantity = parseFloat(item.quantity) || 1;
                
                console.log(`Processing item: unitCost=${unitCost}, profitPercentage=${profitPercentage}, quantity=${quantity}`);
                
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
                        material_type, packaging_unit, packaging_weight, pieces_per_package, package_cost, item_notes
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                `, [
                    quotationResult.insertId, item.material_id || null, item.material_name || '',
                    unitCostUSD || 0, unitCostSYP || 0, profitPercentage, finalPriceUSD, finalPriceSYP,
                    quantity, totalPriceUSD, totalPriceSYP, item.material_type || null, item.packaging_unit || null,
                    item.packaging_weight || null, item.pieces_per_package || null, item.package_cost || null, item.item_notes || null
                ]);

                totalAmount += totalPriceUSD;
                totalAmountSyp += totalPriceSYP;
            }
        }

        // تحديث المبلغ الإجمالي
        await req.db.query(`
            UPDATE quotations SET total_amount = ?, total_amount_syp = ? WHERE id = ?
        `, [totalAmount, totalAmountSyp, quotationResult.insertId]);

        console.log('Quotation saved successfully with ID:', quotationResult.insertId);
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
        const displayQuotation = {
            ...quotation[0],
            total_amount: req.defaultCurrency && req.defaultCurrency.code === 'SYP' 
                ? (quotation[0].total_amount_syp || quotation[0].total_amount)
                : quotation[0].total_amount
        };

        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayItems = items.map((item) => {
            const mat = item.material_id ? materialsMap.get(item.material_id) : null;
            const packageCostFromMat = mat ? (isSyp ? (mat.package_cost_syp || mat.package_cost || 0) : (mat.package_cost || 0)) : 0;
            const packageCost = (isSyp ? (item.package_cost_syp || item.package_cost) : item.package_cost);
            const resolvedPackageCost = (packageCost != null ? packageCost : packageCostFromMat);
                return {
                    ...item,
                unit_cost: isSyp ? (item.unit_cost_syp || item.unit_cost) : item.unit_cost,
                final_price: isSyp ? (item.final_price_syp || item.final_price) : item.final_price,
                total_price: isSyp ? (item.total_price_syp || item.total_price) : item.total_price,
                package_cost: resolvedPackageCost,
                material_type: item.material_type || (mat ? mat.material_type : null),
                packaging_unit: item.packaging_unit || (mat ? mat.packaging_unit : null),
                packaging_weight: item.packaging_weight != null ? item.packaging_weight : (mat ? mat.packaging_weight : null),
                pieces_per_package: item.pieces_per_package != null ? item.pieces_per_package : (mat ? mat.pieces_per_package : null)
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
        const [qRows] = await req.db.query(`SELECT * FROM quotations WHERE id = ?`, [id]);
        if (qRows.length === 0) {
            req.flash('error_msg', 'عرض السعر غير موجود');
            return res.redirect('/costs/quotations');
        }
        const quotation = qRows[0];
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
            const mat = item.material_id ? materialsMap.get(item.material_id) : null;
            const final = isSyp ? (item.final_price_syp || item.final_price || 0) : (item.final_price || 0);
            const total = isSyp ? (item.total_price_syp || item.total_price || (final * (item.quantity || 1))) : (item.total_price || (final * (item.quantity || 1)));
            const packageCostFromMat = mat ? (isSyp ? (mat.package_cost_syp || mat.package_cost || 0) : (mat.package_cost || 0)) : 0;
            const packageCost = (isSyp ? (item.package_cost_syp || item.package_cost) : item.package_cost);
            const resolvedPackageCost = (packageCost != null ? packageCost : packageCostFromMat);
            return {
                ...item,
                final_price: final,
                total_price: total,
                package_cost: resolvedPackageCost,
                material_type: item.material_type || (mat ? mat.material_type : null),
                packaging_unit: item.packaging_unit || (mat ? mat.packaging_unit : null),
                packaging_weight: item.packaging_weight != null ? item.packaging_weight : (mat ? mat.packaging_weight : null),
                pieces_per_package: item.pieces_per_package != null ? item.pieces_per_package : (mat ? mat.pieces_per_package : null)
            };
        });
        const grandTotal = displayItems.reduce((s, it) => s + (parseFloat(it.total_price) || 0), 0);

        res.render('costs/quotation-print', {
            title: `طباعة عرض السعر ${quotation.quotation_number}`,
            quotation,
            items: displayItems,
            grandTotal,
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
        const url = `${process.env.BASE_URL}/costs/quotations/${id}/print-pdf-raw`;
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
        const [qRows] = await req.db.query(`SELECT * FROM quotations WHERE id = ?`, [id]);
        if (qRows.length === 0) {
            return res.status(404).send('عرض السعر غير موجود');
        }
        const quotation = qRows[0];
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
            const mat = item.material_id ? materialsMap.get(item.material_id) : null;
            const final = isSyp ? (item.final_price_syp || item.final_price || 0) : (item.final_price || 0);
            const total = isSyp ? (item.total_price_syp || item.total_price || (final * (item.quantity || 1))) : (item.total_price || (final * (item.quantity || 1)));
            const packageCostFromMat = mat ? (isSyp ? (mat.package_cost_syp || mat.package_cost || 0) : (mat.package_cost || 0)) : 0;
            const packageCost = (isSyp ? (item.package_cost_syp || item.package_cost) : item.package_cost);
            const resolvedPackageCost = (packageCost != null ? packageCost : packageCostFromMat);
            return {
                ...item,
                final_price: final,
                total_price: total,
                package_cost: resolvedPackageCost,
                material_type: item.material_type || (mat ? mat.material_type : null),
                packaging_unit: item.packaging_unit || (mat ? mat.packaging_unit : null),
                packaging_weight: item.packaging_weight != null ? item.packaging_weight : (mat ? mat.packaging_weight : null),
                pieces_per_package: item.pieces_per_package != null ? item.pieces_per_package : (mat ? mat.pieces_per_package : null)
            };
        });
        const grandTotal = displayItems.reduce((s, it) => s + (parseFloat(it.total_price) || 0), 0);

        res.render('costs/quotation-print', {
            title: `طباعة عرض السعر ${quotation.quotation_number}`,
            quotation,
            items: displayItems,
            grandTotal,
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
        const material = materials[0];
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
            defaultCurrency: req.defaultCurrency || null,
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
            SELECT id, material_name, packaging_unit, packaging_weight, gross_package_weight, package_cost, package_cost_syp 
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
        const displayOrders = orders.map(order => ({
            ...order,
            total_amount: isSyp ? (order.total_amount_syp || order.total_amount) : order.total_amount
        }));

        res.render('costs/orders', {
            title: 'الطلبيات',
            orders: displayOrders,
            materials,
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
        console.log('Received order request body:', JSON.stringify(req.body, null, 2));
        
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
        console.log('Exchange rate:', exchangeRateValue);
        
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

        const [orderResult] = await req.db.query(`
            INSERT INTO orders (
                order_number, client_name, order_date, delivery_date,
                responsible_worker, quality_controller, pallets_count, container_number,
                packages_count, waybill_number, accreditation_number, notes
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            orderNumber, client_name || null, orderDateSql, deliveryDateSql,
            responsible_worker || null, quality_controller || null, pallets_count || null, container_number || null,
            packages_count || null, waybill_number || null, accreditation_number || null, notes || null
        ]);

        // حفظ بنود الطلبية إن وُجدت
        if (items && Array.isArray(items)) {
            for (const item of items) {
                // تحويل البيانات إلى أرقام مع معالجة الأخطاء
                const unitPrice = parseFloat(item.unit_price) || 0;
                const quantity = parseFloat(item.requested_quantity) || 1;
                
                console.log(`Processing order item: unitPrice=${unitPrice}, quantity=${quantity}`);
                
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
                        unit_price, unit_price_syp, total_price, total_price_syp, notes
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
                    item.notes || null
                ]);
            }
        }

        console.log('Order saved successfully with ID:', orderResult.insertId);
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
            SELECT * FROM materials WHERE id = ?
        `, [id]);
        
        if (materials.length === 0) {
            return res.status(404).json({ success: false, message: 'المادة غير موجودة' });
        }
        
        res.json({ success: true, material: materials[0] });
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
        const displayLogs = logs.map((log) => {
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
        
        await req.db.query('DELETE FROM materials WHERE id = ?', [id]);
        
        res.json({ success: true, message: 'تم حذف المادة بنجاح' });
    } catch (error) {
        console.error('خطأ في حذف المادة:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في حذف المادة' });
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
        const displayItems = items.map(it => ({
            ...it,
            unit_price: isSyp ? (it.unit_price_syp || it.unit_price) : it.unit_price,
            total_price: isSyp ? (it.total_price_syp || it.total_price) : it.total_price
        }));
        
        res.json({ success: true, order: orders[0], items: displayItems });
    } catch (error) {
        console.error('خطأ في جلب بيانات الطلبية:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في جلب بيانات الطلبية' });
    }
};

// تحديث طلبية
const updateOrder = async (req, res) => {
    try {
        console.log('Received order update request body:', JSON.stringify(req.body, null, 2));
        
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
        console.log('Exchange rate:', exchangeRateValue);
        
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
        
        await req.db.query(`
            UPDATE orders SET
                client_name = ?, order_date = ?, delivery_date = ?,
                responsible_worker = ?, quality_controller = ?, pallets_count = ?, container_number = ?,
                packages_count = ?, waybill_number = ?, accreditation_number = ?, notes = ?
            WHERE id = ?
        `, [
            client_name || null, orderDateSql, deliveryDateSql,
            responsible_worker || null, quality_controller || null, pallets_count || null, container_number || null,
            packages_count || null, waybill_number || null, accreditation_number || null, notes || null, id
        ]);

        // حدّث البنود
        await req.db.query('DELETE FROM order_items WHERE order_id = ?', [id]);
        if (items && Array.isArray(items)) {
            for (const item of items) {
                // تحويل البيانات إلى أرقام مع معالجة الأخطاء
                const unitPrice = parseFloat(item.unit_price) || 0;
                const quantity = parseFloat(item.requested_quantity) || 1;
                
                console.log(`Processing update order item: unitPrice=${unitPrice}, quantity=${quantity}`);
                
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
                        unit_price, unit_price_syp, total_price, total_price_syp, notes
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
                    item.notes || null
                ]);
            }
        }
        
        console.log('Order updated successfully with ID:', id);
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

        // اختيار القيم حسب العملة المحددة
        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const displayItems = items.map(it => {
            const qty = parseFloat(it.requested_quantity) || 0;
            const unitPrice = isSyp ? (it.unit_price_syp || it.unit_price) : it.unit_price;
            const totalPrice = isSyp ? (it.total_price_syp || it.total_price) : it.total_price;
            const weight = parseFloat(it.weight) || 0;
            const weightTotal = qty * weight;
            return { 
                ...it, 
                unit_price: unitPrice != null ? parseFloat(unitPrice) : null, 
                total_price: totalPrice != null ? parseFloat(totalPrice) : null, 
                weight_total: weightTotal 
            };
        });
        const totals = {
            totalRequestedQuantity: displayItems.reduce((s, it) => s + (parseFloat(it.requested_quantity) || 0), 0),
            totalWeight: displayItems.reduce((s, it) => s + (parseFloat(it.weight_total) || 0), 0),
            totalVolume: displayItems.reduce((s, it) => s + (parseFloat(it.volume) || 0), 0),
            grandTotal: displayItems.reduce((s, it) => s + (it.total_price != null ? parseFloat(it.total_price) : 0), 0)
        };

        res.render('costs/order-details', {
            title: `تفاصيل الطلبية ${orders[0].order_number}`,
            order: orders[0],
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
        const [orders] = await req.db.query('SELECT * FROM orders WHERE id = ?', [id]);
        if (orders.length === 0) {
            req.flash('error_msg', 'الطلبية غير موجودة');
            return res.redirect('/costs/orders');
        }
        const [items] = await req.db.query('SELECT * FROM order_items WHERE order_id = ?', [id]);

        // اختيار القيم حسب العملة المحددة
        const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
        const pricedItems = items.map(it => {
            const qty = parseFloat(it.requested_quantity) || 0;
            const unitPrice = isSyp ? (it.unit_price_syp || it.unit_price) : it.unit_price;
            const totalPrice = isSyp ? (it.total_price_syp || it.total_price) : it.total_price;
            return { 
                ...it, 
                unit_price: unitPrice != null ? parseFloat(unitPrice) : null, 
                total_price: totalPrice != null ? parseFloat(totalPrice) : null 
            };
        });

        const totals = {
            totalRequestedQuantity: pricedItems.reduce((s, it) => s + (parseFloat(it.requested_quantity) || 0), 0),
            totalWeight: pricedItems.reduce((s, it) => {
                const qty = parseFloat(it.requested_quantity) || 0;
                const w = parseFloat(it.weight) || 0;
                return s + (qty * w);
            }, 0),
            totalVolume: pricedItems.reduce((s, it) => s + (parseFloat(it.volume) || 0), 0),
            grandTotal: pricedItems.reduce((s, it) => s + (it.total_price != null ? parseFloat(it.total_price) : 0), 0)
        };

        res.render('costs/order-print', {
            title: `طباعة طلبية ${orders[0].order_number}`,
            order: orders[0],
            items: pricedItems,
            totals,
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
        const url = `${process.env.BASE_URL}/costs/orders/${id}/print-pdf-raw`;
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
            SELECT * FROM materials WHERE id = ?
        `, [id]);
        
        if (materials.length === 0) {
            req.flash('error_msg', 'المادة غير موجودة');
            return res.redirect('/costs/cost-statement');
        }
        
        const material = materials[0];
        
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
            user: req.session.user,
            formatDate: formatDate
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
    getOrderPrintRaw
}; 