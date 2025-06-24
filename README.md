# نظام إدارة المختبر - Lab Inventory Management System

## نظرة عامة

نظام إدارة المختبر هو تطبيق ويب متكامل مصمم خصيصاً لإدارة مختبر تحليل زيت الزيتون. يوفر النظام إدارة شاملة للمخزون، الفواتير، الشهادات، والمستخدمين مع واجهة مستخدم عربية سهلة الاستخدام.

## المميزات الرئيسية

### 🔐 نظام المصادقة والأمان
- تسجيل الدخول والخروج
- إدارة المستخدمين والصلاحيات (Admin, Editor, Viewer)
- حماية المسارات والوظائف
- جلسات آمنة مع MySQL Store
- تشفير كلمات المرور باستخدام bcrypt

### 📦 إدارة المخزون
- إضافة وتعديل وحذف العينات
- تتبع الكميات الحالية والأساسية
- قياسات جودة زيت الزيتون (pH، البيروكسيد، الامتصاص)
- نظام سلة المحذوفات (Soft Delete)
- طباعة تقارير المخزون
- تصدير البيانات بصيغة PDF
- البحث والفلترة المتقدمة
- نظام رفض العينات

### 🧾 إدارة الفواتير
- إنشاء وتعديل الفواتير
- إضافة عينات متعددة للفاتورة
- تتبع حالة الدفع (مدفوع/غير مدفوع)
- طباعة الفواتير
- نظام سلة المحذوفات للفواتير
- حساب الأوزان الصافية تلقائياً
- تتبع حركة المبيعات

### 📋 إدارة الشهادات
- شهادات داخلية وخارجية
- إدارة بيانات العملاء
- طباعة الشهادات
- نظام سلة المحذوفات للشهادات
- رموز QR للوصول العام
- قياسات متعددة للعينات

### 📊 التقارير والتصدير
- تصدير البيانات بصيغة PDF
- طباعة تقارير مفصلة
- إحصائيات المخزون
- تقارير حركة المبيعات
- طباعة بصيغة A4 محسنة

## التقنيات المستخدمة

### Backend
- **Node.js** (v16+) - بيئة تشغيل JavaScript
- **Express.js** (v4.18+) - إطار عمل الويب
- **MySQL** (v8.0+) - قاعدة البيانات
- **EJS** (v3.1+) - محرك القوالب
- **bcrypt** (v6.0+) - تشفير كلمات المرور
- **express-session** (v1.17+) - إدارة الجلسات
- **helmet** (v8.1+) - أمان التطبيق
- **mysql2** (v3.14+) - محرك MySQL
- **express-validator** (v7.0+) - التحقق من المدخلات

### Frontend
- **Bootstrap 5** - إطار عمل CSS
- **Font Awesome** - الأيقونات
- **JavaScript (ES6+)** - التفاعل في المتصفح
- **EJS** - قوالب HTML الديناميكية
- **jQuery** - معالجة DOM

### الأدوات المساعدة
- **Puppeteer** (v24.10+) - إنشاء ملفات PDF
- **ExcelJS** (v4.4+) - التعامل مع ملفات Excel
- **Winston** (v3.8+) - تسجيل الأحداث
- **Morgan** (v1.10+) - تسجيل الطلبات
- **node-cron** (v4.1+) - المهام المجدولة
- **QRCode** (v1.5+) - إنشاء رموز QR
- **UUID** (v11.1+) - إنشاء معرفات فريدة

## متطلبات النظام

### البرامج المطلوبة
- **Node.js** (الإصدار 16 أو أحدث)
- **MySQL** (الإصدار 8.0 أو أحدث)
- **npm** أو **yarn**

### متطلبات النظام
- **RAM**: 2GB على الأقل
- **مساحة التخزين**: 1GB متاحة
- **نظام التشغيل**: Windows, macOS, Linux
- **المتصفح**: Chrome, Firefox, Safari, Edge (الإصدارات الحديثة)

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
mysql -u root -p lab_inventory < src/database/lab_inventory\ \(4\).sql
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

```
lab_inventory/
├── src/
│   ├── app.js                    # الملف الرئيسي للتطبيق
│   ├── .env                      # ملف إعدادات البيئة
│   ├── controllers/              # وحدات التحكم
│   │   ├── authController.js     # التحكم بالمصادقة
│   │   ├── inventoryController.js # التحكم بالمخزون
│   │   ├── invoiceController.js  # التحكم بالفواتير
│   │   ├── certificatesController.js # التحكم بالشهادات
│   │   ├── userController.js     # التحكم بالمستخدمين
│   │   ├── exportController.js   # التحكم بالتصدير
│   │   └── homeController.js     # التحكم بالصفحة الرئيسية
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
│   │   ├── invoices.js           # مسارات الفواتير
│   │   ├── certificates.js       # مسارات الشهادات
│   │   ├── users.js              # مسارات المستخدمين
│   │   ├── exports.js            # مسارات التصدير
│   │   └── index.js              # المسارات الرئيسية
│   ├── views/                    # قوالب العرض
│   │   ├── layouts/              # تخطيطات الصفحات
│   │   │   ├── main.ejs          # التخطيط الرئيسي
│   │   │   ├── public.ejs        # تخطيط الصفحات العامة
│   │   │   ├── header.ejs        # رأس الصفحة
│   │   │   └── footer.ejs        # تذييل الصفحة
│   │   ├── inventory/            # صفحات المخزون
│   │   │   ├── index.ejs         # قائمة المخزون
│   │   │   ├── create.ejs        # إنشاء عينة
│   │   │   ├── edit.ejs          # تعديل عينة
│   │   │   ├── show.ejs          # عرض عينة
│   │   │   ├── deleted.ejs       # سلة المحذوفات
│   │   │   └── print.ejs         # صفحة الطباعة
│   │   ├── invoices/             # صفحات الفواتير
│   │   │   ├── index.ejs         # قائمة الفواتير
│   │   │   ├── create.ejs        # إنشاء فاتورة
│   │   │   ├── edit.ejs          # تعديل فاتورة
│   │   │   ├── view.ejs          # عرض فاتورة
│   │   │   └── deleted.ejs       # سلة المحذوفات
│   │   ├── certificates/         # صفحات الشهادات
│   │   │   ├── index.ejs         # قائمة الشهادات
│   │   │   ├── create.ejs        # إنشاء شهادة
│   │   │   ├── show.ejs          # عرض شهادة
│   │   │   ├── public.ejs        # الصفحة العامة
│   │   │   └── deleted.ejs       # سلة المحذوفات
│   │   ├── auth/                 # صفحات المصادقة
│   │   │   ├── login.ejs         # تسجيل الدخول
│   │   │   ├── register.ejs      # تسجيل مستخدم جديد
│   │   │   └── change-password.ejs # تغيير كلمة المرور
│   │   ├── users/                # صفحات المستخدمين
│   │   │   ├── index.ejs         # قائمة المستخدمين
│   │   │   ├── create.ejs        # إنشاء مستخدم
│   │   │   └── edit.ejs          # تعديل مستخدم
│   │   ├── index.ejs             # الصفحة الرئيسية
│   │   └── error.ejs             # صفحة الأخطاء
│   ├── public/                   # الملفات الثابتة
│   │   ├── css/                  # ملفات CSS
│   │   │   ├── bootstrap.rtl.min.css # Bootstrap RTL
│   │   │   └── style.css         # الأنماط المخصصة
│   │   └── js/                   # ملفات JavaScript
│   │       ├── bootstrap.bundle.min.js # Bootstrap JS
│   │       └── main.js           # JavaScript الرئيسي
│   ├── utils/                    # الأدوات المساعدة
│   │   ├── helpers.js            # دوال مساعدة
│   │   └── logger.js             # نظام التسجيل
│   └── validators/               # قواعد التحقق
│       ├── auth.js               # التحقق من المصادقة
│       ├── inventory.js          # التحقق من المخزون
│       ├── invoices.js           # التحقق من الفواتير
│       └── certificates.js       # التحقق من الشهادات
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

**الاستجابة:**
```json
{
  "success": true,
  "message": "تم تسجيل الدخول بنجاح",
  "user": {
    "id": 1,
    "username": "admin",
    "role": "admin",
    "full_name": "مدير النظام"
  }
}
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
- date: تاريخ العينة (YYYY-MM-DD)
- supplier: اسم المورد
- sample_number: رقم العينة
- page: رقم الصفحة
- limit: عدد العناصر في الصفحة
```

**الاستجابة:**
```json
{
  "inventory": [
    {
      "id": 1,
      "date": "2025-01-01",
      "sample_number": "123",
      "supplier_or_sample_name": "مورد",
      "base_quantity": 100.00,
      "current_quantity": 50.00,
      "ph": 7.00,
      "peroxide_value": 5.00,
      "absorption_readings": "1.5 2.0 1.8 2.2 1.9",
      "sigma_absorbance": 0.0050,
      "analyst": "محلل",
      "notes": "ملاحظات",
      "created_at": "2025-01-01T00:00:00.000Z"
    }
  ],
  "total": 100,
  "page": 1,
  "limit": 10
}
```

#### إنشاء عينة جديدة
```http
POST /inventory/create
Content-Type: application/x-www-form-urlencoded

date=2025-01-01&sample_number=123&supplier_or_sample_name=مورد&base_quantity=100&current_quantity=100&ph=7&peroxide_value=5&absorption_readings=1.5 2.0 1.8 2.2 1.9&sigma_absorbance=0.005&analyst=محلل&notes=ملاحظات
```

**الاستجابة:**
```json
{
  "success": true,
  "message": "تم إنشاء العينة بنجاح",
  "id": 1
}
```

#### تحديث عينة
```http
POST /inventory/:id/edit
Content-Type: application/x-www-form-urlencoded

date=2025-01-01&sample_number=123&supplier_or_sample_name=مورد&base_quantity=100&current_quantity=50&ph=7&peroxide_value=5&absorption_readings=1.5 2.0 1.8 2.2 1.9&sigma_absorbance=0.005&analyst=محلل&notes=ملاحظات
```

#### جلب عينة واحدة
```http
GET /inventory/:id
```

#### نقل عينة إلى سلة المحذوفات
```http
POST /inventory/trash/:id
Content-Type: application/json
```

**الاستجابة:**
```json
{
  "success": true,
  "message": "تم نقل العينة 123 إلى سلة المحذوفات بنجاح"
}
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

#### تفريغ سلة المحذوفات
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

#### تبديل حالة رفض العينة
```http
POST /inventory/:id/toggle-reject
Content-Type: application/json
```

### الفواتير (Invoices)

#### جلب جميع الفواتير
```http
GET /invoices
Query Parameters:
- date: تاريخ الفاتورة
- customer_name: اسم العميل
- status: حالة الدفع (paid/unpaid)
- page: رقم الصفحة
- limit: عدد العناصر في الصفحة
```

#### إنشاء فاتورة جديدة
```http
POST /invoices/create
Content-Type: application/x-www-form-urlencoded

invoice_number=INV001&date=2025-01-01&customer_name=عميل&customer_phone=123456789&customer_address=عنوان&driver_name=سائق&notes=ملاحظات&items=[{"inventory_id":1,"quantity":10}]
```

#### تحديث فاتورة
```http
POST /invoices/:id/edit
Content-Type: application/x-www-form-urlencoded

invoice_number=INV001&date=2025-01-01&customer_name=عميل&customer_phone=123456789&customer_address=عنوان&driver_name=سائق&notes=ملاحظات&items=[{"inventory_id":1,"quantity":10}]
```

#### جلب فاتورة واحدة
```http
GET /invoices/:id
```

#### نقل فاتورة إلى سلة المحذوفات
```http
POST /invoices/trash/:id
Content-Type: application/json
```

#### استعادة فاتورة من سلة المحذوفات
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

#### تفريغ سلة المحذوفات
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
- page: رقم الصفحة
- limit: عدد العناصر في الصفحة
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

#### جلب شهادة واحدة
```http
GET /certificates/:id
```

#### الوصول العام للشهادة
```http
GET /certificates/public/:public_id
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

### المستخدمين (Users)

#### جلب جميع المستخدمين
```http
GET /users
```

#### إنشاء مستخدم جديد
```http
POST /users/create
Content-Type: application/x-www-form-urlencoded

username=user&password=password&email=user@example.com&role=editor&full_name=اسم المستخدم
```

#### تحديث مستخدم
```http
POST /users/:id/edit
Content-Type: application/x-www-form-urlencoded

username=user&email=user@example.com&role=editor&full_name=اسم المستخدم
```

#### حذف مستخدم
```http
POST /users/delete/:id
Content-Type: application/json
```

## قاعدة البيانات

### الجداول الرئيسية

#### جدول المستخدمين (users)
```sql
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100) UNIQUE,
  role ENUM('admin', 'editor', 'viewer') DEFAULT 'viewer',
  full_name VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

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

#### جدول الفواتير (invoices)
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

#### جدول عناصر الفواتير (invoice_items)
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

#### جدول الجلسات (sessions)
```sql
CREATE TABLE sessions (
  session_id VARCHAR(128) PRIMARY KEY,
  expires INT UNSIGNED NOT NULL,
  data MEDIUMTEXT
);
```

## الأمان

### حماية التطبيق
- **Helmet.js**: حماية من هجمات XSS و CSRF
- **bcrypt**: تشفير كلمات المرور
- **express-session**: إدارة الجلسات الآمنة
- **express-validator**: التحقق من المدخلات
- **Content Security Policy**: حماية من هجمات XSS

### إدارة الصلاحيات
- **Admin**: صلاحيات كاملة (إدارة المستخدمين، حذف نهائي)
- **Editor**: إضافة وتعديل وحذف (نقل إلى سلة المحذوفات)
- **Viewer**: عرض فقط

### حماية المسارات
- جميع المسارات محمية ما عدا صفحات الطباعة والتصدير
- التحقق من الصلاحيات قبل تنفيذ العمليات
- حماية من CSRF attacks

## المهام المجدولة

### حذف السجلات المحذوفات ناعماً
```javascript
// كل يوم عند منتصف الليل
cron.schedule('0 0 * * *', async () => {
  // حذف السجلات المحذوفة ناعماً التي يزيد عمرها عن شهر واحد
  const [certificatesResult] = await conn.query(`
    DELETE FROM certificates WHERE deleted_at < NOW() - INTERVAL 1 MONTH
  `);
  
  const [inventoryResult] = await conn.query(`
    DELETE FROM inventory WHERE deleted_at < NOW() - INTERVAL 1 MONTH
  `);
  
  const [invoicesResult] = await conn.query(`
    DELETE FROM invoices WHERE deleted_at < NOW() - INTERVAL 1 MONTH
  `);
}, {
  scheduled: true,
  timezone: "Asia/Damascus"
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

### تثبيت التبعيات الجديدة
```bash
npm install package-name
```

## استكشاف الأخطاء

### مشاكل شائعة

#### خطأ في الاتصال بقاعدة البيانات
```bash
# التحقق من إعدادات MySQL
mysql -u root -p
# التأكد من وجود قاعدة البيانات
SHOW DATABASES;
# التحقق من إعدادات الاتصال في src/.env
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

#### خطأ في الذاكرة
```bash
# زيادة ذاكرة Node.js
node --max-old-space-size=4096 src/app.js
```

### ملفات التسجيل
- **logs/app.log**: سجلات التطبيق العامة
- **logs/error.log**: سجلات الأخطاء
- **logs/access.log**: سجلات الطلبات

## الأداء والتحسين

### تحسين قاعدة البيانات
- استخدام الفهارس (Indexes) على الأعمدة المطلوبة
- تحسين الاستعلامات
- استخدام Connection Pooling

### تحسين التطبيق
- استخدام Caching للبيانات الثابتة
- ضغط الملفات الثابتة
- تحسين استعلامات قاعدة البيانات

### مراقبة الأداء
- استخدام Winston للتسجيل
- مراقبة استخدام الذاكرة
- مراقبة استجابة قاعدة البيانات

## المساهمة

1. Fork المشروع
2. إنشاء فرع للميزة الجديدة (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push إلى الفرع (`git push origin feature/AmazingFeature`)
5. فتح Pull Request

### معايير الكود
- استخدام ESLint للتحقق من جودة الكود
- اتباع معايير JavaScript ES6+
- كتابة تعليقات باللغة العربية
- اختبار الوظائف قبل الإرسال

## الترخيص

هذا المشروع مرخص تحت رخصة MIT. راجع ملف `LICENSE` للتفاصيل.

## الدعم

للدعم الفني أو الاستفسارات، يرجى التواصل عبر:
- البريد الإلكتروني: support@example.com
- الهاتف: +963-XXX-XXX-XXX
- GitHub Issues: [رابط المشروع]

## الإصدارات

### v1.0.0 (الحالي)
- ✅ نظام إدارة المخزون الأساسي
- ✅ نظام إدارة الفواتير
- ✅ نظام إدارة الشهادات
- ✅ نظام المصادقة والأمان
- ✅ واجهة مستخدم عربية
- ✅ تصدير البيانات بصيغة PDF
- ✅ نظام سلة المحذوفات
- ✅ طباعة التقارير
- ✅ نظام رفض العينات
- ✅ رموز QR للشهادات

## خطة التطوير المستقبلية

### v1.1.0 (قيد التطوير)
- [ ] نظام التنبيهات والإشعارات
- [ ] لوحة تحكم للإحصائيات
- [ ] نظام النسخ الاحتياطي التلقائي
- [ ] واجهة API للجوال
- [ ] نظام التقارير المتقدمة

### v1.2.0 (مخطط)
- [ ] دعم متعدد اللغات
- [ ] نظام الإشعارات المتقدم
- [ ] تكامل مع أنظمة خارجية
- [ ] نظام إدارة المخزون المتقدم
- [ ] واجهة مستخدم محسنة

### v2.0.0 (مستقبلي)
- [ ] تطبيق جوال
- [ ] نظام إدارة متعدد المختبرات
- [ ] ذكاء اصطناعي للتنبؤات
- [ ] نظام إدارة الجودة المتقدم

---

**تم تطوير هذا النظام بواسطة فريق NEXA للبرمجيات**

**آخر تحديث**: يناير 2025
**الإصدار**: v1.0.0
