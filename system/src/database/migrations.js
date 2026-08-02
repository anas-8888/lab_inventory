'use strict';

const fs = require('fs');
const path = require('path');

const MIGRATIONS_DIR = path.resolve(__dirname, '../../migrations');

async function runMigrations(pool) {
    await pool.query(`
        CREATE TABLE IF NOT EXISTS schema_migrations (
            migration_name VARCHAR(255) NOT NULL PRIMARY KEY,
            applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);

    const files = fs.existsSync(MIGRATIONS_DIR)
        ? fs.readdirSync(MIGRATIONS_DIR)
            .filter((name) => /^\d+_.+\.js$/.test(name))
            .sort((a, b) => a.localeCompare(b, 'en', { numeric: true }))
        : [];

    const [appliedRows] = await pool.query('SELECT migration_name FROM schema_migrations');
    const applied = new Set(appliedRows.map((row) => row.migration_name));

    for (const file of files) {
        if (applied.has(file)) continue;

        const migration = require(path.join(MIGRATIONS_DIR, file));
        if (!migration || typeof migration.up !== 'function') {
            throw new Error(`Migration ${file} must export an up(connection) function`);
        }

        const connection = await pool.getConnection();
        try {
            console.log(`[MIGRATION] applying ${file}`);
            await migration.up(connection);
            await connection.query(
                'INSERT INTO schema_migrations (migration_name) VALUES (?)',
                [file]
            );
            console.log(`[MIGRATION] applied ${file}`);
        } finally {
            connection.release();
        }
    }
}

module.exports = { runMigrations };
