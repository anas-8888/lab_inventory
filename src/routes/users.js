const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { isAuthenticated, isAdmin } = require('../middleware/auth');

// عرض قائمة المستخدمين
router.get('/', isAuthenticated, isAdmin, userController.getUsers);

// عرض نموذج إضافة مستخدم جديد
router.get('/create', isAuthenticated, isAdmin, userController.getCreateForm);

// إضافة مستخدم جديد
router.post('/create', isAuthenticated, isAdmin, userController.createUser);

// عرض نموذج تعديل مستخدم
router.get('/:id/edit', isAuthenticated, isAdmin, userController.getEditForm);

// تحديث بيانات المستخدم
router.post('/:id/edit', isAuthenticated, isAdmin, userController.updateUser);

// حذف مستخدم
router.post('/delete/:id', isAuthenticated, isAdmin, userController.deleteUser);

module.exports = router; 