const { buildRawNumericMap, parseRawNumericMap, rawOrValue, normalizeRawNumeric } = require('../utils/rawNumbers');
const path = require('path');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');
const { generatePdfWithMetrics } = require('../utils/pdf');

const NOTE_RAW_FIELDS = ['price', 'weight'];

function applyNoteRaw(note) {
  if (!note || typeof note !== 'object') return note;
  const rawMap = parseRawNumericMap(note.numeric_raw);
  return {
    ...note,
    price: rawOrValue(rawMap, 'price', note.price),
    weight: rawOrValue(rawMap, 'weight', note.weight),
  };
}

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
        DATE_FORMAT(n.note_date, '%Y-%m-%d') AS note_date,
        n.numeric_raw
      FROM notes n
      LEFT JOIN materials m ON m.id = n.material_id
      ORDER BY n.note_date DESC, n.id DESC
    `);
    const [materials] = await req.db.query(`
      SELECT id, material_name FROM materials ORDER BY material_name
    `);

    res.render("notes/index", {
      title: "الملاحظات",
      notes: rows.map(applyNoteRaw),
      materials,
    });
  } catch (err) {
    console.error('listNotes error:', err);
    req.flash('error_msg', 'حدث خطأ أثناء جلب الملاحظات');
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
        DATE_FORMAT(n.note_date, '%d/%m/%Y') AS note_date_fmt,
        n.numeric_raw
      FROM notes n
      LEFT JOIN materials m ON m.id = n.material_id
      WHERE n.id = ?
    `, [id]);
    if (!rows.length) {
      req.flash('error_msg', 'لم يتم العثور على الملاحظة المطلوبة');
      return res.redirect('/notes');
    }
    const note = applyNoteRaw(rows[0]);
    if (req.headers.accept && req.headers.accept.includes('application/json')) {
      return res.json({ success: true, note });
    }
    res.render('notes/show', { title: 'عرض الملاحظة', note });
  } catch (err) {
    console.error('viewNote error:', err);
    req.flash('error_msg', 'حدث خطأ أثناء جلب الملاحظة');
    res.redirect('/notes');
  }
};

const createNote = async (req, res) => {
  try {
    const { material_id, material_name, price, weight, note_text } = req.body;
    const priceRaw = normalizeRawNumeric(price);
    const weightRaw = normalizeRawNumeric(weight);
    const parsedPrice = priceRaw !== null ? parseFloat(priceRaw) : null;
    const parsedWeight = weightRaw !== null ? parseFloat(weightRaw) : null;
    const noteRawMap = buildRawNumericMap(req.body, NOTE_RAW_FIELDS);

    let materialIdForInsert = null;
    if (material_id !== undefined && material_id !== '') {
      const maybeId = parseInt(material_id);
      if (!Number.isNaN(maybeId) && maybeId > 0) {
        const [mats] = await req.db.query('SELECT id FROM materials WHERE id = ? LIMIT 1', [maybeId]);
        if (mats.length > 0) materialIdForInsert = maybeId;
      }
    }

    await req.db.query(`
      INSERT INTO notes (material_id, material_name, price, weight, note_date, note_text, numeric_raw)
      VALUES (?, ?, ?, ?, NOW(), ?, ?)
    `, [
      materialIdForInsert,
      (material_name || null),
      parsedPrice,
      parsedWeight,
      note_text || null,
      JSON.stringify(noteRawMap)
    ]);

    res.json({ success: true });
  } catch (err) {
    console.error('createNote error:', err);
    res.status(500).json({ success: false, message: 'حدث خطأ أثناء إنشاء الملاحظة' });
  }
};

const updateNote = async (req, res) => {
  try {
    const { id } = req.params;
    const { material_id, material_name, price, weight, note_text } = req.body;
    const priceRaw = normalizeRawNumeric(price);
    const weightRaw = normalizeRawNumeric(weight);
    const parsedPrice = priceRaw !== null ? parseFloat(priceRaw) : null;
    const parsedWeight = weightRaw !== null ? parseFloat(weightRaw) : null;
    const noteRawMap = buildRawNumericMap(req.body, NOTE_RAW_FIELDS);

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
      SET material_id = ?, material_name = ?, price = ?, weight = ?, note_date = NOW(), note_text = ?, numeric_raw = ?
      WHERE id = ?
    `, [
      materialIdForUpdate,
      (material_name || null),
      parsedPrice,
      parsedWeight,
      note_text || null,
      JSON.stringify(noteRawMap),
      id
    ]);

    res.json({ success: true });
  } catch (err) {
    console.error('updateNote error:', err);
    res.status(500).json({ success: false, message: 'حدث خطأ أثناء تحديث الملاحظة' });
  }
};

const deleteNote = async (req, res) => {
  try {
    const { id } = req.params;
    await req.db.query('DELETE FROM notes WHERE id = ?', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error('deleteNote error:', err);
    res.status(500).json({ success: false, message: 'حدث خطأ أثناء حذف الملاحظة' });
  }
};

const exportNotesPDF = async (req, res) => {
  const pdf = require('html-pdf-node');
  try {
    const [rows] = await req.db.query(`
      SELECT 
        n.id,
        n.material_id,
        COALESCE(NULLIF(n.material_name, ''), m.material_name) AS material_name,
        n.price,
        n.weight,
        n.note_text,
        n.note_date,
        n.numeric_raw
      FROM notes n
      LEFT JOIN materials m ON m.id = n.material_id
      ORDER BY n.note_date DESC, n.id DESC
    `);

    const notes = rows.map(applyNoteRaw);
    const baseUrl = process.env.BASE_URL || `${req.protocol}://${req.get('host')}`;

    req.app.render('notes/print', { notes, baseUrl, layout: false }, async (err, html) => {
      if (err) {
        console.error('Render notes print failed:', err);
        return res.status(500).json({ success: false, message: 'تعذر إنشاء ملف الطباعة.' });
      }

      try {
        const options = {
          format: 'A4',
          preferCSSPageSize: true,
          printBackground: true,
          timeout: 120000,
          puppeteerArgs: {
            args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage', '--disable-gpu', '--no-zygote'],
            executablePath: process.env.PUPPETEER_EXECUTABLE_PATH || process.env.CHROME_PATH || undefined
          }
        };

        const pdfBuffer = await generatePdfWithMetrics(pdf, { content: html }, options, 'notes-list');
        const fileName = `${uuidv4()}.pdf`;
        const savePath = path.join(__dirname, '../public/notes_pdf', fileName);
        fs.mkdirSync(path.dirname(savePath), { recursive: true });
        await fs.promises.writeFile(savePath, pdfBuffer);

        return res.json({
          success: true,
          url: `${baseUrl}/public/notes_pdf/${fileName}`
        });
      } catch (pdfError) {
        console.error('Notes PDF generation failed:', pdfError);
        return res.status(500).json({ success: false, message: 'حدث خطأ أثناء إنشاء ملف PDF.' });
      }
    });
  } catch (err) {
    console.error('exportNotesPDF error:', err);
    return res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير الملاحظات.' });
  }
};

module.exports = {
  listNotes,
  viewNote,
  createNote,
  updateNote,
  deleteNote,
  exportNotesPDF,
};


