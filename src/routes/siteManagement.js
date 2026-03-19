const express = require('express');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const { isAdmin } = require('../middleware/auth');
const controller = require('../controllers/siteManagementController');

const router = express.Router();

const uploadDir = path.join(__dirname, '../public/website_images');
fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname || '').toLowerCase();
    const safeExt = ['.jpg', '.jpeg', '.png', '.webp', '.gif', '.svg'].includes(ext) ? ext : '.png';
    const base = `website_${Date.now()}_${Math.random().toString(36).slice(2, 10)}`;
    cb(null, `${base}${safeExt}`);
  }
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    if (file.mimetype && file.mimetype.startsWith('image/')) return cb(null, true);
    return cb(new Error('يسمح فقط برفع الصور')); 
  }
});

router.post('/contact-messages', upload.any(), controller.createContactMessage);
router.get('/', isAdmin, controller.getSiteContentIndex);
router.get('/:id', isAdmin, controller.getSiteContentDetails);
router.get('/:id/edit', isAdmin, controller.getEditSiteContent);
router.post('/:id/update', isAdmin, upload.any(), controller.updateSiteContent);

module.exports = router;
