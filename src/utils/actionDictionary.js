/**
 * قاموس تحويل الطلبات إلى أسماء الحركات البشرية
 * يحول method + path إلى وصف بشري بالعربية
 */

const actionDictionary = {
    // المصادقة والجلسات
    'POST /auth/login': 'تسجيل الدخول',
    'POST /auth/logout': 'تسجيل الخروج',
    'GET /auth/login': 'عرض صفحة تسجيل الدخول',
    'POST /auth/change-password': 'تغيير كلمة المرور',
    'GET /auth/change-password': 'عرض صفحة تغيير كلمة المرور',

    // المستخدمين
    'GET /users': 'استعراض كل المستخدمين',
    'GET /users/create': 'عرض نموذج إضافة مستخدم',
    'POST /users/create': 'إضافة مستخدم جديد',
    'GET /users/:id': 'عرض تفاصيل مستخدم',
    'GET /users/:id/edit': 'عرض نموذج تعديل مستخدم',
    'POST /users/:id/edit': 'تعديل بيانات مستخدم',
    'DELETE /users/:id': 'حذف مستخدم',

    // المخزون
    'GET /inventory': 'استعراض المخزون',
    'GET /inventory/create': 'عرض نموذج إضافة عينة',
    'POST /inventory/create': 'إضافة عينة جديدة',
    'GET /inventory/:id': 'عرض تفاصيل عينة',
    'GET /inventory/:id/edit': 'عرض نموذج تعديل عينة',
    'POST /inventory/:id/edit': 'تعديل بيانات عينة',
    'DELETE /inventory/:id': 'حذف عينة',
    'GET /inventory/search': 'البحث في المخزون',

    // الفواتير
    'GET /invoices': 'استعراض الفواتير',
    'GET /invoices/create': 'عرض نموذج إنشاء فاتورة',
    'POST /invoices/create': 'إنشاء فاتورة جديدة',
    'GET /invoices/:id': 'عرض تفاصيل فاتورة',
    'GET /invoices/:id/edit': 'عرض نموذج تعديل فاتورة',
    'POST /invoices/:id/edit': 'تعديل فاتورة',
    'DELETE /invoices/:id': 'حذف فاتورة',
    'GET /invoices/:id/print': 'طباعة فاتورة',
    'GET /invoices/api/inventory': 'جلب بيانات المخزون للفواتير',
    'PUT /invoices/:id/status': 'تحديث حالة فاتورة',

    // الشهادات
    'GET /certificates': 'استعراض الشهادات',
    'GET /certificates/create': 'عرض نموذج إنشاء شهادة',
    'POST /certificates/create': 'إنشاء شهادة جديدة',
    'GET /certificates/:id': 'عرض تفاصيل شهادة',
    'GET /certificates/:id/edit': 'عرض نموذج تعديل شهادة',
    'POST /certificates/:id/edit': 'تعديل شهادة',
    'DELETE /certificates/:id': 'حذف شهادة',
    'GET /certificates/:id/print': 'طباعة شهادة',

    // التكاليف
    'GET /costs': 'استعراض لوحة التكاليف',
    'GET /costs/materials': 'استعراض المواد',
    'GET /costs/materials/create': 'عرض نموذج إضافة مادة',
    'POST /costs/materials/create': 'إضافة مادة جديدة',
    'GET /costs/materials/:id': 'عرض تفاصيل مادة',
    'GET /costs/materials/:id/edit': 'عرض نموذج تعديل مادة',
    'POST /costs/materials/:id/edit': 'تعديل مادة',
    'DELETE /costs/materials/:id': 'حذف مادة',

    'GET /costs/quotations': 'استعراض عروض الأسعار',
    'GET /costs/quotations/create': 'عرض نموذج إنشاء عرض سعر',
    'POST /costs/quotations/create': 'إنشاء عرض سعر جديد',
    'GET /costs/quotations/:id': 'عرض تفاصيل عرض سعر',
    'DELETE /costs/quotations/:id': 'حذف عرض سعر',

    'GET /costs/orders': 'استعراض الطلبيات',
    'GET /costs/orders/create': 'عرض نموذج إنشاء طلبية',
    'POST /costs/orders/create': 'إنشاء طلبية جديدة',
    'GET /costs/orders/:id': 'عرض تفاصيل طلبية',
    'GET /costs/orders/:id/print': 'طباعة طلبية',
    'GET /costs/orders/:id/print-pdf': 'تصدير طلبية PDF',

    // الملاحظات
    'GET /notes': 'استعراض الملاحظات',
    'GET /notes/create': 'عرض نموذج إضافة ملاحظة',
    'POST /notes/create': 'إضافة ملاحظة جديدة',
    'GET /notes/:id': 'عرض تفاصيل ملاحظة',
    'GET /notes/:id/edit': 'عرض نموذج تعديل ملاحظة',
    'POST /notes/:id/edit': 'تعديل ملاحظة',
    'DELETE /notes/:id': 'حذف ملاحظة',

    // سجل الحركات
    'GET /activity-logs': 'عرض سجل الحركات',
    'GET /activity-logs/details/:id': 'عرض تفاصيل سجل',
    'GET /activity-logs/export': 'تصدير سجل الحركات',
    'GET /activity-logs/api/stats': 'جلب إحصائيات سجل الحركات',

    // الصفحة الرئيسية
    'GET /': 'زيارة الصفحة الرئيسية',
    'GET /dashboard': 'عرض لوحة التحكم'
};

/**
 * يحول method + path إلى اسم حركة بشري
 * @param {string} method - نوع الطلب (GET, POST, etc.)
 * @param {string} path - مسار الطلب
 * @returns {string} اسم الحركة بالعربية
 */
function getActionName(method, path) {
    // تنظيف المسار من المعاملات الديناميكية
    let cleanPath = path;
    
    // استبدال الأرقام بـ :id
    cleanPath = cleanPath.replace(/\/\d+/g, '/:id');
    
    // استبدال query parameters
    cleanPath = cleanPath.split('?')[0];
    
    const key = `${method.toUpperCase()} ${cleanPath}`;
    
    // البحث عن تطابق مباشر
    if (actionDictionary[key]) {
        return actionDictionary[key];
    }
    
    // البحث عن تطابق جزئي للمسارات الديناميكية
    for (const [pattern, action] of Object.entries(actionDictionary)) {
        const [patternMethod, patternPath] = pattern.split(' ');
        if (patternMethod === method.toUpperCase() && matchesPattern(cleanPath, patternPath)) {
            return action;
        }
    }
    
    // إذا لم يوجد تطابق، إرجاع وصف عام
    return getGenericActionName(method, cleanPath);
}

/**
 * يتحقق من تطابق المسار مع النمط
 */
function matchesPattern(path, pattern) {
    if (path === pattern) return true;
    
    const pathParts = path.split('/');
    const patternParts = pattern.split('/');
    
    if (pathParts.length !== patternParts.length) return false;
    
    for (let i = 0; i < pathParts.length; i++) {
        if (patternParts[i].startsWith(':')) continue;
        if (pathParts[i] !== patternParts[i]) return false;
    }
    
    return true;
}

/**
 * ينشئ اسم حركة عام بناءً على method و path
 */
function getGenericActionName(method, path) {
    const methodNames = {
        'GET': 'استعراض',
        'POST': 'إضافة/تحديث',
        'PUT': 'تحديث',
        'DELETE': 'حذف',
        'PATCH': 'تعديل جزئي'
    };
    
    const methodName = methodNames[method.toUpperCase()] || 'عملية';
    const pathName = path.replace(/\//g, ' ').replace(/:/g, '').trim() || 'صفحة';
    
    return `${methodName} ${pathName}`;
}

module.exports = {
    getActionName,
    actionDictionary
};
