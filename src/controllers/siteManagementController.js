const fs = require('fs');
const path = require('path');

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
  const c = contentObj || {};
  const navItems = Array.isArray(c?.navigation?.items) ? c.navigation.items : [];
  const stats = Array.isArray(c?.about?.stats) ? c.about.stats : [];
  const productSectionsRaw = normalizeProductSections(c);
  const steps = Array.isArray(c?.production?.steps) ? c.production.steps : [];
  const footerCounters = Array.isArray(c?.footer?.counters) ? c.footer.counters : [];

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
        current_image: p?.image || ''
      }))
    };
  });

  return {
    id: row?.id || null,
    content_name: row?.content_name || 'محتوى الموقع',
    site_id: row?.site_id || c.siteId || '',
    default_language: c.defaultLanguage || 'ar',
    updated_by: c.updatedBy || '',

    seo_title_ar: c?.metadata?.ar?.title || '',
    seo_title_en: c?.metadata?.en?.title || '',
    seo_description_ar: c?.metadata?.ar?.description || '',
    seo_description_en: c?.metadata?.en?.description || '',
    seo_keywords_ar: Array.isArray(c?.metadata?.ar?.keywords) ? c.metadata.ar.keywords.join(', ') : '',
    seo_keywords_en: Array.isArray(c?.metadata?.en?.keywords) ? c.metadata.en.keywords.join(', ') : '',
    current_og_image: c?.metadata?.ogImage || '',
    current_twitter_image: c?.metadata?.twitterImage || '',

    current_logo_image: c?.branding?.logo?.url || '',
    current_logo_icon: c?.branding?.icon?.url || '',

    hero_subtitle_ar: c?.hero?.subtitle?.ar || '',
    hero_subtitle_en: c?.hero?.subtitle?.en || '',
    hero_title_ar: c?.hero?.title?.ar || '',
    hero_title_en: c?.hero?.title?.en || '',
    hero_description_ar: c?.hero?.description?.ar || '',
    hero_description_en: c?.hero?.description?.en || '',
    hero_cta_primary_ar: c?.hero?.ctaPrimary?.ar || '',
    hero_cta_primary_en: c?.hero?.ctaPrimary?.en || '',
    hero_cta_secondary_ar: c?.hero?.ctaSecondary?.ar || '',
    hero_cta_secondary_en: c?.hero?.ctaSecondary?.en || '',
    hero_image_alt_ar: c?.hero?.backgroundImage?.alt?.ar || '',
    hero_image_alt_en: c?.hero?.backgroundImage?.alt?.en || '',
    current_hero_image: c?.hero?.backgroundImage?.url || '',

    about_subtitle_ar: c?.about?.subtitle?.ar || '',
    about_subtitle_en: c?.about?.subtitle?.en || '',
    about_title_ar: c?.about?.title?.ar || '',
    about_title_en: c?.about?.title?.en || '',
    about_paragraph1_ar: c?.about?.paragraph1?.ar || '',
    about_paragraph1_en: c?.about?.paragraph1?.en || '',
    about_paragraph2_ar: c?.about?.paragraph2?.ar || '',
    about_paragraph2_en: c?.about?.paragraph2?.en || '',
    current_about_main_image: c?.about?.images?.main || '',
    current_about_secondary_image: c?.about?.images?.secondary || '',

    products_subtitle_ar: c?.products?.subtitle?.ar || '',
    products_subtitle_en: c?.products?.subtitle?.en || '',
    products_title_ar: c?.products?.title?.ar || '',
    products_title_en: c?.products?.title?.en || '',
    products_intro_ar: c?.products?.intro?.ar || '',
    products_intro_en: c?.products?.intro?.en || '',

    production_subtitle_ar: c?.production?.subtitle?.ar || '',
    production_subtitle_en: c?.production?.subtitle?.en || '',
    production_title_ar: c?.production?.title?.ar || '',
    production_title_en: c?.production?.title?.en || '',
    current_production_image: c?.production?.image || '',

    contact_subtitle_ar: c?.contact?.subtitle?.ar || '',
    contact_subtitle_en: c?.contact?.subtitle?.en || '',
    contact_title_ar: c?.contact?.title?.ar || '',
    contact_title_en: c?.contact?.title?.en || '',
    contact_placeholder_name_ar: c?.contact?.form?.placeholders?.name?.ar || '',
    contact_placeholder_name_en: c?.contact?.form?.placeholders?.name?.en || '',
    contact_placeholder_email_ar: c?.contact?.form?.placeholders?.email?.ar || '',
    contact_placeholder_email_en: c?.contact?.form?.placeholders?.email?.en || '',
    contact_placeholder_message_ar: c?.contact?.form?.placeholders?.message?.ar || '',
    contact_placeholder_message_en: c?.contact?.form?.placeholders?.message?.en || '',
    contact_submit_ar: c?.contact?.form?.submitLabel?.ar || '',
    contact_submit_en: c?.contact?.form?.submitLabel?.en || '',
    contact_address_ar: c?.contact?.contactInfo?.address?.ar || '',
    contact_address_en: c?.contact?.contactInfo?.address?.en || '',
    contact_phone: c?.contact?.contactInfo?.phone || '',
    contact_email: c?.contact?.contactInfo?.email || '',
    contact_map_url: c?.contact?.map?.embedUrl || '',

    footer_tagline_ar: c?.footer?.tagline?.ar || '',
    footer_tagline_en: c?.footer?.tagline?.en || '',
    footer_description_ar: c?.footer?.description?.ar || '',
    footer_description_en: c?.footer?.description?.en || '',
    footer_quick_links_title_ar: c?.footer?.quickLinksTitle?.ar || '',
    footer_quick_links_title_en: c?.footer?.quickLinksTitle?.en || '',
    footer_contact_info_title_ar: c?.footer?.contactInfoTitle?.ar || '',
    footer_contact_info_title_en: c?.footer?.contactInfoTitle?.en || '',
    footer_rights_ar: c?.footer?.rights?.ar || '',
    footer_rights_en: c?.footer?.rights?.en || '',
    footer_crafted_ar: c?.footer?.crafted?.ar || '',
    footer_crafted_en: c?.footer?.crafted?.en || '',
    footer_facebook: c?.footer?.socialLinks?.facebook || '',
    footer_instagram: c?.footer?.socialLinks?.instagram || '',
    footer_linkedin: c?.footer?.socialLinks?.linkedin || '',

    navItems: navItems.map((n) => ({
      key: n?.key || '',
      label_ar: n?.label?.ar || '',
      label_en: n?.label?.en || ''
    })),
    stats: stats.map((s) => ({
      key: s?.key || '',
      number_ar: s?.number?.ar || '',
      number_en: s?.number?.en || '',
      label_ar: s?.label?.ar || '',
      label_en: s?.label?.en || ''
    })),
    productSections,
    footerCounters: footerCounters.map((x) => ({
      label_ar: x?.label?.ar || '',
      label_en: x?.label?.en || '',
      value: x?.value || ''
    })),
    steps: steps.map((s) => ({
      order: s?.order || '',
      title_ar: s?.title?.ar || '',
      title_en: s?.title?.en || '',
      description_ar: s?.description?.ar || '',
      description_en: s?.description?.en || ''
    }))
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
    contact: {
      subtitle: { ar: t(body.contact_subtitle_ar), en: t(body.contact_subtitle_en) },
      title: { ar: t(body.contact_title_ar), en: t(body.contact_title_en) },
      form: {
        placeholders: {
          name: { ar: t(body.contact_placeholder_name_ar), en: t(body.contact_placeholder_name_en) },
          email: { ar: t(body.contact_placeholder_email_ar), en: t(body.contact_placeholder_email_en) },
          message: { ar: t(body.contact_placeholder_message_ar), en: t(body.contact_placeholder_message_en) }
        },
        submitLabel: { ar: t(body.contact_submit_ar), en: t(body.contact_submit_en) }
      },
      contactInfo: {
        address: { ar: t(body.contact_address_ar), en: t(body.contact_address_en) },
        phone: t(body.contact_phone),
        email: t(body.contact_email)
      },
      map: { embedUrl: t(body.contact_map_url) }
    },
    footer: {
      tagline: { ar: t(body.footer_tagline_ar), en: t(body.footer_tagline_en) },
      description: { ar: t(body.footer_description_ar), en: t(body.footer_description_en) },
      quickLinksTitle: { ar: t(body.footer_quick_links_title_ar), en: t(body.footer_quick_links_title_en) },
      contactInfoTitle: { ar: t(body.footer_contact_info_title_ar), en: t(body.footer_contact_info_title_en) },
      rights: { ar: t(body.footer_rights_ar), en: t(body.footer_rights_en) },
      crafted: { ar: t(body.footer_crafted_ar), en: t(body.footer_crafted_en) },
      socialLinks: {
        facebook: t(body.footer_facebook),
        instagram: t(body.footer_instagram),
        linkedin: t(body.footer_linkedin)
      },
      counters: (() => {
        const labelsAr = toArray(body.footer_counter_label_ar);
        const labelsEn = toArray(body.footer_counter_label_en);
        const values = toArray(body.footer_counter_value);
        const counters = [];
        for (let i = 0; i < Math.max(labelsAr.length, labelsEn.length, values.length); i += 1) {
          const ar = t(labelsAr[i]);
          const en = t(labelsEn[i]);
          const value = t(values[i]);
          if (!ar && !en && !value) continue;
          counters.push({ label: { ar, en }, value });
        }
        return counters;
      })()
    }
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
        sectionItems[index].image = `/public/website_images/${f.filename}`;
      });
  });
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
    const senderName = t(req.body.sender_name);
    const senderPhone = t(req.body.sender_phone);
    const messageText = t(req.body.message_text);

    if (!senderName || !senderPhone || !messageText) {
      return res.status(400).json({
        success: false,
        message: 'الاسم والرقم ونص الرسالة مطلوبة'
      });
    }

    const senderIp = extractClientIp(req);
    const userAgent = t(req.headers['user-agent']);

    const [insertResult] = await req.db.query(
      `INSERT INTO website_contact_messages
       (sender_name, sender_phone, message_text, sender_ip, user_agent)
       VALUES (?, ?, ?, ?, ?)`,
      [senderName, senderPhone, messageText, senderIp, userAgent]
    );

    const messageId = insertResult.insertId;
    const files = Array.isArray(req.files) ? req.files : [];
    const attachments = files
      .filter((f) => (f.fieldname || '').startsWith('attachments'))
      .map((f) => `/public/website_images/${f.filename}`);

    if (attachments.length) {
      const values = attachments.map((fileUrl) => [messageId, fileUrl]);
      await req.db.query(
        `INSERT INTO website_contact_attachments (message_id, file_url)
         VALUES ?`,
        [values]
      );
    }

    return res.status(201).json({
      success: true,
      message: 'تم استلام الرسالة بنجاح',
      data: {
        id: messageId,
        sender_name: senderName,
        sender_phone: senderPhone,
        message_text: messageText,
        sender_ip: senderIp,
        attachments_count: attachments.length
      }
    });
  } catch (error) {
    console.error('خطأ في استقبال رسالة التواصل:', error);
    return res.status(500).json({
      success: false,
      message: 'تعذر حفظ الرسالة'
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

    const existingContentObj = parseJsonSafe(existingRow.content_json, readTemplateContent());
    const contentObj = buildContentFromFriendlyForm(req.body);
    contentObj.navigation = existingContentObj?.navigation || { items: [] };
    const existingSections = normalizeProductSections(existingContentObj);
    const newSections = normalizeProductSections(contentObj);
    PRODUCT_SECTION_DEFS.forEach((def) => {
      const oldName = existingSections?.[def.key]?.name;
      if (oldName && typeof oldName === 'object') {
        newSections[def.key].name = {
          ar: t(oldName.ar) || def.defaultAr,
          en: t(oldName.en) || def.defaultEn
        };
      } else {
        newSections[def.key].name = { ar: def.defaultAr, en: def.defaultEn };
      }
    });
    contentObj.products = contentObj.products || {};
    contentObj.products.sections = newSections;
    const existingFooter = existingContentObj?.footer && typeof existingContentObj.footer === 'object'
      ? existingContentObj.footer
      : {};
    contentObj.footer = {
      ...existingFooter,
      socialLinks: {
        ...(existingFooter.socialLinks || {}),
        facebook: t(req.body.footer_facebook),
        instagram: t(req.body.footer_instagram),
        linkedin: ''
      }
    };
    applyUploadedImages(contentObj, req.body, req.files || []);

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
    req.flash('error_msg', 'تعذر تحديث السجل');
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
