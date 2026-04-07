// Standalone script to create/update an admin user
// Usage:
//  1) Ensure dependencies: npm i mysql2 bcryptjs
//  2) Optionally set env: DB_HOST, DB_USER, DB_PASSWORD, DB_NAME
//  3) Run: node seed_admin.js

const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');
// Load environment variables early (try src/.env then .env)
const envCandidates = [path.resolve(__dirname, 'src/.env'), path.resolve(__dirname, '.env')];
for (const p of envCandidates) {
  if (fs.existsSync(p)) {
    dotenv.config({ path: p });
    break;
  }
}

const bcrypt = require('bcryptjs');
const { pool } = require('./src/database/db');

async function ensureAdminUser() {
  try {
    // Ensure required roles exist with fixed ids used by the app (2=editor, 3=viewer, 4=admin)
    await pool.execute(
      'INSERT IGNORE INTO roles (id, name) VALUES (2, ?), (3, ?), (4, ?)',
      ['editor', 'viewer', 'admin']
    );

    const username = 'admin';
    const plainPassword = '123456';
    const roleIdAdmin = 4; // per application mapping: 4 = admin

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(plainPassword, salt);

    const [rows] = await pool.execute('SELECT id FROM users WHERE username = ?', [username]);

    if (rows.length === 0) {
      await pool.execute(
        'INSERT INTO users (username, password_hash, role_id) VALUES (?, ?, ?)',
        [username, passwordHash, roleIdAdmin]
      );
      console.log('✔️ Created admin user with username "admin" and default password "123456"');
    } else {
      await pool.execute(
        'UPDATE users SET password_hash = ?, role_id = ? WHERE username = ? LIMIT 1',
        [passwordHash, roleIdAdmin, username]
      );
      console.log('✔️ Updated existing "admin" user password and role to admin');
    }
  } catch (err) {
    console.error('❌ Failed to seed admin user:', err.message);
    process.exitCode = 1;
  }
}

ensureAdminUser();


