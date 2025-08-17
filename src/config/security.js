// إعدادات الأمان للنظام
const securityConfig = {
    // إعدادات Content Security Policy
    csp: {
        directives: {
            defaultSrc: ["'self'"],
            styleSrc: ["'self'", "'unsafe-inline'", "https:", "http:"],
            scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'", "https:", "http:"],
            scriptSrcAttr: ["'unsafe-inline'"], // السماح بـ inline event handlers
            imgSrc: ["'self'", "data:", "https:", "http:"],
            connectSrc: ["'self'", "https:", "http:"],
            fontSrc: ["'self'", "https:", "http:", "data:"],
            objectSrc: ["'self'"],
            mediaSrc: ["'self'"],
            frameSrc: ["'self'", "https:", "http:"],
            workerSrc: ["'self'", "blob:"],
            childSrc: ["'self'", "blob:"],
        },
    },
    
    // إعدادات الجلسة
    session: {
        secret: process.env.SESSION_SECRET || 'your-secret-key-here',
        resave: false,
        saveUninitialized: false,
        cookie: {
            secure: process.env.NODE_ENV === 'production',
            maxAge: 24 * 60 * 60 * 1000, // 24 ساعة
            httpOnly: true,
            sameSite: 'lax'
        }
    },
    
    // إعدادات Helmet
    helmet: {
        contentSecurityPolicy: true,
        crossOriginEmbedderPolicy: false,
        crossOriginOpenerPolicy: false,
        crossOriginResourcePolicy: false,
        dnsPrefetchControl: true,
        frameguard: true,
        hidePoweredBy: true,
        hsts: true,
        ieNoOpen: true,
        noSniff: true,
        permittedCrossDomainPolicies: true,
        referrerPolicy: true,
        xssFilter: true
    }
};

module.exports = securityConfig;
