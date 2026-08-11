const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: Number(process.env.DB_PORT) || 3306,

    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

async function testDatabaseConnection() {
    try {
        const connection = await pool.getConnection();

        console.log('======================================');
        console.log('     SRISHMS DATABASE CONNECTED');
        console.log('======================================');
        console.log(`Database: ${process.env.DB_NAME}`);
        console.log(`Host: ${process.env.DB_HOST}`);
        console.log('MySQL connection successful.');
        console.log('======================================');

        connection.release();

        return true;
    } catch (error) {
        console.error('======================================');
        console.error('     DATABASE CONNECTION FAILED');
        console.error('======================================');
        console.error(error.message);
        console.error('======================================');

        return false;
    }
}

module.exports = {
    pool,
    testDatabaseConnection
};