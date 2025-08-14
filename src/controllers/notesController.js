const listNotes = async (req, res) => {
  try {
    const [rows] = await req.db.query(`
      SELECT 
        n.id,
        n.material_id,
        COALESCE(NULLIF(n.material_name, ''), m.material_name) AS material_name,
        n.price,
        n.weight,
        n.note_text,
        DATE_FORMAT(n.note_date, '%Y-%m-%d') AS note_date
      FROM notes n
      LEFT JOIN materials m ON m.id = n.material_id
      ORDER BY n.note_date DESC, n.id DESC
    `);
    const [materials] = await req.db.query(`
      SELECT id, material_name FROM materials ORDER BY material_name
    `);

    res.render('notes/index', {
      title: 'الملاحظات',
      notes: rows,
      materials
    });
  } catch (err) {
    console.error('listNotes error:', err);
    req.flash('error_msg', 'حدث خطأ في تحميل الملاحظات');
    res.redirect('/');
  }
};

const viewNote = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await req.db.query(`
      SELECT 
        n.id,
        n.material_id,
        COALESCE(NULLIF(n.material_name, ''), m.material_name) AS material_name,
        n.price,
        n.weight,
        n.note_text,
        DATE_FORMAT(n.note_date, '%d/%m/%Y') AS note_date_fmt
      FROM notes n
      LEFT JOIN materials m ON m.id = n.material_id
      WHERE n.id = ?
    `, [id]);
    if (!rows.length) {
      req.flash('error_msg', 'الملاحظة غير موجودة');
      return res.redirect('/notes');
    }
    if (req.headers.accept && req.headers.accept.includes('application/json')) {
      return res.json({ success: true, note: rows[0] });
    }
    res.render('notes/show', { title: 'عرض ملاحظة', note: rows[0] });
  } catch (err) {
    console.error('viewNote error:', err);
    req.flash('error_msg', 'حدث خطأ في عرض الملاحظة');
    res.redirect('/notes');
  }
};

const createNote = async (req, res) => {
  try {
    const { material_id, material_name, price, weight, note_text } = req.body;
    const parsedPrice = (price !== undefined && price !== '') ? parseFloat(price) : null;
    const parsedWeight = (weight !== undefined && weight !== '') ? parseFloat(weight) : null;
    // material_id اختياري، وإذا لم يُرسل أو غير صالح نتركه NULL
    let materialIdForInsert = null;
    if (material_id !== undefined && material_id !== '') {
      const maybeId = parseInt(material_id);
      if (!Number.isNaN(maybeId) && maybeId > 0) {
        const [mats] = await req.db.query('SELECT id FROM materials WHERE id = ? LIMIT 1', [maybeId]);
        if (mats.length > 0) materialIdForInsert = maybeId;
      }
    }

    await req.db.query(`
      INSERT INTO notes (material_id, material_name, price, weight, note_date, note_text)
      VALUES (?, ?, ?, ?, NOW(), ?)
    `, [materialIdForInsert, (material_name || null), parsedPrice, parsedWeight, note_text || null]);

    res.json({ success: true });
  } catch (err) {
    console.error('createNote error:', err);
    res.status(500).json({ success: false, message: 'فشل إنشاء الملاحظة' });
  }
};

const updateNote = async (req, res) => {
  try {
    const { id } = req.params;
    const { material_id, material_name, price, weight, note_text } = req.body;
    const parsedPrice = (price !== undefined && price !== '') ? parseFloat(price) : null;
    const parsedWeight = (weight !== undefined && weight !== '') ? parseFloat(weight) : null;
    let materialIdForUpdate = null;
    if (material_id !== undefined && material_id !== '') {
      const maybeId = parseInt(material_id);
      if (!Number.isNaN(maybeId) && maybeId > 0) {
        const [mats] = await req.db.query('SELECT id FROM materials WHERE id = ? LIMIT 1', [maybeId]);
        if (mats.length > 0) materialIdForUpdate = maybeId;
      }
    }

    await req.db.query(`
      UPDATE notes 
      SET material_id = ?, material_name = ?, price = ?, weight = ?, note_date = NOW(), note_text = ?
      WHERE id = ?
    `, [materialIdForUpdate, (material_name || null), parsedPrice, parsedWeight, note_text || null, id]);

    res.json({ success: true });
  } catch (err) {
    console.error('updateNote error:', err);
    res.status(500).json({ success: false, message: 'فشل تعديل الملاحظة' });
  }
};

const deleteNote = async (req, res) => {
  try {
    const { id } = req.params;
    await req.db.query('DELETE FROM notes WHERE id = ?', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error('deleteNote error:', err);
    res.status(500).json({ success: false, message: 'فشل حذف الملاحظة' });
  }
};

module.exports = {
  listNotes,
  viewNote,
  createNote,
  updateNote,
  deleteNote,
};

