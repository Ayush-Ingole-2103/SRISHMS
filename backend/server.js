const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

const { testDatabaseConnection } = require('./config/db');
const testRoutes = require('./routes/test.routes');

dotenv.config();

const app = express();

const PORT = process.env.PORT || 5000;


// ============================================================
// MIDDLEWARE
// ============================================================

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/test', testRoutes);


// ============================================================
// HEALTH CHECK
// ============================================================

app.get('/api/health', async (req, res) => {
    res.json({
        success: true,
        status: 'healthy',
        service: 'SRISHMS Backend',
        timestamp: new Date().toISOString()
    });
});


// ============================================================
// DATABASE TEST
// ============================================================

app.get('/api/health/db', async (req, res) => {
    try {
        const connected = await testDatabaseConnection();

        if (!connected) {
            return res.status(500).json({
                success: false,
                status: 'database_error',
                message: 'Unable to connect to MySQL database'
            });
        }

        res.json({
            success: true,
            status: 'healthy',
            database: process.env.DB_NAME,
            message: 'MySQL database connection successful'
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            status: 'database_error',
            message: error.message
        });
    }
});


// ============================================================
// 404 HANDLER
// ============================================================

app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: 'API endpoint not found'
    });
});


// ============================================================
// START SERVER
// ============================================================

async function startServer() {

    console.log('');
    console.log('======================================');
    console.log('       SRISHMS BACKEND SERVER');
    console.log('======================================');

    await testDatabaseConnection();

    app.listen(PORT, () => {
        console.log('');
        console.log(`Server running on: http://localhost:${PORT}`);
        console.log(`Health check:      http://localhost:${PORT}/api/health`);
        console.log(`Database check:    http://localhost:${PORT}/api/health/db`);
        console.log('');
        console.log('======================================');
    });
}

startServer();