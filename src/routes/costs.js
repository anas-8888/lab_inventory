const express = require('express');
const router = express.Router();
const { isAuthenticated, isAdmin } = require('../middleware/auth');
const costsController = require('../controllers/costsController');

// الصفحة الرئيسية للتكاليف
router.get('/', isAuthenticated, isAdmin, costsController.getCosts);

// المرحلة الأولى: بيان الكلفة
router.get('/cost-statement', isAuthenticated, isAdmin, costsController.getCostStatement);
router.get('/cost-statement/:id', isAuthenticated, isAdmin, costsController.getMaterial);
router.get('/cost-statement/:id/logs', isAuthenticated, isAdmin, costsController.getMaterialCostLogs);
router.get('/cost-statement/:id/preview', isAuthenticated, isAdmin, costsController.getMaterialPreview);
router.get('/cost-statement/:id/print', isAuthenticated, isAdmin, costsController.getMaterialPrintPage);
router.get('/cost-statement/:id/print-pdf-raw', costsController.getMaterialPrintPage);
router.get('/cost-statement/:id/pdf', isAuthenticated, isAdmin, async (req, res) => {
  try {
    const pdf = require('html-pdf-node');
    const path = require('path');
    const fs = require('fs');
    const { v4: uuidv4 } = require('uuid');
    const url = `${process.env.BASE_URL}/costs/cost-statement/${req.params.id}/print-pdf-raw`;
    const options = { format: 'A4' };
    const file = { url };
    const fileName = `${uuidv4()}.pdf`;
    const savePath = path.join(__dirname, '../public/materials_pdf', fileName);
    const pdfBuffer = await pdf.generatePdf(file, options);
    fs.mkdirSync(path.dirname(savePath), { recursive: true });
    fs.writeFileSync(savePath, pdfBuffer);
    const fileUrl = `${process.env.BASE_URL}/public/materials_pdf/${fileName}`;
    res.json({ success: true, url: fileUrl });
  } catch (error) {
    console.error('Error exporting material PDF:', error);
    res.status(500).json({ success: false, message: 'حدث خطأ أثناء تصدير المادة كـ PDF' });
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