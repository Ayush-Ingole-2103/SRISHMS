const { pool } = require("../config/db");
/*
 * GET /api/dashboard
 *
 * Returns all information required by the SRISHMS dashboard.
 */
const getDashboard = async (req, res) => {
    try {
        /*
         * The authenticated user ID can come from either:
         *
         * req.session.userId
         * or
         * req.user.user_id
         *
         * This makes the controller compatible with our authentication
         * implementation.
         */
        const userId =
            req.session?.user?.user_id ||
            req.session?.userId ||
            req.session?.user_id ||
            req.user?.user_id ||
            req.user?.id;

        if (!userId) {
            return res.status(401).json({
                success: false,
                message: "Authentication required."
            });
        }

        /*
         * Find the store assigned to the logged-in user.
         */
        const [storeRows] = await pool.query(
            `
            SELECT 
                su.store_id,
                su.assigned_role,
                s.store_name,
                s.currency,
                s.timezone
            FROM store_users su
            INNER JOIN stores s
                ON s.store_id = su.store_id
            WHERE su.user_id = ?
              AND s.status = 'active'
            ORDER BY su.store_user_id ASC
            LIMIT 1
            `,
            [userId]
        );

        if (storeRows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "No active store is assigned to this user."
            });
        }

        const storeId = storeRows[0].store_id;

        /*
         * ============================================================
         * 1. DASHBOARD STATISTICS
         * ============================================================
         */

        const [statsRows] = await pool.query(
            `
            SELECT
                (
                    SELECT COUNT(*)
                    FROM products
                    WHERE store_id = ?
                      AND status = 'active'
                ) AS totalProducts,

                (
                    SELECT COALESCE(
                        SUM(i.current_stock * p.purchase_price),
                        0
                    )
                    FROM inventory i
                    INNER JOIN products p
                        ON p.product_id = i.product_id
                    WHERE i.store_id = ?
                      AND p.status = 'active'
                ) AS stockValue,

                (
                    SELECT COUNT(*)
                    FROM inventory i
                    INNER JOIN products p
                        ON p.product_id = i.product_id
                    WHERE i.store_id = ?
                      AND p.status = 'active'
                      AND i.current_stock > 0
                      AND i.current_stock <= p.minimum_stock
                ) AS lowStock,

                (
                    SELECT COUNT(*)
                    FROM inventory i
                    INNER JOIN products p
                        ON p.product_id = i.product_id
                    WHERE i.store_id = ?
                      AND p.status = 'active'
                      AND i.current_stock = 0
                ) AS outOfStock,

                (
                    SELECT COUNT(*)
                    FROM suppliers
                    WHERE store_id = ?
                      AND status = 'active'
                ) AS totalSuppliers
            `,
            [storeId, storeId, storeId, storeId, storeId]
        );

        /*
         * ============================================================
         * 2. SALES OVERVIEW — LAST 7 DAYS
         * ============================================================
         */

        const [salesOverview] = await pool.query(
            `
            SELECT
                DATE(sale_date) AS sale_date,
                COALESCE(SUM(total_amount), 0) AS total_sales
            FROM sales
            WHERE store_id = ?
              AND sale_date >= CURDATE() - INTERVAL 6 DAY
              AND payment_status = 'paid'
            GROUP BY DATE(sale_date)
            ORDER BY DATE(sale_date)
            `,
            [storeId]
        );

        /*
         * ============================================================
         * 3. STOCK HEALTH OVERVIEW
         * ============================================================
         */

        const [stockHealthRows] = await pool.query(
            `
            SELECT
                health_status,
                COUNT(*) AS product_count
            FROM stock_health
            WHERE store_id = ?
            GROUP BY health_status
            `,
            [storeId]
        );

        const stockHealth = {
            healthy: 0,
            monitor: 0,
            slowMoving: 0,
            critical: 0
        };

        stockHealthRows.forEach(row => {
            switch (row.health_status) {
                case "healthy":
                    stockHealth.healthy = Number(row.product_count);
                    break;

                case "monitor":
                    stockHealth.monitor = Number(row.product_count);
                    break;

                case "slow_moving":
                    stockHealth.slowMoving = Number(row.product_count);
                    break;

                case "critical":
                    stockHealth.critical = Number(row.product_count);
                    break;
            }
        });

        /*
         * ============================================================
         * 4. TOP SELLING PRODUCTS — LAST 30 DAYS
         * ============================================================
         */

        const [topSellingProducts] = await pool.query(
            `
            SELECT
                p.product_id,
                p.product_name,
                p.sku,
                COALESCE(SUM(si.quantity), 0) AS units_sold,
                COALESCE(SUM(si.subtotal), 0) AS sales_value
            FROM sale_items si
            INNER JOIN sales s
                ON s.sale_id = si.sale_id
            INNER JOIN products p
                ON p.product_id = si.product_id
            WHERE s.store_id = ?
              AND s.sale_date >= CURDATE() - INTERVAL 30 DAY
              AND s.payment_status = 'paid'
              AND p.status = 'active'
            GROUP BY
                p.product_id,
                p.product_name,
                p.sku
            ORDER BY units_sold DESC
            LIMIT 5
            `,
            [storeId]
        );

        /*
         * ============================================================
         * 5. LOW STOCK PRODUCTS
         * ============================================================
         */

        const [lowStockProducts] = await pool.query(
            `
            SELECT
                p.product_id,
                p.product_name,
                p.sku,
                i.current_stock,
                p.minimum_stock,
                p.maximum_stock
            FROM inventory i
            INNER JOIN products p
                ON p.product_id = i.product_id
            WHERE i.store_id = ?
              AND p.status = 'active'
              AND i.current_stock > 0
              AND i.current_stock <= p.minimum_stock
            ORDER BY i.current_stock ASC
            LIMIT 5
            `,
            [storeId]
        );

        /*
         * ============================================================
         * 6. DEAD STOCK PRODUCTS
         *
         * A product is considered dead stock when:
         * - it has stock available
         * - AND there has been no sale for 30+ days
         *
         * stock_health.days_since_last_sale is used when available.
         * ============================================================
         */

        const [deadStockProducts] = await pool.query(
            `
            SELECT
                p.product_id,
                p.product_name,
                p.sku,
                sh.current_stock,
                sh.days_since_last_sale,
                sh.health_status
            FROM stock_health sh
            INNER JOIN products p
                ON p.product_id = sh.product_id
            WHERE sh.store_id = ?
              AND p.status = 'active'
              AND sh.current_stock > 0
              AND sh.days_since_last_sale >= 30
            ORDER BY sh.days_since_last_sale DESC
            LIMIT 5
            `,
            [storeId]
        );

        /*
         * ============================================================
         * 7. RECENT PURCHASES
         * ============================================================
         */

        const [recentPurchases] = await pool.query(
            `
            SELECT
                pu.purchase_id,
                pu.po_number,
                pu.purchase_date,
                pu.total_amount,
                pu.status,
                s.supplier_name
            FROM purchases pu
            INNER JOIN suppliers s
                ON s.supplier_id = pu.supplier_id
            WHERE pu.store_id = ?
            ORDER BY pu.purchase_date DESC
            LIMIT 5
            `,
            [storeId]
        );

        /*
         * ============================================================
         * 8. TOTAL SALES
         * ============================================================
         */

        const [salesSummaryRows] = await pool.query(
            `
            SELECT
                COALESCE(SUM(total_amount), 0) AS totalSales,
                COUNT(*) AS totalOrders
            FROM sales
            WHERE store_id = ?
              AND payment_status = 'paid'
              AND sale_date >= CURDATE() - INTERVAL 30 DAY
            `,
            [storeId]
        );

        /*
         * ============================================================
         * FINAL RESPONSE
         * ============================================================
         */

        return res.status(200).json({
            success: true,

            data: {
                store: {
                    storeId: storeRows[0].store_id,
                    storeName: storeRows[0].store_name,
                    currency: storeRows[0].currency,
                    timezone: storeRows[0].timezone,
                    role: storeRows[0].assigned_role
                },

                stats: {
                    totalProducts: Number(statsRows[0].totalProducts),
                    stockValue: Number(statsRows[0].stockValue),
                    lowStock: Number(statsRows[0].lowStock),
                    outOfStock: Number(statsRows[0].outOfStock),
                    totalSuppliers: Number(statsRows[0].totalSuppliers)
                },

                salesSummary: {
                    totalSales: Number(salesSummaryRows[0].totalSales),
                    totalOrders: Number(salesSummaryRows[0].totalOrders)
                },

                salesOverview: salesOverview.map(row => ({
                    date: row.sale_date,
                    sales: Number(row.total_sales)
                })),

                stockHealth,

                topSellingProducts: topSellingProducts.map(row => ({
                    productId: row.product_id,
                    productName: row.product_name,
                    sku: row.sku,
                    unitsSold: Number(row.units_sold),
                    salesValue: Number(row.sales_value)
                })),

                lowStockProducts,

                deadStockProducts,

                recentPurchases
            }
        });

    } catch (error) {

        console.error("Dashboard Error:", error);

        return res.status(500).json({
            success: false,
            message: "Failed to load dashboard data.",
            error: process.env.NODE_ENV === "development"
                ? error.message
                : undefined
        });
    }
};

module.exports = {
    getDashboard
};