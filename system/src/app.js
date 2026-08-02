require('dotenv').config({ path: __dirname + '/.env' });
const express = require('express');
const session = require('express-session');
const MySQLStore = require('express-mysql-session')(session);
const path = require('path');
const flash = require('connect-flash');
const expressLayouts = require('express-ejs-layouts');
const helmet = require('helmet');
const methodOverride = require('method-override');
const multer = require('multer');
const cron = require('node-cron');
const http = require('http');
const { Server } = require('socket.io');
const { pool } = require('./database/db');
const { runMigrations } = require('./database/migrations');
const { authMiddleware } = require('./middleware/auth');
const { addCurrencyToRequest } = require('./middleware/currency');
const { trackUserActivity } = require('./middleware/presenceMiddleware');
const morgan = require('morgan');
const securityConfig = require('./config/security');
const os = require('os');

// إنشاء تطبيق Express وخادم HTTP
const app = express();
const server = http.createServer(app);
const REQUEST_TIMEOUT_MS = Number(process.env.REQUEST_TIMEOUT_MS || 180000);
const KEEP_ALIVE_TIMEOUT_MS = Number(process.env.KEEP_ALIVE_TIMEOUT_MS || 65000);
const HEADERS_TIMEOUT_MS = Number(process.env.HEADERS_TIMEOUT_MS || 66000);
const MEMORY_LOG_INTERVAL_MS = Number(process.env.MEMORY_LOG_INTERVAL_MS || 300000);
const ENABLE_MEMORY_LOG = process.env.ENABLE_MEMORY_LOG !== 'false';
const HEAVY_REQUEST_THRESHOLD_MS = Number(process.env.HEAVY_REQUEST_THRESHOLD_MS || 3000);
const DB_ACQUIRE_TIMEOUT_MS = Number(process.env.DB_ACQUIRE_TIMEOUT_MS || 15000);

// إعداد ترويسة الأمان باستخدام helmet
app.use(helmet(securityConfig.helmet));
app.use(helmet.contentSecurityPolicy(securityConfig.csp));

// إعداد الوسائط (middlewares) - يجب أن تكون بهذا الترتيب

// إضافة headers للسماح بالنوافذ المنبثقة
app.use((req, res, next) => {
    res.setHeader('X-Frame-Options', 'SAMEORIGIN');
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    // إزالة Permissions-Policy header الذي يسبب مشاكل
    next();
});

// CORS للمسارات العامة الخاصة بالموقع الخارجي (Landing Page)
function normalizeOrigin(origin) {
    if (!origin || typeof origin !== 'string') return '';
    return origin.trim().replace(/\/+$/, '');
}

function parseAllowedOrigins(rawValue) {
    if (!rawValue || typeof rawValue !== 'string') return [];
    return rawValue
        .split(',')
        .map((origin) => normalizeOrigin(origin))
        .filter(Boolean);
}

const publicSiteAllowedOrigins = (() => {
    const defaults = [
        'https://ajajbrothers.com',
        'https://www.ajajbrothers.com',
        'https://plus.ajajbrothers.com',
        'http://localhost:8081',
        'http://localhost:3000'
    ];

    const envList = parseAllowedOrigins(process.env.PUBLIC_SITE_ALLOWED_ORIGINS);
    const legacyList = parseAllowedOrigins(process.env.PUBLIC_SITE_ALLOWED_ORIGIN);

    // Merge env values with safe defaults (don't let misconfigured env break production CORS)
    return Array.from(new Set([...defaults, ...envList, ...legacyList]));
})();

function applyPublicSiteCors(req, res) {
    // Public landing-site APIs are intentionally open for read access
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

app.use((req, res, next) => {
    const isPublicSiteApi =
        req.path.startsWith('/site-management/public/') ||
        req.path.startsWith('/site-management/public-content') ||
        req.path.startsWith('/site-management/contact-messages');

    if (!isPublicSiteApi) return next();

    applyPublicSiteCors(req, res);
    if (req.method === 'OPTIONS') return res.sendStatus(204);
    return next();
});

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// إضافة method-override للتعامل مع PUT/DELETE requests
app.use(methodOverride('_method'));

// إعدادات القوالب
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(expressLayouts);
app.set('layout', 'layouts/main');
app.set("layout extractScripts", true);
app.set("layout extractStyles", true);

// إعداد الملفات الثابتة
app.use('/public', express.static(path.join(__dirname, 'public'), {
    maxAge: '1d',
    etag: false
}));

// إعداد الجلسة (Session)
const sessionStore = new MySQLStore({
    expiration: 24 * 60 * 60 * 1000, // 24 ساعة
    clearExpired: true,
    checkExpirationInterval: 15 * 60 * 1000,
    createDatabaseTable: true,
    schema: {
        tableName: 'sessions',
        columnNames: {
            session_id: 'session_id',
            expires: 'expires',
            data: 'data'
        }
    }
}, pool);

app.set('trust proxy', 1); // لإبلاغ Express بأن الاتصال آمن خلف بروكسي

app.use(session({
    secret: process.env.SESSION_SECRET || 'your-secret-key-here',
    resave: false,
    saveUninitialized: false,
    store: sessionStore,
    cookie: {
        secure: process.env.NODE_ENV === 'production',
        maxAge: 24 * 60 * 60 * 1000, // 24 ساعة
        httpOnly: true,
        sameSite: 'lax'
    }
}));

// إعداد رسائل الفلاش
app.use(flash());

// حارس timeout للطلبات الطويلة (مثل PDF) لتفادي التعليق غير المنتهي
app.use((req, res, next) => {
    req.setTimeout(REQUEST_TIMEOUT_MS);
    res.setTimeout(REQUEST_TIMEOUT_MS);
    next();
});

// تسجيل مدة الطلبات الثقيلة فقط (بدون إغراق اللوج)
app.use((req, res, next) => {
    const trackHeavy =
        req.path.includes('/pdf') ||
        req.path.includes('/print-pdf-raw') ||
        req.path.startsWith('/exports/');

    if (!trackHeavy) return next();

    const startedAt = Date.now();
    res.on('finish', () => {
        const durationMs = Date.now() - startedAt;
        if (durationMs >= HEAVY_REQUEST_THRESHOLD_MS) {
            console.log(
                `[REQ] ${req.method} ${req.originalUrl} status=${res.statusCode} duration=${durationMs}ms`
            );
        }
    });
    next();
});

// إضافة اتصال قاعدة البيانات إلى كل طلب
app.use(async (req, res, next) => {
    try {
        // تخطي فتح اتصال قاعدة البيانات للمسارات طويلة الأمد أو الملفات الثابتة
        if (
            req.path.startsWith('/socket.io') ||
            req.path.startsWith('/public') ||
            req.path.startsWith('/css') ||
            req.path.startsWith('/js') ||
            req.path.startsWith('/images') ||
            req.path === '/favicon.ico'
        ) {
            return next();
        }

        // افتح req.db فقط للمسارات التي تعتمد عليه فعليًا لتخفيف ضغط الاتصالات.
        const needsRequestConnection =
            req.path.startsWith('/costs') ||
            req.path.startsWith('/certificates') ||
            req.path.startsWith('/notes') ||
            req.path.startsWith('/site-management');

        if (!needsRequestConnection) {
            return next();
        }

        let timedOut = false;
        const acquirePromise = pool.getConnection();
        const timeoutPromise = new Promise((_, reject) => {
            const timer = setTimeout(() => {
                timedOut = true;
                reject(new Error(`DB acquire timeout after ${DB_ACQUIRE_TIMEOUT_MS}ms`));
            }, DB_ACQUIRE_TIMEOUT_MS);
            timer.unref?.();
        });

        const connection = await Promise.race([acquirePromise, timeoutPromise]);
        acquirePromise
            .then((lateConnection) => {
                if (timedOut) {
                    lateConnection.release();
                }
            })
            .catch(() => {});

        req.db = connection;

        let released = false;
        const release = () => {
            if (!released) {
                released = true;
                connection.release();
            }
        };

        res.on('finish', release);
        res.on('close', release);

        next();
    } catch (error) {
        console.error('[DB] request connection acquire failed:', error.message || error);
        next(error);
    }
});

// وسيط المصادقة
app.use((req, res, next) => {
    const publicPrefixes = [
        '/site-management/public/',
        '/site-management/public-content',
        '/site-management/contact-messages',
        '/inventory/print-pdf-raw',
        '/inventory/export/pdf',
        '/costs/cost-statement/print-list',
        '/costs/cost-statement/print-list-pdf-raw',
        '/costs/cost-statement/export/pdf',
    ];
    const isPublicCostStatementItemPrint =
        /^\/costs\/cost-statement\/\d+\/print$/.test(req.path) ||
        /^\/costs\/cost-statement\/\d+\/print-pdf-raw$/.test(req.path) ||
        /^\/costs\/cost-statement\/\d+\/pdf$/.test(req.path);

    if (publicPrefixes.some(path => req.path.startsWith(path)) || isPublicCostStatementItemPrint) {
        return next();
    }
    return authMiddleware(req, res, next);
});

// المتغيرات العامة للـ Views
app.use((req, res, next) => {
    res.locals.success_msg = req.flash('success_msg');
    res.locals.error_msg = req.flash('error_msg');
    res.locals.error = req.flash('error');
    res.locals.user = req.session.user || null;
    res.locals.session = req.session;
    res.locals.currentPath = req.path;
    res.locals.appName = 'نظام إدارة المختبر';
    res.locals.title = 'نظام إدارة المختبر'; // العنوان الافتراضي
    res.locals.baseUrl = process.env.BASE_URL || `${req.protocol}://${req.get('host')}`;
    next();
});

// إضافة العملة للطلبات
app.use(addCurrencyToRequest);

// تتبع نشاط المستخدمين
app.use(trackUserActivity);

// نظام سجل الحركات - يجب أن يكون قبل جميع المسارات
const contextExtractor = require('./middleware/contextExtractor');
const activityLogger = require('./middleware/activityLogger');

// استخراج سياق المستخدم
app.use(contextExtractor);

// تسجيل الحركات
app.use(activityLogger);

// تعطيل layout الافتراضي لمسار طباعة PDF المخزون فقط
app.use((req, res, next) => {
  if (req.path.startsWith('/inventory/print-pdf-raw')) {
    res.locals.layout = false;
  }
  if (
    req.path.startsWith('/costs/cost-statement/print-list-pdf-raw') ||
    /^\/costs\/cost-statement\/\d+\/print-pdf-raw$/.test(req.path)
  ) {
    res.locals.layout = false;
  }
  next();
});

// تعطيل تسجيل الحركات لمسارات معينة
app.use((req, res, next) => {
  if (req.path.startsWith('/activity-logs')) {
    req.skipActivityLog = true;
  }
  next();
});

// الصفحة الرئيسية: يدار عبر الراوتر الرئيسي

// المسارات
app.use('/', require('./routes/index'));
app.use('/auth', require('./routes/auth'));
app.use('/inventory', require('./routes/inventory'));
app.use('/invoices', require('./routes/invoices'));
app.use('/users', require('./routes/users'));
app.use('/certificates', require('./routes/certificates'));
app.use('/exports', require('./routes/exports'));
app.use('/costs', require('./routes/costs'));
app.use('/notes', require('./routes/notes'));
app.use('/activity-logs', require('./routes/activity'));
app.use('/site-management', require('./routes/siteManagement'));
app.use('/admin', require('./routes/admin'));

// معالجة خطأ 404
app.use((req, res, next) => {
    res.status(404).render('error', {
        title: 'خطأ 404',
        message: 'الصفحة غير موجودة',
        error: {}
    });
});

// معالجة الأخطاء العامة
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).render('error', {
        title: 'خطأ في الخادم',
        message: 'حدث خطأ في الخادم',
        error: process.env.NODE_ENV === 'development' ? err : {}
    });
});

// Cron Job لحذف السجلات المحذوفة ناعماً (كل يوم عند منتصف الليل)
cron.schedule('0 0 * * *', async () => {
    let conn;
    try {        
        conn = await pool.getConnection();
        // حذف السجلات المحذوفة ناعماً التي يزيد عمرها عن شهر واحد
        await conn.query(`
            DELETE FROM certificates WHERE deleted_at < NOW() - INTERVAL 1 MONTH
        `);
        
        await conn.query(`
            DELETE i
            FROM inventory i
            WHERE i.deleted_at < NOW() - INTERVAL 1 MONTH
              AND NOT EXISTS (
                SELECT 1
                FROM invoice_items ii
                WHERE ii.inventory_id = i.id
              )
        `);
        
        await conn.query(`
            DELETE FROM invoices WHERE deleted_at < NOW() - INTERVAL 1 MONTH
        `);
        
    } catch (error) {
        console.error('خطأ في عملية حذف السجلات المحذوفة ناعماً:', error);
    } finally {
        if (conn) {
            conn.release();
        }
    }
}, {
    scheduled: true,
    timezone: "Asia/Damascus" // توقيت دمشق
});

// إعداد Socket.IO
const io = new Server(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

// إعداد نظام Presence
const presenceSystem = require('./services/presenceService')(io, pool);

// إعداد timeouts على مستوى HTTP server
server.requestTimeout = REQUEST_TIMEOUT_MS;
server.keepAliveTimeout = KEEP_ALIVE_TIMEOUT_MS;
server.headersTimeout = HEADERS_TIMEOUT_MS;

// مراقبة دورية للذاكرة لتشخيص التسربات قبل الوصول لإعادة التشغيل
if (ENABLE_MEMORY_LOG) {
    const memoryTimer = setInterval(() => {
        const memoryUsage = process.memoryUsage();
        const rssMb = (memoryUsage.rss / 1024 / 1024).toFixed(1);
        const heapUsedMb = (memoryUsage.heapUsed / 1024 / 1024).toFixed(1);
        const heapTotalMb = (memoryUsage.heapTotal / 1024 / 1024).toFixed(1);
        const extMb = (memoryUsage.external / 1024 / 1024).toFixed(1);
        const load = os.loadavg ? os.loadavg().map((value) => value.toFixed(2)).join(',') : 'n/a';

        console.log(
            `[MEMORY] rss=${rssMb}MB heapUsed=${heapUsedMb}MB heapTotal=${heapTotalMb}MB external=${extMb}MB load=${load}`
        );
    }, MEMORY_LOG_INTERVAL_MS);

    memoryTimer.unref();
}

// تسجيل واضح للأخطاء غير المعالجة التي قد تؤدي للحاجة لإعادة تشغيل PM2
process.on('unhandledRejection', (reason) => {
    console.error('[FATAL][unhandledRejection]', reason);
});

process.on('uncaughtException', (error) => {
    console.error('[FATAL][uncaughtException]', error);
});

// تشغيل الخادم بعد تطبيق المايغريشن المرقمة على قاعدة البيانات الحالية.
const PORT = process.env.PORT || 3000;
runMigrations(pool)
    .then(() => {
        server.listen(PORT, '0.0.0.0', () => {
            console.log(`Server running on port ${PORT}`);
        });
    })
    .catch((error) => {
        console.error('[FATAL] Database migrations failed:', error);
        process.exitCode = 1;
    });
