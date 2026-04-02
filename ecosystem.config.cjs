module.exports = {
  apps: [
    {
      name: "ajaj_node",

      // الملف الرئيسي
      script: "./src/app.js",

      // مسار المشروع
      cwd: "/home/plus.ajajbrothers.com",

      // وضع التشغيل
      exec_mode: "fork",

      // إعادة التشغيل التلقائي
      autorestart: true,
      watch: false,

      // عدد النسخ (خليه 1 بسبب socket)
      instances: 1,

      // البيئة
      env: {
        NODE_ENV: "production",
        PORT: 3004
      },

      // تحسين الأداء
      max_memory_restart: "300M",

      // تسجيل اللوج
      error_file: "/home/plus.ajajbrothers.com/logs/error.log",
      out_file: "/home/plus.ajajbrothers.com/logs/out.log",
      log_date_format: "YYYY-MM-DD HH:mm:ss"
    }
  ]
};
