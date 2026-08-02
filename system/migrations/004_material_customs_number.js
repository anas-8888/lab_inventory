'use strict';

async function columnExists(connection, tableName, columnName) {
    const [rows] = await connection.query(
        `SELECT 1 FROM information_schema.COLUMNS
         WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ? LIMIT 1`,
        [tableName, columnName]
    );
    return rows.length > 0;
}

async function up(connection) {
    if (!(await columnExists(connection, 'materials', 'customs_number'))) {
        await connection.query(
            'ALTER TABLE materials ADD COLUMN customs_number VARCHAR(255) NULL AFTER material_number'
        );
    }
}

module.exports = { up };
