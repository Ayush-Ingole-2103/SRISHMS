const express = require('express');

const {
    register,
    login,
    getCurrentUser,
    logout
} = require('../controllers/auth.controller');

const { requireAuth } = require('../middleware/auth.middleware');

const router = express.Router();


// ============================================================
// REGISTER
// POST /api/auth/register
// ============================================================

router.post('/register', register);


// ============================================================
// LOGIN
// POST /api/auth/login
// ============================================================

router.post('/login', login);


// ============================================================
// CURRENT USER
// GET /api/auth/me
// ============================================================

router.get('/me', requireAuth, getCurrentUser);


// ============================================================
// LOGOUT
// POST /api/auth/logout
// ============================================================

router.post('/logout', logout);


module.exports = router;