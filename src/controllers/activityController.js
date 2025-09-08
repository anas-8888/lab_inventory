/**
 * Activity Controller
 * يدير عرض وإدارة سجل الحركات
 */

const { pool } = require('../database/db');

/**
 * عرض صفحة سجل الحركات
 */
exports.getActivityLogs = async (req, res) => {
    try {
        // التحقق من صلاحية الادمن
        if (!req.session.user || req.session.user.role !== 'admin') {
            req.flash('error_msg', 'غير مصرح لك بالوصول إلى هذه الصفحة');
            return res.redirect('/');
        }

        // التحقق من وجود الجدول أولاً
        try {
            await pool.execute('SELECT 1 FROM activity_logs LIMIT 1');
        } catch (tableError) {
            if (tableError.code === 'ER_NO_SUCH_TABLE') {
                req.flash('error_msg', 'جدول سجل الحركات غير موجود. يرجى تنفيذ الـ SQL المطلوب لإنشاء الجدول أولاً.');
                return res.redirect('/');
            }
            throw tableError;
        }

        // معاملات البحث والفلترة
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 50;
        const offset = (page - 1) * limit;
        
        const search = req.query.search || '';
        const actorFilter = req.query.actor || '';
        const actionFilter = req.query.action || '';
        const statusFilter = req.query.status || '';
        const dateFrom = req.query.date_from || '';
        const dateTo = req.query.date_to || '';
        
        // تجاهل معامل _refresh (يُستخدم فقط لـ cache busting)
        // لا حاجة لعمل شيء معه

        // بناء الاستعلام
        let whereConditions = [];
        let queryParams = [];

        if (search) {
            whereConditions.push('(action_name LIKE ? OR actor_name_snapshot LIKE ? OR path LIKE ?)');
            queryParams.push(`%${search}%`, `%${search}%`, `%${search}%`);
        }

        if (actorFilter) {
            whereConditions.push('actor_name_snapshot LIKE ?');
            queryParams.push(`%${actorFilter}%`);
        }

        if (actionFilter) {
            whereConditions.push('action_name LIKE ?');
            queryParams.push(`%${actionFilter}%`);
        }

        if (statusFilter) {
            if (statusFilter === 'success') {
                whereConditions.push('status_code >= 200 AND status_code < 300');
            } else if (statusFilter === 'error') {
                whereConditions.push('status_code >= 400');
            } else if (statusFilter === 'redirect') {
                whereConditions.push('status_code >= 300 AND status_code < 400');
            }
        }

        if (dateFrom) {
            whereConditions.push('DATE(created_at) >= ?');
            queryParams.push(dateFrom);
        }

        if (dateTo) {
            whereConditions.push('DATE(created_at) <= ?');
            queryParams.push(dateTo);
        }

        const whereClause = whereConditions.length > 0 ? 'WHERE ' + whereConditions.join(' AND ') : '';

        // استعلام العد الإجمالي
        const countQuery = `SELECT COUNT(*) as total FROM activity_logs ${whereClause}`;
        const [countResult] = await pool.execute(countQuery, queryParams);
        const totalRecords = countResult[0].total;
        const totalPages = Math.ceil(totalRecords / limit);

        // استعلام البيانات
        const dataQuery = `
            SELECT 
                id,
                action_name,
                actor_id,
                actor_name_snapshot,
                method,
                path,
                status_code,
                ip_address,
                created_at
            FROM activity_logs 
            ${whereClause}
            ORDER BY created_at DESC 
            LIMIT ? OFFSET ?
        `;
        
        const [logs] = await pool.execute(dataQuery, [...queryParams, limit, offset]);

        // جلب قائمة المستخدمين للفلتر
        const [users] = await pool.execute(`
            SELECT DISTINCT actor_name_snapshot 
            FROM activity_logs 
            WHERE actor_name_snapshot IS NOT NULL 
            ORDER BY actor_name_snapshot
        `);

        // جلب قائمة الحركات للفلتر
        const [actions] = await pool.execute(`
            SELECT DISTINCT action_name 
            FROM activity_logs 
            ORDER BY action_name
        `);

        res.render('activity/index', {
            title: 'سجل الحركات',
            logs,
            users,
            actions,
            pagination: {
                current: page,
                total: totalPages,
                limit,
                totalRecords
            },
            filters: {
                search,
                actor: actorFilter,
                action: actionFilter,
                status: statusFilter,
                date_from: dateFrom,
                date_to: dateTo
            }
        });

    } catch (error) {
        console.error('خطأ في جلب سجل الحركات:', error);
        
        // التحقق من نوع الخطأ
        if (error.code === 'ER_NO_SUCH_TABLE') {
            req.flash('error_msg', 'جدول سجل الحركات غير موجود. يرجى تنفيذ الـ SQL لإنشاء الجدول أولاً.');
        } else {
            req.flash('error_msg', 'حدث خطأ أثناء جلب سجل الحركات');
        }
        
        res.redirect('/');
    }
};

/**
 * عرض تفاصيل سجل معين
 */
exports.getActivityDetails = async (req, res) => {
    try {
        // التحقق من صلاحية الادمن
        if (!req.session.user || req.session.user.role !== 'admin') {
            return res.status(403).json({ error: 'غير مصرح لك بالوصول' });
        }

        const { id } = req.params;

        const [logs] = await pool.execute(`
            SELECT 
                id,
                action_name,
                actor_id,
                actor_name_snapshot,
                method,
                path,
                status_code,
                ip_address,
                user_agent,
                created_at
            FROM activity_logs 
            WHERE id = ?
        `, [id]);

        if (logs.length === 0) {
            return res.status(404).json({ error: 'السجل غير موجود' });
        }

        res.json(logs[0]);

    } catch (error) {
        console.error('خطأ في جلب تفاصيل السجل:', error);
        res.status(500).json({ error: 'حدث خطأ أثناء جلب التفاصيل' });
    }
};

/**
 * تصدير سجل الحركات إلى CSV
 */
exports.exportActivityLogs = async (req, res) => {
    try {
        // التحقق من صلاحية الادمن
        if (!req.session.user || req.session.user.role !== 'admin') {
            req.flash('error_msg', 'غير مصرح لك بالوصول إلى هذه الصفحة');
            return res.redirect('/');
        }

        // جلب آخر 500 سجل
        const [logs] = await pool.execute(`
            SELECT 
                action_name,
                actor_name_snapshot,
                method,
                path,
                status_code,
                ip_address,
                created_at
            FROM activity_logs 
            ORDER BY created_at DESC 
            LIMIT 500
        `);

        // إعداد headers للتحميل
        res.setHeader('Content-Type', 'text/csv; charset=utf-8');
        res.setHeader('Content-Disposition', 'attachment; filename="activity_logs.csv"');

        // كتابة BOM للدعم العربي
        res.write('\uFEFF');

        // كتابة العناوين
        res.write('الحركة,المنفذ,الطريقة,المسار,الحالة,عنوان IP,التاريخ والوقت\n');

        // كتابة البيانات
        logs.forEach(log => {
            const row = [
                log.action_name || '',
                log.actor_name_snapshot || '',
                log.method || '',
                log.path || '',
                log.status_code || '',
                log.ip_address || '',
                log.created_at ? new Date(log.created_at).toLocaleString('ar-EG') : ''
            ];
            res.write(row.map(field => `"${field.toString().replace(/"/g, '""')}"`).join(',') + '\n');
        });

        res.end();

    } catch (error) {
        console.error('خطأ في تصدير سجل الحركات:', error);
        req.flash('error_msg', 'حدث خطأ أثناء تصدير السجل');
        res.redirect('/activity-logs');
    }
};

/**
 * API للحصول على إحصائيات سجل الحركات
 */
exports.getActivityStats = async (req, res) => {
    try {
        // التحقق من صلاحية الادمن
        if (!req.session.user || req.session.user.role !== 'admin') {
            return res.status(403).json({ error: 'غير مصرح لك بالوصول' });
        }

        // إحصائيات عامة
        const [totalStats] = await pool.execute(`
            SELECT 
                COUNT(*) as total_logs,
                COUNT(DISTINCT actor_id) as unique_users,
                COUNT(CASE WHEN status_code >= 200 AND status_code < 300 THEN 1 END) as successful_requests,
                COUNT(CASE WHEN status_code >= 400 THEN 1 END) as failed_requests
            FROM activity_logs
        `);

        // أكثر الحركات تكراراً
        const [topActions] = await pool.execute(`
            SELECT action_name, COUNT(*) as count 
            FROM activity_logs 
            GROUP BY action_name 
            ORDER BY count DESC 
            LIMIT 10
        `);

        // أكثر المستخدمين نشاطاً
        const [topUsers] = await pool.execute(`
            SELECT actor_name_snapshot, COUNT(*) as count 
            FROM activity_logs 
            WHERE actor_name_snapshot IS NOT NULL 
            GROUP BY actor_name_snapshot 
            ORDER BY count DESC 
            LIMIT 10
        `);

        res.json({
            stats: totalStats[0],
            topActions,
            topUsers
        });

    } catch (error) {
        console.error('خطأ في جلب إحصائيات السجل:', error);
        res.status(500).json({ error: 'حدث خطأ أثناء جلب الإحصائيات' });
    }
};
