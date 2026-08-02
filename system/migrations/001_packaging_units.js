'use strict';

async function columnExists(connection, tableName, columnName) {
    const [rows] = await connection.query(
        `SELECT 1
         FROM information_schema.COLUMNS
         WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?
         LIMIT 1`,
        [tableName, columnName]
    );
    return rows.length > 0;
}

async function constraintExists(connection, tableName, constraintName) {
    const [rows] = await connection.query(
        `SELECT 1
         FROM information_schema.TABLE_CONSTRAINTS
         WHERE CONSTRAINT_SCHEMA = DATABASE() AND TABLE_NAME = ? AND CONSTRAINT_NAME = ?
         LIMIT 1`,
        [tableName, constraintName]
    );
    return rows.length > 0;
}

async function addColumn(connection, tableName, columnName, definition) {
    if (!(await columnExists(connection, tableName, columnName))) {
        await connection.query(`ALTER TABLE \`${tableName}\` ADD COLUMN \`${columnName}\` ${definition}`);
    }
}

async function addForeignKey(connection, tableName, constraintName, sql) {
    if (!(await constraintExists(connection, tableName, constraintName))) {
        await connection.query(`ALTER TABLE \`${tableName}\` ADD CONSTRAINT \`${constraintName}\` ${sql}`);
    }
}

async function up(connection) {
    await connection.query(`
        CREATE TABLE IF NOT EXISTS packaging_units (
            id INT NOT NULL AUTO_INCREMENT,
            name VARCHAR(100) NOT NULL,
            kilograms_per_unit DECIMAL(15,3) NOT NULL,
            is_active TINYINT(1) NOT NULL DEFAULT 1,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY uq_packaging_units_name_weight (name, kilograms_per_unit),
            CONSTRAINT chk_packaging_units_kg_positive CHECK (kilograms_per_unit > 0)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);

    await connection.query(`
        CREATE TABLE IF NOT EXISTS material_packaging_units (
            id INT NOT NULL AUTO_INCREMENT,
            material_id INT NOT NULL,
            packaging_unit_id INT NOT NULL,
            unit_role ENUM('primary','secondary') NOT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY uq_material_packaging_role (material_id, unit_role),
            UNIQUE KEY uq_material_packaging_unit (material_id, packaging_unit_id),
            KEY idx_material_packaging_unit (packaging_unit_id),
            CONSTRAINT fk_material_packaging_material FOREIGN KEY (material_id)
                REFERENCES materials(id) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT fk_material_packaging_unit FOREIGN KEY (packaging_unit_id)
                REFERENCES packaging_units(id) ON DELETE RESTRICT ON UPDATE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);

    await addColumn(connection, 'quotation_items', 'packaging_unit_id', 'INT NULL AFTER material_id');
    await addColumn(connection, 'order_items', 'packaging_unit_id', 'INT NULL AFTER material_id');

    await addForeignKey(
        connection,
        'quotation_items',
        'fk_quotation_items_packaging_unit',
        'FOREIGN KEY (`packaging_unit_id`) REFERENCES `packaging_units` (`id`) ON DELETE SET NULL ON UPDATE CASCADE'
    );
    await addForeignKey(
        connection,
        'order_items',
        'fk_order_items_packaging_unit',
        'FOREIGN KEY (`packaging_unit_id`) REFERENCES `packaging_units` (`id`) ON DELETE SET NULL ON UPDATE CASCADE'
    );

    // Dynamic backfill: derive the catalog from the legacy data in whichever database runs this migration.
    await connection.beginTransaction();
    try {
        await connection.query(`
            INSERT IGNORE INTO packaging_units (name, kilograms_per_unit)
            SELECT DISTINCT
                   COALESCE(NULLIF(TRIM(packaging_unit), ''), 'وحدة غير محددة'),
                   CASE WHEN packaging_weight > 0 THEN packaging_weight ELSE 1 END
            FROM materials
        `);

        await connection.query(`
            INSERT INTO material_packaging_units (material_id, packaging_unit_id, unit_role)
            SELECT m.id, pu.id, 'primary'
            FROM materials m
            INNER JOIN packaging_units pu
                ON pu.name COLLATE utf8mb4_unicode_ci = COALESCE(NULLIF(TRIM(m.packaging_unit), ''), 'وحدة غير محددة') COLLATE utf8mb4_unicode_ci
               AND pu.kilograms_per_unit = CASE WHEN m.packaging_weight > 0 THEN m.packaging_weight ELSE 1 END
            LEFT JOIN material_packaging_units mpu
                ON mpu.material_id = m.id AND mpu.unit_role = 'primary'
            WHERE mpu.id IS NULL
        `);

        await connection.query(`
            UPDATE quotation_items qi
            INNER JOIN material_packaging_units mpu
                ON mpu.material_id = qi.material_id AND mpu.unit_role = 'primary'
            SET qi.packaging_unit_id = mpu.packaging_unit_id
            WHERE qi.packaging_unit_id IS NULL
        `);

        await connection.query(`
            UPDATE order_items oi
            INNER JOIN material_packaging_units mpu
                ON mpu.material_id = oi.material_id AND mpu.unit_role = 'primary'
            SET oi.packaging_unit_id = mpu.packaging_unit_id
            WHERE oi.packaging_unit_id IS NULL
        `);

        await connection.commit();
    } catch (error) {
        await connection.rollback();
        throw error;
    }
}

module.exports = { up };
