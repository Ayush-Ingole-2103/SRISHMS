const express = require("express");
const cors = require("cors");
const session = require("express-session");
require("dotenv").config();

const app = express();

const PORT = process.env.PORT || 5000;

// ================================
// Middleware
// ================================

app.use(
    cors({
        origin: true,
        credentials: true
    })
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(
    session({
        secret: process.env.SESSION_SECRET || "srishms_secret",
        resave: false,
        saveUninitialized: false,
        cookie: {
            httpOnly: true,
            secure: false,
            maxAge: 1000 * 60 * 60 * 24
        }
    })
);

// ================================
// Root Route
// ================================

app.get("/", (req, res) => {
    res.json({
        success: true,
        application: "SRISHMS",
        message: "Smart Retail Inventory & Stock Health Management System API is running 🚀"
    });
});

// ================================
// Health Check
// ================================

app.get("/api/health", (req, res) => {
    res.json({
        success: true,
        status: "healthy",
        timestamp: new Date()
    });
});

// ================================
// Server
// ================================

app.listen(PORT, () => {
    console.log("========================================");
    console.log("       SRISHMS BACKEND SERVER");
    console.log("========================================");
    console.log(`Server running on: http://localhost:${PORT}`);
    console.log(`Health check:     http://localhost:${PORT}/api/health`);
    console.log("========================================");
});