# نظام إدارة المختبر - Lab Inventory Management System

## نظرة عامة

نظام إدارة المختبر هو تطبيق ويب متكامل مصمم خصيصاً لإدارة مختبر تحليل زيت
الزيتون. يوفر النظام إدارة شاملة للمخزون، طلبات  الشحن، الشهادات،
والمستخدمين مع واجهة مستخدم عربية سهلة الاستخدام.

## المميزات الرئيسية

### 🔐 نظام المصادقة والأمان

- تسجيل الدخول والخروج
- إدارة المستخدمين والصلاحيات (إدارة المستخدمين محصورة بالأدمن فقط)
- حماية المسارات والوظائف
- جلسات آمنة مع MySQL Store

### 📦 إدارة المخزون

- إضافة وتعديل وحذف العينات
- تتبع الكميات الحالية والأساسية
- قياسات جودة زيت الزيتون (pH، البيروكسيد، الامتصاص)
- نظام سلة المحذوفات (Soft Delete)
- طباعة تقارير المخزون
- تصدير البيانات بصيغة PDF

### 🧾 إدارة طلبات  الشحن

- إنشاء وتعديل طلبات  الشحن
- إضافة عينات متعددة لطلبية الشحن
- تتبع حالة الدفع
- طباعة طلبات  الشحن
- نظام سلة المحذوفات للفواتير

### 📋 إدارة الشهادات

- شهادات داخلية وخارجية
- إدارة بيانات العملاء
- طباعة الشهادات
- نظام سلة المحذوفات للشهادات

### 📊 التقارير والتصدير

- تصدير وشارك PDF مباشرة مع روابط عامة
  (الشهادات، عروض الأسعار، الطلبيات، ومعاينة المواد)
- طباعة تقارير مفصلة
- إحصائيات المخزون

## التقنيات المستخدمة

### Backend

- **Node.js** - بيئة تشغيل JavaScript
- **Express.js** - إطار عمل الويب
- **MySQL** - قاعدة البيانات
- **EJS** - محرك القوالب
- **bcrypt** - تشفير كلمات المرور
- **express-session** - إدارة الجلسات
- **helmet** - أمان التطبيق

### Frontend

- **Bootstrap 5** - إطار عمل CSS
- **Font Awesome** - الأيقونات
- **JavaScript (ES6+)** - التفاعل في المتصفح
- **EJS** - قوالب HTML الديناميكية

### الأدوات المساعدة

- **Puppeteer** - إنشاء ملفات PDF
- **ExcelJS** - التعامل مع ملفات Excel
- **Winston** - تسجيل الأحداث
- **Morgan** - تسجيل الطلبات
- **node-cron** - المهام المجدولة

## متطلبات النظام

### البرامج المطلوبة

- **Node.js** (الإصدار 16 أو أحدث)
- **MySQL** (الإصدار 8.0 أو أحدث)
- **npm** أو **yarn**

### متطلبات التشغيل

- **RAM**: 2GB على الأقل
- **مساحة التخزين**: 1GB متاحة
- **نظام التشغيل**: Windows, macOS, Linux

## التثبيت والإعداد

### 1. استنساخ المشروع

```bash
git clone <repository-url>
cd lab_inventory
```

### 2. تثبيت التبعيات

```bash
npm install
```

### 3. إعداد قاعدة البيانات

```bash
# إنشاء قاعدة البيانات
mysql -u root -p
CREATE DATABASE lab_inventory CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit;

# استيراد هيكل قاعدة البيانات
mysql -u root -p lab_inventory < src/database/lab_inventory.sql
```

### 4. إعداد ملف البيئة

```bash
# نسخ ملف البيئة
cp src/.env.example src/.env

# تعديل الإعدادات في src/.env
```

### 5. تشغيل التطبيق

```bash
# وضع التطوير
npm run dev

# وضع الإنتاج
npm start
```

## إعدادات البيئة (.env)

### إعدادات قاعدة البيانات

```env
DB_HOST=localhost          # عنوان خادم قاعدة البيانات
DB_USER=root              # اسم المستخدم
DB_PASSWORD=              # كلمة المرور
DB_NAME=lab_inventory     # اسم قاعدة البيانات
```

### إعدادات التطبيق

```env
NODE_ENV=local            # بيئة التشغيل (local/production)
PORT=3000                 # منفذ التطبيق
STATE=local               # حالة التطبيق
```

### إعدادات الأمان

```env
SESSION_SECRET=your-local-session-secret-here    # مفتاح تشفير الجلسات
COOKIE_SECRET=your-local-cookie-secret-here      # مفتاح تشفير الكوكيز
```

### إعدادات المسارات

```env
BASE_URL=http://localhost:3000    # الرابط الأساسي للتطبيق
# (مطلوب لتوليد روابط PDF العامة)
APP_URL=http://localhost:3000     # رابط التطبيق
APP_NAME=نظام إدارة المختبر       # اسم التطبيق
```

### إعدادات التحميل

```env
UPLOAD_PATH=./uploads     # مسار حفظ الملفات المرفوعة
MAX_FILE_SIZE=50mb        # الحد الأقصى لحجم الملف
```

### إعدادات التسجيل

```env
LOG_LEVEL=debug           # مستوى التسجيل
LOG_PATH=./logs           # مسار ملفات التسجيل
```

## هيكل المشروع

```text
lab_inventory/
├── src/
│   ├── app.js                    # الملف الرئيسي للتطبيق
│   ├── .env                      # ملف إعدادات البيئة
│   ├── controllers/              # وحدات التحكم
│   │   ├── authController.js     # التحكم بالمصادقة
│   │   ├── inventoryController.js # التحكم بالمخزون
│   │   ├── invoiceController.js  # التحكم بطلبات  الشحن
│   │   ├── certificatesController.js # التحكم بالشهادات
│   │   └── userController.js     # التحكم بالمستخدمين
│   ├── database/                 # قاعدة البيانات
│   │   ├── db.js                 # إعداد الاتصال
│   │   ├── init.js               # تهيئة قاعدة البيانات
│   │   └── lab_inventory (4).sql # هيكل قاعدة البيانات
│   ├── middleware/               # الوسائط البرمجية
│   │   ├── auth.js               # وسيط المصادقة
│   │   ├── database.js           # وسيط قاعدة البيانات
│   │   └── validators.js         # وسيط التحقق
│   ├── routes/                   # مسارات التطبيق
│   │   ├── auth.js               # مسارات المصادقة
│   │   ├── inventory.js          # مسارات المخزون
│   │   ├── invoices.js           # مسارات طلبات  الشحن
│   │   ├── certificates.js       # مسارات الشهادات
│   │   └── users.js              # مسارات المستخدمين
│   ├── views/                    # قوالب العرض
│   │   ├── layouts/              # تخطيطات الصفحات
│   │   ├── inventory/            # صفحات المخزون
│   │   ├── invoices/             # صفحات طلبات  الشحن
│   │   ├── certificates/         # صفحات الشهادات
│   │   └── auth/                 # صفحات المصادقة
│   ├── public/                   # الملفات الثابتة
│   │   ├── css/                  # ملفات CSS
│   │   └── js/                   # ملفات JavaScript
│   ├── utils/                    # الأدوات المساعدة
│   │   ├── helpers.js            # دوال مساعدة
│   │   └── logger.js             # نظام التسجيل
│   └── validators/               # قواعد التحقق
├── logs/                         # ملفات التسجيل
├── uploads/                      # الملفات المرفوعة
├── package.json                  # تبعيات المشروع
└── README.md                     # هذا الملف
```

## API Documentation

### المصادقة (Authentication)

#### تسجيل الدخول

```http
POST /auth/login
Content-Type: application/x-www-form-urlencoded

username=admin&password=password
```

#### تسجيل الخروج

```http
GET /auth/logout
```

#### تغيير كلمة المرور

```http
POST /auth/change-password
Content-Type: application/x-www-form-urlencoded

currentPassword=old&newPassword=new&confirmPassword=new
```

### المخزون (Inventory)

#### جلب جميع العينات

```http
GET /inventory
Query Parameters:
- date: تاريخ العينة
- supplier: اسم المورد
- sample_number: رقم العينة
```

#### إنشاء عينة جديدة

```http
POST /inventory/create
Content-Type: application/x-www-form-urlencoded

date=2025-01-01&
sample_number=123&
supplier_or_sample_name=مورد&
base_quantity=100&
current_quantity=100&
ph=7&
peroxide_value=5&
absorption_readings=1.5 2.0 1.8 2.2 1.9&
sigma_absorbance=0.005&
analyst=محلل&
notes=ملاحظات
```

#### تحديث عينة

```http
POST /inventory/:id/edit
Content-Type: application/x-www-form-urlencoded

date=2025-01-01&
sample_number=123&
supplier_or_sample_name=مورد&
base_quantity=100&
current_quantity=50&
ph=7&
peroxide_value=5&
absorption_readings=1.5 2.0 1.8 2.2 1.9&
sigma_absorbance=0.005&
analyst=محلل&
notes=ملاحظات
```

#### نقل عينة إلى سلة المحذوفات

```http
POST /inventory/trash/:id
Content-Type: application/json
```

#### استعادة عينة من سلة المحذوفات

```http
POST /inventory/:id/restore
Content-Type: application/json
```

#### حذف عينات متعددة

```http
POST /inventory/trash
Content-Type: application/json

{
  "ids": [1, 2, 3]
}
```

#### استعادة عينات متعددة

```http
POST /inventory/restore-multiple
Content-Type: application/json

{
  "ids": [1, 2, 3]
}
```

#### تفريغ سلة محذوفات الفواتير

```http
POST /inventory/empty-trash
Content-Type: application/json
```

#### تصدير المخزون بصيغة PDF

```http
GET /inventory/export/pdf
Query Parameters:
- date: تاريخ العينة
- supplier: اسم المورد
- sample_number: رقم العينة
```

#### طباعة المخزون

```http
GET /inventory/print
Query Parameters:
- date: تاريخ العينة
- supplier: اسم المورد
- sample_number: رقم العينة
```

### طلبات  الشحن (Invoices)

#### جلب جميع طلبات  الشحن

```http
GET /invoices
Query Parameters:
- date: تاريخ طلب الشحن
- customer_name: اسم العميل
- status: حالة الدفع (paid/unpaid)
```

#### إنشاء طلبية شحن جديدة

```http
POST /invoices/create
Content-Type: application/x-www-form-urlencoded

invoice_number=INV001&date=2025-01-01&customer_name=عميل&customer_phone=123456789&customer_address=عنوان&driver_name=سائق&notes=ملاحظات&items=[{"inventory_id":1,"quantity":10}]
```

#### تحديث طلبية شحن

```http
POST /invoices/:id/edit
Content-Type: application/x-www-form-urlencoded

invoice_number=INV001&date=2025-01-01&customer_name=عميل&customer_phone=123456789&customer_address=عنوان&driver_name=سائق&notes=ملاحظات&items=[{"inventory_id":1,"quantity":10}]
```

#### نقل طلبية شحن إلى سلة المحذوفات

```http
POST /invoices/trash/:id
Content-Type: application/json
```

#### استعادة طلبية شحن من سلة المحذوفات

```http
POST /invoices/:id/restore
Content-Type: application/json
```

#### حذف فواتير متعددة

```http
POST /invoices/trash
Content-Type: application/json

{
  "ids": [1, 2, 3]
}
```

#### استعادة فواتير متعددة

```http
POST /invoices/restore-multiple
Content-Type: application/json

{
  "ids": [1, 2, 3]
}
```

#### تفريغ سلة محذوفات الشهادات

```http
POST /invoices/empty-trash
Content-Type: application/json
```

### الشهادات (Certificates)

#### جلب جميع الشهادات

```http
GET /certificates
Query Parameters:
- date: تاريخ الشهادة
- customer_name: اسم العميل
- type: نوع الشهادة (internal/external)
```

#### إنشاء شهادة جديدة

```http
POST /certificates/create
Content-Type: application/x-www-form-urlencoded

certificate_number=CERT001&year=2025&type=external&date=2025-01-01&customer_name=عميل&customer_phone=123456789&customer_address=عنوان&analyst=محلل&notes=ملاحظات&items=[{"sample_number":"123","quantity":100,"ph":7,"peroxide":5}]
```

#### تحديث شهادة

```http
POST /certificates/:id/edit
Content-Type: application/x-www-form-urlencoded

certificate_number=CERT001&year=2025&type=external&date=2025-01-01&customer_name=عميل&customer_phone=123456789&customer_address=عنوان&analyst=محلل&notes=ملاحظات&items=[{"sample_number":"123","quantity":100,"ph":7,"peroxide":5}]
```

#### نقل شهادة إلى سلة المحذوفات

```http
POST /certificates/trash/:id
Content-Type: application/json
```

#### استعادة شهادة من سلة المحذوفات

```http
POST /certificates/:id/restore
Content-Type: application/json
```

#### حذف شهادات متعددة

```http
POST /certificates/trash
Content-Type: application/json

{
  "ids": [1, 2, 3]
}
```

#### استعادة شهادات متعددة

```http
POST /certificates/restore-multiple
Content-Type: application/json

{
  "ids": [1, 2, 3]
}
```

#### تفريغ سلة المحذوفات

```http
POST /certificates/empty-trash
Content-Type: application/json
```

### التكاليف (Costs)

#### عروض الأسعار (Quotations)

```http
GET /costs/quotations/:id           # تفاصيل العرض
GET /costs/quotations/:id/print     # صفحة الطباعة
GET /costs/quotations/:id/pdf       # تصدير PDF → رابط عام
GET /costs/quotations/:id/print-pdf-raw  # الطباعة الخام (بدون حماية) لتوليد PDF
```

#### الطلبيات (Orders)

```http
GET /costs/orders/:id               # تفاصيل الطلبية
GET /costs/orders/:id/print         # صفحة الطباعة
GET /costs/orders/:id/pdf           # تصدير PDF → رابط عام
GET /costs/orders/:id/print-pdf-raw # الطباعة الخام (بدون حماية) لتوليد PDF
```

#### معاينة المادة/المادة (Materials)

```http
GET /costs/cost-statement/:id/preview      # معاينة المادة
GET /costs/cost-statement/:id/print        # صفحة الطباعة
GET /costs/cost-statement/:id/pdf          # تصدير PDF → رابط عام
GET /costs/cost-statement/:id/print-pdf-raw # الطباعة الخام لتوليد PDF
```

ملاحظة: يتم حفظ ملفات PDF المصدّرة في مجلدات عامة يمكن الوصول إليها بالرابط:

- public/certificates_pdf/
- public/quotations_pdf/
- public/orders_pdf/
- public/materials_pdf/

### المستخدمين (Users)

#### جلب جميع المستخدمين

```http
GET /users
```

#### إنشاء مستخدم جديد

```http
POST /users/create
Content-Type: application/x-www-form-urlencoded

username=user&password=password&role_id=2|3|4
```

#### تحديث مستخدم

```http
POST /users/:id/edit
Content-Type: application/x-www-form-urlencoded

username=user&role_id=2|3|4
```

#### حذف مستخدم

```http
POST /users/delete/:id
Content-Type: application/json
```

## قاعدة البيانات

### الجداول الرئيسية

#### جدول المستخدمين (users)

يعتمد النظام على `role_id` (قيم نموذجية: 2=editor، 3=viewer، 4=admin)
مع جدول أدوار مستقل.

#### جدول المخزون (inventory)

```sql
CREATE TABLE inventory (
  id INT PRIMARY KEY AUTO_INCREMENT,
  date DATE NOT NULL,
  sample_number VARCHAR(50) NOT NULL,
  supplier_or_sample_name VARCHAR(255) NOT NULL,
  base_quantity DECIMAL(10,2),
  current_quantity DECIMAL(10,2),
  sample_weight DECIMAL(10,2),
  net_weight_total DECIMAL(10,2) NOT NULL,
  ph DECIMAL(4,2),
  peroxide_value DECIMAL(10,2),
  absorption_readings VARCHAR(255),
  sigma_absorbance DECIMAL(10,4),
  notes TEXT,
  analyst VARCHAR(100),
  is_rejected TINYINT(1) DEFAULT 0,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### جدول طلبات  الشحن (invoices)

```sql
CREATE TABLE invoices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  invoice_number VARCHAR(50) NOT NULL,
  date DATE NOT NULL,
  customer_name VARCHAR(255) NOT NULL,
  driver_name VARCHAR(255),
  notes TEXT,
  customer_phone VARCHAR(20),
  customer_address TEXT,
  total_amount DECIMAL(10,2) NOT NULL,
  status ENUM('paid', 'unpaid') DEFAULT 'unpaid',
  created_by INT NOT NULL,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### جدول عناصر طلبات  الشحن (invoice_items)

```sql
CREATE TABLE invoice_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  invoice_id INT NOT NULL,
  inventory_id INT NOT NULL,
  quantity DECIMAL(10,2) NOT NULL,
  net_weight DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
  FOREIGN KEY (inventory_id) REFERENCES inventory(id)
);
```

#### جدول الشهادات (certificates)

```sql
CREATE TABLE certificates (
  id INT PRIMARY KEY AUTO_INCREMENT,
  certificate_number VARCHAR(50),
  year INT,
  type ENUM('internal', 'external'),
  date DATE,
  customer_name VARCHAR(255),
  customer_phone VARCHAR(20),
  customer_address TEXT,
  analyst VARCHAR(100),
  notes TEXT,
  items JSON,
  total_quantity DECIMAL(10,2),
  total_weight DECIMAL(10,2),
  public_id VARCHAR(36),
  created_by INT,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## الأمان

### حماية التطبيق

- **Helmet.js**: حماية من هجمات XSS و CSRF
- **bcrypt**: تشفير كلمات المرور
- **express-session**: إدارة الجلسات الآمنة
- **express-validator**: التحقق من المدخلات

### إدارة الصلاحيات

- **Admin**: صلاحيات كاملة، وإدارة المستخدمين والمشاهدة والتعديل والحذف
- **Editor**: صلاحيات التحرير حسب نطاق الشاشات المسموح بها، بدون إدارة المستخدمين
- **Viewer**: عرض فقط

### حماية المسارات

- جميع المسارات محمية ما عدا مسارات الطباعة الخام التالية اللازمة لتوليد PDF:
  - /certificates/:id/print-pdf-raw
  - /costs/quotations/:id/print-pdf-raw
  - /costs/orders/:id/print-pdf-raw
  - /costs/cost-statement/:id/print-pdf-raw
- التحقق من الصلاحيات قبل تنفيذ العمليات؛ إدارة المستخدمين محصورة بالأدمن

## المهام المجدولة

### حذف السجلات المحذوفة ناعماً

```javascript
// كل يوم عند منتصف الليل
cron.schedule('0 0 * * *', async () => {
  // حذف السجلات المحذوفة ناعماً التي يزيد عمرها عن شهر واحد
});
```

## التطوير

### تشغيل في وضع التطوير

```bash
npm run dev
```

### تشغيل في وضع الإنتاج

```bash
npm start
```

### تهيئة قاعدة البيانات

```bash
npm run init-db
```

## استكشاف الأخطاء

### مشاكل شائعة

#### خطأ في الاتصال بقاعدة البيانات

```bash
# التحقق من إعدادات MySQL
mysql -u root -p
# التأكد من وجود قاعدة البيانات
SHOW DATABASES;
```

#### خطأ في المنفذ

```bash
# التحقق من المنفذ المستخدم
netstat -an | grep 3000
# تغيير المنفذ في ملف .env
PORT=3001
```

#### خطأ في الصلاحيات

```bash
# التأكد من صلاحيات الملفات
chmod 755 src/
chmod 644 src/.env
```

## المساهمة

1. Fork المشروع
2. إنشاء فرع للميزة الجديدة (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push إلى الفرع (`git push origin feature/AmazingFeature`)
5. فتح Pull Request

## الترخيص

هذا المشروع مرخص تحت رخصة MIT. راجع ملف `LICENSE` للتفاصيل.

## الدعم

للدعم الفني أو الاستفسارات، يرجى التواصل عبر:

- البريد الإلكتروني: <anas.kilani@nexa-group.net>
- الهاتف: +963-964594375

## الإصدارات

### v2.0.0 (الحالي)

- تحديث كامل لتخطيط طباعة عرض السعر: تقليل المساحات العلوية، تكديس بطاقات
  المعلومات رأسياً، تخفيض ارتفاع الصفوف، وتحكم دقيق بعدد الأسطر لكل صفحة
  (الأولى حتى 19 سطراً، ثم 30 سطراً في بقية الصفحات) مع فوتر أنيق ثابت
- إضافة تصدير PDF مع روابط مشاركة عامة لعروض الأسعار والطلبيات ومعاينة
  المواد، اعتماداً على صفحات الطباعة الحالية
- حصر إدارة المستخدمين بالأدمن وإخفاء الروابط لغير الأدمن في الواجهة
- تحسينات عدة على الفوتر في الطباعة لالتصاقه بأسفل الصفحة وخط فاصل مناسب

### v1.0.0 (سابق)

- نظام إدارة المخزون الأساسي
- نظام إدارة طلبات  الشحن
- نظام إدارة الشهادات
- نظام المصادقة والأمان
- واجهة مستخدم عربية
- تصدير البيانات بصيغة PDF
- نظام سلة المحذوفات

## خطة التطوير المستقبلية

### v1.1.0 (قيد التطوير)

- [ ] نظام التنبيهات
- [ ] لوحة تحكم للإحصائيات
- [ ] نظام النسخ الاحتياطي التلقائي
- [ ] واجهة API للجوال

### v1.2.0 (مخطط)

- [ ] نظام التقارير المتقدمة
- [ ] دعم متعدد اللغات
- [ ] نظام الإشعارات
- [ ] تكامل مع أنظمة خارجية

---

تم تطوير هذا النظام بواسطة فريق NEXA GROUP للبرمجيات.
