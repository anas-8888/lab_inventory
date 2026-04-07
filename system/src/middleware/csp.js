// Middleware لمعالجة مشاكل Content Security Policy
const cspMiddleware = (req, res, next) => {
    // إضافة headers إضافية للأمان
    res.setHeader('X-Frame-Options', 'SAMEORIGIN');
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    
    // إضافة header للسماح بالنوافذ المنبثقة إذا لزم الأمر
    if (req.path.includes('/print') || req.path.includes('/export')) {
        res.setHeader('X-Frame-Options', 'ALLOWALL');
    }
    
    next();
};

// Middleware لمعالجة الأخطاء المتعلقة بـ CSP
const cspErrorHandler = (err, req, res, next) => {
    if (err.message && err.message.includes('Content Security Policy')) {
        console.warn('CSP Error:', err.message);
        // يمكن إضافة منطق إضافي هنا لمعالجة أخطاء CSP
    }
    next(err);
};

module.exports = {
    cspMiddleware,
    cspErrorHandler
};
