'use strict';

async function ensureColumn(connection, tableName, columnName) {
    const [rows] = await connection.query(
        `SELECT COUNT(*) AS count FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?`,
        [tableName, columnName]
    );
    if (!Number(rows[0].count)) {
        await connection.query(`ALTER TABLE \`${tableName}\` ADD COLUMN \`${columnName}\` INT DEFAULT NULL`);
    }
}

async function up(connection) {
    await ensureColumn(connection, 'quotations', 'brand_id');
    await ensureColumn(connection, 'orders', 'brand_id');
}

module.exports = { up };
