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
const { authMiddleware } = require('./middleware/auth');
const { addCurrencyToRequest } = require('./middleware/currency');
const { trackUserActivity } = require('./middleware/presenceMiddleware');
const morgan = require('morgan');
const securityConfig = require('./config/security');

// إنشاء تطبيق Express وخادم HTTP
const app = express();
const server = http.createServer(app);

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
const publicSiteAllowedOrigins = (process.env.PUBLIC_SITE_ALLOWED_ORIGINS || 'http://localhost:8081')
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);

function applyPublicSiteCors(req, res) {
    const requestOrigin = req.headers.origin;
    if (!requestOrigin) return;

    if (publicSiteAllowedOrigins.includes(requestOrigin)) {
        res.setHeader('Access-Control-Allow-Origin', requestOrigin);
        res.setHeader('Vary', 'Origin');
    } else {
        return;
    }

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

        const connection = await pool.getConnection();
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
        next(error);
    }
});

// وسيط المصادقة
app.use((req, res, next) => {
    const publicPaths = [
        '/site-management/public/',
        '/site-management/public-content',
        '/site-management/contact-messages',
        '/inventory/print-pdf-raw',
        '/inventory/export/pdf',
        '/costs/cost-statement/print-list',
        '/costs/cost-statement/print-list-pdf-raw',
        '/costs/cost-statement/export/pdf',
        '/costs/cost-statement/', // for single material print and print-pdf-raw
    ];
    if (publicPaths.some(path => req.path.startsWith(path))) {
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
    const conn = await pool.getConnection();
    try {        
        // حذف السجلات المحذوفة ناعماً التي يزيد عمرها عن شهر واحد
        const [certificatesResult] = await conn.query(`
            DELETE FROM certificates WHERE deleted_at < NOW() - INTERVAL 1 MONTH
        `);
        
        const [inventoryResult] = await conn.query(`
            DELETE i
            FROM inventory i
            WHERE i.deleted_at < NOW() - INTERVAL 1 MONTH
              AND NOT EXISTS (
                SELECT 1
                FROM invoice_items ii
                WHERE ii.inventory_id = i.id
              )
        `);
        
        const [invoicesResult] = await conn.query(`
            DELETE FROM invoices WHERE deleted_at < NOW() - INTERVAL 1 MONTH
        `);
        
    } catch (error) {
        console.error('خطأ في عملية حذف السجلات المحذوفة ناعماً:', error);
    } finally {
        conn.release();
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

// تشغيل الخادم
const PORT = process.env.PORT || 3000;
server.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
});
