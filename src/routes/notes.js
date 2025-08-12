const express = require('express');
const router = express.Router();
const { isAdmin } = require('../middleware/auth');
const notesController = require('../controllers/notesController');

// جميع مسارات الملاحظات للمسؤول فقط
router.get('/', isAdmin, notesController.listNotes);
router.get('/:id', isAdmin, notesController.viewNote);
router.post('/', isAdmin, notesController.createNote);
router.put('/:id', isAdmin, notesController.updateNote);
router.delete('/:id', isAdmin, notesController.deleteNote);

module.exports = router;

