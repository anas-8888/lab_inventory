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
router.post('/cost-statement', isAuthenticated, isAdmin, costsController.createMaterial);
router.put('/cost-statement/:id', isAuthenticated, isAdmin, costsController.updateMaterial);
router.delete('/cost-statement/:id', isAuthenticated, isAdmin, costsController.deleteMaterial);

// المرحلة الثانية: عروض الأسعار
router.get('/quotations', isAuthenticated, isAdmin, costsController.getQuotations);
router.post('/quotations', isAuthenticated, isAdmin, costsController.createQuotation);
router.get('/quotations/:id', isAuthenticated, isAdmin, costsController.getQuotationDetails);
router.delete('/quotations/:id', isAuthenticated, isAdmin, costsController.deleteQuotation);

// المرحلة الثالثة: الطلبيات
router.get('/orders', isAuthenticated, isAdmin, costsController.getOrders);
router.get('/orders/:id', isAuthenticated, isAdmin, costsController.getOrder);
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