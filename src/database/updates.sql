ALTER TABLE quotations
  ADD COLUMN sale_description VARCHAR(255) NULL AFTER client_address,
  ADD COLUMN payment_method VARCHAR(255) NULL AFTER sale_description;

ALTER TABLE materials
  ADD COLUMN additional_expense_items LONGTEXT NULL
  CHECK (json_valid(additional_expense_items))
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
