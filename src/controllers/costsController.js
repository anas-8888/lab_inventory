const { pool } = require('../database/db');

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

        res.render('costs/index', {
            title: 'إدارة التكاليف',
            materials,
            quotations,
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
        
        res.render('costs/cost-statement', {
            title: 'بيان الكلفة',
            materials,
            formatDate
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
            material_type,
            material_name,
            price_before_waste,
            gross_weight,
            waste_percentage,
            packaging_unit,
            packaging_weight,
            empty_package_price,
            sticker_price,
            additional_expenses,
            labor_cost,
            preservatives_cost,
            carton_price,
            pieces_per_package,
            pallet_price,
            packages_per_pallet
        } = req.body;

        // تحويل القيم إلى أرقام
        const price_before_waste_num = parseFloat(price_before_waste) || 0;
        const gross_weight_num = parseFloat(gross_weight) || 0;
        const waste_percentage_num = parseFloat(waste_percentage) || 0;
        const empty_package_price_num = parseFloat(empty_package_price) || 0;
        const sticker_price_num = parseFloat(sticker_price) || 0;
        const additional_expenses_num = parseFloat(additional_expenses) || 0;
        const labor_cost_num = parseFloat(labor_cost) || 0;
        const preservatives_cost_num = parseFloat(preservatives_cost) || 0;
        const carton_price_num = parseFloat(carton_price) || 0;
        const pieces_per_package_num = parseInt(pieces_per_package) || 1;
        const pallet_price_num = parseFloat(pallet_price) || 0;
        const packages_per_pallet_num = parseInt(packages_per_pallet) || 1;

        // حساب كلفة القطعة الواحدة
        const net_weight = gross_weight_num * (1 - waste_percentage_num / 100);
        const price_per_kg_after_waste = price_before_waste_num / (1 - waste_percentage_num / 100);
        const material_cost_in_unit = price_per_kg_after_waste * (parseFloat(packaging_weight) || 0);
        const total_packaging_costs = empty_package_price_num + sticker_price_num + additional_expenses_num + labor_cost_num + preservatives_cost_num;
        const unit_cost = material_cost_in_unit + total_packaging_costs;

        // حساب كلفة الطرد
        const pallet_share = pallet_price_num / packages_per_pallet_num;
        const package_cost = unit_cost + pallet_share;

        // حفظ المادة
        const [result] = await req.db.query(`
            INSERT INTO materials (
                material_type, material_name, price_before_waste, gross_weight,
                waste_percentage, packaging_unit, packaging_weight, empty_package_price,
                sticker_price, additional_expenses, labor_cost, preservatives_cost,
                carton_price, pieces_per_package, pallet_price, packages_per_pallet,
                unit_cost, package_cost
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            material_type, material_name, price_before_waste_num, gross_weight_num,
            waste_percentage_num, packaging_unit, parseFloat(packaging_weight) || 0, empty_package_price_num,
            sticker_price_num, additional_expenses_num, labor_cost_num, preservatives_cost_num,
            carton_price_num, pieces_per_package_num, pallet_price_num, packages_per_pallet_num,
            unit_cost, package_cost
        ]);

        // حفظ في سجل التكاليف
        await req.db.query(`
            INSERT INTO cost_logs (material_id, material_name, unit_cost, package_cost)
            VALUES (?, ?, ?, ?)
        `, [result.insertId, material_name, unit_cost, package_cost]);

        res.json({ success: true, message: 'تم حفظ المادة بنجاح' });
    } catch (error) {
        console.error('خطأ في حفظ المادة:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في حفظ المادة' });
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
            empty_package_price,
            sticker_price,
            additional_expenses,
            labor_cost,
            preservatives_cost,
            carton_price,
            pieces_per_package,
            pallet_price,
            packages_per_pallet
        } = req.body;

        // تحويل القيم إلى أرقام
        const price_before_waste_num = parseFloat(price_before_waste) || 0;
        const gross_weight_num = parseFloat(gross_weight) || 0;
        const waste_percentage_num = parseFloat(waste_percentage) || 0;
        const empty_package_price_num = parseFloat(empty_package_price) || 0;
        const sticker_price_num = parseFloat(sticker_price) || 0;
        const additional_expenses_num = parseFloat(additional_expenses) || 0;
        const labor_cost_num = parseFloat(labor_cost) || 0;
        const preservatives_cost_num = parseFloat(preservatives_cost) || 0;
        const carton_price_num = parseFloat(carton_price) || 0;
        const pieces_per_package_num = parseInt(pieces_per_package) || 1;
        const pallet_price_num = parseFloat(pallet_price) || 0;
        const packages_per_pallet_num = parseInt(packages_per_pallet) || 1;

        // حساب كلفة القطعة الواحدة
        const net_weight = gross_weight_num * (1 - waste_percentage_num / 100);
        const price_per_kg_after_waste = price_before_waste_num / (1 - waste_percentage_num / 100);
        const material_cost_in_unit = price_per_kg_after_waste * (parseFloat(packaging_weight) || 0);
        const total_packaging_costs = empty_package_price_num + sticker_price_num + additional_expenses_num + labor_cost_num + preservatives_cost_num;
        const unit_cost = material_cost_in_unit + total_packaging_costs;

        // حساب كلفة الطرد
        const pallet_share = pallet_price_num / packages_per_pallet_num;
        const package_cost = unit_cost + pallet_share;

        // تحديث المادة
        await req.db.query(`
            UPDATE materials SET
                material_type = ?, material_name = ?, price_before_waste = ?, gross_weight = ?,
                waste_percentage = ?, packaging_unit = ?, packaging_weight = ?, empty_package_price = ?,
                sticker_price = ?, additional_expenses = ?, labor_cost = ?, preservatives_cost = ?,
                carton_price = ?, pieces_per_package = ?, pallet_price = ?, packages_per_pallet = ?,
                unit_cost = ?, package_cost = ?
            WHERE id = ?
        `, [
            material_type, material_name, price_before_waste_num, gross_weight_num,
            waste_percentage_num, packaging_unit, parseFloat(packaging_weight) || 0, empty_package_price_num,
            sticker_price_num, additional_expenses_num, labor_cost_num, preservatives_cost_num,
            carton_price_num, pieces_per_package_num, pallet_price_num, packages_per_pallet_num,
            unit_cost, package_cost, id
        ]);

        // حفظ في سجل التكاليف
        await req.db.query(`
            INSERT INTO cost_logs (material_id, material_name, unit_cost, package_cost)
            VALUES (?, ?, ?, ?)
        `, [id, material_name, unit_cost, package_cost]);

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

        res.render('costs/quotations', {
            title: 'عروض الأسعار',
            quotations,
            materials,
            formatDate
        });
    } catch (error) {
        console.error('خطأ في عرض عروض الأسعار:', error);
        req.flash('error_msg', 'حدث خطأ في عرض عروض الأسعار');
        res.redirect('/costs');
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
            general_profit_percentage,
            items
        } = req.body;

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

        // حفظ العرض
        const [quotationResult] = await req.db.query(`
            INSERT INTO quotations (quotation_number, client_name, client_phone, client_address, notes, general_profit_percentage, total_amount)
            VALUES (?, ?, ?, ?, ?, ?, 0)
        `, [quotationNumber, client_name, client_phone, client_address, notes, general_profit_percentage || 0]);

        let totalAmount = 0;

        // حفظ بنود العرض
        if (items && Array.isArray(items)) {
            for (const item of items) {
                const profitPercentage = item.profit_percentage || general_profit_percentage || 0;
                const finalPrice = item.unit_cost * (1 + profitPercentage / 100);
                const totalPrice = finalPrice * item.quantity;

                await req.db.query(`
                    INSERT INTO quotation_items (quotation_id, material_id, material_name, unit_cost, profit_percentage, final_price, quantity, total_price)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                `, [quotationResult.insertId, item.material_id, item.material_name, item.unit_cost, profitPercentage, finalPrice, item.quantity, totalPrice]);

                totalAmount += totalPrice;
            }
        }

        // تحديث المبلغ الإجمالي
        await req.db.query(`
            UPDATE quotations SET total_amount = ? WHERE id = ?
        `, [totalAmount, quotationResult.insertId]);

        res.json({ success: true, message: 'تم إنشاء عرض السعر بنجاح' });
    } catch (error) {
        console.error('خطأ في إنشاء عرض السعر:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في إنشاء عرض السعر' });
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

        res.render('costs/quotation-details', {
            title: `عرض السعر ${quotation[0].quotation_number}`,
            quotation: quotation[0],
            items,
            formatDate
        });
    } catch (error) {
        console.error('خطأ في عرض تفاصيل عرض السعر:', error);
        req.flash('error_msg', 'حدث خطأ في عرض تفاصيل عرض السعر');
        res.redirect('/costs/quotations');
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
            SELECT * FROM orders ORDER BY created_at DESC
        `);

        res.render('costs/orders', {
            title: 'الطلبيات',
            orders,
            formatDate
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
            client_phone,
            client_address,
            delivery_date,
            responsible_worker,
            notes
        } = req.body;

        // تحويل التاريخ من DD/MM/YYYY إلى YYYY-MM-DD
        const [day, month, year] = delivery_date.split('/');
        const formattedDate = `${year}-${month}-${day}`;

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

        await req.db.query(`
            INSERT INTO orders (order_number, client_name, client_phone, client_address, delivery_date, responsible_worker, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `, [orderNumber, client_name, client_phone, client_address, formattedDate, responsible_worker, notes]);

        res.json({ success: true, message: 'تم إنشاء الطلبية بنجاح' });
    } catch (error) {
        console.error('خطأ في إنشاء الطلبية:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في إنشاء الطلبية' });
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
        
        res.json({ success: true, logs });
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
        
        res.json({ success: true, order: orders[0] });
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
            client_phone,
            client_address,
            delivery_date,
            responsible_worker,
            notes
        } = req.body;
        
        // تحويل التاريخ من DD/MM/YYYY إلى YYYY-MM-DD
        const [day, month, year] = delivery_date.split('/');
        const formattedDate = `${year}-${month}-${day}`;
        
        await req.db.query(`
            UPDATE orders SET
                client_name = ?, client_phone = ?, client_address = ?,
                delivery_date = ?, responsible_worker = ?, notes = ?
            WHERE id = ?
        `, [client_name, client_phone, client_address, formattedDate, responsible_worker, notes, id]);
        
        res.json({ success: true, message: 'تم تحديث الطلبية بنجاح' });
    } catch (error) {
        console.error('خطأ في تحديث الطلبية:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في تحديث الطلبية' });
    }
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
        
        res.render('costs/material-preview', {
            title: 'معاينة المادة',
            material: material,
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
    createQuotation,
    getQuotationDetails,
    getOrders,
    getOrder,
    createOrder,
    updateOrder,
    updateOrderStatus,
    deleteMaterial,
    deleteQuotation,
    deleteOrder
}; 