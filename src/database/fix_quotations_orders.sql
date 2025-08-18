-- حل مشكلة الأرقام الكبيرة في جداول عروض الأسعار والطلبيات
-- قم بتنفيذ هذه الأوامر في قاعدة البيانات على الاستضافة

-- تحديث جدول quotations للتعامل مع الأرقام الكبيرة
ALTER TABLE quotations 
MODIFY COLUMN total_amount DECIMAL(15,2) NOT NULL,
MODIFY COLUMN total_amount_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN general_profit_percentage DECIMAL(5,2) DEFAULT 0.00;

-- تحديث جدول quotation_items للتعامل مع الأرقام الكبيرة
ALTER TABLE quotation_items 
MODIFY COLUMN unit_cost DECIMAL(15,2) NOT NULL,
MODIFY COLUMN unit_cost_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN profit_percentage DECIMAL(5,2) DEFAULT 0.00,
MODIFY COLUMN final_price DECIMAL(15,2) NOT NULL,
MODIFY COLUMN final_price_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN quantity DECIMAL(15,3) NOT NULL,
MODIFY COLUMN total_price DECIMAL(15,2) NOT NULL,
MODIFY COLUMN total_price_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN packaging_weight DECIMAL(15,3) DEFAULT NULL,
MODIFY COLUMN pieces_per_package DECIMAL(15,3) DEFAULT NULL,
MODIFY COLUMN package_cost DECIMAL(15,2) DEFAULT NULL;

-- تحديث جدول orders للتعامل مع الأرقام الكبيرة
ALTER TABLE orders 
MODIFY COLUMN pallets_count DECIMAL(15,3) DEFAULT NULL,
MODIFY COLUMN packages_count DECIMAL(15,3) DEFAULT NULL;

-- تحديث جدول order_items للتعامل مع الأرقام الكبيرة
ALTER TABLE order_items 
MODIFY COLUMN requested_quantity DECIMAL(15,3) NOT NULL,
MODIFY COLUMN weight DECIMAL(15,3) DEFAULT NULL,
MODIFY COLUMN volume DECIMAL(15,3) DEFAULT NULL,
MODIFY COLUMN unit_price DECIMAL(15,2) NOT NULL,
MODIFY COLUMN unit_price_syp DECIMAL(15,2) DEFAULT NULL,
MODIFY COLUMN total_price DECIMAL(15,2) NOT NULL,
MODIFY COLUMN total_price_syp DECIMAL(15,2) DEFAULT NULL;

-- إضافة فهارس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_quotations_number ON quotations(quotation_number);
CREATE INDEX IF NOT EXISTS idx_quotations_client ON quotations(client_name);
CREATE INDEX IF NOT EXISTS idx_quotations_created_at ON quotations(created_at);
CREATE INDEX IF NOT EXISTS idx_quotation_items_quotation_id ON quotation_items(quotation_id);
CREATE INDEX IF NOT EXISTS idx_quotation_items_material_id ON quotation_items(material_id);

CREATE INDEX IF NOT EXISTS idx_orders_number ON orders(order_number);
CREATE INDEX IF NOT EXISTS idx_orders_client ON orders(client_name);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_material_id ON order_items(material_id);

-- التحقق من الإعدادات الحالية
SHOW VARIABLES LIKE 'max_allowed_packet';
SHOW VARIABLES LIKE 'net_buffer_length';
SHOW VARIABLES LIKE 'max_connections';

-- تحديث إعدادات MySQL للتعامل مع الأرقام الكبيرة (إذا كان لديك صلاحيات)
-- SET GLOBAL max_allowed_packet = 67108864; -- 64MB
-- SET GLOBAL net_buffer_length = 1048576; -- 1MB
-- SET GLOBAL max_connections = 200;
