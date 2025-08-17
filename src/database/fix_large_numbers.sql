-- حل مشكلة الأرقام الكبيرة في قاعدة البيانات
-- قم بتنفيذ هذه الأوامر في قاعدة البيانات على الاستضافة

-- تحديث جدول materials للتعامل مع الأرقام الكبيرة
ALTER TABLE materials 
MODIFY COLUMN price_before_waste DECIMAL(15,2) NOT NULL,
MODIFY COLUMN price_before_waste_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN gross_weight DECIMAL(15,2) NOT NULL,
MODIFY COLUMN waste_percentage DECIMAL(5,2) NOT NULL,
MODIFY COLUMN packaging_weight DECIMAL(15,2) NOT NULL,
MODIFY COLUMN packaging_unit_weight DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN empty_package_price DECIMAL(15,2) NOT NULL,
MODIFY COLUMN empty_package_price_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN sticker_price DECIMAL(15,2) NOT NULL,
MODIFY COLUMN sticker_price_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN additional_expenses DECIMAL(15,2) NOT NULL,
MODIFY COLUMN additional_expenses_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN labor_cost DECIMAL(15,2) NOT NULL,
MODIFY COLUMN labor_cost_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN preservatives_cost DECIMAL(15,2) NOT NULL,
MODIFY COLUMN preservatives_cost_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN carton_price DECIMAL(15,2) NOT NULL,
MODIFY COLUMN carton_price_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN pallet_price DECIMAL(15,2) NOT NULL,
MODIFY COLUMN pallet_price_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN unit_cost DECIMAL(15,2) NOT NULL,
MODIFY COLUMN unit_cost_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN package_cost DECIMAL(15,2) NOT NULL,
MODIFY COLUMN package_cost_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN gross_package_weight DECIMAL(15,2) DEFAULT NULL;

-- تحديث جدول cost_logs للتعامل مع الأرقام الكبيرة
ALTER TABLE cost_logs 
MODIFY COLUMN unit_cost DECIMAL(15,2) NOT NULL,
MODIFY COLUMN unit_cost_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN package_cost DECIMAL(15,2) NOT NULL,
MODIFY COLUMN package_cost_syp DECIMAL(15,2) DEFAULT NULL;

-- تحديث جدول notes للتعامل مع الأرقام الكبيرة
ALTER TABLE notes 
MODIFY COLUMN price DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN weight DECIMAL(15,3) DEFAULT NULL;

-- إضافة فهارس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_materials_type ON materials(material_type);
CREATE INDEX IF NOT EXISTS idx_materials_name ON materials(material_name);
CREATE INDEX IF NOT EXISTS idx_materials_created_at ON materials(created_at);

-- التحقق من الإعدادات الحالية
SHOW VARIABLES LIKE 'max_allowed_packet';
SHOW VARIABLES LIKE 'net_buffer_length';
SHOW VARIABLES LIKE 'max_connections';

-- تحديث إعدادات MySQL للتعامل مع الأرقام الكبيرة (إذا كان لديك صلاحيات)
-- SET GLOBAL max_allowed_packet = 67108864; -- 64MB
-- SET GLOBAL net_buffer_length = 1048576; -- 1MB
-- SET GLOBAL max_connections = 200;
