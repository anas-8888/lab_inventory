const express = require('express');
const router = express.Router();
const { exportInventoryToExcel, exportNotesToExcel, exportNotesToPdf } = require('../controllers/exportController');
const { authMiddleware } = require('../middleware/auth');

// Apply authentication middleware to all export routes
router.use(authMiddleware);

// Route to export inventory to Excel
router.get('/inventory/excel', exportInventoryToExcel);
// Route to export notes to Excel
router.get('/notes/excel', exportNotesToExcel);
// Route to export notes to PDF
router.post('/notes/pdf-selected', exportNotesToPdf);

module.exports = router; 
