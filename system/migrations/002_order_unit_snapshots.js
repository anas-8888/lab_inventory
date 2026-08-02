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
    if (!(await columnExists(connection, 'order_items', 'packaging_weight'))) {
        await connection.query('ALTER TABLE order_items ADD COLUMN packaging_weight DECIMAL(15,3) NULL AFTER unit');
    }
    if (!(await columnExists(connection, 'order_items', 'pieces_per_package'))) {
        await connection.query('ALTER TABLE order_items ADD COLUMN pieces_per_package DECIMAL(15,3) NULL AFTER packaging_weight');
    }

    await connection.query(`
        UPDATE order_items oi
        LEFT JOIN packaging_units pu ON pu.id = oi.packaging_unit_id
        LEFT JOIN materials m ON m.id = oi.material_id
        SET oi.packaging_weight = COALESCE(oi.packaging_weight, pu.kilograms_per_unit, m.packaging_weight),
            oi.pieces_per_package = COALESCE(oi.pieces_per_package, m.pieces_per_package)
        WHERE oi.packaging_weight IS NULL OR oi.pieces_per_package IS NULL
    `);
}

module.exports = { up };
