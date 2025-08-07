const { pool } = require('../database/db');

// عرض صفحة التكاليف الرئيسية
exports.getCosts = async (req, res) => {
    try {
        res.render('costs/index', {
            title: 'التكاليف',
            user: req.session.user
        });
    } catch (error) {
        console.error('Error loading costs page:', error);
        req.flash('error_msg', 'حدث خطأ أثناء تحميل صفحة التكاليف');
        res.redirect('/');
    }
};

// إنشاء تكلفة جديدة
exports.createCost = async (req, res) => {
    try {
        // سيتم إضافة منطق إنشاء التكلفة هنا لاحقاً
        req.flash('success_msg', 'تم إنشاء التكلفة بنجاح');
        res.redirect('/costs');
    } catch (error) {
        console.error('Error creating cost:', error);
        req.flash('error_msg', 'حدث خطأ أثناء إنشاء التكلفة');
        res.redirect('/costs');
    }
};

// عرض صفحة إنشاء تكلفة جديدة
exports.getCreateCost = async (req, res) => {
    try {
        res.render('costs/create', {
            title: 'إنشاء تكلفة جديدة',
            user: req.session.user
        });
    } catch (error) {
        console.error('Error loading create cost page:', error);
        req.flash('error_msg', 'حدث خطأ أثناء تحميل صفحة إنشاء التكلفة');
        res.redirect('/costs');
    }
}; 