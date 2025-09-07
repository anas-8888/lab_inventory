const { pool } = require('../database/db');

// middleware لتتبع نشاط المستخدمين
const trackUserActivity = async (req, res, next) => {
    // تحديث آخر نشاط للمستخدم المسجل دخوله فقط
    if (req.session && req.session.user && req.session.user.id) {
        try {
            // تحديث حالة النشاط إلى online عند أي طلب API موثق
            await pool.query(
                'UPDATE users SET activity_status = ? WHERE id = ?',
                ['online', req.session.user.id]
            );
        } catch (error) {
            console.error('خطأ في تتبع نشاط المستخدم:', error);
        }
    }
    next();
};

// middleware خاص لتسجيل الدخول
const onUserLogin = async (userId) => {
    try {
        await pool.query(
            'UPDATE users SET activity_status = ? WHERE id = ?',
            ['online', userId]
        );
    } catch (error) {
        console.error('خطأ في تحديث حالة المستخدم عند تسجيل الدخول:', error);
    }
};

// middleware خاص لتسجيل الخروج
const onUserLogout = async (userId) => {
    try {
        await pool.query(
            'UPDATE users SET activity_status = ?, last_seen_at = ? WHERE id = ?',
            ['offline', new Date(), userId]
        );
    } catch (error) {
        console.error('خطأ في تحديث حالة المستخدم عند تسجيل الخروج:', error);
    }
};

module.exports = {
    trackUserActivity,
    onUserLogin,
    onUserLogout
};
