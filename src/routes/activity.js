/**
 * Activity Routes
 * مسارات سجل الحركات
 */

const express = require('express');
const router = express.Router();
const activityController = require('../controllers/activityController');
const { isAuthenticated, isAdmin } = require('../middleware/auth');

// عرض صفحة سجل الحركات (Admin فقط)
router.get('/', isAuthenticated, isAdmin, activityController.getActivityLogs);

// API لجلب تفاصيل سجل معين (Admin فقط)
router.get('/details/:id', isAuthenticated, isAdmin, activityController.getActivityDetails);

// تصدير سجل الحركات إلى CSV (Admin فقط)
router.get('/export', isAuthenticated, isAdmin, activityController.exportActivityLogs);

// API للحصول على إحصائيات السجل (Admin فقط)
router.get('/api/stats', isAuthenticated, isAdmin, activityController.getActivityStats);

module.exports = router;
