const express = require('express');
const router = express.Router();
const { isAuthenticated, isAdmin } = require('../middleware/auth');
const costsController = require('../controllers/costsController');

// عرض صفحة التكاليف الرئيسية
router.get('/', isAuthenticated, isAdmin, costsController.getCosts);

// عرض صفحة إنشاء تكلفة جديدة
router.get('/create', isAuthenticated, isAdmin, costsController.getCreateCost);

// إنشاء تكلفة جديدة
router.post('/create', isAuthenticated, isAdmin, costsController.createCost);

module.exports = router; 