'use strict';

async function columnExists(connection, tableName, columnName) {
    const [rows] = await connection.query(
        `SELECT 1 FROM information_schema.COLUMNS
         WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ? LIMIT 1`,
        [tableName, columnName]
    );
    return rows.length > 0;
}

async function indexExists(connection, tableName, indexName) {
    const [rows] = await connection.query(
        `SELECT 1 FROM information_schema.STATISTICS
         WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND INDEX_NAME = ? LIMIT 1`,
        [tableName, indexName]
    );
    return rows.length > 0;
}

async function addColumn(connection, tableName, definition) {
    if (!(await columnExists(connection, tableName, 'material_number'))) {
        await connection.query(`ALTER TABLE \`${tableName}\` ADD COLUMN material_number VARCHAR(255) NULL AFTER material_id`);
    }
    if (tableName !== 'materials') {
        await connection.query(`
            UPDATE \`${tableName}\` items
            INNER JOIN materials m ON m.id = items.material_id
            SET items.material_number = m.material_number
            WHERE items.material_number IS NULL OR TRIM(items.material_number) = ''
        `);
    }
}

async function up(connection) {
    if (!(await columnExists(connection, 'materials', 'material_number'))) {
        await connection.query('ALTER TABLE materials ADD COLUMN material_number VARCHAR(255) NULL AFTER id');
    }

    const [materials] = await connection.query('SELECT id, material_number FROM materials ORDER BY id');
    const used = new Set();
    for (const material of materials) {
        const current = String(material.material_number || '').trim();
        let value = current;
        if (!value || used.has(value)) {
            value = String(material.id);
            let suffix = 1;
            while (used.has(value)) value = `${material.id}-${suffix++}`;
        }
        used.add(value);
        if (value !== current) {
            await connection.query('UPDATE materials SET material_number = ? WHERE id = ?', [value, material.id]);
        }
    }

    await connection.query('ALTER TABLE materials MODIFY COLUMN material_number VARCHAR(255) NOT NULL AFTER id');
    if (!(await indexExists(connection, 'materials', 'uq_materials_material_number'))) {
        await connection.query('ALTER TABLE materials ADD UNIQUE KEY uq_materials_material_number (material_number)');
    }

    await addColumn(connection, 'quotation_items');
    await addColumn(connection, 'order_items');
}

module.exports = { up };
