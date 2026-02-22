const bcrypt = require('bcryptjs');
const { pool } = require('../database/db');

// عرض قائمة المستخدمين
exports.getUsers = async (req, res) => {
    try {
        const [users] = await pool.query(`
            SELECT u.id, u.username, u.role_id, u.created_at, r.name as role_name,
                   u.activity_status, u.last_seen_at
            FROM users u
            JOIN roles r ON u.role_id = r.id
            ORDER BY u.activity_status DESC, u.last_seen_at DESC, u.username
        `);

        // تحويل role_id إلى نص وصفي
        const formattedUsers = users.map(user => ({
            ...user,
            role: user.role_id === 2
                ? 'editor'
                : user.role_id === 3
                ? 'viewer'
                : user.role_id === 4
                ? 'admin'
                : 'unknown'
        }));

        res.render('users/index', {
            title: 'إدارة المستخدمين',
            users: formattedUsers,
            user: req.session.user
        });
    } catch (error) {
        console.error('Error fetching users:', error);
        req.flash('error_msg', 'حدث خطأ أثناء جلب بيانات المستخدمين');
        res.redirect('/');
    }
};

// عرض نموذج إضافة مستخدم جديد
exports.getCreateForm = (req, res) => {
    res.render('users/create', {
        title: 'إضافة مستخدم جديد',
        user: req.session.user
    });
};

// إضافة مستخدم جديد
exports.createUser = async (req, res) => {
    try {
        const { username, password, password2, role_id } = req.body;

        // التحقق من تطابق كلمات المرور
        if (password !== password2) {
            req.flash('error_msg', 'كلمات المرور غير متطابقة');
            return res.redirect('/users/create');
        }

        // التحقق من عدم وجود اسم مستخدم مكرر
        const [existingUsers] = await pool.query('SELECT * FROM users WHERE username = ?', [username]);
        if (existingUsers.length > 0) {
            req.flash('error_msg', 'اسم المستخدم موجود مسبقاً');
            return res.redirect('/users/create');
        }

        // تشفير كلمة المرور
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // إضافة المستخدم
        await pool.query(
            'INSERT INTO users (username, password_hash, role_id) VALUES (?, ?, ?)',
            [username, hashedPassword, role_id]
        );

        req.flash('success_msg', 'تم إضافة المستخدم بنجاح');
        res.redirect('/users');
    } catch (error) {
        console.error('Error creating user:', error);
        req.flash('error_msg', 'حدث خطأ أثناء إضافة المستخدم');
        res.redirect('/users/create');
    }
};

// عرض نموذج تعديل مستخدم
exports.getEditForm = async (req, res) => {
    try {
        const [users] = await pool.query(`
            SELECT u.id, u.username, u.role_id, r.name as role_name
            FROM users u
            JOIN roles r ON u.role_id = r.id
            WHERE u.id = ?
        `, [req.params.id]);

        if (users.length === 0) {
            req.flash('error_msg', 'المستخدم غير موجود');
            return res.redirect('/users');
        }

        const editUser = {
            ...users[0],
            role:
                users[0].role_id === 2
                    ? 'editor'
                    : users[0].role_id === 3
                    ? 'viewer'
                    : users[0].role_id === 4
                    ? 'admin'
                    : 'unknown'
        };

        res.render('users/edit', {
            title: 'تعديل بيانات المستخدم',
            user: req.session.user,
            editUser: editUser
        });
    } catch (error) {
        console.error('Error fetching user:', error);
        req.flash('error_msg', 'حدث خطأ أثناء جلب بيانات المستخدم');
        res.redirect('/users');
    }
};

// تحديث بيانات المستخدم
exports.updateUser = async (req, res) => {
    try {
        const { username, role_id } = req.body;
        const userId = req.params.id;

        // التحقق من عدم وجود اسم مستخدم مكرر
        const [existingUsers] = await pool.query(
            'SELECT * FROM users WHERE username = ? AND id != ?',
            [username, userId]
        );
        if (existingUsers.length > 0) {
            req.flash('error_msg', 'اسم المستخدم موجود مسبقاً');
            return res.redirect(`/users/${userId}/edit`);
        }

        // تحديث بيانات المستخدم
        await pool.query(
            'UPDATE users SET username = ?, role_id = ? WHERE id = ?',
            [username, role_id, userId]
        );

        req.flash('success_msg', 'تم تحديث بيانات المستخدم بنجاح');
        res.redirect('/users');
    } catch (error) {
        console.error('Error updating user:', error);
        req.flash('error_msg', 'حدث خطأ أثناء تحديث بيانات المستخدم');
        res.redirect(`/users/${req.params.id}/edit`);
    }
};

// حذف مستخدم
exports.deleteUser = async (req, res) => {
    let connection;
    try {
        const userId = parseInt(req.params.id, 10);
        const currentUserId = parseInt(req.session?.user?.id, 10);
        if (!Number.isInteger(currentUserId)) {
            req.flash('error_msg', 'الجلسة غير صالحة، يرجى تسجيل الدخول مرة أخرى');
            return res.redirect('/auth/login');
        }

        connection = await pool.getConnection();
        await connection.beginTransaction();

        // Check target user exists
        const [user] = await connection.query('SELECT * FROM users WHERE id = ?', [userId]);
        if (user.length === 0) {
            await connection.rollback();
            req.flash('error_msg', 'المستخدم غير موجود');
            return res.redirect('/users');
        }

        // Prevent deleting current logged-in user
        if (userId === currentUserId) {
            await connection.rollback();
            req.flash('error_msg', 'لا يمكن حذف المستخدم الحالي');
            return res.redirect('/users');
        }

        // Reassign dependent rows to the current admin/editor to satisfy foreign keys
        await connection.query('UPDATE invoices SET created_by = ? WHERE created_by = ?', [currentUserId, userId]);

        const [result] = await connection.query('DELETE FROM users WHERE id = ?', [userId]);
        if (result.affectedRows === 0) {
            await connection.rollback();
            req.flash('error_msg', 'فشل حذف المستخدم');
            return res.redirect('/users');
        }

        await connection.commit();
        req.flash('success_msg', 'تم حذف المستخدم بنجاح');
        return res.redirect('/users');
    } catch (error) {
        if (connection) {
            try { await connection.rollback(); } catch (_) {}
        }
        console.error('Error deleting user:', error);
        if (error?.code === 'ER_ROW_IS_REFERENCED_2') {
            req.flash('error_msg', 'لا يمكن حذف المستخدم لوجود بيانات مرتبطة به في النظام');
        } else {
            req.flash('error_msg', 'حدث خطأ أثناء حذف المستخدم');
        }
        return res.redirect('/users');
    } finally {
        if (connection) connection.release();
    }
};
