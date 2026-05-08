const mysql = require('mysql2/promise');
const fs = require('fs').promises;
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

async function initializeDatabase() {
  let connection;
  try {
    // Create connection without database
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || ''
    });

    // Read and execute schema file.
    // Prefer schema.sql, and fallback to lab_inventory.sql to match current repository structure.
    const schemaPath = path.join(__dirname, 'schema.sql');
    const fallbackSchemaPath = path.join(__dirname, 'lab_inventory.sql');
    let schema;

    try {
      schema = await fs.readFile(schemaPath, 'utf8');
      console.log('Using schema.sql');
    } catch (err) {
      if (err.code !== 'ENOENT') throw err;
      schema = await fs.readFile(fallbackSchemaPath, 'utf8');
      console.log('schema.sql not found, using lab_inventory.sql');
    }
    
    // Split and execute each statement
    const statements = schema.split(';').filter(stmt => stmt.trim());
    for (const statement of statements) {
      if (statement.trim()) {
        await connection.query(statement);
      }
    }

    console.log('Database initialized successfully');
  } catch (error) {
    console.error('Error initializing database:', error);
    throw error;
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

// Run if called directly
if (require.main === module) {
  initializeDatabase()
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}

module.exports = initializeDatabase; 
