const express = require('express');

const {
    register,
    login,
    getCurrentUser,
    logout
} = require('../controllers/auth.controller');

const router = express.Router();


// POST /api/auth/register
router.post('/register', register);


// POST /api/auth/login
router.post('/login', login);


// GET /api/auth/me
router.get('/me', getCurrentUser);


// POST /api/auth/logout
router.post('/logout', logout);


module.exports = router;