const mysql = require('mysql2/promise');
const hostingConfig = require('../config/hosting');

// إنشاء pool للاتصال بقاعدة البيانات مع إعدادات محسنة للاستضافة
const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'lab_inventory',
    charset: 'utf8mb4',
    collation: 'utf8mb4_unicode_ci',
    
    // إعدادات محسنة للاستضافة
    acquireTimeout: hostingConfig.database.acquireTimeout,
    timeout: hostingConfig.database.timeout,
    connectionLimit: hostingConfig.database.connectionLimit,
    queueLimit: hostingConfig.database.queueLimit,
    
    // إعدادات إضافية للاستقرار
    acquireTimeoutMillis: hostingConfig.database.acquireTimeoutMillis,
    createTimeoutMillis: hostingConfig.database.createTimeoutMillis,
    destroyTimeoutMillis: hostingConfig.database.destroyTimeoutMillis,
    idleTimeoutMillis: hostingConfig.database.idleTimeoutMillis,
    reapIntervalMillis: hostingConfig.database.reapIntervalMillis,
    createRetryIntervalMillis: hostingConfig.database.createRetryIntervalMillis,
    
    // إعدادات إضافية للتعامل مع الأرقام الكبيرة
    supportBigNumbers: true,
    bigNumberStrings: true,
    decimalNumbers: true,
    
    // إعدادات إضافية للاستقرار
    multipleStatements: false,
    dateStrings: false,
    trace: false,
    
    // إعدادات إضافية للتعامل مع الأخطاء
    enableKeepAlive: true,
    keepAliveInitialDelay: 0
});

// اختبار الاتصال
pool.getConnection()
    .then(connection => {
        console.log('Database connected successfully');
        connection.release();
    })
    .catch(err => {
        console.error('Database connection failed:', err);
    });

// معالجة أخطاء الاتصال
pool.on('error', (err) => {
    console.error('Database pool error:', err);
    if (err.code === 'PROTOCOL_CONNECTION_LOST') {
        console.log('Database connection was closed.');
    }
    if (err.code === 'ER_CON_COUNT_ERROR') {
        console.log('Database has too many connections.');
    }
    if (err.code === 'ECONNREFUSED') {
        console.log('Database connection was refused.');
    }
});

// دالة مساعدة للتعامل مع الأرقام الكبيرة
const safeParseFloat = (value) => {
    if (value === null || value === undefined || value === '') {
        return 0;
    }
    const parsed = parseFloat(value);
    return isNaN(parsed) ? 0 : parsed;
};

// دالة مساعدة للتعامل مع الأرقام الصحيحة
const safeParseInt = (value) => {
    if (value === null || value === undefined || value === '') {
        return 0;
    }
    const parsed = parseInt(value);
    return isNaN(parsed) ? 0 : parsed;
};

module.exports = {
    pool,
    safeParseFloat,
    safeParseInt
}; 