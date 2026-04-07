const { pool } = require('../database/db');

// دالة جلب العملة الافتراضية
const getDefaultCurrency = async (db) => {
    try {
        const [settings] = await db.query(`
            SELECT setting_value FROM system_settings WHERE setting_key = 'default_currency'
        `);
        
        const defaultCurrency = settings.length > 0 ? settings[0].setting_value : 'USD';
        
        const [currencies] = await db.query(`
            SELECT * FROM currencies WHERE code = ?
        `, [defaultCurrency]);
        
        return currencies.length > 0 ? currencies[0] : null;
    } catch (error) {
        console.error('خطأ في جلب العملة الافتراضية:', error);
        return null;
    }
};

// دالة تحويل العملة
const convertCurrency = async (db, amount, fromCurrencyId, toCurrencyId) => {
    try {
        if (fromCurrencyId === toCurrencyId) {
            return parseFloat(amount);
        }
        
        const [rates] = await db.query(`
            SELECT rate FROM exchange_rates 
            WHERE from_currency_id = ? AND to_currency_id = ?
        `, [fromCurrencyId, toCurrencyId]);
        
        if (rates.length === 0) {
            return parseFloat(amount);
        }
        
        return parseFloat(amount) * parseFloat(rates[0].rate);
    } catch (error) {
        console.error('خطأ في تحويل العملة:', error);
        return parseFloat(amount);
    }
};

// دالة تحويل المبلغ للعرض (من USD إلى العملة المحددة)
const convertAmountForDisplay = async (db, amount, defaultCurrency) => {
    try {
        if (!defaultCurrency || defaultCurrency.code === 'USD') {
            return parseFloat(amount);
        }
        
        // البحث عن معرف عملة USD
        const [usdCurrency] = await db.query(`SELECT id FROM currencies WHERE code = 'USD'`);
        if (usdCurrency.length === 0) {
            return parseFloat(amount);
        }
        
        // البحث عن معرف العملة الافتراضية
        const [targetCurrency] = await db.query(`SELECT id FROM currencies WHERE code = ?`, [defaultCurrency.code]);
        if (targetCurrency.length === 0) {
            return parseFloat(amount);
        }
        
        // تحويل من USD إلى العملة المحددة
        return await convertCurrency(db, amount, usdCurrency[0].id, targetCurrency[0].id);
    } catch (error) {
        console.error('خطأ في تحويل المبلغ للعرض:', error);
        return parseFloat(amount);
    }
};

// دالة تنسيق المبلغ مع العملة
const formatAmount = (amount, currencySymbol = '$') => {
    const numAmount = parseFloat(amount) || 0;
    return `${numAmount.toFixed(2)} ${currencySymbol}`;
};

// دالة تنسيق المبلغ المحول للعرض
const formatConvertedAmount = async (db, amount, defaultCurrency) => {
    try {
        const convertedAmount = await convertAmountForDisplay(db, amount, defaultCurrency);
        const symbol = defaultCurrency ? defaultCurrency.symbol : '$';
        return formatAmount(convertedAmount, symbol);
    } catch (error) {
        console.error('خطأ في تنسيق المبلغ المحول:', error);
        return formatAmount(amount, defaultCurrency ? defaultCurrency.symbol : '$');
    }
};

// middleware لإضافة العملة للـ request
const addCurrencyToRequest = async (req, res, next) => {
    try {
        // استخدام اتصال الطلب إذا كان متاحاً، وإلا استخدم الـ pool مباشرةً للمسارات التي لا تفتح اتصالاً
        const dbConn = req.db || pool;
        const defaultCurrency = await getDefaultCurrency(dbConn);
        req.defaultCurrency = defaultCurrency;
        res.locals.defaultCurrency = defaultCurrency;
        
        // إضافة دوال التحويل للـ res.locals
        res.locals.convertAmountForDisplay = (amount) => convertAmountForDisplay(dbConn, amount, defaultCurrency);
        res.locals.formatConvertedAmount = (amount) => formatConvertedAmount(dbConn, amount, defaultCurrency);
        
        next();
    } catch (error) {
        console.error('خطأ في إضافة العملة للطلب:', error);
        next();
    }
};

module.exports = {
    getDefaultCurrency,
    convertCurrency,
    convertAmountForDisplay,
    formatAmount,
    formatConvertedAmount,
    addCurrencyToRequest
};
