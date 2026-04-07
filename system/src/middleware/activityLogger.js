/**
 * Activity Logger Middleware
 * يقوم بتسجيل جميع الطلبات في جدول activity_logs مع الاحتفاظ بآخر 500 سجل فقط
 */

const { getActionName } = require('../utils/actionDictionary');
const { pool } = require('../database/db');

/**
 * قائمة المسارات المستثناة من التسجيل
 */
const excludedPaths = [
    '/public/',
    '/css/',
    '/js/',
    '/images/',
    '/favicon.ico',
    '/socket.io/',
    '/activity-logs', // استثناء صفحة سجل الحركات نفسها
    '/activity-logs/' // استثناء جميع مسارات سجل الحركات الفرعية
];

/**
 * يتحقق من كون المسار مستثنى من التسجيل
 */
function isExcludedPath(path) {
    return excludedPaths.some(excluded => {
        if (excluded.endsWith('/')) {
            return path.startsWith(excluded);
        } else {
            return path === excluded || path.startsWith(excluded + '/');
        }
    });
}

/**
 * ينشئ الجملة الوصفية للحركة
 */
function createDescriptiveText(actorName, actionName) {
    const now = new Date();
    const dateStr = now.toLocaleDateString('ar-EG', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
    const timeStr = now.toLocaleTimeString('ar-EG', {
        hour: '2-digit',
        minute: '2-digit'
    });
    
    return `${actorName} قام بـ ${actionName} في ${dateStr} عند ${timeStr}`;
}

/**
 * يحذف السجلات الزائدة للاحتفاظ بآخر 500 فقط
 */
async function maintainLogLimit(connection) {
    try {
        // عد السجلات الحالية
        const [countResult] = await connection.execute('SELECT COUNT(*) as total FROM activity_logs');
        const totalLogs = countResult[0].total;
        
        if (totalLogs > 500) {
            // حذف السجلات الأقدم - طريقة أبسط وأكثر أماناً
            const deleteCount = totalLogs - 500;
            await connection.execute(`
                DELETE FROM activity_logs 
                ORDER BY created_at ASC 
                LIMIT ?
            `, [deleteCount]);
        }
    } catch (error) {
        console.error('خطأ في صيانة حد سجل الحركات:', error);
    }
}

/**
 * يسجل الحركة في قاعدة البيانات
 */
async function logActivity(req, res, actionName, statusCode) {
    return await logActivityWithPath(req, res, actionName, statusCode, req.path, req.method);
}

/**
 * يسجل الحركة في قاعدة البيانات مع مسار وطريقة محددة
 */
async function logActivityWithPath(req, res, actionName, statusCode, path, method) {
    if (!req.activityContext) return;
    
    let connection;
    try {
        connection = await pool.getConnection();
        const { userId, userName, ipAddress, userAgent } = req.activityContext;
        
        // إدراج السجل الجديد
        await connection.execute(`
            INSERT INTO activity_logs (
                action_name, 
                actor_id, 
                actor_name_snapshot, 
                method, 
                path, 
                status_code, 
                ip_address, 
                user_agent,
                created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
        `, [
            actionName,
            userId,
            userName,
            method,
            path,
            statusCode,
            ipAddress,
            userAgent
        ]);
        
        // صيانة حد السجلات (الاحتفاظ بآخر 500)
        await maintainLogLimit(connection);
        
    } catch (error) {
        console.error('خطأ في تسجيل الحركة:', error);
        // إذا كان الخطأ بسبب عدم وجود الجدول، اعرض رسالة واضحة
        if (error.code === 'ER_NO_SUCH_TABLE') {
            console.error('⚠️  جدول activity_logs غير موجود! يرجى تنفيذ الـ SQL لإنشاء الجدول أولاً.');
        }
    } finally {
        if (connection) {
            connection.release();
        }
    }
}

/**
 * Activity Logger Middleware
 */
const activityLogger = (req, res, next) => {
    // تخطي إذا تم تعيين علم التجاهل
    if (req.skipActivityLog) {
        return next();
    }
    
    // تخطي المسارات المستثناة
    if (isExcludedPath(req.path)) {
        return next();
    }
    
    // تخطي طلبات الملفات الثابتة
    if (req.path.match(/\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$/)) {
        return next();
    }
    
    // حفظ المسار الأصلي للطلب (قبل أي إعادة توجيه)
    const originalPath = req.originalUrl || req.path;
    const originalMethod = req.method;
    
    // حفظ الدالة الأصلية للـ response
    const originalEnd = res.end;
    
    // تعديل دالة end لتسجيل الحركة عند انتهاء الاستجابة
    res.end = function(chunk, encoding) {
        // استدعاء الدالة الأصلية
        originalEnd.call(this, chunk, encoding);
        
        // تسجيل الحركة بشكل غير متزامن
        setImmediate(async () => {
            try {
                // تنظيف المسار الأصلي من query parameters
                const cleanPath = originalPath.split('?')[0];
                const actionName = getActionName(originalMethod, cleanPath);
                await logActivityWithPath(req, res, actionName, res.statusCode, cleanPath, originalMethod);
            } catch (error) {
                console.error('خطأ في تسجيل الحركة:', error);
            }
        });
    };
    
    next();
};

module.exports = activityLogger;
