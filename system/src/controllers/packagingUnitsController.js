'use strict';

const normalizeName = (value) => String(value || '').trim();

const list = async (req, res) => {
    try {
        const [units] = await req.db.query(`
            SELECT pu.*,
                   COUNT(DISTINCT mpu.material_id) AS materials_count
            FROM packaging_units pu
            LEFT JOIN material_packaging_units mpu ON mpu.packaging_unit_id = pu.id
            GROUP BY pu.id
            ORDER BY pu.is_active DESC, pu.name ASC, pu.kilograms_per_unit ASC
        `);
        res.render('costs/packaging-units', {
            title: 'وحدات التعبئة',
            units
        });
    } catch (error) {
        console.error('خطأ في عرض وحدات التعبئة:', error);
        req.flash('error_msg', 'تعذر عرض وحدات التعبئة');
        res.redirect('/costs');
    }
};

const create = async (req, res) => {
    try {
        const name = normalizeName(req.body.name);
        const kilogramsPerUnit = Number(req.body.kilograms_per_unit);
        if (!name || !Number.isFinite(kilogramsPerUnit) || kilogramsPerUnit <= 0) {
            return res.status(400).json({ success: false, message: 'اسم الوحدة وقيمتها بالكيلو مطلوبان' });
        }

        const [result] = await req.db.query(
            `INSERT INTO packaging_units (name, kilograms_per_unit)
             VALUES (?, ?)
             ON DUPLICATE KEY UPDATE is_active = 1, updated_at = CURRENT_TIMESTAMP`,
            [name, kilogramsPerUnit]
        );
        res.json({ success: true, id: result.insertId || null, message: 'تم حفظ وحدة التعبئة' });
    } catch (error) {
        console.error('خطأ في إضافة وحدة التعبئة:', error);
        res.status(500).json({ success: false, message: 'تعذر حفظ وحدة التعبئة' });
    }
};

const update = async (req, res) => {
    try {
        const id = Number.parseInt(req.params.id, 10);
        const name = normalizeName(req.body.name);
        const kilogramsPerUnit = Number(req.body.kilograms_per_unit);
        if (!Number.isInteger(id) || !name || !Number.isFinite(kilogramsPerUnit) || kilogramsPerUnit <= 0) {
            return res.status(400).json({ success: false, message: 'بيانات وحدة التعبئة غير صالحة' });
        }

        const [existingRows] = await req.db.query(`
            SELECT pu.*, COUNT(mpu.id) AS links_count
            FROM packaging_units pu
            LEFT JOIN material_packaging_units mpu ON mpu.packaging_unit_id = pu.id
            WHERE pu.id = ? GROUP BY pu.id
        `, [id]);
        if (existingRows.length === 0) {
            return res.status(404).json({ success: false, message: 'وحدة التعبئة غير موجودة' });
        }
        const existing = existingRows[0];
        if (Number(existing.links_count) > 0) {
            return res.status(409).json({
                success: false,
                message: 'لا يمكن تعديل وحدة تعبئة مرتبطة بمواد'
            });
        }

        const [result] = await req.db.query(
            `UPDATE packaging_units pu
             SET name = ?, kilograms_per_unit = ?
             WHERE pu.id = ?
               AND NOT EXISTS (
                   SELECT 1 FROM material_packaging_units mpu
                   WHERE mpu.packaging_unit_id = pu.id
               )`,
            [name, kilogramsPerUnit, id]
        );
        if (result.affectedRows === 0) {
            return res.status(409).json({ success: false, message: 'لا يمكن تعديل وحدة تعبئة مرتبطة بمواد' });
        }
        res.json({ success: true, message: 'تم تحديث وحدة التعبئة' });
    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({ success: false, message: 'توجد وحدة بنفس الاسم والقيمة بالكيلو' });
        }
        console.error('خطأ في تعديل وحدة التعبئة:', error);
        res.status(500).json({ success: false, message: 'تعذر تحديث وحدة التعبئة' });
    }
};

const setActive = async (req, res) => {
    try {
        const id = Number.parseInt(req.params.id, 10);
        const isActive = req.body.is_active === true || req.body.is_active === 1 || req.body.is_active === '1';
        if (!Number.isInteger(id)) {
            return res.status(400).json({ success: false, message: 'معرّف وحدة التعبئة غير صالح' });
        }
        const [existingRows] = await req.db.query(`
            SELECT pu.id, COUNT(mpu.id) AS links_count
            FROM packaging_units pu
            LEFT JOIN material_packaging_units mpu ON mpu.packaging_unit_id = pu.id
            WHERE pu.id = ?
            GROUP BY pu.id
        `, [id]);
        if (existingRows.length === 0) {
            return res.status(404).json({ success: false, message: 'وحدة التعبئة غير موجودة' });
        }
        if (!isActive && Number(existingRows[0].links_count) > 0) {
            return res.status(409).json({ success: false, message: 'لا يمكن تعطيل وحدة تعبئة مرتبطة بمواد' });
        }
        const [result] = await req.db.query(
            `UPDATE packaging_units pu
             SET is_active = ?
             WHERE pu.id = ?
               AND (? = 1 OR NOT EXISTS (
                   SELECT 1 FROM material_packaging_units mpu
                   WHERE mpu.packaging_unit_id = pu.id
               ))`,
            [isActive ? 1 : 0, id, isActive ? 1 : 0]
        );
        if (result.affectedRows === 0) {
            return res.status(409).json({ success: false, message: 'لا يمكن تعطيل وحدة تعبئة مرتبطة بمواد' });
        }
        res.json({ success: true, message: isActive ? 'تم تفعيل الوحدة' : 'تم تعطيل الوحدة' });
    } catch (error) {
        console.error('خطأ في تغيير حالة وحدة التعبئة:', error);
        res.status(500).json({ success: false, message: 'تعذر تغيير حالة الوحدة' });
    }
};

module.exports = { list, create, update, setActive };
