const express = require('express');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const { isAdmin } = require('../middleware/auth');
const { createRateLimiter } = require('../middleware/simpleRateLimiter');
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
  limits: { fileSize: 5 * 1024 * 1024, files: 30 },
  fileFilter: (req, file, cb) => {
    const ext = path.extname(file.originalname || '').toLowerCase();
    const allowedExt = new Set(['.jpg', '.jpeg', '.png', '.webp', '.gif', '.svg']);
    const allowedMime = new Set([
      'image/jpeg',
      'image/png',
      'image/webp',
      'image/gif',
      'image/svg+xml'
    ]);
    if (allowedExt.has(ext) && allowedMime.has((file.mimetype || '').toLowerCase())) {
      return cb(null, true);
    }
    return cb(new Error('يسمح فقط برفع الصور')); 
  }
});

const publicContentLimiter = createRateLimiter({
  keyPrefix: 'site-public-content',
  windowMs: 60 * 1000,
  max: 120,
  message: 'عدد كبير من الطلبات، حاول مجددًا بعد دقيقة.'
});

const contactMessageLimiter = createRateLimiter({
  keyPrefix: 'site-contact-messages',
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: 'تم تجاوز عدد الرسائل المسموح، حاول لاحقًا.'
});

router.post(
  '/contact-messages',
  contactMessageLimiter,
  upload.array('attachments', 5),
  controller.createContactMessage
);
router.get('/public/logo', publicContentLimiter, controller.getPublicLogo);
router.get('/public/icon', publicContentLimiter, controller.getPublicIcon);
router.get('/public/categories', publicContentLimiter, controller.getPublicProductCategories);
router.get('/public/products', publicContentLimiter, controller.getPublicProducts);
router.get('/public-content', publicContentLimiter, controller.getPublicSiteContent);
router.post('/contact-messages/:id/delete', isAdmin, controller.deleteContactMessage);
router.get('/', isAdmin, controller.getSiteContentIndex);
router.get('/:id', isAdmin, controller.getSiteContentDetails);
router.get('/:id/edit', isAdmin, controller.getEditSiteContent);
router.post('/:id/update', isAdmin, upload.any(), controller.updateSiteContent);

module.exports = router;
