const express = require('express');
const router = express.Router();
const { isAuthenticated, isAdmin } = require('../middleware/auth');
const costsController = require('../controllers/costsController');

// الصفحة الرئيسية للتكاليف
router.get('/', isAuthenticated, isAdmin, costsController.getCosts);

// المرحلة الأولى: بيان الكلفة
router.get('/cost-statement', isAuthenticated, isAdmin, costsController.getCostStatement);
// مسارات عامة وثابتة يجب أن تسبق المسارات الديناميكية
router.get('/cost-statement/print-list', costsController.getMaterialsListPrintPage);
router.get('/cost-statement/print-list-pdf-raw', costsController.getMaterialsListPrintPage);
// تصدير PDF لقائمة المواد (رندر محلي)
router.get('/cost-statement/export/pdf', async (req, res) => {
  try {
    const pdf = require('html-pdf-node');
    const path = require('path');
    const fs = require('fs');
    const { v4: uuidv4 } = require('uuid');

    const baseUrl = process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}`;
    const file = { url: `${baseUrl}/costs/cost-statement/print-list-pdf-raw` };

    const executablePath = process.env.PUPPETEER_EXECUTABLE_PATH || process.env.CHROME_PATH || undefined;
    const options = {
      format: 'A4',
      preferCSSPageSize: true,
      printBackground: true,
      margin: { top: '10mm', right: '10mm', bottom: '10mm', left: '10mm' },
      timeout: 120000,
      puppeteerArgs: {
        args: ['--no-sandbox','--disable-setuid-sandbox','--disable-dev-shm-usage','--disable-gpu','--no-zygote'],
        executablePath
      }
    };

    let pdfBuffer;
    try {
      pdfBuffer = await pdf.generatePdf(file, options);
    } catch (e) {
      console.error('PDF generation failed (list):', e);
      const fallbackUrl = `${baseUrl}/costs/cost-statement/print-list`;
      return res.json({ success: true, url: fallbackUrl, fallback: true });
    }

    const fileName = `${uuidv4()}.pdf`;
    const savePath = path.join(__dirname, '../public/materials_list_pdf', fileName);
    fs.mkdirSync(path.dirname(savePath), { recursive: true });
    fs.writeFileSync(savePath, pdfBuffer);
    const fileUrl = `${baseUrl}/public/materials_list_pdf/${fileName}`;
    res.json({ success: true, url: fileUrl });
  } catch (error) {
    console.error('Error exporting materials list PDF:', error);
    res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير قائمة المواد كـ PDF' });
  }
});
router.get('/cost-statement/:id', isAuthenticated, isAdmin, costsController.getMaterial);
router.get('/cost-statement/:id/components', isAuthenticated, isAdmin, costsController.getMaterialComponents);
router.get('/cost-statement/:id/logs', isAuthenticated, isAdmin, costsController.getMaterialCostLogs);
router.get('/cost-statement/:id/preview', isAuthenticated, isAdmin, costsController.getMaterialPreview);
router.get('/cost-statement/:id/print', costsController.getMaterialPrintPage);
router.get('/cost-statement/:id/print-pdf-raw', costsController.getMaterialPrintPage);
router.get('/cost-statement/:id/pdf', async (req, res) => {
  try {
    const pdf = require('html-pdf-node');
    const path = require('path');
    const fs = require('fs');
    const { v4: uuidv4 } = require('uuid');

    const baseUrl = process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}`;
    const file = { url: `${baseUrl}/costs/cost-statement/${req.params.id}/print-pdf-raw` };

    const executablePath = process.env.PUPPETEER_EXECUTABLE_PATH || process.env.CHROME_PATH || undefined;
    const options = {
      format: 'A4',
      preferCSSPageSize: true,
      printBackground: true,
      margin: { top: '10mm', right: '10mm', bottom: '10mm', left: '10mm' },
      timeout: 120000,
      puppeteerArgs: {
        args: ['--no-sandbox','--disable-setuid-sandbox','--disable-dev-shm-usage','--disable-gpu','--no-zygote'],
        executablePath
      }
    };

    let pdfBuffer;
    try {
      pdfBuffer = await pdf.generatePdf(file, options);
    } catch (e) {
      console.error('PDF generation failed (material):', e);
      const fallbackUrl = `${baseUrl}/costs/cost-statement/${req.params.id}/print`;
      return res.json({ success: true, url: fallbackUrl, fallback: true });
    }

    const fileName = `${uuidv4()}.pdf`;
    const savePath = path.join(__dirname, '../public/materials_list_pdf', fileName);
    fs.mkdirSync(path.dirname(savePath), { recursive: true });
    fs.writeFileSync(savePath, pdfBuffer);
    const fileUrl = `${baseUrl}/public/materials_list_pdf/${fileName}`;
    res.json({ success: true, url: fileUrl });
  } catch (error) {
    console.error('Error exporting material PDF:', error);
    res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير المادة كـ PDF' });
  }
});
// طباعة قائمة كل المواد (عرض وطباعة)
router.get('/cost-statement/print-list', costsController.getMaterialsListPrintPage);
router.get('/cost-statement/print-list-pdf-raw', costsController.getMaterialsListPrintPage);
// تصدير PDF لقائمة المواد
router.get('/cost-statement/export/pdf', async (req, res) => {
  try {
    const pdf = require('html-pdf-node');
    const path = require('path');
    const fs = require('fs');
    const { v4: uuidv4 } = require('uuid');
    // بدلاً من جلب HTML عبر HTTP (قد يصطدم بالمصادقة)، قم بالرندر محلياً
    const [materials] = await req.db.query(`SELECT * FROM materials ORDER BY created_at DESC`);
    const isSyp = req.defaultCurrency && req.defaultCurrency.code === 'SYP';
    const displayMaterials = materials.map(m => ({
      ...m,
      unit_cost: isSyp ? (m.unit_cost_syp || m.unit_cost) : m.unit_cost,
      package_cost: isSyp ? (m.package_cost_syp || m.package_cost) : m.package_cost
    }));
    const locals = { title: 'طباعة قائمة المواد', materials: displayMaterials, defaultCurrency: req.defaultCurrency || null, layout: false };
    req.app.render('costs/materials-print-list', locals, async (err, html) => {
      if (err) {
        console.error('Render materials list failed:', err);
        return res.status(500).json({ success: false, message: 'تعذر إنشاء الملف' });
      }
      const options = { format: 'A4', preferCSSPageSize: true };
      const pdfBuffer = await pdf.generatePdf({ content: html }, options);
      const fileName = `${uuidv4()}.pdf`;
      const savePath = path.join(__dirname, '../public/materials_list_pdf', fileName);
      fs.mkdirSync(path.dirname(savePath), { recursive: true });
      fs.writeFileSync(savePath, pdfBuffer);
      const fileUrl = `${process.env.BASE_URL}/public/materials_list_pdf/${fileName}`;
      res.json({ success: true, url: fileUrl });
    });
  } catch (error) {
    console.error('Error exporting materials list PDF:', error);
    res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير قائمة المواد كـ PDF' });
  }
});
router.post('/cost-statement', isAuthenticated, isAdmin, costsController.createMaterial);
router.put('/cost-statement/:id', isAuthenticated, isAdmin, costsController.updateMaterial);
router.delete('/cost-statement/:id', isAuthenticated, isAdmin, costsController.deleteMaterial);

// المرحلة الثانية: عروض الأسعار
router.get('/quotations', isAuthenticated, isAdmin, costsController.getQuotations);
router.post('/quotations', isAuthenticated, isAdmin, costsController.createQuotation);
router.get('/quotations/:id', isAuthenticated, isAdmin, costsController.getQuotationDetails);
router.get('/quotations/:id/print', isAuthenticated, isAdmin, costsController.getQuotationPrintPage);
router.get('/quotations/:id/print-pdf-raw', costsController.getQuotationPrintRaw);
router.get('/quotations/:id/pdf', isAuthenticated, isAdmin, costsController.exportQuotationPDF);
router.get('/quotations/:id/json', isAuthenticated, isAdmin, costsController.getQuotationJson);
router.put('/quotations/:id', isAuthenticated, isAdmin, costsController.updateQuotation);
router.delete('/quotations/:id', isAuthenticated, isAdmin, costsController.deleteQuotation);

// المرحلة الثالثة: الطلبيات
router.get('/orders', isAuthenticated, isAdmin, costsController.getOrders);
router.get('/orders/:id', isAuthenticated, isAdmin, costsController.getOrder);
router.get('/orders/:id/details', isAuthenticated, isAdmin, costsController.getOrderDetailsPage);
router.get('/orders/:id/print', isAuthenticated, isAdmin, costsController.getOrderPrintPage);
router.get('/orders/:id/print-pdf-raw', costsController.getOrderPrintRaw);
router.get('/orders/:id/pdf', isAuthenticated, isAdmin, costsController.exportOrderPDF);
router.post('/orders', isAuthenticated, isAdmin, costsController.createOrder);
router.put('/orders/:id', isAuthenticated, isAdmin, costsController.updateOrder);
router.put('/orders/:id/status', isAuthenticated, isAdmin, costsController.updateOrderStatus);
router.delete('/orders/:id', isAuthenticated, isAdmin, costsController.deleteOrder);

// إضافة routes للعملات
const currencyController = require('../controllers/currencyController');

// إعدادات العملة
router.get('/currency-settings', isAuthenticated, isAdmin, currencyController.getCurrencySettings);
router.post('/currency-settings/default', isAuthenticated, isAdmin, currencyController.updateDefaultCurrency);
router.post('/currency-settings/exchange-rate', isAuthenticated, isAdmin, currencyController.updateExchangeRate);
router.get('/currency-settings/default', isAuthenticated, isAdmin, currencyController.getDefaultCurrency);
router.post('/currency-settings/convert', isAuthenticated, isAdmin, currencyController.convertCurrency);

module.exports = router; 