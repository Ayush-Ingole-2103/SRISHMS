-- ============================================================
-- SRISHMS SEED DATA
-- Smart Retail Inventory & Stock Health Management System
-- Development / Demo Data
-- ============================================================

USE srishms_db;


-- ============================================================
-- 1. USERS
-- ============================================================

INSERT INTO users
(full_name, email, phone, password_hash, role, status)
VALUES
(
    'Shree Kirana Store Owner',
    'admin@srishms.com',
    '+919876543210',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'owner',
    'active'
),
(
    'Rahul Sharma',
    'manager@srishms.com',
    '+919876543211',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'manager',
    'active'
),
(
    'Priya Patil',
    'staff@srishms.com',
    '+919876543212',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'staff',
    'active'
);


-- ============================================================
-- 2. STORE
-- ============================================================

INSERT INTO stores
(store_name, email, phone, address, currency, timezone, status)
VALUES
(
    'Shree Kirana Store',
    'store@gmail.com',
    '+919876543210',
    '123, Market Road, Your City, Maharashtra - 444001',
    'INR',
    'Asia/Kolkata',
    'active'
);


-- ============================================================
-- 3. STORE USERS
-- ============================================================

INSERT INTO store_users
(store_id, user_id, assigned_role)
VALUES
(1, 1, 'owner'),
(1, 2, 'manager'),
(1, 3, 'staff');


-- ============================================================
-- 4. CATEGORIES
-- ============================================================

INSERT INTO categories
(category_name, description, status)
VALUES
('Grocery', 'Daily grocery and food products', 'active'),
('Household', 'Household cleaning and utility products', 'active'),
('Personal Care', 'Personal hygiene and care products', 'active'),
('Beverages', 'Tea, coffee and beverage products', 'active'),
('Cosmetics', 'Beauty and cosmetic products', 'active');


-- ============================================================
-- 5. BRANDS
-- ============================================================

INSERT INTO brands
(brand_name, status)
VALUES
('Aashirvaad', 'active'),
('Tata', 'active'),
('Surf Excel', 'active'),
('Parle', 'active'),
('Colgate', 'active'),
('Maggi', 'active'),
('Dove', 'active'),
('Bournvita', 'active');


-- ============================================================
-- 6. SUPPLIERS
-- ============================================================

INSERT INTO suppliers
(
    store_id,
    supplier_name,
    contact_person,
    phone,
    email,
    address,
    status
)
VALUES
(
    1,
    'Shree Traders',
    'Rajesh Gupta',
    '9765432100',
    'shreetraders@gmail.com',
    'Amravati, Maharashtra',
    'active'
),
(
    1,
    'New Sunrise Agency',
    'Nitin Shah',
    '9765432101',
    'newsunrise@gmail.com',
    'Nagpur, Maharashtra',
    'active'
),
(
    1,
    'Mahalaxmi Distributors',
    'Mahesh Patil',
    '9765432102',
    'mahalaxmi.dist@gmail.com',
    'Akola, Maharashtra',
    'active'
),
(
    1,
    'Vijay Enterprises',
    'Vijay Shah',
    '9765432103',
    'vijayenterprises@gmail.com',
    'Amravati, Maharashtra',
    'active'
),
(
    1,
    'Patel Bros',
    'Rahul Patel',
    '9765432104',
    'patelbros@gmail.com',
    'Nagpur, Maharashtra',
    'active'
),
(
    1,
    'S.K. Agencies',
    'Sanjay Kumar',
    '9765432105',
    'skagencies@gmail.com',
    'Amravati, Maharashtra',
    'active'
),
(
    1,
    'R.K. Suppliers',
    'Rajesh Kumar',
    '9765432106',
    'rksuppliers@gmail.com',
    'Akola, Maharashtra',
    'active'
);


-- ============================================================
-- 7. PRODUCTS
-- ============================================================

INSERT INTO products
(
    store_id,
    category_id,
    brand_id,
    supplier_id,
    product_name,
    sku,
    description,
    purchase_price,
    selling_price,
    minimum_stock,
    maximum_stock,
    status
)
VALUES
(
    1, 1, 1, 1,
    'Aashirvaad Atta 5kg',
    'PROD-001',
    'Whole wheat flour 5kg pack',
    210.00,
    250.00,
    10,
    50,
    'active'
),
(
    1, 4, 2, 2,
    'Tata Tea 250g',
    'PROD-002',
    'Premium tea leaves 250g pack',
    95.00,
    120.00,
    10,
    50,
    'active'
),
(
    1, 2, 3, 3,
    'Surf Excel 1kg',
    'PROD-003',
    'Laundry detergent 1kg pack',
    180.00,
    210.00,
    10,
    40,
    'active'
),
(
    1, 1, 4, 1,
    'Parle-G Biscuits 120g',
    'PROD-004',
    'Glucose biscuits 120g',
    8.00,
    10.00,
    30,
    100,
    'active'
),
(
    1, 3, 5, 4,
    'Colgate Toothpaste 200g',
    'PROD-005',
    'Anticavity toothpaste 200g',
    75.00,
    105.00,
    10,
    50,
    'active'
),
(
    1, 1, 6, 2,
    'Maggi Noodles 70g',
    'PROD-006',
    'Instant noodles 70g pack',
    11.00,
    15.00,
    20,
    100,
    'active'
),
(
    1, 3, 7, 5,
    'Dove Soap 100g',
    'PROD-007',
    'Moisturizing beauty bar',
    38.00,
    48.00,
    10,
    50,
    'active'
),
(
    1, 1, 8, 6,
    'Bournvita 500g',
    'PROD-008',
    'Chocolate health drink 500g',
    190.00,
    225.00,
    10,
    40,
    'active'
);


-- ============================================================
-- 8. INVENTORY
-- ============================================================

INSERT INTO inventory
(store_id, product_id, current_stock, location)
VALUES
(1, 1, 15, 'Main Store'),
(1, 2, 25, 'Main Store'),
(1, 3, 2,  'Main Store'),
(1, 4, 85, 'Main Store'),
(1, 5, 0,  'Main Store'),
(1, 6, 5,  'Main Store'),
(1, 7, 18, 'Main Store'),
(1, 8, 7,  'Main Store');


-- ============================================================
-- 9. SALES
-- ============================================================

INSERT INTO sales
(
    store_id,
    invoice_number,
    customer_name,
    sale_date,
    subtotal,
    discount,
    tax,
    total_amount,
    payment_method,
    payment_status,
    created_by
)
VALUES
(
    1,
    'INV-1058',
    'Walk-in Customer',
    DATE_SUB(NOW(), INTERVAL 1 DAY),
    1250.00,
    0.00,
    0.00,
    1250.00,
    'cash',
    'paid',
    3
),
(
    1,
    'INV-1057',
    'Rahul Sharma',
    DATE_SUB(NOW(), INTERVAL 2 DAY),
    890.00,
    40.00,
    0.00,
    850.00,
    'upi',
    'paid',
    3
),
(
    1,
    'INV-1056',
    'Walk-in Customer',
    DATE_SUB(NOW(), INTERVAL 3 DAY),
    1540.00,
    0.00,
    0.00,
    1540.00,
    'card',
    'paid',
    2
),
(
    1,
    'INV-1055',
    'Priya Patil',
    DATE_SUB(NOW(), INTERVAL 5 DAY),
    320.00,
    20.00,
    0.00,
    300.00,
    'cash',
    'paid',
    3
),
(
    1,
    'INV-1054',
    'Walk-in Customer',
    DATE_SUB(NOW(), INTERVAL 7 DAY),
    450.00,
    0.00,
    0.00,
    450.00,
    'upi',
    'paid',
    2
),
(
    1,
    'INV-1053',
    'Neha Patil',
    DATE_SUB(NOW(), INTERVAL 9 DAY),
    615.00,
    15.00,
    0.00,
    600.00,
    'cash',
    'paid',
    3
);


-- ============================================================
-- 10. SALE ITEMS
-- ============================================================

INSERT INTO sale_items
(
    sale_id,
    product_id,
    quantity,
    unit_price,
    discount,
    subtotal
)
VALUES
(1, 1, 2, 250.00, 0.00, 500.00),
(1, 2, 2, 120.00, 0.00, 240.00),
(1, 4, 30, 10.00, 0.00, 300.00),
(1, 6, 14, 15.00, 0.00, 210.00),

(2, 3, 2, 210.00, 0.00, 420.00),
(2, 5, 2, 105.00, 0.00, 210.00),
(2, 6, 20, 15.00, 40.00, 260.00),

(3, 1, 2, 250.00, 0.00, 500.00),
(3, 7, 5, 48.00, 0.00, 240.00),
(3, 8, 2, 225.00, 0.00, 450.00),
(3, 2, 2, 120.00, 0.00, 240.00),

(4, 5, 1, 105.00, 0.00, 105.00),
(4, 6, 10, 15.00, 0.00, 150.00),
(4, 4, 5, 10.00, 0.00, 50.00),

(5, 1, 1, 250.00, 0.00, 250.00),
(5, 2, 1, 120.00, 0.00, 120.00),
(5, 4, 8, 10.00, 0.00, 80.00),

(6, 7, 5, 48.00, 0.00, 240.00),
(6, 8, 1, 225.00, 0.00, 225.00),
(6, 4, 15, 10.00, 0.00, 150.00);


-- ============================================================
-- 11. PURCHASES
-- ============================================================

INSERT INTO purchases
(
    store_id,
    supplier_id,
    po_number,
    purchase_date,
    subtotal,
    discount,
    tax,
    total_amount,
    status,
    created_by
)
VALUES
(
    1,
    1,
    'PUR-1062',
    DATE_SUB(NOW(), INTERVAL 2 DAY),
    12450.00,
    0.00,
    0.00,
    12450.00,
    'completed',
    2
),
(
    1,
    2,
    'PUR-1061',
    DATE_SUB(NOW(), INTERVAL 4 DAY),
    8230.00,
    0.00,
    0.00,
    8230.00,
    'completed',
    2
),
(
    1,
    3,
    'PUR-1060',
    DATE_SUB(NOW(), INTERVAL 6 DAY),
    5460.00,
    0.00,
    0.00,
    5460.00,
    'pending',
    2
),
(
    1,
    4,
    'PUR-1059',
    DATE_SUB(NOW(), INTERVAL 8 DAY),
    9320.00,
    0.00,
    0.00,
    9320.00,
    'cancelled',
    1
),
(
    1,
    1,
    'PUR-1058',
    DATE_SUB(NOW(), INTERVAL 10 DAY),
    10460.00,
    0.00,
    0.00,
    10460.00,
    'completed',
    2
);


-- ============================================================
-- 12. PURCHASE ITEMS
-- ============================================================

INSERT INTO purchase_items
(
    purchase_id,
    product_id,
    quantity,
    unit_cost,
    discount,
    subtotal
)
VALUES
(1, 1, 30, 210.00, 0.00, 6300.00),
(1, 2, 30, 95.00, 0.00, 2850.00),
(1, 4, 400, 8.25, 0.00, 3300.00),

(2, 3, 20, 180.00, 0.00, 3600.00),
(2, 5, 20, 75.00, 0.00, 1500.00),
(2, 6, 285, 11.00, 0.00, 3135.00),

(3, 7, 100, 38.00, 0.00, 3800.00),
(3, 8, 10, 190.00, 0.00, 1900.00),

(4, 1, 20, 210.00, 0.00, 4200.00),
(4, 2, 20, 95.00, 0.00, 1900.00),

(5, 7, 50, 38.00, 0.00, 1900.00),
(5, 8, 40, 190.00, 0.00, 7600.00),
(5, 6, 87, 11.00, 0.00, 957.00);


-- ============================================================
-- 13. STOCK MOVEMENTS
-- ============================================================

INSERT INTO stock_movements
(
    store_id,
    product_id,
    movement_type,
    quantity,
    stock_before,
    stock_after,
    reference_type,
    reference_id,
    created_by
)
VALUES

-- Aashirvaad Atta
(1, 1, 'purchase', 30, 0, 30, 'purchase', 1, 2),
(1, 1, 'sale', -2, 30, 28, 'sale', 1, 3),
(1, 1, 'sale', -2, 28, 26, 'sale', 3, 2),
(1, 1, 'sale', -1, 26, 25, 'sale', 5, 3),
(1, 1, 'adjustment', -10, 25, 15, 'manual_adjustment', NULL, 2),

-- Tata Tea
(1, 2, 'purchase', 30, 0, 30, 'purchase', 1, 2),
(1, 2, 'sale', -2, 30, 28, 'sale', 1, 3),
(1, 2, 'sale', -2, 28, 26, 'sale', 3, 2),
(1, 2, 'sale', -1, 26, 25, 'sale', 5, 3),

-- Surf Excel
(1, 3, 'purchase', 20, 0, 20, 'purchase', 2, 2),
(1, 3, 'sale', -2, 20, 18, 'sale', 2, 3),
(1, 3, 'adjustment', -16, 18, 2, 'manual_adjustment', NULL, 2),

-- Parle-G
(1, 4, 'purchase', 400, 0, 400, 'purchase', 1, 2),
(1, 4, 'sale', -30, 400, 370, 'sale', 1, 3),
(1, 4, 'sale', -5, 370, 365, 'sale', 4, 3),
(1, 4, 'sale', -8, 365, 357, 'sale', 5, 2),
(1, 4, 'sale', -15, 357, 342, 'sale', 6, 3),
(1, 4, 'adjustment', -257, 342, 85, 'manual_adjustment', NULL, 2),

-- Colgate
(1, 5, 'purchase', 20, 0, 20, 'purchase', 2, 2),
(1, 5, 'sale', -2, 20, 18, 'sale', 2, 3),
(1, 5, 'sale', -1, 18, 17, 'sale', 4, 3),
(1, 5, 'adjustment', -17, 17, 0, 'manual_adjustment', NULL, 2),

-- Maggi
(1, 6, 'purchase', 285, 0, 285, 'purchase', 2, 2),
(1, 6, 'sale', -14, 285, 271, 'sale', 1, 3),
(1, 6, 'sale', -20, 271, 251, 'sale', 2, 3),
(1, 6, 'sale', -10, 251, 241, 'sale', 4, 3),
(1, 6, 'adjustment', -236, 241, 5, 'manual_adjustment', NULL, 2),

-- Dove
(1, 7, 'purchase', 50, 0, 50, 'purchase', 5, 2),
(1, 7, 'sale', -5, 50, 45, 'sale', 3, 2),
(1, 7, 'sale', -5, 45, 40, 'sale', 6, 3),
(1, 7, 'adjustment', -22, 40, 18, 'manual_adjustment', NULL, 2),

-- Bournvita
(1, 8, 'purchase', 40, 0, 40, 'purchase', 5, 2),
(1, 8, 'sale', -2, 40, 38, 'sale', 3, 2),
(1, 8, 'sale', -1, 38, 37, 'sale', 6, 3),
(1, 8, 'adjustment', -30, 37, 7, 'manual_adjustment', NULL, 2);


-- ============================================================
-- 14. STOCK HEALTH
-- ============================================================

INSERT INTO stock_health
(
    store_id,
    product_id,
    current_stock,
    sales_velocity,
    days_since_last_sale,
    stock_turnover,
    health_score,
    health_status
)
VALUES
(1, 1, 15, 2.50, 1, 4.20, 82.00, 'healthy'),
(1, 2, 25, 2.00, 1, 3.80, 78.00, 'healthy'),
(1, 3, 2,  3.50, 2, 8.50, 42.00, 'critical'),
(1, 4, 85, 5.20, 1, 6.40, 92.00, 'healthy'),
(1, 5, 0,  1.80, 5, 2.10, 18.00, 'critical'),
(1, 6, 5,  4.80, 1, 9.20, 38.00, 'critical'),
(1, 7, 18, 0.50, 4, 1.30, 65.00, 'monitor'),
(1, 8, 7,  0.20, 9, 0.80, 28.00, 'dead_stock');


-- ============================================================
-- 15. ALERTS
-- ============================================================

INSERT INTO alerts
(
    store_id,
    product_id,
    alert_type,
    severity,
    title,
    message,
    is_read,
    created_at
)
VALUES
(
    1,
    5,
    'out_of_stock',
    'critical',
    'Out of Stock',
    'Colgate Toothpaste 200g is currently out of stock.',
    FALSE,
    DATE_SUB(NOW(), INTERVAL 1 HOUR)
),
(
    1,
    3,
    'low_stock',
    'warning',
    'Low Stock',
    'Surf Excel 1kg stock is below the minimum stock level.',
    FALSE,
    DATE_SUB(NOW(), INTERVAL 3 HOUR)
),
(
    1,
    6,
    'low_stock',
    'warning',
    'Low Stock',
    'Maggi Noodles 70g stock is critically low.',
    FALSE,
    DATE_SUB(NOW(), INTERVAL 5 HOUR)
),
(
    1,
    8,
    'dead_stock',
    'critical',
    'Dead Stock Alert',
    'Bournvita 500g has very low sales velocity.',
    FALSE,
    DATE_SUB(NOW(), INTERVAL 1 DAY)
),
(
    1,
    NULL,
    'purchase_pending',
    'info',
    'Purchase Order Pending',
    'Purchase order PUR-1060 is waiting for approval.',
    TRUE,
    DATE_SUB(NOW(), INTERVAL 1 DAY)
),
(
    1,
    7,
    'slow_moving',
    'warning',
    'Slow Moving Stock',
    'Dove Soap 100g has low sales velocity.',
    FALSE,
    DATE_SUB(NOW(), INTERVAL 2 DAY)
);


-- ============================================================
-- 16. STORE SETTINGS
-- ============================================================

INSERT INTO store_settings
(store_id, setting_key, setting_value)
VALUES
(1, 'low_stock_threshold', '10'),
(1, 'dead_stock_days', '45'),
(1, 'notification_enabled', 'true'),
(1, 'currency', 'INR'),
(1, 'timezone', 'Asia/Kolkata'),
(1, 'date_format', 'DD/MM/YYYY');


-- ============================================================
-- SEED COMPLETE
-- ============================================================

SELECT 'SRISHMS seed data inserted successfully!' AS message;