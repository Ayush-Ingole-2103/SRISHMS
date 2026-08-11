const bcrypt = require('bcryptjs');
const { pool } = require('../config/db');


// ============================================================
// REGISTER
// ============================================================

const register = async (req, res) => {
    try {
        const {
            full_name,
            email,
            phone,
            password,
            confirm_password
        } = req.body;


        // ----------------------------------------------------
        // VALIDATION
        // ----------------------------------------------------

        if (!full_name || !email || !password || !confirm_password) {
            return res.status(400).json({
                success: false,
                message: 'Full name, email, password and confirm password are required.'
            });
        }


        if (password !== confirm_password) {
            return res.status(400).json({
                success: false,
                message: 'Passwords do not match.'
            });
        }


        if (password.length < 8) {
            return res.status(400).json({
                success: false,
                message: 'Password must contain at least 8 characters.'
            });
        }


        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailRegex.test(email)) {
            return res.status(400).json({
                success: false,
                message: 'Please provide a valid email address.'
            });
        }


        // ----------------------------------------------------
        // CHECK EXISTING USER
        // ----------------------------------------------------

        const [existingUsers] = await pool.query(
            `SELECT user_id FROM users WHERE email = ? LIMIT 1`,
            [email.trim().toLowerCase()]
        );


        if (existingUsers.length > 0) {
            return res.status(409).json({
                success: false,
                message: 'An account with this email already exists.'
            });
        }


        // ----------------------------------------------------
        // HASH PASSWORD
        // ----------------------------------------------------

        const passwordHash = await bcrypt.hash(password, 12);


        // ----------------------------------------------------
        // CREATE USER
        // ----------------------------------------------------
        // IMPORTANT:
        // Public registration always creates a STAFF account.
        // Owner/Manager roles should be assigned by an authorized
        // administrator later.

        const [result] = await pool.query(
            `
            INSERT INTO users
            (
                full_name,
                email,
                phone,
                password_hash,
                role,
                status
            )
            VALUES (?, ?, ?, ?, 'staff', 'active')
            `,
            [
                full_name.trim(),
                email.trim().toLowerCase(),
                phone ? phone.trim() : null,
                passwordHash
            ]
        );


        // ----------------------------------------------------
        // RESPONSE
        // ----------------------------------------------------

        return res.status(201).json({
            success: true,
            message: 'Account created successfully.',
            data: {
                user_id: result.insertId,
                full_name: full_name.trim(),
                email: email.trim().toLowerCase(),
                role: 'staff'
            }
        });

    } catch (error) {

        console.error('Registration error:', error);

        return res.status(500).json({
            success: false,
            message: 'Server error while creating account.'
        });
    }
};



// ============================================================
// LOGIN
// ============================================================

const login = async (req, res) => {
    try {

        const {
            email,
            password
        } = req.body;


        // ----------------------------------------------------
        // VALIDATION
        // ----------------------------------------------------

        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Email and password are required.'
            });
        }


        // ----------------------------------------------------
        // FIND USER
        // ----------------------------------------------------

        const [users] = await pool.query(
            `
            SELECT
                user_id,
                full_name,
                email,
                phone,
                password_hash,
                role,
                status
            FROM users
            WHERE email = ?
            LIMIT 1
            `,
            [email.trim().toLowerCase()]
        );


        if (users.length === 0) {
            return res.status(401).json({
                success: false,
                message: 'Invalid email or password.'
            });
        }


        const user = users[0];


        // ----------------------------------------------------
        // CHECK ACCOUNT STATUS
        // ----------------------------------------------------

        if (user.status !== 'active') {
            return res.status(403).json({
                success: false,
                message: `Your account is ${user.status}. Please contact the administrator.`
            });
        }


        // ----------------------------------------------------
        // COMPARE PASSWORD
        // ----------------------------------------------------

        const passwordMatch = await bcrypt.compare(
            password,
            user.password_hash
        );


        if (!passwordMatch) {
            return res.status(401).json({
                success: false,
                message: 'Invalid email or password.'
            });
        }


        // ----------------------------------------------------
        // CREATE SESSION
        // ----------------------------------------------------

        req.session.user = {
            user_id: user.user_id,
            full_name: user.full_name,
            email: user.email,
            phone: user.phone,
            role: user.role,
            status: user.status
        };


        // ----------------------------------------------------
        // RESPONSE
        // ----------------------------------------------------

        return res.status(200).json({
            success: true,
            message: 'Login successful.',
            data: req.session.user
        });

    } catch (error) {

        console.error('Login error:', error);

        return res.status(500).json({
            success: false,
            message: 'Server error while logging in.'
        });
    }
};



// ============================================================
// GET CURRENT USER
// ============================================================

const getCurrentUser = async (req, res) => {

    if (!req.session || !req.session.user) {
        return res.status(401).json({
            success: false,
            authenticated: false,
            message: 'Not authenticated.'
        });
    }

    return res.status(200).json({
        success: true,
        authenticated: true,
        data: req.session.user
    });
};

// ============================================================
// LOGOUT
// ============================================================

const logout = (req, res) => {

    req.session.destroy((error) => {

        if (error) {

            console.error('Logout error:', error);

            return res.status(500).json({
                success: false,
                message: 'Unable to logout.'
            });
        }


        res.clearCookie('connect.sid');


        return res.status(200).json({
            success: true,
            message: 'Logout successful.'
        });

    });

};


module.exports = {
    register,
    login,
    getCurrentUser,
    logout
};