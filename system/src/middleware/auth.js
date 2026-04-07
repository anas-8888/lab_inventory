const { v4: uuidv4 } = require('uuid');
const SHIPPING_MANAGER_ROLE = 'shipping_manager';
const SHIPPING_CRUD_ROLES = ['admin', 'editor', SHIPPING_MANAGER_ROLE];

// Authentication middleware
const authMiddleware = async (req, res, next) => {
  // Skip auth for login, register, public certificate routes, and print-pdf-raw
  if (
    req.path.startsWith('/auth/') ||
    req.path.startsWith('/certificates/public/') ||
    (/^\/invoices\/\d+\/print-pdf-raw$/.test(req.path)) ||
    (/^\/certificates\/\d+\/print-pdf-raw$/.test(req.path)) ||
    (/^\/inventory\/print-pdf-raw$/.test(req.path)) ||
    (/^\/costs\/cost-statement\/\d+\/print-pdf-raw$/.test(req.path)) ||
    (/^\/costs\/cost-statement\/\d+\/print$/.test(req.path)) ||
    (/^\/costs\/cost-statement\/\d+\/pdf$/.test(req.path)) ||
    (/^\/costs\/cost-statement\/print-list$/.test(req.path)) ||
    (/^\/costs\/cost-statement\/print-list-pdf-raw$/.test(req.path)) ||
    (/^\/costs\/cost-statement\/export\/pdf$/.test(req.path)) ||
    (/^\/costs\/quotations\/\d+\/print-pdf-raw$/.test(req.path)) ||
    (/^\/costs\/orders\/\d+\/print-pdf-raw$/.test(req.path))
  ) {
    return next();
  }

  // Check if user is logged in
  if (!req.session.user) {
    return res.redirect('/auth/login');
  }

  // Make user data available to all views
  res.locals.user = req.session.user;

  // مستخدم طلبات الشحن: يسمح فقط بصفحات طلبات الشحن + الصفحة الرئيسية + المصادقة
  if (req.session.user.role === SHIPPING_MANAGER_ROLE) {
    const allowedExact = ['/', '/home'];
    const allowedPrefixes = ['/invoices', '/auth'];
    const isAllowed =
      allowedExact.includes(req.path) ||
      allowedPrefixes.some(prefix => req.path.startsWith(prefix));

    if (!isAllowed) {
      req.flash('error_msg', 'هذه الصلاحية مخصصة لإدارة طلبات الشحن فقط');
      return res.redirect('/invoices');
    }
  }

  next();
};

const requireAuth = (req, res, next) => {
  if (!req.session.user) {
    req.flash('error_msg', 'يجب تسجيل الدخول للوصول إلى هذه الصفحة');
    return res.redirect('/auth/login');
  }
  next();
};

// Role-based access control middleware
const requireRole = (roles) => {
  return (req, res, next) => {
    if (!req.session.user) {
      req.flash('error_msg', 'يجب تسجيل الدخول للوصول إلى هذه الصفحة');
      return res.redirect('/auth/login');
    }

    if (!roles.includes(req.session.user.role)) {
      req.flash('error_msg', 'ليس لديك صلاحية للوصول إلى هذه الصفحة');
      return res.redirect('/');
    }

    next();
  };
};

// Session management
const createSession = async (req, userId) => {
  const sessionId = uuidv4();
  const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours

  // Store session in database
  await req.db.execute(
    'INSERT INTO sessions (id, user_id, expires_at) VALUES (?, ?, ?)',
    [sessionId, userId, expiresAt]
  );

  // Set session cookie
  req.session.id = sessionId;
  req.session.expiresAt = expiresAt;

  return true;
};

const destroySession = async (req) => {
  if (req.session.id) {
    // Remove session from database
    await req.db.execute('DELETE FROM sessions WHERE id = ?', [req.session.id]);
  }
  req.session.destroy();
  return true;
};

// التحقق من تسجيل الدخول
const isAuthenticated = (req, res, next) => {
    if (req.session.user) {
        return next();
    }
    req.flash('error_msg', 'يجب تسجيل الدخول للوصول إلى هذه الصفحة');
    res.redirect('/auth/login');
};

// التحقق من صلاحية المحرر أو المسؤول
const isEditor = (req, res, next) => {

    if (req.session.user && (req.session.user.role === 'editor' || req.session.user.role === 'admin')) {
        return next();
    }

    // التحقق مما إذا كان الطلب هو طلب API
    if (req.xhr || req.headers.accept.includes('application/json')) {
        return res.status(403).json({
            error: 'ليس لديك صلاحية للوصول إلى هذه الصفحة'
        });
    }

    // إذا كان طلب صفحة عادية
    req.flash('error_msg', 'ليس لديك صلاحية للوصول إلى هذه الصفحة');
    res.redirect('/');
};

// صلاحية إدارة طلبات الشحن (CRUD): مدير طلبات الشحن + المحرر + المسؤول
const isShippingCrud = (req, res, next) => {
    if (req.session.user && SHIPPING_CRUD_ROLES.includes(req.session.user.role)) {
        return next();
    }

    if (req.xhr || req.headers.accept.includes('application/json')) {
        return res.status(403).json({
            error: 'ليس لديك صلاحية للوصول إلى هذه الصفحة'
        });
    }

    req.flash('error_msg', 'ليس لديك صلاحية للوصول إلى هذه الصفحة');
    res.redirect('/');
};

// التحقق من صلاحية المسؤول فقط
const isAdmin = (req, res, next) => {

    if (req.session.user && req.session.user.role === 'admin') {
        return next();
    }

    // التحقق مما إذا كان الطلب هو طلب API
    if (req.xhr || req.headers.accept.includes('application/json')) {
        return res.status(403).json({
            error: 'ليس لديك صلاحية للوصول إلى هذه الصفحة'
        });
    }

    // إذا كان طلب صفحة عادية
    req.flash('error_msg', 'ليس لديك صلاحية للوصول إلى هذه الصفحة');
    res.redirect('/');
};

module.exports = {
    authMiddleware,
    requireAuth,
    requireRole,
    createSession,
    destroySession,
    isAuthenticated,
    isEditor,
    isShippingCrud,
    isAdmin,
}; 
