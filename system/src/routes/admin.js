const express = require('express');
const router = express.Router();
const { isAuthenticated, isAdmin } = require('../middleware/auth');
const adminController = require('../controllers/adminController');

router.post('/settings/database-backup', isAuthenticated, isAdmin, adminController.exportDatabaseBackup);

module.exports = router;

