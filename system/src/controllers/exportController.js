const Excel = require('exceljs');
const { pool } = require('../database/db');
const { parseRawNumericMap, rawOrValue } = require('../utils/rawNumbers');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

function convertDateToISO(dateString) {
    if (!dateString) return null;
    if (dateString.includes('-') && dateString.length === 10) return dateString;
    if (dateString.includes('/')) {
        const [day, month, year] = dateString.split('/');
        return `${year}-${String(month || '').padStart(2, '0')}-${String(day || '').padStart(2, '0')}`;
    }
    return dateString;
}

function parseIds(rawIds) {
    if (!rawIds) return [];
    const values = Array.isArray(rawIds) ? rawIds : String(rawIds).split(',');
    return values
        .map((value) => parseInt(String(value).trim(), 10))
        .filter((value) => Number.isFinite(value) && value > 0);
}

exports.exportInventoryToExcel = async (req, res) => {
    try {
        const { date, supplier, sample_number, positive_quantity, ids } = req.query || {};

        // Create a new workbook and worksheet
        const workbook = new Excel.Workbook();
        const worksheet = workbook.addWorksheet('المخزون');

        // Set RTL direction for the worksheet
        worksheet.views = [{ rightToLeft: true }];

        // Define columns
        worksheet.columns = [
            { header: 'رقم العينة', key: 'sample_number', width: 15 },
            { header: 'اسم المورد/العينة', key: 'supplier_or_sample_name', width: 30 },
            { header: 'التاريخ', key: 'date', width: 15 },
            { header: 'الكمية الأساسية', key: 'base_quantity', width: 15 },
            { header: 'الكمية الحالية', key: 'current_quantity', width: 15 },
            { header: 'الوزن الصافي', key: 'net_weight_total', width: 15 },
            { header: 'وزن التعبئة', key: 'sample_weight', width: 15 },
            { header: 'درجة الحموضة', key: 'ph', width: 10 },
            { header: 'رقم البيروكسيد', key: 'peroxide_value', width: 15 },
            { header: 'امتصاص 232', key: 'abs_232', width: 12 },
            { header: 'امتصاص 266', key: 'abs_266', width: 12 },
            { header: 'امتصاص 270', key: 'abs_270', width: 12 },
            { header: 'امتصاص 274', key: 'abs_274', width: 12 },
            { header: 'Delta K', key: 'delta_k', width: 12 },
            { header: 'ستيجما ستاديين', key: 'sigma_absorbance', width: 15 },
            { header: 'المحلل', key: 'analyst', width: 20 },
            { header: 'ملاحظات', key: 'notes', width: 30 }
        ];

        // Style the header row
        worksheet.getRow(1).font = { bold: true, size: 12 };
        worksheet.getRow(1).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FFE0E0E0' }
        };

        // Get data from database
        let sql = `
            SELECT 
                i.sample_number,
                i.supplier_or_sample_name,
                DATE_FORMAT(i.date, '%Y-%m-%d') as date,
                i.base_quantity,
                i.current_quantity,
                i.net_weight_total,
                i.sample_weight,
                i.ph,
                i.peroxide_value,
                SUBSTRING_INDEX(SUBSTRING_INDEX(i.absorption_readings, ' ', 1), ' ', -1) as abs_232,
                SUBSTRING_INDEX(SUBSTRING_INDEX(i.absorption_readings, ' ', 2), ' ', -1) as abs_266,
                SUBSTRING_INDEX(SUBSTRING_INDEX(i.absorption_readings, ' ', 3), ' ', -1) as abs_270,
                SUBSTRING_INDEX(SUBSTRING_INDEX(i.absorption_readings, ' ', 4), ' ', -1) as abs_274,
                SUBSTRING_INDEX(i.absorption_readings, ' ', -1) as delta_k,
                i.sigma_absorbance,
                i.numeric_raw,
                i.analyst,
                i.notes
            FROM inventory i
            WHERE i.deleted_at IS NULL
        `;
        const params = [];

        if (date) {
            const formattedDate = convertDateToISO(String(date).trim());
            if (formattedDate) {
                sql += ` AND DATE(i.date) = ?`;
                params.push(formattedDate);
            }
        }

        if (supplier) {
            sql += ` AND i.supplier_or_sample_name LIKE ?`;
            params.push(`%${String(supplier).trim()}%`);
        }

        if (sample_number) {
            sql += ` AND i.sample_number LIKE ?`;
            params.push(`%${String(sample_number).trim()}%`);
        }

        if (positive_quantity === '1') {
            sql += ` AND i.current_quantity > 0`;
        }

        const selectedIds = parseIds(ids);
        if (selectedIds.length > 0) {
            sql += ` AND i.id IN (?)`;
            params.push(selectedIds);
        }

        sql += ` ORDER BY CAST(i.sample_number AS UNSIGNED) DESC`;

        const [rows] = await pool.query(sql, params);

        // Add rows to worksheet
        rows.forEach((row) => {
            const rawMap = parseRawNumericMap(row.numeric_raw);
            worksheet.addRow({
                ...row,
                base_quantity: rawOrValue(rawMap, 'base_quantity', row.base_quantity),
                current_quantity: rawOrValue(rawMap, 'current_quantity', row.current_quantity),
                net_weight_total: rawOrValue(rawMap, 'net_weight_total', row.net_weight_total),
                sample_weight: rawOrValue(rawMap, 'sample_weight', row.sample_weight),
                ph: rawOrValue(rawMap, 'ph', row.ph),
                peroxide_value: rawOrValue(rawMap, 'peroxide_value', row.peroxide_value),
                sigma_absorbance: rawOrValue(rawMap, 'sigma_absorbance', row.sigma_absorbance)
            });
        });

        // Set borders for all cells
        worksheet.eachRow((row, rowNumber) => {
            row.eachCell((cell) => {
                cell.border = {
                    top: { style: 'thin' },
                    left: { style: 'thin' },
                    bottom: { style: 'thin' },
                    right: { style: 'thin' }
                };
                // Center align all cells
                cell.alignment = { horizontal: 'center', vertical: 'middle' };
            });
        });

        // Auto-fit columns
        worksheet.columns.forEach(column => {
            column.width = Math.max(column.width || 10, 10);
        });

        // Set response headers
        res.setHeader(
            'Content-Type',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        );
        res.setHeader(
            'Content-Disposition',
            'attachment; filename=inventory-' + Date.now() + '.xlsx'
        );

        // Write to response
        await workbook.xlsx.write(res);
        res.end();
    } catch (error) {
        console.error('Error exporting inventory:', error);
        res.status(500).json({
            success: false,
            message: 'حدث خطأ أثناء تصدير البيانات'
        });
    }
};

exports.exportNotesToExcel = async (req, res) => {
    try {
        const { ids } = req.query || {};
        const selectedIds = parseIds(ids);

        const workbook = new Excel.Workbook();
        const worksheet = workbook.addWorksheet('الملاحظات');
        worksheet.views = [{ rightToLeft: true }];

        worksheet.columns = [
            { header: 'رقم', key: 'id', width: 10 },
            { header: 'اسم المادة', key: 'material_name', width: 30 },
            { header: 'السعر', key: 'price', width: 12 },
            { header: 'الوزن', key: 'weight', width: 12 },
            { header: 'التاريخ', key: 'note_date', width: 15 },
            { header: 'الملاحظات', key: 'note_text', width: 40 }
        ];

        worksheet.getRow(1).font = { bold: true, size: 12 };
        worksheet.getRow(1).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FFE0E0E0' }
        };

        let sql = `
            SELECT 
                n.id,
                COALESCE(NULLIF(n.material_name, ''), m.material_name) AS material_name,
                n.price,
                n.weight,
                n.note_text,
                DATE_FORMAT(n.note_date, '%Y-%m-%d') AS note_date,
                n.numeric_raw
            FROM notes n
            LEFT JOIN materials m ON m.id = n.material_id
            WHERE 1 = 1
        `;
        const params = [];

        if (selectedIds.length > 0) {
            sql += ` AND n.id IN (?)`;
            params.push(selectedIds);
        }

        sql += ` ORDER BY n.note_date DESC, n.id DESC`;

        const [rows] = await pool.query(sql, params);
        rows.forEach((row) => {
            const rawMap = parseRawNumericMap(row.numeric_raw);
            worksheet.addRow({
                id: row.id,
                material_name: row.material_name || '-',
                price: rawOrValue(rawMap, 'price', row.price),
                weight: rawOrValue(rawMap, 'weight', row.weight),
                note_date: row.note_date || '-',
                note_text: row.note_text || '-'
            });
        });

        worksheet.eachRow((row) => {
            row.eachCell((cell) => {
                cell.border = {
                    top: { style: 'thin' },
                    left: { style: 'thin' },
                    bottom: { style: 'thin' },
                    right: { style: 'thin' }
                };
                cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: true };
            });
        });

        worksheet.columns.forEach(column => {
            column.width = Math.max(column.width || 10, 10);
        });

        res.setHeader(
            'Content-Type',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        );
        res.setHeader(
            'Content-Disposition',
            'attachment; filename=notes-' + Date.now() + '.xlsx'
        );

        await workbook.xlsx.write(res);
        res.end();
    } catch (error) {
        console.error('Error exporting notes:', error);
        res.status(500).json({
            success: false,
            message: 'حدث خطأ أثناء تصدير الملاحظات'
        });
    }
};

exports.exportNotesToPdf = async (req, res) => {
    try {
        const ids = Array.isArray(req.body?.ids) ? req.body.ids : [];
        const selectedIds = ids
            .map((value) => parseInt(String(value).trim(), 10))
            .filter((value) => Number.isFinite(value) && value > 0);
        if (!selectedIds.length) {
            return res.status(400).json({ success: false, message: 'يرجى تحديد ملاحظات للتصدير' });
        }

        let sql = `
            SELECT 
                n.id,
                COALESCE(NULLIF(n.material_name, ''), m.material_name) AS material_name,
                n.price,
                n.weight,
                n.note_text,
                DATE_FORMAT(n.note_date, '%Y-%m-%d') AS note_date,
                n.numeric_raw
            FROM notes n
            LEFT JOIN materials m ON m.id = n.material_id
            WHERE n.id IN (?)
            ORDER BY n.note_date DESC, n.id DESC
        `;
        const [rows] = await pool.query(sql, [selectedIds]);
        if (!rows.length) {
            return res.status(404).json({ success: false, message: 'لا توجد ملاحظات صالحة للتصدير' });
        }

        const notes = rows.map((row) => {
            const rawMap = parseRawNumericMap(row.numeric_raw);
            return {
                id: row.id,
                material_name: row.material_name || '-',
                price: rawOrValue(rawMap, 'price', row.price),
                weight: rawOrValue(rawMap, 'weight', row.weight),
                note_date: row.note_date || '-',
                note_text: row.note_text || '-'
            };
        });

        const pdf = require('html-pdf-node');
        const baseUrl = process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}`;
        req.app.render('notes/notes-print-list', {
            title: 'قائمة الملاحظات',
            notes,
            baseUrl,
            layout: false
        }, async (err, html) => {
            if (err) {
                console.error('Render notes PDF failed:', err);
                return res.status(500).json({ success: false, message: 'تعذر إنشاء ملف PDF' });
            }
            const options = {
                format: 'A4',
                preferCSSPageSize: true,
                printBackground: true,
                margin: { top: '14mm', right: '14mm', bottom: '14mm', left: '14mm' }
            };
            const pdfBuffer = await pdf.generatePdf({ content: html }, options);
            const fileName = `${uuidv4()}.pdf`;
            const savePath = path.join(__dirname, '../public/notes_list_pdf', fileName);
            fs.mkdirSync(path.dirname(savePath), { recursive: true });
            fs.writeFileSync(savePath, pdfBuffer);

            return res.json({
                success: true,
                url: `${baseUrl}/public/notes_list_pdf/${fileName}`
            });
        });
    } catch (error) {
        console.error('Error exporting notes to PDF:', error);
        res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير ملف PDF' });
    }
};
