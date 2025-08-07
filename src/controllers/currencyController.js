const { pool } = require('../database/db');

// عرض صفحة إدارة العملات
const getCurrencySettings = async (req, res) => {
    try {
        const [currencies] = await req.db.query(`
            SELECT * FROM currencies ORDER BY is_default DESC, name
        `);
        
        const [exchangeRates] = await req.db.query(`
            SELECT er.*, 
                   fc.code as from_currency_code, fc.name as from_currency_name, fc.symbol as from_currency_symbol,
                   tc.code as to_currency_code, tc.name as to_currency_name, tc.symbol as to_currency_symbol
            FROM exchange_rates er
            JOIN currencies fc ON er.from_currency_id = fc.id
            JOIN currencies tc ON er.to_currency_id = tc.id
            ORDER BY er.created_at DESC
        `);
        
        const [defaultCurrency] = await req.db.query(`
            SELECT setting_value FROM system_settings WHERE setting_key = 'default_currency'
        `);
        
        res.render('costs/currency-settings', {
            title: 'إعدادات العملة',
            currencies,
            exchangeRates,
            defaultCurrency: defaultCurrency.length > 0 ? defaultCurrency[0].setting_value : 'USD',
            formatDate
        });
    } catch (error) {
        console.error('خطأ في عرض إعدادات العملة:', error);
        req.flash('error_msg', 'حدث خطأ في عرض إعدادات العملة');
        res.redirect('/costs');
    }
};

// تحديث العملة الافتراضية
const updateDefaultCurrency = async (req, res) => {
    try {
        const { currency_code } = req.body;
        
        await req.db.query(`
            INSERT INTO system_settings (setting_key, setting_value) 
            VALUES ('default_currency', ?) 
            ON DUPLICATE KEY UPDATE setting_value = ?
        `, [currency_code, currency_code]);
        
        res.json({ success: true, message: 'تم تحديث العملة الافتراضية بنجاح' });
    } catch (error) {
        console.error('خطأ في تحديث العملة الافتراضية:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في تحديث العملة الافتراضية' });
    }
};

// تحديث سعر الصرف
const updateExchangeRate = async (req, res) => {
    try {
        const { from_currency_id, to_currency_id, rate } = req.body;
        
        await req.db.query(`
            INSERT INTO exchange_rates (from_currency_id, to_currency_id, rate) 
            VALUES (?, ?, ?) 
            ON DUPLICATE KEY UPDATE rate = ?
        `, [from_currency_id, to_currency_id, rate, rate]);
        
        res.json({ success: true, message: 'تم تحديث سعر الصرف بنجاح' });
    } catch (error) {
        console.error('خطأ في تحديث سعر الصرف:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في تحديث سعر الصرف' });
    }
};

// جلب العملة الافتراضية
const getDefaultCurrency = async (req, res) => {
    try {
        const [settings] = await req.db.query(`
            SELECT setting_value FROM system_settings WHERE setting_key = 'default_currency'
        `);
        
        const defaultCurrency = settings.length > 0 ? settings[0].setting_value : 'USD';
        
        const [currencies] = await req.db.query(`
            SELECT * FROM currencies WHERE code = ?
        `, [defaultCurrency]);
        
        if (currencies.length === 0) {
            return res.json({ success: false, message: 'العملة الافتراضية غير موجودة' });
        }
        
        res.json({ success: true, currency: currencies[0] });
    } catch (error) {
        console.error('خطأ في جلب العملة الافتراضية:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في جلب العملة الافتراضية' });
    }
};

// تحويل العملة
const convertCurrency = async (req, res) => {
    try {
        const { amount, from_currency_id, to_currency_id } = req.body;
        
        if (from_currency_id === to_currency_id) {
            return res.json({ success: true, converted_amount: amount });
        }
        
        const [rates] = await req.db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = ? AND to_currency_id = ?
        `, [from_currency_id, to_currency_id]);
        
        if (rates.length === 0) {
            return res.status(404).json({ success: false, message: 'سعر الصرف غير موجود' });
        }
        
        const convertedAmount = parseFloat(amount) * parseFloat(rates[0].rate);
        
        res.json({ success: true, converted_amount: convertedAmount });
    } catch (error) {
        console.error('خطأ في تحويل العملة:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ في تحويل العملة' });
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

module.exports = {
    getCurrencySettings,
    updateDefaultCurrency,
    updateExchangeRate,
    getDefaultCurrency,
    convertCurrency,
    formatDate
};
