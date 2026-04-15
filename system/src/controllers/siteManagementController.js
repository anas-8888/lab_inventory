const fs = require('fs');
const path = require('path');
const { pool } = require('../database/db');

const TEMPLATE_PATH = path.join(__dirname, '../../site-content-body.example.json');
const PRODUCT_SECTION_DEFS = [
  { key: 'olive_products', defaultAr: 'منتجات الزيتون', defaultEn: 'Olive Products' },
  { key: 'olive_oil', defaultAr: 'زيت الزيتون', defaultEn: 'Olive Oil' },
  { key: 'agri_crops', defaultAr: 'المحاصيل الزراعية', defaultEn: 'Agricultural Crops' }
];

function readTemplateContent() {
  try {
    const raw = fs.readFileSync(TEMPLATE_PATH, 'utf8');
    return JSON.parse(raw);
  } catch (_) {
    return {};
  }
}

function toArray(value) {
  if (Array.isArray(value)) return value;
  if (value === undefined || value === null) return [];
  return [value];
}

function t(value) {
  return String(value == null ? '' : value).trim();
}

function splitList(value) {
  return t(value)
    .split(',')
    .map((x) => x.trim())
    .filter(Boolean);
}

function splitLines(value) {
  return t(value)
    .split(/\r?\n/)
    .map((x) => x.trim())
    .filter(Boolean);
}

function parseJsonSafe(raw, fallback = {}) {
  try {
    return JSON.parse(raw || '{}');
  } catch (_) {
    return fallback;
  }
}

function findFile(files, fieldName) {
  return (files || []).find((f) => f.fieldname === fieldName);
}

function dateOnly(d) {
  if (!d) return '-';
  const dt = new Date(d);
  const dd = String(dt.getDate()).padStart(2, '0');
  const mm = String(dt.getMonth() + 1).padStart(2, '0');
  const yy = dt.getFullYear();
  return `${dd}/${mm}/${yy}`;
}

function extractClientIp(req) {
  const forwardedFor = t(req.headers['x-forwarded-for']);
  if (forwardedFor) {
    return forwardedFor.split(',')[0].trim();
  }
  return t(req.ip || req.connection?.remoteAddress || req.socket?.remoteAddress);
}

function toPublicAssetUrl(req, rawUrl) {
  const value = t(rawUrl);
  if (!value) return '';

  if (/^https?:\/\//i.test(value) || value.startsWith('data:') || value.startsWith('blob:')) {
    return value;
  }

  const origin = `${req.protocol}://${req.get('host')}`;
  if (value.startsWith('/')) {
    return `${origin}${value}`;
  }
  return `${origin}/${value}`;
}

function normalizeLegacyImagePath(rawPath) {
  const value = t(rawPath);
  if (!value) return '';
  if (value.startsWith('/img/')) {
    return `/public/website_images/${value.slice('/img/'.length)}`;
  }
  return value;
}

function isSameAssetPath(a, b) {
  const left = t(a).replace(/\/+$/, '');
  const right = t(b).replace(/\/+$/, '');
  return Boolean(left) && Boolean(right) && left === right;
}

function buildMinimalContent(rawContent, fallbackUpdatedBy = '') {
  const content = rawContent && typeof rawContent === 'object' ? rawContent : {};
  const sections = normalizeProductSections(content);

  return {
    branding: {
      logo: {
        url: t(content?.branding?.logo?.url)
      },
      icon: {
        url: t(content?.branding?.icon?.url)
      }
    },
    products: {
      sections
    },
    updatedBy: t(content?.updatedBy) || t(fallbackUpdatedBy)
  };
}

async function fetchInboxMessages(db) {
  try {
    const [messages] = await db.query(
      `SELECT id, sender_name, sender_phone, message_text, sender_ip, created_at
       FROM website_contact_messages
       ORDER BY created_at DESC
       LIMIT 200`
    );
    if (!messages.length) return [];

    const ids = messages.map((m) => m.id);
    const placeholders = ids.map(() => '?').join(',');
    const [attachmentsRows] = await db.query(
      `SELECT id, message_id, file_url
       FROM website_contact_attachments
       WHERE message_id IN (${placeholders})
       ORDER BY id ASC`,
      ids
    );

    const attachmentsByMessage = attachmentsRows.reduce((acc, row) => {
      if (!acc[row.message_id]) acc[row.message_id] = [];
      acc[row.message_id].push({ id: row.id, file_url: row.file_url });
      return acc;
    }, {});

    return messages.map((msg) => ({
      ...msg,
      created_at_display: msg.created_at
        ? new Date(msg.created_at).toLocaleString('en-GB', { hour12: false })
        : '-',
      attachments: attachmentsByMessage[msg.id] || []
    }));
  } catch (error) {
    if (error && error.code === 'ER_NO_SUCH_TABLE') {
      return [];
    }
    throw error;
  }
}

function normalizeProductSections(contentObj) {
  const content = contentObj || {};
  const sections = (content?.products?.sections && typeof content.products.sections === 'object')
    ? content.products.sections
    : {};

  // Backward compatibility: old structure products.items -> olive_oil.items
  if (!sections.olive_oil && Array.isArray(content?.products?.items)) {
    sections.olive_oil = {
      name: {
        ar: content?.products?.title?.ar || 'زيت الزيتون',
        en: content?.products?.title?.en || 'Olive Oil'
      },
      categories: [],
      items: content.products.items
    };
  }

  PRODUCT_SECTION_DEFS.forEach((def) => {
    if (!sections[def.key] || typeof sections[def.key] !== 'object') {
      sections[def.key] = {};
    }
    if (!sections[def.key].name || typeof sections[def.key].name !== 'object') {
      sections[def.key].name = { ar: def.defaultAr, en: def.defaultEn };
    }
    if (!Array.isArray(sections[def.key].categories)) {
      sections[def.key].categories = [];
    }
    if (!Array.isArray(sections[def.key].items)) {
      sections[def.key].items = [];
    }
  });

  return sections;
}

async function ensureSingletonSiteContent(db, userId = null) {
  const [rows] = await db.query(
    `SELECT id, content_name, site_id, content_json
     FROM website_content
     WHERE deleted_at IS NULL
     ORDER BY id ASC
     LIMIT 1`
  );

  if (rows.length) {
    return rows[0];
  }

  const template = readTemplateContent();
  const siteId = t(template.siteId) || 'default-site';
  const contentName = 'محتوى الموقع الرئيسي';

  const [result] = await db.query(
    `INSERT INTO website_content (content_name, site_id, content_json, created_by)
     VALUES (?, ?, ?, ?)`,
    [contentName, siteId, JSON.stringify(template), userId]
  );

  const [createdRows] = await db.query(
    `SELECT id, content_name, site_id, content_json
     FROM website_content
     WHERE id = ?
     LIMIT 1`,
    [result.insertId]
  );

  return createdRows[0];
}

function buildFormData(contentObj, row = null) {
  const c = buildMinimalContent(contentObj || {}, row?.updated_by || '');
  const productSectionsRaw = normalizeProductSections(c);

  const productSections = {};
  PRODUCT_SECTION_DEFS.forEach((def) => {
    const section = productSectionsRaw[def.key] || {};
    const categories = Array.isArray(section.categories) ? section.categories : [];
    const items = Array.isArray(section.items) ? section.items : [];

    productSections[def.key] = {
      title_ar: section?.name?.ar || def.defaultAr,
      title_en: section?.name?.en || def.defaultEn,
      categories_ar_text: categories.map((x) => (typeof x === 'string' ? x : (x?.ar || ''))).filter(Boolean).join('\n'),
      categories_en_text: categories.map((x) => (typeof x === 'string' ? '' : (x?.en || ''))).join('\n'),
      items: items.map((p) => ({
        id: p?.id || '',
        category_ar: p?.category?.ar || (typeof p?.category === 'string' ? p.category : ''),
        category_en: p?.category?.en || '',
        name_ar: p?.name?.ar || '',
        name_en: p?.name?.en || '',
        description_ar: p?.description?.ar || '',
        description_en: p?.description?.en || '',
        features_ar: Array.isArray(p?.features) ? p.features.map((f) => f?.ar || '').filter(Boolean).join('\n') : '',
        features_en: Array.isArray(p?.features) ? p.features.map((f) => f?.en || '').filter(Boolean).join('\n') : '',
        acidity: p?.acidity || '',
        current_image: normalizeLegacyImagePath(p?.image)
      }))
    };
  });

  return {
    id: row?.id || null,
    content_name: row?.content_name || 'محتوى الموقع',
    site_id: row?.site_id || '',
    updated_by: c.updatedBy || '',

    current_logo_image: c?.branding?.logo?.url || '',
    current_logo_icon: c?.branding?.icon?.url || '',
    productSections
  };
}

function buildContentFromFriendlyForm(body) {
  const productSections = {};
  PRODUCT_SECTION_DEFS.forEach((def) => {
    const sectionTitleAr = t(body[`${def.key}_title_ar`]) || def.defaultAr;
    const sectionTitleEn = t(body[`${def.key}_title_en`]) || def.defaultEn;

    const catAr = splitLines(body[`${def.key}_categories_ar_text`]);
    const catEn = splitLines(body[`${def.key}_categories_en_text`]);
    const categories = [];
    for (let i = 0; i < Math.max(catAr.length, catEn.length); i += 1) {
      const ar = t(catAr[i]);
      const en = t(catEn[i]);
      if (!ar && !en) continue;
      categories.push({ ar, en });
    }

    const pId = toArray(body[`${def.key}_product_id`]);
    const pCategoryAr = toArray(body[`${def.key}_product_category_ar`]);
    const pCategoryEn = toArray(body[`${def.key}_product_category_en`]);
    const pNameAr = toArray(body[`${def.key}_product_name_ar`]);
    const pNameEn = toArray(body[`${def.key}_product_name_en`]);
    const pDescAr = toArray(body[`${def.key}_product_description_ar`]);
    const pDescEn = toArray(body[`${def.key}_product_description_en`]);
    const pFeaturesAr = toArray(body[`${def.key}_product_features_ar`]);
    const pFeaturesEn = toArray(body[`${def.key}_product_features_en`]);
    const pAcidity = toArray(body[`${def.key}_product_acidity`]);
    const pCurrentImage = toArray(body[`${def.key}_current_product_image`]);

    const items = [];
    for (let i = 0; i < Math.max(pNameAr.length, pNameEn.length, pCategoryAr.length, pCategoryEn.length); i += 1) {
      const nameAr = t(pNameAr[i]);
      const nameEn = t(pNameEn[i]);
      const categoryAr = t(pCategoryAr[i]);
      const categoryEn = t(pCategoryEn[i]);
      if (!nameAr && !nameEn && !categoryAr && !categoryEn) continue;
      const featuresArRows = splitLines(pFeaturesAr[i]);
      const featuresEnRows = splitLines(pFeaturesEn[i]);
      const features = [];
      for (let k = 0; k < Math.max(featuresArRows.length, featuresEnRows.length); k += 1) {
        const ar = t(featuresArRows[k]);
        const en = t(featuresEnRows[k]);
        if (!ar && !en) continue;
        features.push({ ar, en });
      }

      items.push({
        id: t(pId[i]) || String(items.length + 1),
        category: { ar: categoryAr, en: categoryEn },
        name: { ar: nameAr, en: nameEn },
        description: { ar: t(pDescAr[i]), en: t(pDescEn[i]) },
        features,
        acidity: t(pAcidity[i]),
        image: t(pCurrentImage[i])
      });
    }

    productSections[def.key] = {
      name: { ar: sectionTitleAr, en: sectionTitleEn },
      categories,
      items
    };
  });

  return {
    branding: {
      logo: {
        url: t(body.current_logo_image)
      },
      icon: {
        url: t(body.current_logo_icon)
      }
    },
    products: {
      sections: productSections
    },
    updatedBy: t(body.updated_by)
  };
}

function applyUploadedImages(contentObj, body, files) {
  const setImage = (fieldName, apply) => {
    const file = findFile(files, fieldName);
    if (file) apply(`/public/website_images/${file.filename}`);
  };

  setImage('logo_image_file', (v) => { contentObj.branding.logo.url = v; });
  setImage('logo_icon_file', (v) => {
    if (!contentObj.branding.icon || typeof contentObj.branding.icon !== 'object') {
      contentObj.branding.icon = {};
    }
    contentObj.branding.icon.url = v;
  });
  const sections = normalizeProductSections(contentObj);
  PRODUCT_SECTION_DEFS.forEach((def) => {
    const sectionItems = Array.isArray(sections?.[def.key]?.items) ? sections[def.key].items : [];
    const regex = new RegExp(`^${def.key}_product_image_(\\d+)$`);
    files
      .filter((f) => regex.test(f.fieldname || ''))
      .forEach((f) => {
        const index = Number((f.fieldname || '').match(regex)?.[1]);
        if (!Number.isFinite(index) || !sectionItems[index]) return;
        removeOldWebsiteImage(sectionItems[index].image);
        sectionItems[index].image = `/public/website_images/${f.filename}`;
      });
  });
}

function removeOldWebsiteImage(rawUrl) {
  const value = t(rawUrl);
  if (!value || !value.startsWith('/public/website_images/')) return;
  const normalized = path.normalize(value.replace(/^\/+/, ''));
  const fullPath = path.join(__dirname, '..', normalized);
  const websiteImagesRoot = path.join(__dirname, '../public/website_images');
  if (!fullPath.startsWith(path.normalize(websiteImagesRoot))) return;
  try {
    if (fs.existsSync(fullPath)) fs.unlinkSync(fullPath);
  } catch (_) {
    // Ignore file cleanup errors.
  }
}

function collectProductWebsiteImages(contentObj) {
  const sections = normalizeProductSections(contentObj);
  const images = new Set();
  PRODUCT_SECTION_DEFS.forEach((def) => {
    const sectionItems = Array.isArray(sections?.[def.key]?.items) ? sections[def.key].items : [];
    sectionItems.forEach((item) => {
      const image = t(item?.image);
      if (image && image.startsWith('/public/website_images/')) {
        images.add(image);
      }
    });
  });
  return images;
}

function cleanupRemovedProductImages(oldContentObj, nextContentObj) {
  const oldImages = collectProductWebsiteImages(oldContentObj);
  const nextImages = collectProductWebsiteImages(nextContentObj);
  oldImages.forEach((imagePath) => {
    if (!nextImages.has(imagePath)) {
      removeOldWebsiteImage(imagePath);
    }
  });
}

function ensureSingleImagePerProduct(files) {
  const productImageFieldRegex = /^(olive_products|olive_oil|agri_crops)_product_image_\d+$/;
  const counters = new Map();

  (Array.isArray(files) ? files : []).forEach((file) => {
    const fieldName = t(file?.fieldname);
    if (!productImageFieldRegex.test(fieldName)) return;
    counters.set(fieldName, (counters.get(fieldName) || 0) + 1);
  });

  const violatedField = Array.from(counters.entries()).find(([, count]) => count > 1);
  if (violatedField) {
    throw new Error('يسمح برفع صورة واحدة فقط لكل منتج.');
  }
}

async function ensureContactInboxTables(db) {
  await db.query(
    `CREATE TABLE IF NOT EXISTS website_contact_messages (
      id INT AUTO_INCREMENT PRIMARY KEY,
      sender_name VARCHAR(191) NOT NULL,
      sender_phone VARCHAR(100) NOT NULL,
      message_text TEXT NOT NULL,
      sender_ip VARCHAR(45) NULL,
      user_agent TEXT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_wcm_created_at (created_at),
      INDEX idx_wcm_sender_phone (sender_phone)
    )`
  );

  await db.query(
    `CREATE TABLE IF NOT EXISTS website_contact_attachments (
      id INT AUTO_INCREMENT PRIMARY KEY,
      message_id INT NOT NULL,
      file_url VARCHAR(500) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_wca_message_id (message_id),
      CONSTRAINT fk_wca_message_id
        FOREIGN KEY (message_id) REFERENCES website_contact_messages(id)
        ON DELETE CASCADE
    )`
  );
}

async function ensureContactInboxSchema(db) {
  await ensureContactInboxTables(db);

  const [columns] = await db.query('SHOW COLUMNS FROM website_contact_messages');
  const columnMap = new Map(
    (Array.isArray(columns) ? columns : []).map((col) => [
      t(col?.Field).toLowerCase(),
      t(col?.Type).toLowerCase()
    ])
  );

  const hasTextLikeType = (type) => /(char|text)/i.test(t(type));

  if (!hasTextLikeType(columnMap.get('sender_name'))) {
    await db.query(
      'ALTER TABLE website_contact_messages MODIFY COLUMN sender_name VARCHAR(191) NOT NULL'
    );
  }

  if (!hasTextLikeType(columnMap.get('sender_phone'))) {
    await db.query(
      'ALTER TABLE website_contact_messages MODIFY COLUMN sender_phone VARCHAR(100) NOT NULL'
    );
  }

  if (!hasTextLikeType(columnMap.get('message_text'))) {
    await db.query(
      'ALTER TABLE website_contact_messages MODIFY COLUMN message_text TEXT NOT NULL'
    );
  }

  if (!columnMap.has('sender_ip')) {
    await db.query(
      'ALTER TABLE website_contact_messages ADD COLUMN sender_ip VARCHAR(45) NULL AFTER message_text'
    );
  }

  if (!columnMap.has('user_agent')) {
    await db.query(
      'ALTER TABLE website_contact_messages ADD COLUMN user_agent TEXT NULL AFTER sender_ip'
    );
  }
}

async function insertContactMessage(db, payload) {
  const { senderName, senderPhone, normalizedMessageText, senderIp, userAgent } = payload;
  const safeName = t(senderName).slice(0, 191) || 'غير محدد';
  const safeMessage = t(normalizedMessageText).slice(0, 4000) || '-';
  const safePhoneDigits = t(senderPhone).replace(/[^\d]/g, '').slice(0, 100) || '0';
  const isLegacyCompatibleError = (error) => (
    error &&
    ['ER_BAD_FIELD_ERROR', 'ER_TRUNCATED_WRONG_VALUE_FOR_FIELD'].includes(error.code)
  );

  const insertModern = async () => db.query(
    `INSERT INTO website_contact_messages
     (sender_name, sender_phone, message_text, sender_ip, user_agent)
     VALUES (?, ?, ?, ?, ?)`,
    [senderName, senderPhone, normalizedMessageText, senderIp, userAgent]
  );

  const insertLegacy = async () => db.query(
    `INSERT INTO website_contact_messages
     (sender_name, sender_phone, message_text)
     VALUES (?, ?, ?)`,
    [senderName, senderPhone, normalizedMessageText]
  );

  const insertSuperLegacy = async () => db.query(
    `INSERT INTO website_contact_messages
     (sender_name, sender_phone, message_text)
     VALUES (?, ?, ?)`,
    [safeName, safePhoneDigits, safeMessage]
  );

  try {
    const [modernResult] = await insertModern();
    return modernResult;
  } catch (firstError) {
    if (isLegacyCompatibleError(firstError)) {
      try {
        const [legacyResult] = await insertLegacy();
        return legacyResult;
      } catch (legacyError) {
        if (isLegacyCompatibleError(legacyError)) {
          try {
            const [superLegacyResult] = await insertSuperLegacy();
            return superLegacyResult;
          } catch (superLegacyError) {
            if (isLegacyCompatibleError(superLegacyError)) {
              const schemaError = new Error('CONTACT_INBOX_SCHEMA_INCOMPATIBLE');
              schemaError.code = 'CONTACT_INBOX_SCHEMA_INCOMPATIBLE';
              throw schemaError;
            }
            throw superLegacyError;
          }
        }
        throw legacyError;
      }
    }

    if (firstError && firstError.code === 'ER_NO_SUCH_TABLE') {
      await ensureContactInboxTables(db);
      try {
        const [modernAfterCreate] = await insertModern();
        return modernAfterCreate;
      } catch (secondError) {
        if (isLegacyCompatibleError(secondError)) {
          try {
            const [legacyAfterCreate] = await insertLegacy();
            return legacyAfterCreate;
          } catch (legacyAfterCreateError) {
            if (isLegacyCompatibleError(legacyAfterCreateError)) {
              try {
                const [superLegacyAfterCreate] = await insertSuperLegacy();
                return superLegacyAfterCreate;
              } catch (superLegacyAfterCreateError) {
                if (isLegacyCompatibleError(superLegacyAfterCreateError)) {
                  const schemaError = new Error('CONTACT_INBOX_SCHEMA_INCOMPATIBLE');
                  schemaError.code = 'CONTACT_INBOX_SCHEMA_INCOMPATIBLE';
                  throw schemaError;
                }
                throw superLegacyAfterCreateError;
              }
            }
            throw legacyAfterCreateError;
          }
        }
        throw secondError;
      }
    }

    throw firstError;
  }
}

async function loadPublicContentSnapshot(req) {
  const [rows] = await req.db.query(
    `SELECT id, site_id, content_json, updated_at
     FROM website_content
     WHERE deleted_at IS NULL
     ORDER BY id ASC
     LIMIT 1`
  );

  const row = rows[0];
  const contentObj = buildMinimalContent(
    row ? parseJsonSafe(row.content_json, readTemplateContent()) : readTemplateContent(),
    row?.updated_by || ''
  );

  return { row, contentObj };
}

function buildPublicSections(req, contentObj) {
  const rawSections = normalizeProductSections(contentObj);
  const sections = {};
  const defaultProductImageRaw = '/public/images/defult.png';
  const logoRaw = normalizeLegacyImagePath(contentObj?.branding?.logo?.url);

  PRODUCT_SECTION_DEFS.forEach((def) => {
    const section = rawSections?.[def.key] || {};
    const categories = Array.isArray(section.categories) ? section.categories : [];
    const items = Array.isArray(section.items) ? section.items : [];

    sections[def.key] = {
      key: def.key,
      name: {
        ar: t(section?.name?.ar) || def.defaultAr,
        en: t(section?.name?.en) || def.defaultEn
      },
      categories: categories.map((cat) => ({
        ar: typeof cat === 'string' ? t(cat) : t(cat?.ar),
        en: typeof cat === 'string' ? '' : t(cat?.en)
      })),
      items: items.map((item, index) => {
        const explicitImageCandidate = normalizeLegacyImagePath(item?.image);
        const explicitImageRaw = isSameAssetPath(explicitImageCandidate, logoRaw) ? '' : explicitImageCandidate;
        const imageRaw = explicitImageRaw || defaultProductImageRaw;
        return {
          id: t(item?.id) || String(index + 1),
          category: {
            ar: t(item?.category?.ar || item?.category),
            en: t(item?.category?.en)
          },
          name: {
            ar: t(item?.name?.ar),
            en: t(item?.name?.en)
          },
          description: {
            ar: t(item?.description?.ar),
            en: t(item?.description?.en)
          },
          features: Array.isArray(item?.features)
            ? item.features
                .map((feature) => ({
                  ar: t(feature?.ar),
                  en: t(feature?.en)
                }))
                .filter((feature) => feature.ar || feature.en)
            : [],
          acidity: t(item?.acidity),
          image_url: toPublicAssetUrl(req, imageRaw),
          image_raw: imageRaw,
          image_is_default_fallback: !explicitImageRaw
        };
      })
    };
  });

  return sections;
}

exports.getSiteContentIndex = async (req, res) => {
  try {
    const singleton = await ensureSingletonSiteContent(req.db, req.session.user?.id || null);
    return res.redirect(`/site-management/${singleton.id}/edit`);
  } catch (error) {
    console.error('خطأ في عرض إدارة الموقع:', error);
    req.flash('error_msg', 'تعذر تحميل صفحة إدارة الموقع');
    res.redirect('/');
  }
};

exports.getCreateSiteContent = async (req, res) => {
  req.flash('error_msg', 'إدارة الموقع تعمل بسجل واحد فقط. يمكنك تعديل السجل الحالي.');
  return res.redirect('/site-management');
};

exports.createSiteContent = async (req, res) => {
  req.flash('error_msg', 'لا يمكن إنشاء سجل جديد. يوجد سجل وحيد لإدارة الموقع.');
  return res.redirect('/site-management');
};

exports.getSiteContentDetails = async (req, res) => {
  return res.redirect(`/site-management/${req.params.id}/edit`);
};

exports.getEditSiteContent = async (req, res) => {
  try {
    const singleton = await ensureSingletonSiteContent(req.db, req.session.user?.id || null);
    const [rows] = await req.db.query(
      `SELECT * FROM website_content WHERE id = ? AND deleted_at IS NULL LIMIT 1`,
      [singleton.id]
    );
    const row = rows[0];
    if (!row) {
      req.flash('error_msg', 'تعذر تحميل سجل إدارة الموقع');
      return res.redirect('/');
    }
    if (String(req.params.id) !== String(row.id)) {
      return res.redirect(`/site-management/${row.id}/edit`);
    }
    const contentObj = parseJsonSafe(row.content_json, readTemplateContent());
    const formData = buildFormData(contentObj, row);
    const inboxMessages = await fetchInboxMessages(req.db);

    res.render('site-management/form', {
      title: `تعديل محتوى الموقع #${row.id}`,
      mode: 'edit',
      formData,
      currentRecord: row,
      inboxMessages
    });
  } catch (error) {
    console.error('خطأ في تحميل تعديل محتوى الموقع:', error);
    req.flash('error_msg', 'تعذر تحميل بيانات التعديل');
    res.redirect('/site-management');
  }
};

exports.createContactMessage = async (req, res) => {
  try {
    const db = req.db && typeof req.db.query === 'function' ? req.db : pool;
    await ensureContactInboxSchema(db);
    const body = req.body && typeof req.body === 'object' ? req.body : {};
    const senderName = t(body.sender_name).slice(0, 191);
    const senderPhone = t(body.sender_phone).slice(0, 100);
    const messageText = t(body.message_text).slice(0, 4000);
    const messageSource = t(body.message_source).slice(0, 100);
    const isSellProductsRequest = messageSource === 'sell_products_modal';
    const files = Array.isArray(req.files) ? req.files : [];
    const attachments = files
      .filter((f) => (f.fieldname || '').startsWith('attachments'))
      .map((f) => `/public/website_images/${f.filename}`);

    if (!senderName || !senderPhone) {
      return res.status(400).json({
        success: false,
        message: 'الاسم والرقم مطلوبان'
      });
    }

    if (!isSellProductsRequest && !messageText) {
      return res.status(400).json({
        success: false,
        message: 'نص الرسالة مطلوب'
      });
    }

    if (messageText && messageText.length < 3) {
      return res.status(400).json({
        success: false,
        message: 'نص الرسالة قصير جدًا'
      });
    }

    const normalizedMessageText = isSellProductsRequest
      ? (
          messageText
            ? `[طلب بيع منتجات]\n${messageText}`
            : '[طلب بيع منتجات] تم الإرسال من نافذة البيع في اللاندنغ بيج'
        )
      : messageText;

    const senderIp = extractClientIp(req);
    const userAgent = t(req.headers['user-agent']).slice(0, 1000);

    const insertResult = await insertContactMessage(db, {
      senderName,
      senderPhone,
      normalizedMessageText,
      senderIp,
      userAgent
    });

    const messageId = insertResult.insertId;

    if (attachments.length) {
      const values = attachments.map((fileUrl) => [messageId, fileUrl]);
      try {
        await db.query(
          `INSERT INTO website_contact_attachments (message_id, file_url)
           VALUES ?`,
          [values]
        );
      } catch (attachmentError) {
        // Keep the message saved even if old schemas do not have attachments table.
        if (!(attachmentError && attachmentError.code === 'ER_NO_SUCH_TABLE')) {
          throw attachmentError;
        }
      }
    }

    return res.status(201).json({
      success: true,
      message: 'تم استلام الرسالة بنجاح',
      data: {
        id: messageId,
        sender_name: senderName,
        sender_phone: senderPhone,
        message_text: normalizedMessageText,
        sender_ip: senderIp,
        message_source: isSellProductsRequest ? 'sell_products_modal' : 'contact_cta',
        attachments_count: attachments.length
      }
    });
  } catch (error) {
    console.error('خطأ في استقبال رسالة التواصل:', error);
    if (error && ['ER_TABLEACCESS_DENIED_ERROR', 'ER_DBACCESS_DENIED_ERROR', 'ER_ACCESS_DENIED_ERROR'].includes(error.code)) {
      return res.status(500).json({
        success: false,
        message: 'تعذر حفظ الرسالة: صلاحيات قاعدة البيانات غير كافية.'
      });
    }
    if (error && error.code === 'CONTACT_INBOX_SCHEMA_INCOMPATIBLE') {
      return res.status(500).json({
        success: false,
        message: 'تعذر حفظ الرسالة: هيكل جدول الرسائل غير متوافق مع الحقول النصية.'
      });
    }
    if (error && error.code === 'ER_NO_SUCH_TABLE') {
      return res.status(500).json({
        success: false,
        message: 'تعذر حفظ الرسالة: جداول الرسائل غير مهيأة على الخادم.'
      });
    }
    return res.status(500).json({
      success: false,
      message: `تعذر حفظ الرسالة${error?.code ? `: ${error.code}` : ''}`
    });
  }
};

exports.deleteContactMessage = async (req, res) => {
  try {
    const messageId = Number(req.params.id);
    const singleton = await ensureSingletonSiteContent(req.db, req.session.user?.id || null);

    if (!Number.isFinite(messageId) || messageId <= 0) {
      req.flash('error_msg', 'معرف الرسالة غير صالح');
      return res.redirect(`/site-management/${singleton.id}/edit#tab-inbox`);
    }

    const [result] = await req.db.query(
      `DELETE FROM website_contact_messages WHERE id = ? LIMIT 1`,
      [messageId]
    );

    if (!result.affectedRows) {
      req.flash('error_msg', 'الرسالة غير موجودة أو تم حذفها مسبقًا');
      return res.redirect(`/site-management/${singleton.id}/edit#tab-inbox`);
    }

    req.flash('success_msg', 'تم حذف الرسالة بنجاح');
    return res.redirect(`/site-management/${singleton.id}/edit#tab-inbox`);
  } catch (error) {
    console.error('خطأ في حذف رسالة البريد الوارد:', error);
    req.flash('error_msg', 'تعذر حذف الرسالة');
    return res.redirect('/site-management');
  }
};

exports.getPublicLogo = async (req, res) => {
  try {
    const { contentObj } = await loadPublicContentSnapshot(req);
    const logoRaw = contentObj?.branding?.logo?.url || '';

    return res.json({
      success: true,
      data: {
        logo_url: toPublicAssetUrl(req, logoRaw),
        logo_raw: t(logoRaw)
      }
    });
  } catch (error) {
    console.error('خطأ في جلب شعار الموقع:', error);
    return res.status(500).json({ success: false, message: 'تعذر تحميل الشعار' });
  }
};

exports.getPublicIcon = async (req, res) => {
  try {
    const { contentObj } = await loadPublicContentSnapshot(req);
    const iconRaw = contentObj?.branding?.icon?.url || '';

    return res.json({
      success: true,
      data: {
        icon_url: toPublicAssetUrl(req, iconRaw),
        icon_raw: t(iconRaw)
      }
    });
  } catch (error) {
    console.error('خطأ في جلب أيقونة الموقع:', error);
    return res.status(500).json({ success: false, message: 'تعذر تحميل الأيقونة' });
  }
};

exports.getPublicProductCategories = async (req, res) => {
  try {
    const { contentObj } = await loadPublicContentSnapshot(req);
    const sections = buildPublicSections(req, contentObj);
    const categoriesBySection = {};

    PRODUCT_SECTION_DEFS.forEach((def) => {
      categoriesBySection[def.key] = {
        key: def.key,
        name: sections[def.key]?.name || { ar: def.defaultAr, en: def.defaultEn },
        categories: Array.isArray(sections[def.key]?.categories) ? sections[def.key].categories : []
      };
    });

    return res.json({
      success: true,
      data: {
        sections: categoriesBySection
      }
    });
  } catch (error) {
    console.error('خطأ في جلب فئات المنتجات:', error);
    return res.status(500).json({ success: false, message: 'تعذر تحميل الفئات' });
  }
};

exports.getPublicProducts = async (req, res) => {
  try {
    const { contentObj } = await loadPublicContentSnapshot(req);
    const sections = buildPublicSections(req, contentObj);
    const productsBySection = {};

    PRODUCT_SECTION_DEFS.forEach((def) => {
      productsBySection[def.key] = {
        key: def.key,
        name: sections[def.key]?.name || { ar: def.defaultAr, en: def.defaultEn },
        items: Array.isArray(sections[def.key]?.items) ? sections[def.key].items : []
      };
    });

    return res.json({
      success: true,
      data: {
        sections: productsBySection
      }
    });
  } catch (error) {
    console.error('خطأ في جلب المنتجات:', error);
    return res.status(500).json({ success: false, message: 'تعذر تحميل المنتجات' });
  }
};

exports.getPublicSiteContent = async (req, res) => {
  try {
    const { row, contentObj } = await loadPublicContentSnapshot(req);

    const logoRaw = contentObj?.branding?.logo?.url || '';
    const iconRaw = contentObj?.branding?.icon?.url || '';
    const sections = buildPublicSections(req, contentObj);

    return res.json({
      success: true,
      data: {
        site_id: row?.site_id || contentObj?.siteId || '',
        updated_at: row?.updated_at || null,
        updated_by: t(contentObj?.updatedBy),
        branding: {
          logo_url: toPublicAssetUrl(req, logoRaw),
          icon_url: toPublicAssetUrl(req, iconRaw),
          logo_raw: t(logoRaw),
          icon_raw: t(iconRaw)
        },
        products: {
          sections
        }
      }
    });
  } catch (error) {
    console.error('خطأ في جلب محتوى الموقع العام:', error);
    return res.status(500).json({
      success: false,
      message: 'تعذر تحميل محتوى الموقع'
    });
  }
};

exports.updateSiteContent = async (req, res) => {
  try {
    const singleton = await ensureSingletonSiteContent(req.db, req.session.user?.id || null);
    const id = singleton.id;
    const [existsRows] = await req.db.query(
      `SELECT id, content_name, site_id, content_json FROM website_content WHERE id = ? AND deleted_at IS NULL LIMIT 1`,
      [id]
    );
    if (!existsRows.length) {
      req.flash('error_msg', 'السجل غير موجود');
      return res.redirect('/site-management');
    }
    const existingRow = existsRows[0];
    const contentName = existingRow.content_name || 'محتوى الموقع';

    const existingContentObj = buildMinimalContent(
      parseJsonSafe(existingRow.content_json, readTemplateContent()),
      req.session.user?.email || req.session.user?.username || ''
    );
    const contentObj = buildContentFromFriendlyForm(req.body);
    const existingSections = normalizeProductSections(existingContentObj);
    const newSections = normalizeProductSections(contentObj);
    PRODUCT_SECTION_DEFS.forEach((def) => {
      const oldName = existingSections?.[def.key]?.name;
      newSections[def.key].name = {
        ar: t(oldName?.ar) || def.defaultAr,
        en: t(oldName?.en) || def.defaultEn
      };
    });
    contentObj.products = { sections: newSections };
    contentObj.updatedBy = req.session.user?.email || req.session.user?.username || t(contentObj.updatedBy);
    ensureSingleImagePerProduct(req.files || []);
    applyUploadedImages(contentObj, req.body, req.files || []);
    cleanupRemovedProductImages(existingContentObj, contentObj);

    await req.db.query(
      `UPDATE website_content
       SET content_name = ?, site_id = ?, content_json = ?, updated_at = CURRENT_TIMESTAMP, updated_by = ?
       WHERE id = ?`,
      [contentName, existingRow.site_id || null, JSON.stringify(contentObj), req.session.user?.id || null, id]
    );

    req.flash('success_msg', 'تم تحديث محتوى الموقع بنجاح');
    res.redirect('/site-management');
  } catch (error) {
    console.error('خطأ في تحديث محتوى الموقع:', error);
    req.flash('error_msg', error?.message || 'تعذر تحديث السجل');
    res.redirect(`/site-management/${req.params.id}/edit`);
  }
};

exports.deleteSiteContent = async (req, res) => {
  req.flash('error_msg', 'لا يمكن حذف سجل إدارة الموقع. السجل وحيد ومخصص للتعديل فقط.');
  return res.redirect('/site-management');
};

exports.getDeletedSiteContent = async (req, res) => {
  req.flash('error_msg', 'سلة المحذوفات غير متاحة في إدارة الموقع (سجل وحيد).');
  return res.redirect('/site-management');
};

exports.restoreSiteContent = async (req, res) => {
  req.flash('error_msg', 'الاستعادة غير متاحة في إدارة الموقع (سجل وحيد).');
  return res.redirect('/site-management');
};

exports.hardDeleteSiteContent = async (req, res) => {
  req.flash('error_msg', 'الحذف النهائي غير متاح في إدارة الموقع (سجل وحيد).');
  return res.redirect('/site-management');
};
