// أدوات التشخيص للمشاكل في الاستضافة
const fs = require('fs');
const path = require('path');

// دالة لتسجيل الأخطاء
const logError = (error, context = '') => {
    const timestamp = new Date().toISOString();
    const logEntry = {
        timestamp,
        context,
        error: {
            message: error.message,
            stack: error.stack,
            code: error.code,
            errno: error.errno,
            sqlMessage: error.sqlMessage,
            sqlState: error.sqlState
        }
    };

    const logDir = path.join(__dirname, '../../logs');
    if (!fs.existsSync(logDir)) {
        fs.mkdirSync(logDir, { recursive: true });
    }

    const logFile = path.join(logDir, 'errors.log');
    fs.appendFileSync(logFile, JSON.stringify(logEntry, null, 2) + '\n---\n');
    
    console.error(`[${timestamp}] Error in ${context}:`, error);
};

// دالة لمراقبة أداء الطلبات
const logRequest = (req, res, next) => {
    const start = Date.now();
    const originalSend = res.send;
    
    res.send = function(data) {
        const duration = Date.now() - start;
        const logEntry = {
            timestamp: new Date().toISOString(),
            method: req.method,
            url: req.url,
            statusCode: res.statusCode,
            duration: `${duration}ms`,
            userAgent: req.get('User-Agent'),
            ip: req.ip,
            bodySize: JSON.stringify(req.body).length
        };

        const logDir = path.join(__dirname, '../../logs');
        if (!fs.existsSync(logDir)) {
            fs.mkdirSync(logDir, { recursive: true });
        }

        const logFile = path.join(logDir, 'requests.log');
        fs.appendFileSync(logFile, JSON.stringify(logEntry, null, 2) + '\n---\n');
        
        originalSend.call(this, data);
    };
    
    next();
};

// دالة لفحص صحة البيانات
const validateData = (data, schema) => {
    const errors = [];
    
    for (const [field, rules] of Object.entries(schema)) {
        const value = data[field];
        
        if (rules.required && (value === undefined || value === null || value === '')) {
            errors.push(`${field} is required`);
            continue;
        }
        
        if (value !== undefined && value !== null && value !== '') {
            if (rules.type === 'number') {
                const num = parseFloat(value);
                if (isNaN(num)) {
                    errors.push(`${field} must be a valid number`);
                } else if (rules.min !== undefined && num < rules.min) {
                    errors.push(`${field} must be at least ${rules.min}`);
                } else if (rules.max !== undefined && num > rules.max) {
                    errors.push(`${field} must be at most ${rules.max}`);
                }
            } else if (rules.type === 'integer') {
                const num = parseInt(value);
                if (isNaN(num)) {
                    errors.push(`${field} must be a valid integer`);
                } else if (rules.min !== undefined && num < rules.min) {
                    errors.push(`${field} must be at least ${rules.min}`);
                } else if (rules.max !== undefined && num > rules.max) {
                    errors.push(`${field} must be at most ${rules.max}`);
                }
            } else if (rules.type === 'string') {
                if (typeof value !== 'string') {
                    errors.push(`${field} must be a string`);
                } else if (rules.minLength !== undefined && value.length < rules.minLength) {
                    errors.push(`${field} must be at least ${rules.minLength} characters`);
                } else if (rules.maxLength !== undefined && value.length > rules.maxLength) {
                    errors.push(`${field} must be at most ${rules.maxLength} characters`);
                }
            }
        }
    }
    
    return errors;
};

// مخطط التحقق من بيانات المادة
const materialSchema = {
    material_type: { type: 'string', required: true, maxLength: 100 },
    material_name: { type: 'string', required: true, maxLength: 255 },
    price_before_waste: { type: 'number', required: true, min: 0, max: 999999999 },
    gross_weight: { type: 'number', required: true, min: 0, max: 999999999 },
    waste_percentage: { type: 'number', required: true, min: 0, max: 100 },
    packaging_unit: { type: 'string', required: true, maxLength: 50 },
    packaging_weight: { type: 'number', required: true, min: 0, max: 999999999 },
    packaging_unit_weight: { type: 'number', min: 0, max: 999999999 },
    empty_package_price: { type: 'number', min: 0, max: 999999999 },
    sticker_price: { type: 'number', min: 0, max: 999999999 },
    additional_expenses: { type: 'number', min: 0, max: 999999999 },
    labor_cost: { type: 'number', min: 0, max: 999999999 },
    preservatives_cost: { type: 'number', min: 0, max: 999999999 },
    carton_price: { type: 'number', min: 0, max: 999999999 },
    pieces_per_package: { type: 'integer', min: 1, max: 999999 },
    pallet_price: { type: 'number', min: 0, max: 999999999 },
    packages_per_pallet: { type: 'integer', min: 1, max: 999999 }
};

module.exports = {
    logError,
    logRequest,
    validateData,
    materialSchema
};
