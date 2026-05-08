const { pool } = require('../database/db');

const connectDb = async (req, res, next) => {
    if (req.db) {
        return next();
    }

    try {
        const connection = await pool.getConnection();
        req.db = connection;

        let released = false;
        const release = () => {
            if (!released) {
                released = true;
                connection.release();
            }
        };

        res.on('finish', release);
        res.on('close', release);
        next();
    } catch (error) {
        next(error);
    }
};

module.exports = { connectDb }; 
