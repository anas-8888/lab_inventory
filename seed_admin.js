// Standalone script to create/update an admin user
// Usage:
//  1) Ensure dependencies: npm i mysql2 bcryptjs
//  2) Optionally set env: DB_HOST, DB_USER, DB_PASSWORD, DB_NAME
//  3) Run: node seed_admin.js

const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

const {
  DB_HOST = '127.0.0.1',
  DB_USER = 'root',
  DB_PASSWORD = '',
  DB_NAME = 'lab_inventory',
} = process.env;

async function ensureAdminUser() {
  const connection = await mysql.createConnection({
    host: DB_HOST,
    user: DB_USER,
    password: DB_PASSWORD,
    database: DB_NAME,
    charset: 'utf8mb4_unicode_ci',
  });

  try {
    const username = 'admin';
    const plainPassword = '123456';
    const roleIdAdmin = 4; // per application mapping: 4 = admin

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(plainPassword, salt);

    const [rows] = await connection.execute('SELECT id FROM users WHERE username = ?', [username]);

    if (rows.length === 0) {
      await connection.execute(
        'INSERT INTO users (username, password_hash, role_id) VALUES (?, ?, ?)',
        [username, passwordHash, roleIdAdmin]
      );
      console.log('✔️ Created admin user with username "admin" and default password "123456"');
    } else {
      await connection.execute(
        'UPDATE users SET password_hash = ?, role_id = ? WHERE username = ? LIMIT 1',
        [passwordHash, roleIdAdmin, username]
      );
      console.log('✔️ Updated existing "admin" user password and role to admin');
    }

    console.log(`DB: ${DB_NAME} @ ${DB_HOST} as ${DB_USER}`);
  } catch (err) {
    console.error('❌ Failed to seed admin user:', err.message);
    process.exitCode = 1;
  } finally {
    try { await connection.end(); } catch (_) {}
  }
}

ensureAdminUser();


