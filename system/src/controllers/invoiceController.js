const { pool } = require('../database/db');
const path = require('path');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');
const moment = require('moment');
const { normalizeRawNumeric, parseRawNumericMap, rawOrValue } = require('../utils/rawNumbers');

const INVENTORY_RAW_FIELDS = ['base_quantity', 'current_quantity', 'sample_weight', 'net_weight_total', 'ph', 'peroxide_value', 'sigma_absorbance'];
const INVOICE_ITEM_RAW_FIELDS = ['quantity', 'price', 'net_weight', 'ph', 'peroxide_value', 'absorption_232', 'absorption_266', 'absorption_270', 'absorption_274', 'delta_k'];
const INVOICE_RAW_FIELDS = ['total_amount', 'avg_ph', 'avg_peroxide', 'avg_232', 'avg_270', 'avg_delta_k', 'total_quantity_tanks', 'total_quantity_liters'];

function roundTo3(value) {
    const num = Number(value);
    if (!Number.isFinite(num)) return 0;
    return Number(num.toFixed(3));
}

function applyInventoryRaw(item) {
    if (!item || typeof item !== 'object') return item;
    const rawMap = parseRawNumericMap(item.numeric_raw);
    const mapped = { ...item };
    INVENTORY_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });
    return mapped;
}

function applyInvoiceItemRaw(item) {
    if (!item || typeof item !== 'object') return item;
    const rawMap = parseRawNumericMap(item.numeric_raw);
    const mapped = { ...item };
    INVOICE_ITEM_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });
    return mapped;
}

function applyInvoiceRaw(item) {
    if (!item || typeof item !== 'object') return item;
    const rawMap = parseRawNumericMap(item.numeric_raw);
    const mapped = { ...item };
    INVOICE_RAW_FIELDS.forEach((field) => {
        mapped[field] = rawOrValue(rawMap, field, mapped[field]);
    });
    return mapped;
}

// عرض قائمة طلبات  الشحن
exports.getInvoices = async (req, res) => {
    try {
        const { date, customer, invoice_number } = req.query;
        let query = `
            SELECT i.*, 
                   i.total_quantity_tanks,
                   i.total_quantity_liters,
                   u.username as created_by_name,
                   DATE_FORMAT(i.date, '%Y-%m-%d') as formatted_date
            FROM invoices i
            LEFT JOIN users u ON i.created_by = u.id
            WHERE i.deleted_at IS NULL
        `;
        const params = [];

        if (date) {
            query += ` AND DATE(i.date) = ?`;
            params.push(date);
        }
        if (customer) {
            query += ` AND i.customer_name LIKE ?`;
            params.push(`%${customer}%`);
        }
        if (invoice_number) {
            query += ` AND i.invoice_number LIKE ?`;
            params.push(`%${invoice_number}%`);
        }

        query += ` ORDER BY i.date DESC, i.id DESC`;

        const [invoiceRows] = await pool.query(query, params);
        const invoices = invoiceRows.map(applyInvoiceRaw);
        
        // إعادة حساب الوزن الإجمالي لكل طلبية شحن باستخدام الصيغة المطلوبة
        for (let invoice of invoices) {
            // جلب عناصر طلب الشحن مع بيانات المخزون
            const [items] = await pool.query(`
                SELECT ii.quantity, inv.net_weight_total, inv.base_quantity
                FROM invoice_items ii
                JOIN inventory inv ON ii.inventory_id = inv.id
                WHERE ii.invoice_id = ?
            `, [invoice.id]);
            
            // إعادة حساب الوزن الإجمالي
            let recalculatedWeight = 0;
            items.forEach(item => {
                const quantity = Number(item.quantity) || 0;
                const netWeightTotal = Number(item.net_weight_total) || 0;
                const baseQuantity = Number(item.base_quantity) || 1;
                const weight = (netWeightTotal / baseQuantity) * quantity;
                recalculatedWeight += weight;
            });
            
            // تحديث الوزن في الكائن
            invoice.total_quantity_liters = roundTo3(recalculatedWeight);
        }
        
        res.render('invoices/index', {
            title: 'طلبات  الشحن',
            invoices,
            filters: req.query,
            user: req.session.user
        });
    } catch (error) {
        console.error('Error fetching invoices:', error);
        req.flash('error_msg', 'حدث خطأ أثناء جلب بيانات طلبات  الشحن');
        res.redirect('/');
    }
};

// عرض نموذج إنشاء طلبية شحن جديدة
exports.getCreateForm = async (req, res) => {
    try {
        const [inventoryRows] = await pool.query('SELECT * FROM inventory WHERE current_quantity > 0 AND deleted_at IS NULL ORDER BY date DESC');
        const inventory = inventoryRows.map(applyInventoryRaw);
        
        // جلب رقم آخر طلبية شحن مضافة
        const [lastInvoice] = await pool.query(`
            SELECT invoice_number 
            FROM invoices 
            WHERE deleted_at IS NULL 
            ORDER BY id DESC 
            LIMIT 1
        `);
        
        const lastInvoiceNumber = lastInvoice.length > 0 ? lastInvoice[0].invoice_number : 'لا توجد فواتير سابقة';
        
        res.render('invoices/create', {
            title: 'إنشاء طلبية شحن جديدة',
            inventory,
            lastInvoiceNumber,
            user: req.session.user
        });
    } catch (error) {
        console.error('Error loading create form:', error);
        req.flash('error_msg', 'حدث خطأ أثناء تحميل النموذج');
        res.redirect('/invoices');
    }
};

// إنشاء طلبية شحن جديدة
exports.createInvoice = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        
        // تعيين timeout للمعاملات
        await connection.query('SET SESSION innodb_lock_wait_timeout = 60');
        await connection.query('SET SESSION lock_wait_timeout = 60');
        
        await connection.beginTransaction();

        let {
            date,
            invoice_number,
            customer_name,
            driver_name,
            notes,
            quantities
        } = req.body;

        // التحقق من الحقول المطلوبة
        if (!customer_name || customer_name.trim() === '') {
            throw new Error('اسم الزبون مطلوب');
        }
        
        if (!invoice_number || invoice_number.trim() === '') {
            throw new Error('رقم طلب الشحن مطلوب');
        }
        
        // driver_name اختياري - تنظيف القيمة فقط
        driver_name = driver_name ? driver_name.trim() : '';

        // معالجة quantities إذا كانت نصاً (JSON)
        if (typeof quantities === 'string') {
            try {
                quantities = JSON.parse(quantities);
            } catch (e) {
                throw new Error('خطأ في معالجة الكميات');
            }
        }

        // التحقق من صحة التاريخ والحصول على السنة
        let invoiceYear;
        try {
            if (!date || date.trim() === '') {
                const now = new Date();
                date = now.getFullYear() + '-' +
                    String(now.getMonth() + 1).padStart(2, '0') + '-' +
                    String(now.getDate()).padStart(2, '0');
            } else if (date.includes('/')) {
                // تحويل التاريخ من DD/MM/YYYY إلى YYYY-MM-DD
                const parts = date.split('/');
                if (parts.length === 3) {
                    const day = parts[0];
                    const month = parts[1];
                    const year = parts[2];
                    date = `${year}-${month}-${day}`;
                }
            }
            const invoiceDate = new Date(date);
            if (isNaN(invoiceDate.getTime())) {
                throw new Error('التاريخ غير صالح');
            }
            invoiceYear = invoiceDate.getFullYear();
            if (isNaN(invoiceYear)) {
                throw new Error('لم نتمكن من استخراج السنة من التاريخ');
            }
        } catch (error) {
            throw new Error('خطأ في معالجة التاريخ: ' + error.message);
        }

        // التحقق فقط أن رقم طلب الشحن عدد موجب
        const submittedNumber = parseInt(invoice_number);
        if (isNaN(submittedNumber) || submittedNumber <= 0) {
            throw new Error('رقم طلب الشحن يجب أن يكون عدداً موجباً');
        }

        // التحقق من وجود كميات
        if (!quantities || Object.keys(quantities).length === 0) {
            throw new Error('يجب اختيار عنصر واحد على الأقل');
        }

        let totalQuantity = 0;
        let totalQuantityLiters = 0;
        let weightedSumPH = 0;
        let weightedSumPeroxide = 0;
        let weightedSum232 = 0;
        let weightedSum270 = 0;
        let weightedSumDeltaK = 0;

        // التحقق من توفر الكميات المطلوبة وجمع البيانات للمعدلات
        for (const [inventory_id, quantity] of Object.entries(quantities)) {

            const [item] = await connection.query(
                'SELECT * FROM inventory WHERE id = ? AND deleted_at IS NULL',
                [inventory_id]
            );

            if (item.length === 0) {
                throw new Error(`العنصر غير موجود: ${inventory_id}`);
            }

            const inventoryItem = item[0];

            const quantityRaw = normalizeRawNumeric(quantity);
            if (quantityRaw === null) {
                throw new Error(`الكمية غير صالحة للعنصر: ${inventoryItem.sample_number}`);
            }
            const requestedQuantity = parseFloat(quantityRaw);
            const availableQuantity = parseFloat(inventoryItem.current_quantity);

            if (requestedQuantity > availableQuantity) {
                throw new Error(`الكمية المطلوبة (${requestedQuantity}) أكبر من المتوفرة (${availableQuantity}) للعنصر: ${inventoryItem.sample_number}`);
            }

            totalQuantity += requestedQuantity;
            totalQuantityLiters += requestedQuantity * (inventoryItem.net_weight_total / inventoryItem.base_quantity); // تحويل الكمية إلى ليتر (16 لتر لكل تنكة)

            // استخراج قيم الامتصاص من حقل absorption_readings
            let absorptionReadings = [0, 0, 0, 0, 0];
            try {
                if (inventoryItem.absorption_readings) {
                    if (typeof inventoryItem.absorption_readings === 'string') {
                        // تحويل النص إلى مصفوفة أرقام
                        const readings = inventoryItem.absorption_readings.split(' ').map(Number);
                        if (readings.length >= 5) {
                            absorptionReadings = readings;
                        }
                    } else if (Array.isArray(inventoryItem.absorption_readings)) {
                        absorptionReadings = inventoryItem.absorption_readings;
                    }
                }
            } catch (e) {
                console.error('Error parsing absorption readings:', e);
            }

            // حساب المجاميع الموزونة
            const ph = parseFloat(inventoryItem.ph) || 0;
            const peroxide = parseFloat(inventoryItem.peroxide_value) || 0;
            const sigma = parseFloat(inventoryItem.sigma_absorbance) || 0;

            weightedSumPH += requestedQuantity * ph;
            weightedSumPeroxide += requestedQuantity * peroxide;
            weightedSum232 += requestedQuantity * (absorptionReadings[0] || 0);
            weightedSum270 += requestedQuantity * sigma;
            weightedSumDeltaK += requestedQuantity * (absorptionReadings[4] || 0);

            // تحديث الكمية في المخزون
            await connection.query(
                'UPDATE inventory SET current_quantity = current_quantity - ? WHERE id = ?',
                [requestedQuantity, inventory_id]
            );

        }

        // حساب المتوسطات الموزونة - التعامل مع حالة عدم وجود كميات
        const avgPH = totalQuantity > 0 ? weightedSumPH / totalQuantity : 0;
        const avgPeroxide = totalQuantity > 0 ? weightedSumPeroxide / totalQuantity : 0;
        const avg232 = totalQuantity > 0 ? weightedSum232 / totalQuantity : 0;
        const avg270 = totalQuantity > 0 ? weightedSum270 / totalQuantity : 0;
        const avgDeltaK = totalQuantity > 0 ? weightedSumDeltaK / totalQuantity : 0;

        const invoiceRawMap = {
            total_amount: String(totalQuantityLiters),
            avg_ph: String(avgPH),
            avg_peroxide: String(avgPeroxide),
            avg_232: String(avg232),
            avg_270: String(avg270),
            avg_delta_k: String(avgDeltaK),
            total_quantity_tanks: String(totalQuantity),
            total_quantity_liters: String(totalQuantityLiters)
        };

        // إنشاء طلب الشحن
        const [result] = await connection.query(
            `INSERT INTO invoices (
                invoice_number, customer_name, driver_name,
                date, total_amount, status, notes, created_by,
                avg_ph, avg_peroxide, avg_232, avg_270, avg_delta_k,
                total_quantity_tanks, total_quantity_liters, numeric_raw
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
                invoice_number, customer_name, driver_name,
                date, totalQuantityLiters, 'pending', notes, req.session.user.id,
                avgPH, avgPeroxide, avg232, avg270, avgDeltaK,
                totalQuantity, totalQuantityLiters, JSON.stringify(invoiceRawMap)
            ]
        );

        const invoice_id = result.insertId;

        // إضافة عناصر طلب الشحن
        for (const [inventory_id, quantity] of Object.entries(quantities)) {
            const [item] = await connection.query(
                'SELECT * FROM inventory WHERE id = ?',
                [inventory_id]
            );

            if (item.length > 0) {
                const inventoryItem = item[0];
                let absorptionReadings = [0, 0, 0, 0, 0];
                let absorptionRawReadings = [null, null, null, null, null];

                try {
                    if (inventoryItem.absorption_readings) {
                        if (typeof inventoryItem.absorption_readings === 'string') {
                            const readingsRaw = inventoryItem.absorption_readings.split(' ');
                            const readings = readingsRaw.map((v) => parseFloat(v));
                            if (readings.length >= 5) {
                                absorptionReadings = readings;
                                absorptionRawReadings = readingsRaw.slice(0, 5).map((v) => normalizeRawNumeric(v));
                            }
                        } else if (Array.isArray(inventoryItem.absorption_readings)) {
                            absorptionReadings = inventoryItem.absorption_readings;
                        }
                    }
                } catch (e) {
                    console.error('Error parsing absorption readings for invoice item:', e);
                }

                const quantityRaw = normalizeRawNumeric(quantity);
                if (quantityRaw === null) {
                    throw new Error(`الكمية غير صالحة للعنصر: ${inventoryItem.sample_number}`);
                }
                const requestedQuantity = parseFloat(quantityRaw);
                const ph = parseFloat(inventoryItem.ph) || 0;
                const peroxide = parseFloat(inventoryItem.peroxide_value) || 0;
                const netWeight = requestedQuantity * (inventoryItem.net_weight_total / inventoryItem.base_quantity);
                const inventoryRawMap = parseRawNumericMap(inventoryItem.numeric_raw);
                const invoiceItemRawMap = {};
                if (quantityRaw !== null) invoiceItemRawMap.quantity = quantityRaw;
                const phRaw = normalizeRawNumeric(rawOrValue(inventoryRawMap, 'ph', inventoryItem.ph));
                if (phRaw !== null) invoiceItemRawMap.ph = phRaw;
                const peroxideRaw = normalizeRawNumeric(rawOrValue(inventoryRawMap, 'peroxide_value', inventoryItem.peroxide_value));
                if (peroxideRaw !== null) invoiceItemRawMap.peroxide_value = peroxideRaw;
                if (absorptionRawReadings[0] !== null) invoiceItemRawMap.absorption_232 = absorptionRawReadings[0];
                if (absorptionRawReadings[1] !== null) invoiceItemRawMap.absorption_266 = absorptionRawReadings[1];
                if (absorptionRawReadings[2] !== null) invoiceItemRawMap.absorption_270 = absorptionRawReadings[2];
                if (absorptionRawReadings[3] !== null) invoiceItemRawMap.absorption_274 = absorptionRawReadings[3];
                if (absorptionRawReadings[4] !== null) invoiceItemRawMap.delta_k = absorptionRawReadings[4];

                await connection.query(
                    `INSERT INTO invoice_items (
                        invoice_id, inventory_id, quantity,
                        ph, peroxide_value, absorption_232,
                        absorption_266, absorption_270, absorption_274,
                        delta_k, net_weight, sample_number, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                    [
                        invoice_id, inventory_id, requestedQuantity,
                        ph, peroxide, absorptionReadings[0] || 0,
                        absorptionReadings[1] || 0, absorptionReadings[2] || 0, absorptionReadings[3] || 0,
                        absorptionReadings[4] || 0, netWeight, inventoryItem.sample_number, JSON.stringify(invoiceItemRawMap)
                    ]
                );

            }
        }

        await connection.commit();

        if (req.xhr || req.headers.accept.indexOf('json') > -1) {
            return res.json({
                success: true,
                message: 'تم إنشاء طلب الشحن بنجاح',
                invoiceId: invoice_id
            });
        }

        req.flash('success_msg', 'تم إنشاء طلب الشحن بنجاح');
        // Check if it's an AJAX request
        if (req.xhr || req.headers.accept.indexOf('json') > -1) {
            return res.json({
                success: true,
                invoiceId: invoice_id,
                message: 'تم إنشاء طلب الشحن بنجاح'
            });
        }
        
        res.redirect('/invoices/' + invoice_id);

    } catch (error) {
        try {
            await connection.rollback();
        } catch (rollbackError) {
            console.error('Error during rollback:', rollbackError);
        }
        
        console.error('Error creating invoice:', error);
        
        if (req.xhr || req.headers.accept.indexOf('json') > -1) {
            return res.status(500).json({
                success: false,
                message: error.message || 'حدث خطأ أثناء إنشاء طلب الشحن'
            });
        }
        
        req.flash('error_msg', error.message || 'حدث خطأ أثناء إنشاء طلب الشحن');
        res.redirect('/invoices/create');
    } finally {
        // ضمان إغلاق الاتصال
        try {
            connection.release();
        } catch (releaseError) {
            console.error('Error releasing connection:', releaseError);
        }
    }
};

// عرض طلبية شحن
exports.getInvoice = async (req, res) => {
    try {
        const [invoices] = await pool.query(
            `SELECT i.*, u.username as created_by_name
             FROM invoices i
             LEFT JOIN users u ON i.created_by = u.id
             WHERE i.id = ?`,
            [req.params.id]
        );

        if (invoices.length === 0) {
            req.flash('error_msg', 'طلب الشحن غير موجودة');
            return res.redirect('/invoices');
        }

        const [itemRows] = await pool.query(
            `SELECT ii.*, inv.sample_number, inv.supplier_or_sample_name, 
                    inv.net_weight_total, inv.base_quantity, inv.numeric_raw AS inventory_numeric_raw,
                    (inv.current_quantity + ii.quantity) AS available_quantity
             FROM invoice_items ii
             JOIN inventory inv ON ii.inventory_id = inv.id
             WHERE ii.invoice_id = ?`,
            [req.params.id]
        );
        const items = itemRows.map((item) => {
            const withRaw = applyInvoiceItemRaw(item);
            const invRawMap = parseRawNumericMap(item.inventory_numeric_raw);
            return {
                ...withRaw,
                net_weight_total: rawOrValue(invRawMap, 'net_weight_total', withRaw.net_weight_total),
                base_quantity: rawOrValue(invRawMap, 'base_quantity', withRaw.base_quantity)
            };
        });

        res.render('invoices/view', {
            title: 'عرض طلب الشحن',
            invoice: applyInvoiceRaw(invoices[0]),
            items,
            user: req.session.user
        });
    } catch (error) {
        console.error('Error fetching invoice:', error);
        req.flash('error_msg', 'حدث خطأ أثناء جلب بيانات طلب الشحن');
        res.redirect('/invoices');
    }
};

// طباعة طلبية شحن
exports.printInvoice = async (req, res) => {
    try {
        const [invoices] = await pool.query(
            `SELECT i.*, u.username as created_by_name
             FROM invoices i
             LEFT JOIN users u ON i.created_by = u.id
             WHERE i.id = ? AND i.deleted_at IS NULL`,
            [req.params.id]
        );

        if (invoices.length === 0) {
            req.flash('error_msg', 'طلب الشحن غير موجودة');
            return res.redirect('/invoices');
        }

        const [itemRows] = await pool.query(
            `SELECT ii.*, inv.sample_number, inv.net_weight_total, inv.base_quantity, inv.numeric_raw AS inventory_numeric_raw
             FROM invoice_items ii
             JOIN inventory inv ON ii.inventory_id = inv.id
             WHERE ii.invoice_id = ?`,
            [req.params.id]
        );
        const items = itemRows.map((item) => {
            const withRaw = applyInvoiceItemRaw(item);
            const invRawMap = parseRawNumericMap(item.inventory_numeric_raw);
            return {
                ...withRaw,
                net_weight_total: rawOrValue(invRawMap, 'net_weight_total', withRaw.net_weight_total),
                base_quantity: rawOrValue(invRawMap, 'base_quantity', withRaw.base_quantity)
            };
        });

        // تمرير user: null إذا لم يوجد مستخدم في الجلسة
        res.render('invoices/print', {
            title: 'طباعة طلب الشحن',
            invoice: applyInvoiceRaw(invoices[0]),
            items,
            user: req.session.user || null,
            layout: 'invoices/print'
        });
    } catch (error) {
        console.error('Error printing invoice:', error);
        req.flash('error_msg', 'حدث خطأ أثناء طباعة طلب الشحن');
        res.redirect('/invoices');
    }
};

// حذف طلبية شحن
exports.deleteInvoice = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        // تعيين timeout للمعاملات
        await connection.query('SET SESSION innodb_lock_wait_timeout = 60');
        await connection.query('SET SESSION lock_wait_timeout = 60');
        
        await connection.beginTransaction();

        const invoiceId = req.params.id;
        // التحقق من وجود طلب الشحن (غير محذوفة ناعماً)
        const [invoice] = await connection.query('SELECT * FROM invoices WHERE id = ? AND deleted_at IS NULL', [invoiceId]);
        if (!invoice || invoice.length === 0) {
            throw new Error('طلب الشحن غير موجودة أو محذوفة مسبقاً');
        }

        // جلب عناصر طلب الشحن
        const [items] = await connection.query('SELECT inventory_id, quantity FROM invoice_items WHERE invoice_id = ?', [invoiceId]);
        for (const item of items) {
            // تحقق إذا كانت العينة موجودة
            const [inventory] = await connection.query('SELECT id FROM inventory WHERE id = ?', [item.inventory_id]);
            if (inventory && inventory.length > 0) {
                // إرجاع الكمية
                await connection.query('UPDATE inventory SET current_quantity = current_quantity + ? WHERE id = ?', [item.quantity, item.inventory_id]);
            }
        }

        // حذف تفاصيل طلب الشحن أولاً (العلاقة الفرعية)
        await connection.query('DELETE FROM invoice_items WHERE invoice_id = ?', [invoiceId]);

        // ثم حذف طلب الشحن نفسها
        await connection.query('DELETE FROM invoices WHERE id = ?', [invoiceId]);

        await connection.commit();

        res.json({ success: true, message: 'تم حذف طلب الشحن بنجاح' });
    } catch (error) {
        try {
            await connection.rollback();
        } catch (rollbackError) {
            console.error('Error during rollback:', rollbackError);
        }
        
        console.error('Error deleting invoice:', error);
        res.status(500).json({
            success: false,
            message: 'حدث خطأ أثناء حذف طلب الشحن',
            error: error.message
        });
    } finally {
        // ضمان إغلاق الاتصال
        try {
            connection.release();
        } catch (releaseError) {
            console.error('Error releasing connection:', releaseError);
        }
    }
};

exports.exportInvoicePDF = async (req, res) => {
    const pdf = require('html-pdf-node');
    try {
        const invoiceUrl = `${process.env.BASE_URL}/invoices/${req.params.id}/print-pdf-raw`;

        const options = { format: 'A4' };
        const file = { url: invoiceUrl };

        const fileName = uuidv4() + '.pdf';
        const savePath = path.join(__dirname, '../public/invoices_pdf', fileName);

        // تأكد من وجود مجلد الحفظ
        const dir = path.join(__dirname, '../public/invoices_pdf');
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }

        const pdfBuffer = await pdf.generatePdf(file, options);
        fs.writeFileSync(savePath, pdfBuffer);

        const fileUrl = `${req.protocol}://${req.get('host')}/public/invoices_pdf/${fileName}`;

        res.json({
            success: true,
            url: fileUrl
        });
    } catch (error) {
        console.error('Error exporting invoice PDF:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير طلب الشحن كـ PDF' });
    }
};

// عرض نموذج تعديل طلب الشحن
exports.getEditForm = async (req, res) => {
    try {
        const invoiceId = req.params.id;

        // جلب بيانات طلب الشحن
        const [invoices] = await pool.query(
            `SELECT i.*, u.username as created_by_name
             FROM invoices i
             LEFT JOIN users u ON i.created_by = u.id
             WHERE i.id = ?`,
            [invoiceId]
        );

        if (invoices.length === 0) {
            req.flash('error_msg', 'طلب الشحن غير موجودة');
            return res.redirect('/invoices');
        }

        // جلب عناصر طلب الشحن
        const [itemRows] = await pool.query(
            `SELECT ii.*, inv.sample_number, inv.supplier_or_sample_name, 
                    (inv.current_quantity + ii.quantity) AS available_quantity,
                    inv.numeric_raw AS inventory_numeric_raw
             FROM invoice_items ii
             JOIN inventory inv ON ii.inventory_id = inv.id
             WHERE ii.invoice_id = ?`,
            [invoiceId]
        );
        const items = itemRows.map((item) => {
            const withRaw = applyInvoiceItemRaw(item);
            const invRawMap = parseRawNumericMap(item.inventory_numeric_raw);
            return {
                ...withRaw,
                available_quantity: rawOrValue(invRawMap, 'current_quantity', withRaw.available_quantity)
            };
        });

        // تحديد مصفوفة الـ inventory_id الموجودة في طلب الشحن
        const currentIds = items.map(i => i.inventory_id);

        // جلب المخزون المتاح مع استبعاد العينات المضافة بالفعل
        let inventory;
        if (currentIds.length > 0) {
            const [inventoryRows] = await pool.query(
                'SELECT * FROM inventory WHERE deleted_at IS NULL AND current_quantity > 0 AND id NOT IN (?)',
                [currentIds]
            );
            inventory = inventoryRows.map(applyInventoryRaw);
        } else {
            const [inventoryRows] = await pool.query('SELECT * FROM inventory WHERE deleted_at IS NULL AND current_quantity > 0');
            inventory = inventoryRows.map(applyInventoryRaw);
        }

        res.render('invoices/edit', {
            title: 'تعديل طلب الشحن',
            invoice: applyInvoiceRaw(invoices[0]),
            items,
            inventory,
            user: req.session.user
        });
    } catch (error) {
        console.error('Error loading edit form:', error);
        req.flash('error_msg', 'حدث خطأ أثناء تحميل نموذج التعديل');
        res.redirect('/invoices');
    }
};

// تحديث طلب الشحن
exports.updateInvoice = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        // تعيين timeout للمعاملات
        await connection.query('SET SESSION innodb_lock_wait_timeout = 60');
        await connection.query('SET SESSION lock_wait_timeout = 60');
        
        await connection.beginTransaction();

        const invoiceId = req.params.id;
        let {
            date,
            invoice_number,
            customer_name,
            driver_name,
            notes,
            quantities
        } = req.body;

        // معالجة quantities إذا كانت نصاً (JSON)
        if (typeof quantities === 'string') {
            try {
                quantities = JSON.parse(quantities);
            } catch (e) {
                throw new Error('خطأ في معالجة الكميات');
            }
        }

        // التحقق من وجود طلب الشحن
        const [existingInvoice] = await connection.query('SELECT * FROM invoices WHERE id = ?', [invoiceId]);
        if (existingInvoice.length === 0) {
            throw new Error('طلب الشحن غير موجودة');
        }

        // التحقق من صحة التاريخ
        if (!date || date.trim() === '') {
            const now = new Date();
            date = now.getFullYear() + '-' +
                String(now.getMonth() + 1).padStart(2, '0') + '-' +
                String(now.getDate()).padStart(2, '0');
        } else if (date.includes('/')) {
            // تحويل التاريخ من DD/MM/YYYY إلى YYYY-MM-DD
            const parts = date.split('/');
            if (parts.length === 3) {
                const day = parts[0];
                const month = parts[1];
                const year = parts[2];
                date = `${year}-${month}-${day}`;
            }
        }

        // التحقق من رقم طلب الشحن
        const submittedNumber = parseInt(invoice_number);
        if (isNaN(submittedNumber) || submittedNumber <= 0) {
            throw new Error('رقم طلب الشحن يجب أن يكون عدداً موجباً');
        }

        // جلب الكميات الحالية في طلب الشحن
        const [currentItems] = await connection.query(
            'SELECT inventory_id, quantity FROM invoice_items WHERE invoice_id = ?',
            [invoiceId]
        );

        // إرجاع الكميات الحالية إلى المخزون
        for (const item of currentItems) {
            await connection.query(
                'UPDATE inventory SET current_quantity = current_quantity + ? WHERE id = ?',
                [item.quantity, item.inventory_id]
            );
        }

        // حذف العناصر الحالية
        await connection.query('DELETE FROM invoice_items WHERE invoice_id = ?', [invoiceId]);

        let totalQuantity = 0;
        let totalQuantityLiters = 0;
        let weightedSumPH = 0;
        let weightedSumPeroxide = 0;
        let weightedSum232 = 0;
        let weightedSum270 = 0;
        let weightedSumDeltaK = 0;

        // إضافة العناصر الجديدة
        if (quantities && Object.keys(quantities).length > 0) {
            for (const [inventory_id, quantity] of Object.entries(quantities)) {
                const [rows] = await connection.query(
                    `SELECT current_quantity, ph, peroxide_value, 
                            absorption_readings, sigma_absorbance,
                            supplier_or_sample_name, sample_number,
                            net_weight_total, base_quantity, numeric_raw
                     FROM inventory WHERE id = ?`,
                    [inventory_id]
                );

                if (rows.length === 0) {
                    throw new Error(`العنصر غير موجود: ${inventory_id}`);
                }

                const inventoryItem = rows[0];
                const quantityRaw = normalizeRawNumeric(quantity);
                if (quantityRaw === null) {
                    throw new Error(`الكمية غير صالحة للعنصر: ${inventoryItem.sample_number}`);
                }
                const requestedQuantity = parseFloat(quantityRaw);
                const availableQuantity = parseFloat(inventoryItem.current_quantity);

                if (requestedQuantity > availableQuantity) {
                    throw new Error(`الكمية المطلوبة (${requestedQuantity}) أكبر من المتوفرة (${availableQuantity}) للعنصر: ${inventoryItem.sample_number}`);
                }

                totalQuantity += requestedQuantity;
                const netWeightPerUnit = (parseFloat(inventoryItem.net_weight_total) || 0) / (parseFloat(inventoryItem.base_quantity) || 1);
                totalQuantityLiters += requestedQuantity * netWeightPerUnit;

                // استخراج قيم الامتصاص
                let absorptionReadings = [0, 0, 0, 0, 0];
                try {
                    if (inventoryItem.absorption_readings) {
                        if (typeof inventoryItem.absorption_readings === 'string') {
                            const readings = inventoryItem.absorption_readings.split(' ').map(Number);
                            if (readings.length >= 5) {
                                absorptionReadings = readings;
                            }
                        } else if (Array.isArray(inventoryItem.absorption_readings)) {
                            absorptionReadings = inventoryItem.absorption_readings;
                        }
                    }
                } catch (e) {
                    console.error('Error parsing absorption readings:', e);
                }

                // حساب المجاميع الموزونة
                const ph = parseFloat(inventoryItem.ph) || 0;
                const peroxide = parseFloat(inventoryItem.peroxide_value) || 0;
                const sigma = parseFloat(inventoryItem.sigma_absorbance) || 0;

                weightedSumPH += requestedQuantity * ph;
                weightedSumPeroxide += requestedQuantity * peroxide;
                weightedSum232 += requestedQuantity * (absorptionReadings[0] || 0);
                weightedSum270 += requestedQuantity * sigma;
                weightedSumDeltaK += requestedQuantity * (absorptionReadings[4] || 0);

                // تحديث الكمية في المخزون
                await connection.query(
                    'UPDATE inventory SET current_quantity = current_quantity - ? WHERE id = ?',
                    [requestedQuantity, inventory_id]
                );

                // إضافة العنصر إلى طلب الشحن
                const netWeight = requestedQuantity * netWeightPerUnit;
                const inventoryRawMap = parseRawNumericMap(inventoryItem.numeric_raw);
                const invoiceItemRawMap = {};
                if (quantityRaw !== null) invoiceItemRawMap.quantity = quantityRaw;
                const phRaw = normalizeRawNumeric(rawOrValue(inventoryRawMap, 'ph', inventoryItem.ph));
                if (phRaw !== null) invoiceItemRawMap.ph = phRaw;
                const peroxideRaw = normalizeRawNumeric(rawOrValue(inventoryRawMap, 'peroxide_value', inventoryItem.peroxide_value));
                if (peroxideRaw !== null) invoiceItemRawMap.peroxide_value = peroxideRaw;
                const a232Raw = normalizeRawNumeric(absorptionReadings[0]);
                if (a232Raw !== null) invoiceItemRawMap.absorption_232 = a232Raw;
                const a266Raw = normalizeRawNumeric(absorptionReadings[1]);
                if (a266Raw !== null) invoiceItemRawMap.absorption_266 = a266Raw;
                const a270Raw = normalizeRawNumeric(absorptionReadings[2]);
                if (a270Raw !== null) invoiceItemRawMap.absorption_270 = a270Raw;
                const a274Raw = normalizeRawNumeric(absorptionReadings[3]);
                if (a274Raw !== null) invoiceItemRawMap.absorption_274 = a274Raw;
                const deltaKRaw = normalizeRawNumeric(absorptionReadings[4]);
                if (deltaKRaw !== null) invoiceItemRawMap.delta_k = deltaKRaw;

                await connection.query(
                    `INSERT INTO invoice_items (
                        invoice_id, inventory_id, quantity,
                        ph, peroxide_value, absorption_232,
                        absorption_266, absorption_270, absorption_274,
                        delta_k, net_weight, sample_number, numeric_raw
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                    [
                        invoiceId, inventory_id, requestedQuantity,
                        ph, peroxide, absorptionReadings[0] || 0,
                        absorptionReadings[1] || 0, absorptionReadings[2] || 0, absorptionReadings[3] || 0,
                        absorptionReadings[4] || 0, netWeight, inventoryItem.sample_number, JSON.stringify(invoiceItemRawMap)
                    ]
                );
            }
        }

        // حساب المتوسطات الموزونة
        const avgPH = totalQuantity > 0 ? weightedSumPH / totalQuantity : 0;
        const avgPeroxide = totalQuantity > 0 ? weightedSumPeroxide / totalQuantity : 0;
        const avg232 = totalQuantity > 0 ? weightedSum232 / totalQuantity : 0;
        const avg270 = totalQuantity > 0 ? weightedSum270 / totalQuantity : 0;
        const avgDeltaK = totalQuantity > 0 ? weightedSumDeltaK / totalQuantity : 0;

        const updatedInvoiceRawMap = {
            total_amount: String(totalQuantityLiters),
            avg_ph: String(avgPH),
            avg_peroxide: String(avgPeroxide),
            avg_232: String(avg232),
            avg_270: String(avg270),
            avg_delta_k: String(avgDeltaK),
            total_quantity_tanks: String(totalQuantity),
            total_quantity_liters: String(totalQuantityLiters)
        };

        // تحديث بيانات طلب الشحن
        await connection.query(
            `UPDATE invoices SET 
                invoice_number = ?, customer_name = ?, driver_name = ?, 
                date = ?, notes = ?, total_quantity_tanks = ?, 
                total_quantity_liters = ?, avg_ph = ?, avg_peroxide = ?,
                avg_232 = ?, avg_270 = ?, avg_delta_k = ?,
                numeric_raw = ?,
                updated_at = NOW()
             WHERE id = ?`,
            [
                invoice_number, customer_name, driver_name, date, notes,
                totalQuantity, totalQuantityLiters, avgPH, avgPeroxide,
                avg232, avg270, avgDeltaK, JSON.stringify(updatedInvoiceRawMap), invoiceId
            ]
        );

        await connection.commit();

        if (req.xhr || req.headers.accept.indexOf('json') > -1) {
            return res.json({
                success: true,
                message: 'تم تحديث طلب الشحن بنجاح',
                invoiceId: invoiceId
            });
        }

        req.flash('success_msg', 'تم تحديث طلب الشحن بنجاح');
        res.redirect('/invoices/' + invoiceId);

    } catch (error) {
        try {
            await connection.rollback();
        } catch (rollbackError) {
            console.error('Error during rollback:', rollbackError);
        }
        
        console.error('Error updating invoice:', error);
        
        if (req.xhr || req.headers.accept.indexOf('json') > -1) {
            return res.status(500).json({
                success: false,
                message: error.message || 'حدث خطأ أثناء تحديث طلب الشحن'
            });
        }

        req.flash('error_msg', error.message || 'حدث خطأ أثناء تحديث طلب الشحن');
        res.redirect('/invoices/' + req.params.id);
    } finally {
        // ضمان إغلاق الاتصال
        try {
            connection.release();
        } catch (releaseError) {
            console.error('Error releasing connection:', releaseError);
        }
    }
};

// API لجلب المخزون
exports.getInventoryAPI = async (req, res) => {
    try {
        const { date, sample } = req.query;
        let query = 'SELECT * FROM inventory WHERE current_quantity > 0 AND deleted_at IS NULL';
        const params = [];

        if (date) {
            query += ' AND DATE(date) = ?';
            params.push(date);
        }
        if (sample) {
            query += ' AND sample_number LIKE ?';
            params.push(`%${sample}%`);
        }

        query += ' ORDER BY date DESC';

        const [inventoryRows] = await pool.query(query, params);
        const inventory = inventoryRows.map(applyInventoryRaw);
        res.json(inventory);
    } catch (error) {
        console.error('Error fetching inventory:', error);
        res.status(500).json({ error: 'حدث خطأ أثناء جلب المخزون' });
    }
};

// تحديث حالة طلب الشحن
exports.updateInvoiceStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        
        // التحقق من صحة الحالة
        const validStatuses = ['pending', 'processing', 'completed', 'cancelled'];
        if (!validStatuses.includes(status)) {
            return res.status(400).json({ 
                success: false, 
                message: 'حالة غير صحيحة' 
            });
        }
        
        await pool.query('UPDATE invoices SET status = ? WHERE id = ? AND deleted_at IS NULL', [status, id]);
        
        res.json({ success: true, message: 'تم تحديث حالة طلب الشحن بنجاح' });
    } catch (error) {
        console.error('خطأ في تحديث حالة طلب الشحن:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في تحديث حالة طلب الشحن' });
    }
};

// حذف ناعم (نقل إلى سلة المحذوفات)
exports.trashMultiple = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();
        
        const { ids } = req.body;
        if (!ids || !Array.isArray(ids) || ids.length === 0) {
            return res.status(400).json({ success: false, message: 'يرجى اختيار طلبية شحن واحدة على الأقل' });
        }

        // إرجاع كميات العينات إلى المخزون قبل نقل طلبات  الشحن إلى سلة المحذوفات
        for (const invoiceId of ids) {
            // جلب عناصر طلب الشحن
            const [items] = await connection.query(
                'SELECT inventory_id, quantity FROM invoice_items WHERE invoice_id = ?', 
                [invoiceId]
            );
            
            for (const item of items) {
                // التحقق من وجود العينة في المخزون (غير محذوفة ناعماً)
                const [inventory] = await connection.query(
                    'SELECT id FROM inventory WHERE id = ?', 
                    [item.inventory_id]
                );
                
                if (inventory && inventory.length > 0) {
                    // إرجاع الكمية إلى المخزون
                    await connection.query(
                        'UPDATE inventory SET current_quantity = current_quantity + ? WHERE id = ?', 
                        [item.quantity, item.inventory_id]
                    );
                }
                // إذا لم توجد العينة (محذوفة ناعماً)، نتجاهلها بهدوء
            }
        }

        // نقل طلبات  الشحن إلى سلة المحذوفات
        await connection.query('UPDATE invoices SET deleted_at = NOW() WHERE id IN (?)', [ids]);
        
        await connection.commit();
        res.json({ success: true, message: 'تم نقل طلبات  الشحن المحددة إلى سلة المحذوفات' });
    } catch (error) {
        await connection.rollback();
        console.error('Error trashing invoices:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء نقل طلبات  الشحن إلى سلة المحذوفات' });
    } finally {
        connection.release();
    }
};

// جلب طلبات  الشحن المحذوفة
exports.getDeletedInvoices = async (req, res) => {
    try {
        const [deletedRows] = await pool.query('SELECT * FROM invoices WHERE deleted_at IS NOT NULL ORDER BY deleted_at DESC');
        const deletedInvoices = deletedRows.map(applyInvoiceRaw);
        
        // إعادة حساب الوزن الإجمالي لكل طلبية شحن محذوفة باستخدام الصيغة المطلوبة
        for (let invoice of deletedInvoices) {
            // جلب عناصر طلب الشحن مع بيانات المخزون
            const [items] = await pool.query(`
                SELECT ii.quantity, inv.net_weight_total, inv.base_quantity
                FROM invoice_items ii
                JOIN inventory inv ON ii.inventory_id = inv.id
                WHERE ii.invoice_id = ?
            `, [invoice.id]);
            
            // إعادة حساب الوزن الإجمالي
            let recalculatedWeight = 0;
            items.forEach(item => {
                const quantity = Number(item.quantity) || 0;
                const netWeightTotal = Number(item.net_weight_total) || 0;
                const baseQuantity = Number(item.base_quantity) || 1;
                const weight = (netWeightTotal / baseQuantity) * quantity;
                recalculatedWeight += weight;
            });
            
            // تحديث الوزن في الكائن
            invoice.total_quantity_liters = roundTo3(recalculatedWeight);
        }
        
        res.render('invoices/deleted', { deletedInvoices, user: req.session.user });
    } catch (error) {
        console.error('Error fetching deleted invoices:', error);
        res.status(500).render('error', { message: 'حدث خطأ أثناء جلب طلبات  الشحن المحذوفة', error });
    }
};

// استعادة طلبية شحن واحدة
exports.restoreInvoice = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        // تعيين timeout للمعاملات
        await connection.query('SET SESSION innodb_lock_wait_timeout = 60');
        await connection.query('SET SESSION lock_wait_timeout = 60');
        
        await connection.beginTransaction();
        
        const { id } = req.params;
        
        // التحقق من وجود طلب الشحن المحذوفة
        const [invoice] = await connection.query(
            'SELECT * FROM invoices WHERE id = ? AND deleted_at IS NOT NULL', 
            [id]
        );
        
        if (!invoice || invoice.length === 0) {
            return res.status(404).json({ 
                success: false, 
                message: 'طلب الشحن غير موجودة أو غير محذوفة' 
            });
        }

        // جلب عناصر طلب الشحن
        const [items] = await connection.query(
            'SELECT inventory_id, quantity FROM invoice_items WHERE invoice_id = ?', 
            [id]
        );

        // التحقق من توفر الكميات في المخزون
        for (const item of items) {
            // التحقق من وجود العينة في المخزون (غير محذوفة ناعماً)
            const [inventory] = await connection.query(
                'SELECT id, current_quantity, sample_number FROM inventory WHERE id = ? AND deleted_at IS NULL', 
                [item.inventory_id]
            );
            
            if (inventory && inventory.length > 0) {
                const inventoryItem = inventory[0];
                const requestedQuantity = parseFloat(item.quantity);
                const availableQuantity = parseFloat(inventoryItem.current_quantity);

                // التحقق من توفر الكمية المطلوبة
                if (requestedQuantity > availableQuantity) {
                    // هنا فقط إذا الطلب أكبر من المتوفر
                    return res.status(400).json({
                      success: false,
                      message: `لا يمكن استعادة طلب الشحن رقم ${invoice[0].invoice_number}: 
                        الكمية المتوفرة من العينة ${inventoryItem.sample_number} (${availableQuantity.toFixed(2)}) 
                        أقل من الكمية المطلوبة (${requestedQuantity.toFixed(2)})`
                    });
                  }
                  
                
                // خصم الكمية من المخزون
                await connection.query(
                    'UPDATE inventory SET current_quantity = current_quantity - ? WHERE id = ?', 
                    [item.quantity, item.inventory_id]
                );
            }
            // إذا لم توجد العينة (محذوفة ناعماً)، نتجاهل تحديث المخزون
        }

        // إزالة deleted_at من طلب الشحن
        await connection.query('UPDATE invoices SET deleted_at = NULL WHERE id = ?', [id]);
        
        await connection.commit();
        res.json({ success: true, message: 'تم استعادة طلب الشحن بنجاح' });
    } catch (error) {
        try {
            await connection.rollback();
        } catch (rollbackError) {
            console.error('Error during rollback:', rollbackError);
        }
        
        console.error('Error restoring invoice:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء استعادة طلب الشحن' });
    } finally {
        // ضمان إغلاق الاتصال
        try {
            connection.release();
        } catch (releaseError) {
            console.error('Error releasing connection:', releaseError);
        }
    }
};

// استعادة عدة فواتير
exports.restoreMultiple = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        // تعيين timeout للمعاملات
        await connection.query('SET SESSION innodb_lock_wait_timeout = 60');
        await connection.query('SET SESSION lock_wait_timeout = 60');
        
        await connection.beginTransaction();
        
        const { ids } = req.body;
        if (!ids || !Array.isArray(ids) || ids.length === 0) {
            return res.status(400).json({ success: false, message: 'يرجى اختيار طلبية شحن واحدة على الأقل' });
        }

        // التحقق من وجود طلبات  الشحن المحذوفة
        const [invoices] = await connection.query(
            'SELECT id, invoice_number FROM invoices WHERE id IN (?) AND deleted_at IS NOT NULL', 
            [ids]
        );
        
        if (invoices.length === 0) {
            return res.status(404).json({ 
                success: false, 
                message: 'لا توجد فواتير محذوفة للاستعادة' 
            });
        }

        // التحقق من توفر الكميات في المخزون لجميع طلبات  الشحن
        for (const invoice of invoices) {
            // جلب عناصر طلب الشحن
            const [items] = await connection.query(
                'SELECT inventory_id, quantity FROM invoice_items WHERE invoice_id = ?', 
                [invoice.id]
            );

            for (const item of items) {
                // التحقق من وجود العينة في المخزون (غير محذوفة ناعماً)
                const [inventory] = await connection.query(
                    'SELECT id, current_quantity, sample_number FROM inventory WHERE id = ? AND deleted_at IS NULL', 
                    [item.inventory_id]
                );
                
                if (inventory && inventory.length > 0) {
                    const inventoryItem = inventory[0];
                    
                    // التحقق من توفر الكمية المطلوبة
                    if (inventoryItem.current_quantity < item.quantity) {
                        await connection.rollback();
                        return res.status(400).json({
                            success: false,
                            message: `لا يمكن استعادة طلب الشحن رقم ${invoice.invoice_number}: الكمية المتوفرة من العينة ${inventoryItem.sample_number} (${inventoryItem.current_quantity}) أقل من الكمية المطلوبة (${item.quantity})`
                        });
                    }
                }
                // إذا لم توجد العينة (محذوفة ناعماً)، نتجاهل التحقق
            }
        }

        // إذا وصلنا هنا، جميع الكميات متوفرة - نقوم بالخصم والاستعادة
        for (const invoice of invoices) {
            // جلب عناصر طلب الشحن مرة أخرى للخصم
            const [items] = await connection.query(
                'SELECT inventory_id, quantity FROM invoice_items WHERE invoice_id = ?', 
                [invoice.id]
            );

            for (const item of items) {
                // التحقق من وجود العينة في المخزون (غير محذوفة ناعماً)
                const [inventory] = await connection.query(
                    'SELECT id FROM inventory WHERE id = ?', 
                    [item.inventory_id]
                );
                
                if (inventory && inventory.length > 0) {
                    // خصم الكمية من المخزون
                    await connection.query(
                        'UPDATE inventory SET current_quantity = current_quantity - ? WHERE id = ?', 
                        [item.quantity, item.inventory_id]
                    );
                }
                // إذا لم توجد العينة (محذوفة ناعماً)، نتجاهل تحديث المخزون
            }

            // إزالة deleted_at من طلب الشحن
            await connection.query('UPDATE invoices SET deleted_at = NULL WHERE id = ?', [invoice.id]);
        }
        
        await connection.commit();
        res.json({ success: true, message: 'تم استعادة طلبات  الشحن بنجاح' });
    } catch (error) {
        try {
            await connection.rollback();
        } catch (rollbackError) {
            console.error('Error during rollback:', rollbackError);
        }
        
        console.error('Error restoring invoices:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء استعادة طلبات  الشحن' });
    } finally {
        // ضمان إغلاق الاتصال
        try {
            connection.release();
        } catch (releaseError) {
            console.error('Error releasing connection:', releaseError);
        }
    }
};

// تفريغ سلة المحذوفات (حذف نهائي مع تعديل المخزون)
exports.emptyTrash = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        // تعيين timeout للمعاملات
        await connection.query('SET SESSION innodb_lock_wait_timeout = 60');
        await connection.query('SET SESSION lock_wait_timeout = 60');
        
        await connection.beginTransaction();
        
        // جلب كل طلبات  الشحن المحذوفة
        const [invoices] = await connection.query('SELECT id FROM invoices WHERE deleted_at IS NOT NULL');
        let totalProcessed = 0;
        
        // الكميات قد عادت بالفعل للمخزون عند نقل طلبات  الشحن إلى سلة المحذوفات
        // لذلك لا نحتاج لإعادتها مرة ثانية هنا
        
        totalProcessed = invoices.length;
        
        // حذف عناصر طلبات  الشحن المحذوفة أولاً (العلاقة الفرعية)
        await connection.query('DELETE FROM invoice_items WHERE invoice_id IN (SELECT id FROM invoices WHERE deleted_at IS NOT NULL)');
        
        // ثم حذف طلبات  الشحن المحذوفة نهائياً
        await connection.query('DELETE FROM invoices WHERE deleted_at IS NOT NULL');
        
        await connection.commit();
        res.json({ success: true, message: `تم تفريغ سلة المحذوفات (${totalProcessed} طلبية شحن)` });
    } catch (error) {
        try {
            await connection.rollback();
        } catch (rollbackError) {
            console.error('Error during rollback:', rollbackError);
        }
        
        console.error('Error emptying trash:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء تفريغ سلة المحذوفات' });
    } finally {
        // ضمان إغلاق الاتصال
        try {
            connection.release();
        } catch (releaseError) {
            console.error('Error releasing connection:', releaseError);
        }
    }
};

// حذف جماعي نهائي للفواتير
exports.deleteMultiple = async (req, res) => {
    const connection = await pool.getConnection();
    try {
        // تعيين timeout للمعاملات
        await connection.query('SET SESSION innodb_lock_wait_timeout = 60');
        await connection.query('SET SESSION lock_wait_timeout = 60');
        
        await connection.beginTransaction();
        
        const { ids } = req.body;
        if (!ids || !Array.isArray(ids) || ids.length === 0) {
            return res.status(400).json({ success: false, message: 'يرجى اختيار طلبية شحن واحدة على الأقل' });
        }

        // إرجاع كميات العينات إلى المخزون قبل الحذف النهائي
        for (const invoiceId of ids) {
            // جلب عناصر طلب الشحن
            const [items] = await connection.query(
                'SELECT inventory_id, quantity FROM invoice_items WHERE invoice_id = ?', 
                [invoiceId]
            );
            
            for (const item of items) {
                // التحقق من وجود العينة في المخزون (غير محذوفة ناعماً)
                const [inventory] = await connection.query(
                    'SELECT id FROM inventory WHERE id = ?', 
                    [item.inventory_id]
                );
                
                if (inventory && inventory.length > 0) {
                    // إرجاع الكمية إلى المخزون
                    await connection.query(
                        'UPDATE inventory SET current_quantity = current_quantity + ? WHERE id = ?', 
                        [item.quantity, item.inventory_id]
                    );
                }
                // إذا لم توجد العينة (محذوفة ناعماً)، نتجاهلها بهدوء
            }
        }

        // حذف عناصر طلبات  الشحن أولاً (العلاقة الفرعية)
        await connection.query('DELETE FROM invoice_items WHERE invoice_id IN (?)', [ids]);
        
        // ثم حذف طلبات  الشحن نهائياً
        await connection.query('DELETE FROM invoices WHERE id IN (?)', [ids]);
        
        await connection.commit();
        res.json({ success: true, message: 'تم حذف طلبات  الشحن المحددة نهائياً' });
    } catch (error) {
        try {
            await connection.rollback();
        } catch (rollbackError) {
            console.error('Error during rollback:', rollbackError);
        }
        
        console.error('Error deleting invoices:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء الحذف النهائي للفواتير' });
    } finally {
        // ضمان إغلاق الاتصال
        try {
            connection.release();
        } catch (releaseError) {
            console.error('Error releasing connection:', releaseError);
        }
    }
};

module.exports = exports; 
