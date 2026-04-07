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
    
    console.error(`[${timestamp}] Error in ${context}:`, error.message);
};

// دالة لتسجيل الطلبات الكبيرة
const logLargeRequest = (req, context = '') => {
    const timestamp = new Date().toISOString();
    const requestSize = JSON.stringify(req.body).length;
    
    if (requestSize > 10000) { // تسجيل الطلبات الأكبر من 10KB
        const logEntry = {
            timestamp,
            context,
            method: req.method,
            url: req.url,
            requestSize: `${requestSize} bytes`,
            body: req.body
        };

        const logDir = path.join(__dirname, '../../logs');
        if (!fs.existsSync(logDir)) {
            fs.mkdirSync(logDir, { recursive: true });
        }

        const logFile = path.join(logDir, 'large_requests.log');
        fs.appendFileSync(logFile, JSON.stringify(logEntry, null, 2) + '\n---\n');
        
        console.warn(`[${timestamp}] Large request in ${context}: ${requestSize} bytes`);
    }
};

// دالة لفحص الأرقام الكبيرة
const checkLargeNumbers = (data) => {
    const largeNumbers = [];
    
    const checkValue = (value, path = '') => {
        if (typeof value === 'number') {
            if (value > 999999999) { // أكبر من 999,999,999
                largeNumbers.push({
                    path: path || 'root',
                    value: value,
                    type: 'very_large_number'
                });
            } else if (value > 99999999) { // أكبر من 99,999,999
                largeNumbers.push({
                    path: path || 'root',
                    value: value,
                    type: 'large_number'
                });
            }
        } else if (typeof value === 'string') {
            const numValue = parseFloat(value);
            if (!isNaN(numValue)) {
                checkValue(numValue, path);
            }
        } else if (Array.isArray(value)) {
            value.forEach((item, index) => {
                checkValue(item, `${path}[${index}]`);
            });
        } else if (typeof value === 'object' && value !== null) {
            Object.keys(value).forEach(key => {
                checkValue(value[key], path ? `${path}.${key}` : key);
            });
        }
    };
    
    checkValue(data);
    return largeNumbers;
};

// دالة لفحص قاعدة البيانات
const checkDatabaseConnection = async (db) => {
    try {
        const [result] = await db.query('SELECT 1 as test');
        return { success: true, message: 'Database connection OK' };
    } catch (error) {
        logError(error, 'Database Connection Check');
        return { success: false, message: error.message };
    }
};

// دالة لفحص إعدادات MySQL
const checkMySQLSettings = async (db) => {
    try {
        const [maxPacket] = await db.query("SHOW VARIABLES LIKE 'max_allowed_packet'");
        const [netBuffer] = await db.query("SHOW VARIABLES LIKE 'net_buffer_length'");
        const [maxConnections] = await db.query("SHOW VARIABLES LIKE 'max_connections'");
        
        return {
            success: true,
            settings: {
                max_allowed_packet: maxPacket[0]?.Value,
                net_buffer_length: netBuffer[0]?.Value,
                max_connections: maxConnections[0]?.Value
            }
        };
    } catch (error) {
        logError(error, 'MySQL Settings Check');
        return { success: false, message: error.message };
    }
};

// دالة لفحص حجم الجداول
const checkTableSizes = async (db) => {
    try {
        const [tables] = await db.query(`
            SELECT 
                table_name,
                ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)',
                table_rows
            FROM information_schema.tables 
            WHERE table_schema = DATABASE()
            ORDER BY (data_length + index_length) DESC
        `);
        
        return { success: true, tables };
    } catch (error) {
        logError(error, 'Table Sizes Check');
        return { success: false, message: error.message };
    }
};

// دالة لفحص الأداء
const checkPerformance = async (db) => {
    const startTime = Date.now();
    
    try {
        // فحص سرعة استعلام بسيط
        const [result] = await db.query('SELECT COUNT(*) as count FROM materials');
        const queryTime = Date.now() - startTime;
        
        return {
            success: true,
            queryTime: `${queryTime}ms`,
            materialsCount: result[0]?.count || 0
        };
    } catch (error) {
        logError(error, 'Performance Check');
        return { success: false, message: error.message };
    }
};

// دالة تشخيص شاملة
const runDiagnostics = async (req, db) => {
    const diagnostics = {
        timestamp: new Date().toISOString(),
        request: {
            method: req.method,
            url: req.url,
            bodySize: JSON.stringify(req.body).length
        },
        database: {},
        performance: {},
        largeNumbers: []
    };
    
    // فحص قاعدة البيانات
    diagnostics.database.connection = await checkDatabaseConnection(db);
    diagnostics.database.settings = await checkMySQLSettings(db);
    diagnostics.database.tableSizes = await checkTableSizes(db);
    
    // فحص الأداء
    diagnostics.performance = await checkPerformance(db);
    
    // فحص الأرقام الكبيرة
    diagnostics.largeNumbers = checkLargeNumbers(req.body);
    
    // تسجيل التشخيص
    const logDir = path.join(__dirname, '../../logs');
    if (!fs.existsSync(logDir)) {
        fs.mkdirSync(logDir, { recursive: true });
    }
    
    const logFile = path.join(logDir, 'diagnostics.log');
    fs.appendFileSync(logFile, JSON.stringify(diagnostics, null, 2) + '\n---\n');
    
    return diagnostics;
};

module.exports = {
    logError,
    logLargeRequest,
    checkLargeNumbers,
    checkDatabaseConnection,
    checkMySQLSettings,
    checkTableSizes,
    checkPerformance,
    runDiagnostics
};
