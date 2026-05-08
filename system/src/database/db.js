const mysql = require('mysql2/promise');
const hostingConfig = require('../config/hosting');
const SLOW_CONNECTION_ACQUIRE_MS = Number(process.env.DB_SLOW_ACQUIRE_MS || 2000);
const SLOW_QUERY_MS = Number(process.env.DB_SLOW_QUERY_MS || 1500);
const DB_QUEUE_LIMIT = Number(process.env.DB_QUEUE_LIMIT || hostingConfig.database.queueLimit || 0);
let activeConnections = 0;

// إنشاء pool للاتصال بقاعدة البيانات مع إعدادات محسنة للاستضافة
const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'lab_inventory',
    charset: 'utf8mb4',
    
    // إعدادات محسنة للاستضافة - MySQL2 valid options only
    waitForConnections: true,
    connectTimeout: hostingConfig.database.acquireTimeout,
    connectionLimit: hostingConfig.database.connectionLimit,
    queueLimit: DB_QUEUE_LIMIT,
    
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

// قياس زمن الحصول على اتصال وعدد الاتصالات النشطة
const originalGetConnection = pool.getConnection.bind(pool);
pool.getConnection = async (...args) => {
    const startedAt = Date.now();
    const connection = await originalGetConnection(...args);
    const waitedMs = Date.now() - startedAt;
    activeConnections += 1;

    if (waitedMs >= SLOW_CONNECTION_ACQUIRE_MS) {
        console.warn(
            `[DB] slow connection acquire: waited=${waitedMs}ms active=${activeConnections}`
        );
    }

    const originalRelease = connection.release.bind(connection);
    const originalConnectionQuery = connection.query.bind(connection);
    const originalConnectionExecute = connection.execute.bind(connection);
    connection.query = (...queryArgs) =>
        runWithSlowLog('connection.query', queryArgs[0], () => originalConnectionQuery(...queryArgs));
    connection.execute = (...executeArgs) =>
        runWithSlowLog('connection.execute', executeArgs[0], () => originalConnectionExecute(...executeArgs));

    let released = false;
    connection.release = () => {
        if (!released) {
            released = true;
            activeConnections = Math.max(0, activeConnections - 1);
        }
        return originalRelease();
    };

    return connection;
};

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

pool.on('enqueue', () => {
    console.warn('[DB] waiting for available connection (pool enqueue)');
});

if (DB_QUEUE_LIMIT === 0) {
    console.warn('[DB] queueLimit=0 (unbounded wait queue). Consider setting DB_QUEUE_LIMIT to prevent long hanging queues under load.');
}

function shortenSql(sql) {
    const text = typeof sql === 'string' ? sql : (sql && sql.sql) ? sql.sql : '';
    return text.replace(/\s+/g, ' ').trim().slice(0, 180);
}

async function runWithSlowLog(label, sql, run) {
    const startedAt = Date.now();
    try {
        return await run();
    } finally {
        const durationMs = Date.now() - startedAt;
        if (durationMs >= SLOW_QUERY_MS) {
            console.warn(`[DB] slow ${label}: ${durationMs}ms sql="${shortenSql(sql)}"`);
        }
    }
}

const originalPoolQuery = pool.query.bind(pool);
pool.query = (...args) => runWithSlowLog('pool.query', args[0], () => originalPoolQuery(...args));

const originalPoolExecute = pool.execute.bind(pool);
pool.execute = (...args) => runWithSlowLog('pool.execute', args[0], () => originalPoolExecute(...args));

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
