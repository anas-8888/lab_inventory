'use strict';

async function addColumnIfMissing(connection, tableName, columnName, definition) {
    const [rows] = await connection.query(
        `SELECT COUNT(*) AS count FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?`,
        [tableName, columnName]
    );
    if (!rows[0].count) {
        await connection.query(`ALTER TABLE \`${tableName}\` ADD COLUMN \`${columnName}\` ${definition}`);
    }
}

async function up(connection) {
    await connection.query(`
        CREATE TABLE IF NOT EXISTS brands (
            id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
            brand_name VARCHAR(255) NOT NULL,
            owner_name VARCHAR(255) DEFAULT NULL,
            address TEXT DEFAULT NULL,
            contact_number VARCHAR(100) DEFAULT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            UNIQUE KEY uq_brands_name (brand_name)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    await connection.query(`
        CREATE TABLE IF NOT EXISTS brand_materials (
            brand_id INT NOT NULL,
            material_id INT NOT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (brand_id, material_id),
            CONSTRAINT fk_brand_materials_brand FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE CASCADE,
            CONSTRAINT fk_brand_materials_material FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    await addColumnIfMissing(connection, 'quotations', 'brand_id', 'INT DEFAULT NULL');
    await addColumnIfMissing(connection, 'orders', 'brand_id', 'INT DEFAULT NULL');
}

module.exports = { up };
