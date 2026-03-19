ALTER TABLE quotations
  ADD COLUMN sale_description VARCHAR(255) NULL AFTER client_address,
  ADD COLUMN payment_method VARCHAR(255) NULL AFTER sale_description;

ALTER TABLE materials
  ADD COLUMN additional_expense_items LONGTEXT NULL
  AFTER gross_package_weight;

UPDATE materials
SET additional_expense_items = JSON_ARRAY(
  JSON_OBJECT(
    'name', 'مصروف إضافي',
    'price', ROUND(COALESCE(additional_expenses, 0), 2)
  )
)
WHERE COALESCE(additional_expenses, 0) > 0
  AND (
    additional_expense_items IS NULL
    OR TRIM(additional_expense_items) = ''
    OR additional_expense_items = '[]'
  );

ALTER TABLE materials
  ADD COLUMN material_origin ENUM('internal', 'external') NOT NULL DEFAULT 'internal' AFTER material_name,
  ADD COLUMN external_notes TEXT NULL AFTER additional_expense_items;

ALTER TABLE materials
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER external_notes;

ALTER TABLE quotations
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER general_profit_percentage;

ALTER TABLE quotation_items
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER item_notes;

ALTER TABLE orders
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER notes;

ALTER TABLE order_items
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER gross_weight;

ALTER TABLE inventory
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER notes;

ALTER TABLE invoices
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER total_quantity_liters;

ALTER TABLE invoice_items
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER delta_k;

ALTER TABLE material_components
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER price_per_kg_syp;

ALTER TABLE cost_logs
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER package_cost_syp;

ALTER TABLE notes
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER note_text;

ALTER TABLE certificates
  ADD COLUMN numeric_raw LONGTEXT NULL
  AFTER total_weight;

-- ------------------------------------------------------------
-- Ensure trigger dependency exists
-- material_components triggers call this procedure; if missing,
-- updates on material_components fail with #1305.
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS `CalculateMaterialCostFromComponents`;
DELIMITER $$
CREATE PROCEDURE `CalculateMaterialCostFromComponents` (IN `material_id` INT)
BEGIN
  DECLARE total_cost DECIMAL(10,3) DEFAULT 0.00;
  DECLARE total_cost_syp DECIMAL(15,3) DEFAULT 0.00;
  DECLARE total_weight DECIMAL(10,3) DEFAULT 0.00;

  SELECT
    COALESCE(SUM((weight_grams / 1000.0) * price_per_kg), 0),
    COALESCE(SUM((weight_grams / 1000.0) * price_per_kg_syp), 0),
    COALESCE(SUM(weight_grams / 1000.0), 0)
  INTO total_cost, total_cost_syp, total_weight
  FROM material_components
  WHERE material_components.material_id = material_id;

  UPDATE materials
  SET
    price_before_waste = total_cost,
    price_before_waste_syp = total_cost_syp,
    gross_weight = total_weight
  WHERE id = material_id;
END$$
DELIMITER ;

-- ------------------------------------------------------------
-- Backfill numeric_raw from existing numeric columns
-- Executes only when numeric_raw is empty/invalid
-- ------------------------------------------------------------

UPDATE materials
SET numeric_raw = JSON_OBJECT(
  'price_before_waste', CAST(price_before_waste AS CHAR),
  'price_before_waste_syp', CAST(price_before_waste_syp AS CHAR),
  'gross_weight', CAST(gross_weight AS CHAR),
  'waste_percentage', CAST(waste_percentage AS CHAR),
  'packaging_weight', CAST(packaging_weight AS CHAR),
  'packaging_unit_weight', CAST(packaging_unit_weight AS CHAR),
  'empty_package_price', CAST(empty_package_price AS CHAR),
  'empty_package_price_syp', CAST(empty_package_price_syp AS CHAR),
  'sticker_price', CAST(sticker_price AS CHAR),
  'sticker_price_syp', CAST(sticker_price_syp AS CHAR),
  'additional_expenses', CAST(additional_expenses AS CHAR),
  'additional_expenses_syp', CAST(additional_expenses_syp AS CHAR),
  'labor_cost', CAST(labor_cost AS CHAR),
  'labor_cost_syp', CAST(labor_cost_syp AS CHAR),
  'preservatives_cost', CAST(preservatives_cost AS CHAR),
  'preservatives_cost_syp', CAST(preservatives_cost_syp AS CHAR),
  'carton_price', CAST(carton_price AS CHAR),
  'carton_price_syp', CAST(carton_price_syp AS CHAR),
  'pieces_per_package', CAST(pieces_per_package AS CHAR),
  'pallet_price', CAST(pallet_price AS CHAR),
  'pallet_price_syp', CAST(pallet_price_syp AS CHAR),
  'packages_per_pallet', CAST(packages_per_pallet AS CHAR),
  'unit_cost', CAST(unit_cost AS CHAR),
  'unit_cost_syp', CAST(unit_cost_syp AS CHAR),
  'package_cost', CAST(package_cost AS CHAR),
  'package_cost_syp', CAST(package_cost_syp AS CHAR),
  'gross_package_weight', CAST(gross_package_weight AS CHAR),
  -- Keys used by external-material flow to preserve exactly-entered values.
  'external_unit_cost', CAST(unit_cost AS CHAR),
  'external_package_cost', CAST(package_cost AS CHAR),
  'external_cost_per_kg', CAST(price_before_waste AS CHAR),
  'external_net_weight', CAST(packaging_weight AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE materials
SET numeric_raw = JSON_SET(
  IF(
    IFNULL(JSON_VALID(numeric_raw), 0) = 1,
    numeric_raw,
    JSON_OBJECT()
  ),
  '$.external_unit_cost', CAST(unit_cost AS CHAR),
  '$.external_package_cost', CAST(package_cost AS CHAR),
  '$.external_cost_per_kg', CAST(price_before_waste AS CHAR),
  '$.external_net_weight', CAST(packaging_weight AS CHAR)
)
WHERE material_origin = 'external'
  AND (
    numeric_raw IS NULL
    OR TRIM(numeric_raw) = ''
    OR IFNULL(JSON_VALID(numeric_raw), 0) = 0
    OR JSON_EXTRACT(numeric_raw, '$.external_unit_cost') IS NULL
    OR JSON_EXTRACT(numeric_raw, '$.external_package_cost') IS NULL
    OR JSON_EXTRACT(numeric_raw, '$.external_cost_per_kg') IS NULL
    OR JSON_EXTRACT(numeric_raw, '$.external_net_weight') IS NULL
  );

UPDATE quotations
SET numeric_raw = JSON_OBJECT(
  'total_amount', CAST(total_amount AS CHAR),
  'total_amount_syp', CAST(total_amount_syp AS CHAR),
  'general_profit_percentage', CAST(general_profit_percentage AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE quotation_items
SET numeric_raw = JSON_OBJECT(
  'unit_cost', CAST(unit_cost AS CHAR),
  'unit_cost_syp', CAST(unit_cost_syp AS CHAR),
  'profit_percentage', CAST(profit_percentage AS CHAR),
  'final_price', CAST(final_price AS CHAR),
  'final_price_syp', CAST(final_price_syp AS CHAR),
  'quantity', CAST(quantity AS CHAR),
  'total_price', CAST(total_price AS CHAR),
  'total_price_syp', CAST(total_price_syp AS CHAR),
  'packaging_weight', CAST(packaging_weight AS CHAR),
  'pieces_per_package', CAST(pieces_per_package AS CHAR),
  'package_cost', CAST(package_cost AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE orders
SET numeric_raw = JSON_OBJECT(
  'pallets_count', CAST(pallets_count AS CHAR),
  'packages_count', CAST(packages_count AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE order_items
SET numeric_raw = JSON_OBJECT(
  'quantity', CAST(quantity AS CHAR),
  'weight', CAST(weight AS CHAR),
  'net_weight', CAST(net_weight AS CHAR),
  'gross_weight', CAST(gross_weight AS CHAR),
  'volume', CAST(volume AS CHAR),
  'requested_quantity', CAST(requested_quantity AS CHAR),
  'unit_price', CAST(unit_price AS CHAR),
  'unit_price_syp', CAST(unit_price_syp AS CHAR),
  'total_price', CAST(total_price AS CHAR),
  'total_price_syp', CAST(total_price_syp AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE inventory
SET numeric_raw = JSON_OBJECT(
  'base_quantity', CAST(base_quantity AS CHAR),
  'current_quantity', CAST(current_quantity AS CHAR),
  'sample_weight', CAST(sample_weight AS CHAR),
  'net_weight_total', CAST(net_weight_total AS CHAR),
  'ph', CAST(ph AS CHAR),
  'peroxide_value', CAST(peroxide_value AS CHAR),
  'sigma_absorbance', CAST(sigma_absorbance AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE invoices
SET numeric_raw = JSON_OBJECT(
  'total_amount', CAST(total_amount AS CHAR),
  'avg_ph', CAST(avg_ph AS CHAR),
  'avg_peroxide', CAST(avg_peroxide AS CHAR),
  'avg_232', CAST(avg_232 AS CHAR),
  'avg_270', CAST(avg_270 AS CHAR),
  'avg_delta_k', CAST(avg_delta_k AS CHAR),
  'total_quantity_tanks', CAST(total_quantity_tanks AS CHAR),
  'total_quantity_liters', CAST(total_quantity_liters AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE invoice_items
SET numeric_raw = JSON_OBJECT(
  'quantity', CAST(quantity AS CHAR),
  'price', CAST(price AS CHAR),
  'net_weight', CAST(net_weight AS CHAR),
  'ph', CAST(ph AS CHAR),
  'peroxide_value', CAST(peroxide_value AS CHAR),
  'absorption_232', CAST(absorption_232 AS CHAR),
  'absorption_266', CAST(absorption_266 AS CHAR),
  'absorption_270', CAST(absorption_270 AS CHAR),
  'absorption_274', CAST(absorption_274 AS CHAR),
  'delta_k', CAST(delta_k AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE material_components
SET numeric_raw = JSON_OBJECT(
  'weight_grams', CAST(weight_grams AS CHAR),
  'price_per_kg', CAST(price_per_kg AS CHAR),
  'price_per_kg_syp', CAST(price_per_kg_syp AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE cost_logs
SET numeric_raw = JSON_OBJECT(
  'unit_cost', CAST(unit_cost AS CHAR),
  'unit_cost_syp', CAST(unit_cost_syp AS CHAR),
  'package_cost', CAST(package_cost AS CHAR),
  'package_cost_syp', CAST(package_cost_syp AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE notes
SET numeric_raw = JSON_OBJECT(
  'price', CAST(price AS CHAR),
  'weight', CAST(weight AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

UPDATE certificates
SET numeric_raw = JSON_OBJECT(
  'year', CAST(year AS CHAR),
  'total_quantity', CAST(total_quantity AS CHAR),
  'total_weight', CAST(total_weight AS CHAR)
)
WHERE numeric_raw IS NULL
   OR TRIM(numeric_raw) = ''
   OR IFNULL(JSON_VALID(numeric_raw), 0) = 0;

-- ------------------------------------------------------------
-- Add shipping orders manager role (CRUD for /invoices only)
-- ------------------------------------------------------------
INSERT INTO roles (id, name)
VALUES (5, 'shipping_manager')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- دعم سلة المحذوفات لجدول المواد
ALTER TABLE materials
  ADD COLUMN IF NOT EXISTS deleted_at DATETIME NULL AFTER updated_at;

ALTER TABLE materials
  ADD INDEX IF NOT EXISTS idx_materials_deleted_at (deleted_at);

-- ------------------------------------------------------------
-- إدارة محتوى الموقع (Admin only)
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

-- ------------------------------------------------------------
-- رسائل التواصل (البريد الوارد في إدارة الموقع)
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
