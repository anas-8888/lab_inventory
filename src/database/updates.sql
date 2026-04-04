-- ============================================================
-- Landing Page DB Updates (Only 3 tables)
-- Affected tables:
--   1) website_content
--   2) website_contact_messages
--   3) website_contact_attachments
-- ============================================================

-- ------------------------------------------------------------
-- 1) Website content (single source for logo/icon/products)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS website_content (
  id INT AUTO_INCREMENT PRIMARY KEY,
  content_name VARCHAR(255) NOT NULL,
  site_id VARCHAR(191) NULL,
  content_json LONGTEXT NOT NULL,
  created_by INT NULL,
  updated_by INT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at DATETIME NULL,
  INDEX idx_website_content_site_id (site_id),
  INDEX idx_website_content_deleted_at (deleted_at),
  INDEX idx_website_content_created_by (created_by),
  INDEX idx_website_content_updated_by (updated_by),
  CONSTRAINT fk_website_content_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_website_content_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL,
  CHECK (JSON_VALID(content_json))
);

-- Optional: create one default row if table is empty
INSERT INTO website_content (content_name, site_id, content_json, created_by, updated_by)
SELECT
  'محتوى الموقع الرئيسي',
  'olive-bloom-portfolio',
  JSON_OBJECT(
    'branding', JSON_OBJECT(
      'logo', JSON_OBJECT('url', ''),
      'icon', JSON_OBJECT('url', '')
    ),
    'products', JSON_OBJECT(
      'sections', JSON_OBJECT(
        'olive_products', JSON_OBJECT(
          'name', JSON_OBJECT('ar', 'منتجات الزيتون', 'en', 'Olive Products'),
          'categories', JSON_ARRAY(),
          'items', JSON_ARRAY()
        ),
        'olive_oil', JSON_OBJECT(
          'name', JSON_OBJECT('ar', 'زيت الزيتون', 'en', 'Olive Oil'),
          'categories', JSON_ARRAY(),
          'items', JSON_ARRAY()
        ),
        'agri_crops', JSON_OBJECT(
          'name', JSON_OBJECT('ar', 'المحاصيل الزراعية', 'en', 'Agricultural Crops'),
          'categories', JSON_ARRAY(),
          'items', JSON_ARRAY()
        )
      )
    ),
    'updatedBy', ''
  ),
  NULL,
  NULL
WHERE NOT EXISTS (SELECT 1 FROM website_content);

-- Normalize existing content_json to new minimal structure
UPDATE website_content
SET content_json = JSON_OBJECT(
  'branding', JSON_OBJECT(
    'logo', JSON_OBJECT('url', IFNULL(JSON_UNQUOTE(JSON_EXTRACT(content_json, '$.branding.logo.url')), '')),
    'icon', JSON_OBJECT('url', IFNULL(JSON_UNQUOTE(JSON_EXTRACT(content_json, '$.branding.icon.url')), ''))
  ),
  'products', JSON_OBJECT(
    'sections', JSON_OBJECT(
      'olive_products', IFNULL(
        JSON_EXTRACT(content_json, '$.products.sections.olive_products'),
        JSON_OBJECT(
          'name', JSON_OBJECT('ar', 'منتجات الزيتون', 'en', 'Olive Products'),
          'categories', JSON_ARRAY(),
          'items', JSON_ARRAY()
        )
      ),
      'olive_oil', IFNULL(
        JSON_EXTRACT(content_json, '$.products.sections.olive_oil'),
        JSON_OBJECT(
          'name', JSON_OBJECT('ar', 'زيت الزيتون', 'en', 'Olive Oil'),
          'categories', JSON_ARRAY(),
          'items', JSON_ARRAY()
        )
      ),
      'agri_crops', IFNULL(
        JSON_EXTRACT(content_json, '$.products.sections.agri_crops'),
        JSON_OBJECT(
          'name', JSON_OBJECT('ar', 'المحاصيل الزراعية', 'en', 'Agricultural Crops'),
          'categories', JSON_ARRAY(),
          'items', JSON_ARRAY()
        )
      )
    )
  ),
  'updatedBy', IFNULL(JSON_UNQUOTE(JSON_EXTRACT(content_json, '$.updatedBy')), '')
)
WHERE deleted_at IS NULL
  AND IFNULL(JSON_VALID(content_json), 0) = 1;

-- ------------------------------------------------------------
-- 2) Inbox messages table
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS website_contact_messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sender_name VARCHAR(191) NOT NULL,
  sender_phone VARCHAR(100) NOT NULL,
  message_text TEXT NOT NULL,
  sender_ip VARCHAR(45) NULL,
  user_agent TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_wcm_created_at (created_at),
  INDEX idx_wcm_sender_phone (sender_phone)
);

-- ------------------------------------------------------------
-- 3) Inbox attachments table
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS website_contact_attachments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  message_id INT NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_wca_message_id (message_id),
  CONSTRAINT fk_wca_message_id
    FOREIGN KEY (message_id) REFERENCES website_contact_messages(id)
    ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Costs / Orders: add recipient name for shipping/order print
-- ------------------------------------------------------------
SET @orders_recipient_name_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'orders'
    AND COLUMN_NAME = 'recipient_name'
);

SET @orders_recipient_name_sql := IF(
  @orders_recipient_name_exists = 0,
  'ALTER TABLE orders ADD COLUMN recipient_name VARCHAR(255) NULL AFTER client_name',
  'SELECT 1'
);

PREPARE orders_recipient_name_stmt FROM @orders_recipient_name_sql;
EXECUTE orders_recipient_name_stmt;
DEALLOCATE PREPARE orders_recipient_name_stmt;

