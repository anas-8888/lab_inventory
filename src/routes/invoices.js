const express = require('express');
const router = express.Router();
const invoiceController = require('../controllers/invoiceController');
const { isAuthenticated, isShippingCrud } = require('../middleware/auth');
const { validateInvoice, validate, validateInventoryAvailability } = require('../middleware/validators');

// عرض قائمة طلبات  الشحن
router.get('/', isAuthenticated, isShippingCrud, invoiceController.getInvoices);

// API لجلب المخزون
router.get('/api/inventory', isAuthenticated, isShippingCrud, invoiceController.getInventoryAPI);

// عرض نموذج إنشاء طلبية شحن جديدة
router.get('/create', isAuthenticated, isShippingCrud, invoiceController.getCreateForm);

// Middleware لمعالجة البيانات قبل validation
const preprocessInvoiceData = (req, res, next) => {
    
    // إزالة الحقول quantities[xxx] غير المرغوب فيها
    if (req.body) {
        Object.keys(req.body).forEach(key => {
            if (key.startsWith('quantities[') && key.endsWith(']')) {
                delete req.body[key];
            }
        });
    }
    
    // معالجة quantities إذا كانت string
    if (req.body.quantities && typeof req.body.quantities === 'string') {
        try {
            req.body.quantities = JSON.parse(req.body.quantities);
        } catch (e) {
            // سيتم التعامل مع هذا في validation
        }
    }
    
    // التأكد من أن جميع الحقول النصية مُعرفة
    if (req.body) {
        req.body.customer_name = req.body.customer_name || '';
        req.body.driver_name = req.body.driver_name || '';
        req.body.date = req.body.date || '';
        req.body.invoice_number = req.body.invoice_number || '';
        req.body.notes = req.body.notes || '';
    }
    
    next();
};

// إنشاء طلبية شحن جديدة
router.post('/create', isAuthenticated, isShippingCrud, preprocessInvoiceData, validateInvoice, validateInventoryAvailability, validate, invoiceController.createInvoice);

// مسارات سلة المحذوفات والحذف الجماعي (يجب أن تكون قبل /:id)
router.post('/trash-multiple', isAuthenticated, isShippingCrud, invoiceController.trashMultiple);
router.get('/deleted', isAuthenticated, isShippingCrud, invoiceController.getDeletedInvoices);
router.post('/restore-multiple', isAuthenticated, isShippingCrud, invoiceController.restoreMultiple);
router.post('/empty-trash', isAuthenticated, isShippingCrud, invoiceController.emptyTrash);
router.delete('/delete-multiple', isAuthenticated, isShippingCrud, invoiceController.deleteMultiple);

// طباعة طلبية شحن
router.get('/:id/print', isAuthenticated, isShippingCrud, invoiceController.printInvoice);

// طباعة طلبية شحن بدون حماية الجلسة (مخصص لتوليد PDF)
router.get('/:id/print-pdf-raw', invoiceController.printInvoice);

// حذف طلبية شحن
router.delete('/:id', isAuthenticated, isShippingCrud, invoiceController.deleteInvoice);

// عرض نموذج تعديل طلب الشحن
router.get('/:id/edit', isAuthenticated, isShippingCrud, invoiceController.getEditForm);

// تحديث طلب الشحن
router.put('/:id', isAuthenticated, isShippingCrud, validateInvoice, validateInventoryAvailability, validate, invoiceController.updateInvoice);

// استعادة طلبية شحن واحدة
router.post('/:id/restore', isAuthenticated, isShippingCrud, invoiceController.restoreInvoice);

// تصدير طلب الشحن كـ PDF
router.get('/:id/pdf', isAuthenticated, isShippingCrud, invoiceController.exportInvoicePDF);

// تحديث حالة طلب الشحن
router.put('/:id/status', isAuthenticated, isShippingCrud, invoiceController.updateInvoiceStatus);

// عرض طلبية شحن - يجب أن يكون آخر مسار
router.get('/:id', isAuthenticated, isShippingCrud, invoiceController.getInvoice);

module.exports = router; 
