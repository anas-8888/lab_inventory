/**
 * Context Extractor Middleware
 * يقوم باستخراج هوية المستخدم من الجلسة وإعداد البيانات اللازمة لتسجيل الحركات
 */

const contextExtractor = (req, res, next) => {
    // استخراج معلومات المستخدم من الجلسة
    let userId = null;
    let userName = 'النظام';
    
    if (req.session && req.session.user) {
        userId = req.session.user.id;
        userName = req.session.user.username || `المستخدم ${userId}`;
    }
    
    // إعداد سياق الطلب للاستخدام في middleware التسجيل
    req.activityContext = {
        userId: userId,
        userName: userName,
        ipAddress: req.ip || req.connection.remoteAddress || req.headers['x-forwarded-for'] || 'غير معروف',
        userAgent: req.get('User-Agent') || 'غير معروف'
    };
    
    next();
};

module.exports = contextExtractor;
