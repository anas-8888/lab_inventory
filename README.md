# Lab Inventory Platform

توثيق المنصة بالكامل (النظام الداخلي + اللاندينغ بيج) بعد هيكلة المشروع الحالية.

## 1) نظرة عامة

هذا الريبو يحتوي مشروعين منفصلين:

1. `system/`: النظام الداخلي (لوحة إدارة المختبر + العمليات اليومية)
2. `olive-bloom-portfolio/`: مشروع اللاندينغ بيج (واجهة تسويقية منفصلة)

المشروعان في نفس الريبو فقط للتجميع، لكن التشغيل الفعلي لكل واحد مستقل.

---

## 2) المكونات الرئيسية

### A) النظام الداخلي `system/`

- مبني على: `Node.js + Express + EJS + MySQL`
- الوظائف الأساسية:
  - إدارة العينات والمخزون
  - إدارة طلبات الشحن/الفواتير
  - إدارة الشهادات
  - إدارة المستخدمين والصلاحيات
  - إدارة الملاحظات
  - توليد PDF / Excel ومشاركة روابط الملفات
  - إدارة محتوى الموقع (Site Management)
  - Presence / Activity tracking عبر Socket.IO

### B) اللاندينغ بيج `olive-bloom-portfolio/`

- مشروع واجهة تسويقية منفصل
- يتم بناؤه ونشر الملفات الناتجة على استضافة منفصلة (حسب ملاحظتك)

---

## 3) شجرة الملفات (المعتمدة حاليًا)

```text
lab_inventory/
├── system/
│   ├── public_html/
│   │   └── .htaccess
│   ├── src/
│   │   ├── app.js
│   │   ├── .env                  # Local runtime env (غير مرفوع)
│   │   ├── .env.example          # Template آمن للرفع
│   │   ├── .env.production       # Production template/local copy (غير مرفوع)
│   │   ├── config/
│   │   ├── controllers/
│   │   │   ├── authController.js
│   │   │   ├── inventoryController.js
│   │   │   ├── invoiceController.js
│   │   │   ├── certificatesController.js
│   │   │   ├── costsController.js
│   │   │   ├── notesController.js
│   │   │   ├── exportController.js
│   │   │   ├── activityController.js
│   │   │   ├── siteManagementController.js
│   │   │   ├── userController.js
│   │   │   ├── homeController.js
│   │   │   └── currencyController.js
│   │   ├── database/
│   │   │   ├── db.js
│   │   │   ├── init.js
│   │   │   └── lab_inventory.sql
│   │   ├── middleware/
│   │   ├── routes/
│   │   │   ├── index.js
│   │   │   ├── auth.js
│   │   │   ├── inventory.js
│   │   │   ├── invoices.js
│   │   │   ├── certificates.js
│   │   │   ├── costs.js
│   │   │   ├── notes.js
│   │   │   ├── exports.js
│   │   │   ├── activity.js
│   │   │   ├── siteManagement.js
│   │   │   └── users.js
│   │   ├── services/
│   │   ├── utils/
│   │   ├── validators/
│   │   ├── views/
│   │   └── public/
│   ├── ecosystem.config.cjs
│   ├── package.json
│   ├── seed_admin.js
│   └── README.md
├── olive-bloom-portfolio/
│   ├── package.json
│   └── README.md
└── README.md (هذا الملف)
```

---

## 4) نقاط الدخول (Entry Points)

### النظام الداخلي

- ملف التشغيل: `system/src/app.js`
- PM2 config: `system/ecosystem.config.cjs`
- المنفذ في الإنتاج حسب إعدادك: `PORT=3004`
- اسم التطبيق على PM2/LiteSpeed: `ajaj_node`

### اللاندينغ

- مشروع مستقل داخل `olive-bloom-portfolio/`
- تشغيله/بناءه منفصل عن `system`

---

## 5) تدفق الطلبات داخل النظام الداخلي

1. الطلب يدخل من المتصفح أو API إلى Express (`app.js`)
2. يمر على middleware (جلسات، auth، db، حماية، logging)
3. يتم توجيهه عبر `src/routes/*`
4. كل Route يستدعي Controller مناسب في `src/controllers/*`
5. Controller يتعامل مع MySQL عبر pool/connection من `src/database/db.js`
6. النتيجة:
   - Render EJS view
   - أو JSON response
   - أو إنشاء ملف PDF/Excel وحفظه داخل `src/public/*` ثم إعادة رابطه

---

## 6) تشغيل محلي (Local)

### النظام الداخلي

```bash
cd system
npm install
npm run dev
# أو
npm start
```

تأكد من وجود:
- `system/src/.env`

يمكن البناء عليه من:
- `system/src/.env.example`

### اللاندينغ بيج

```bash
cd olive-bloom-portfolio
npm install
npm run dev
```

---

## 7) تشغيل ونشر على VPS (حسب الإعداد الحالي)

### الواقع الحالي (Production)

- Node app شغّال عبر PM2
- الاسم: `ajaj_node`
- External App على LiteSpeed بنفس الاسم
- المنفذ: `3004`
- المسار الأساسي للتطبيق: داخل `system/`
- `.htaccess` الفعّال للنظام داخل: `system/public_html/.htaccess`

### أوامر PM2 المستخدمة

```bash
pm2 restart ajaj_node
pm2 logs ajaj_node --lines 200
pm2 monit
pm2 describe ajaj_node
```

---

## 8) ملفات البيئة (Environment Files)

داخل `system/src/`:

- `.env`: تشغيل محلي/تشغيلي (سري - لا يرفع)
- `.env.production`: نسخة إعداد إنتاج (سري - لا يرفع)
- `.env.example`: قالب آمن فقط للرفع على Git

ملاحظة: تم ضبط `system/.gitignore` بحيث يمنع رفع الملفات الحساسة ويترك `src/.env.example` فقط.

---

## 9) قاعدة البيانات

- الاتصال يُدار من `system/src/database/db.js`
- سكربت التهيئة: `system/src/database/init.js`
- ملف SQL المرجعي: `system/src/database/lab_inventory.sql`

للاستيراد اليدوي (مثال):

```bash
mysql -u root -p lab_inventory < system/src/database/lab_inventory.sql
```

---

## 10) مخرجات الملفات (PDF/Excel)

يتم توليد الملفات غالبًا داخل مسارات `system/src/public/...` مثل:

- `certificates_pdf`
- `inventory_pdf`
- `invoices_pdf`
- `orders_pdf`
- `quotations_pdf`
- `materials_list_pdf`
- `notes_pdf`

ويتم مشاركة روابط عامة حسب `BASE_URL`.

---

## 11) ملاحظات مهمة للفريق

1. لا تعيد إنشاء بنية قديمة في الجذر مثل `src/` خارج `system/`.
2. أي تعديل على النظام الداخلي يتم داخل `system/` فقط.
3. أي تعديل على اللاندينغ يتم داخل `olive-bloom-portfolio/` فقط.
4. لا يتم رفع أي `.env` أو أسرار إلى Git.

---

## 12) أوامر سريعة مفيدة

```bash
# حالة Git
 git status

# رؤية آخر لوج
 pm2 logs ajaj_node --lines 300

# مراقبة الأداء
 pm2 monit

# تفاصيل العملية
 pm2 describe ajaj_node
```

---

## 13) مسؤولية التشغيل

هذا التوثيق يعكس الوضع الحالي للكود والإعدادات التي تعمل عليها الآن. عند تغيير بنية النشر أو مسارات LiteSpeed/PM2، حدّث هذا الملف مباشرة للحفاظ على مرجعية صحيحة للفريق.
