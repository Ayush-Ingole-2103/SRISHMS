const express = require('express');
const router = express.Router();

const { pool } = require('../config/db');


// GET /api/test/products
router.get('/products', async (req, res) => {

    try {

        const [rows] = await pool.query(`
            SELECT
                product_id,
                product_name,
                sku,
                selling_price,
                status
            FROM products
            ORDER BY product_id
        `);

        res.json({
            success: true,
            count: rows.length,
            data: rows
        });

    } catch (error) {

        console.error('Products test error:', error);

        res.status(500).json({
            success: false,
            message: 'Failed to fetch products',
            error: error.message
        });

    }

});


module.exports = router;