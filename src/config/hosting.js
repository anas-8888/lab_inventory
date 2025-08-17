// تكوين خاص بالاستضافة لمعالجة المشاكل الشائعة
module.exports = {
    // إعدادات قاعدة البيانات للاستضافة
    database: {
        // زيادة مهلة الاتصال
        acquireTimeout: 60000,
        timeout: 60000,
        // إعدادات الاتصال المتعدد
        connectionLimit: 10,
        queueLimit: 0,
        // إعادة المحاولة عند فشل الاتصال
        acquireTimeoutMillis: 60000,
        createTimeoutMillis: 30000,
        destroyTimeoutMillis: 5000,
        idleTimeoutMillis: 30000,
        reapIntervalMillis: 1000,
        createRetryIntervalMillis: 200
    },
    
    // إعدادات الطلبات
    request: {
        // زيادة حد حجم الطلب
        jsonLimit: '50mb',
        urlencodedLimit: '50mb',
        // زيادة مهلة الطلب
        timeout: 30000,
        // إعدادات إضافية
        extended: true
    },
    
    // إعدادات الجلسة
    session: {
        // زيادة مهلة الجلسة
        maxAge: 24 * 60 * 60 * 1000, // 24 ساعة
        // إعدادات الأمان
        secure: true,
        httpOnly: true,
        sameSite: 'lax'
    },
    
    // إعدادات الأمان
    security: {
        // تعطيل بعض ميزات Helmet التي قد تسبب مشاكل
        contentSecurityPolicy: {
            directives: {
                defaultSrc: ["'self'"],
                styleSrc: ["'self'", "'unsafe-inline'", "https://cdn.jsdelivr.net"],
                scriptSrc: ["'self'", "'unsafe-inline'", "https://cdn.jsdelivr.net"],
                imgSrc: ["'self'", "data:", "https:"],
                connectSrc: ["'self'"],
                fontSrc: ["'self'", "https://cdn.jsdelivr.net"],
                objectSrc: ["'none'"],
                mediaSrc: ["'self'"],
                frameSrc: ["'self'"]
            }
        }
    }
};
