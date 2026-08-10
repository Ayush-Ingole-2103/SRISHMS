-- ============================================================
-- SRISHMS DATABASE SCHEMA
-- Smart Retail Inventory & Stock Health Management System
-- ============================================================

-- ============================================================
-- DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS srishms_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE srishms_db;


-- ============================================================
-- 1. USERS
-- ============================================================

CREATE TABLE users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    email VARCHAR(150) NOT NULL UNIQUE,

    phone VARCHAR(20),

    password_hash VARCHAR(255) NOT NULL,

    role ENUM('owner', 'manager', 'staff') NOT NULL DEFAULT 'staff',

    status ENUM('active', 'inactive', 'suspended')
        NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_users_email (email),
    INDEX idx_users_status (status)
);


-- ============================================================
-- 2. STORES
-- ============================================================

CREATE TABLE stores (
    store_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_name VARCHAR(150) NOT NULL,

    email VARCHAR(150),

    phone VARCHAR(20),

    address TEXT,

    currency VARCHAR(10) NOT NULL DEFAULT 'INR',

    timezone VARCHAR(100) NOT NULL DEFAULT 'Asia/Kolkata',

    status ENUM('active', 'inactive')
        NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_stores_status (status)
);


-- ============================================================
-- 3. STORE USERS
-- Connects users with stores
-- ============================================================

CREATE TABLE store_users (
    store_user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    user_id INT UNSIGNED NOT NULL,

    assigned_role ENUM('owner', 'manager', 'staff')
        NOT NULL DEFAULT 'staff',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_store_users_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_store_users_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT uq_store_user
        UNIQUE (store_id, user_id),

    INDEX idx_store_users_store (store_id),
    INDEX idx_store_users_user (user_id)
);


-- ============================================================
-- 4. CATEGORIES
-- ============================================================

CREATE TABLE categories (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    category_name VARCHAR(100) NOT NULL UNIQUE,

    description VARCHAR(255),

    status ENUM('active', 'inactive')
        NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_categories_status (status)
);


-- ============================================================
-- 5. BRANDS
-- ============================================================

CREATE TABLE brands (
    brand_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    brand_name VARCHAR(100) NOT NULL UNIQUE,

    status ENUM('active', 'inactive')
        NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_brands_status (status)
);


-- ============================================================
-- 6. SUPPLIERS
-- ============================================================

CREATE TABLE suppliers (
    supplier_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    supplier_name VARCHAR(150) NOT NULL,

    contact_person VARCHAR(100),

    phone VARCHAR(20),

    email VARCHAR(150),

    address TEXT,

    status ENUM('active', 'inactive')
        NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_suppliers_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    INDEX idx_suppliers_store (store_id),
    INDEX idx_suppliers_name (supplier_name),
    INDEX idx_suppliers_status (status)
);


-- ============================================================
-- 7. PRODUCTS
-- ============================================================

CREATE TABLE products (
    product_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    category_id INT UNSIGNED,

    brand_id INT UNSIGNED,

    supplier_id INT UNSIGNED,

    product_name VARCHAR(150) NOT NULL,

    sku VARCHAR(50) NOT NULL,

    description TEXT,

    purchase_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    selling_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    minimum_stock INT UNSIGNED NOT NULL DEFAULT 0,

    maximum_stock INT UNSIGNED,

    status ENUM('active', 'inactive', 'discontinued')
        NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_products_brand
        FOREIGN KEY (brand_id)
        REFERENCES brands(brand_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_products_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT uq_product_store_sku
        UNIQUE (store_id, sku),

    CONSTRAINT chk_product_prices
        CHECK (purchase_price >= 0 AND selling_price >= 0),

    CONSTRAINT chk_product_stock_limits
        CHECK (
            maximum_stock IS NULL
            OR maximum_stock >= minimum_stock
        ),

    INDEX idx_products_store (store_id),
    INDEX idx_products_category (category_id),
    INDEX idx_products_brand (brand_id),
    INDEX idx_products_supplier (supplier_id),
    INDEX idx_products_name (product_name),
    INDEX idx_products_sku (sku),
    INDEX idx_products_status (status)
);


-- ============================================================
-- 8. INVENTORY
-- ============================================================

CREATE TABLE inventory (
    inventory_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    product_id INT UNSIGNED NOT NULL,

    current_stock INT NOT NULL DEFAULT 0,

    location VARCHAR(100) DEFAULT 'Main Store',

    last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT uq_inventory_product
        UNIQUE (store_id, product_id),

    CONSTRAINT chk_inventory_stock
        CHECK (current_stock >= 0),

    INDEX idx_inventory_store (store_id),
    INDEX idx_inventory_product (product_id),
    INDEX idx_inventory_stock (current_stock)
);


-- ============================================================
-- 9. SALES
-- ============================================================

CREATE TABLE sales (
    sale_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    invoice_number VARCHAR(50) NOT NULL,

    customer_name VARCHAR(150) DEFAULT 'Walk-in Customer',

    sale_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    discount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    tax DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    payment_method ENUM('cash', 'upi', 'card', 'bank_transfer')
        NOT NULL DEFAULT 'cash',

    payment_status ENUM('paid', 'pending', 'refunded')
        NOT NULL DEFAULT 'paid',

    created_by INT UNSIGNED,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sales_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_sales_user
        FOREIGN KEY (created_by)
        REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT uq_sales_invoice
        UNIQUE (store_id, invoice_number),

    CONSTRAINT chk_sales_amounts
        CHECK (
            subtotal >= 0
            AND discount >= 0
            AND tax >= 0
            AND total_amount >= 0
        ),

    INDEX idx_sales_store (store_id),
    INDEX idx_sales_date (sale_date),
    INDEX idx_sales_payment (payment_method),
    INDEX idx_sales_status (payment_status)
);


-- ============================================================
-- 10. SALE ITEMS
-- ============================================================

CREATE TABLE sale_items (
    sale_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    sale_id INT UNSIGNED NOT NULL,

    product_id INT UNSIGNED NOT NULL,

    quantity INT UNSIGNED NOT NULL,

    unit_price DECIMAL(12,2) NOT NULL,

    discount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    subtotal DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_sale_items_sale
        FOREIGN KEY (sale_id)
        REFERENCES sales(sale_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_sale_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_sale_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_sale_item_price
        CHECK (unit_price >= 0),

    INDEX idx_sale_items_sale (sale_id),
    INDEX idx_sale_items_product (product_id)
);


-- ============================================================
-- 11. PURCHASES
-- ============================================================

CREATE TABLE purchases (
    purchase_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    supplier_id INT UNSIGNED NOT NULL,

    po_number VARCHAR(50) NOT NULL,

    purchase_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    discount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    tax DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    status ENUM('pending', 'completed', 'cancelled')
        NOT NULL DEFAULT 'pending',

    created_by INT UNSIGNED,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_purchases_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_purchases_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_purchases_user
        FOREIGN KEY (created_by)
        REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT uq_purchase_po
        UNIQUE (store_id, po_number),

    CONSTRAINT chk_purchase_amounts
        CHECK (
            subtotal >= 0
            AND discount >= 0
            AND tax >= 0
            AND total_amount >= 0
        ),

    INDEX idx_purchases_store (store_id),
    INDEX idx_purchases_supplier (supplier_id),
    INDEX idx_purchases_date (purchase_date),
    INDEX idx_purchases_status (status)
);


-- ============================================================
-- 12. PURCHASE ITEMS
-- ============================================================

CREATE TABLE purchase_items (
    purchase_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    purchase_id INT UNSIGNED NOT NULL,

    product_id INT UNSIGNED NOT NULL,

    quantity INT UNSIGNED NOT NULL,

    unit_cost DECIMAL(12,2) NOT NULL,

    discount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    subtotal DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_purchase_items_purchase
        FOREIGN KEY (purchase_id)
        REFERENCES purchases(purchase_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_purchase_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_purchase_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_purchase_item_cost
        CHECK (unit_cost >= 0),

    INDEX idx_purchase_items_purchase (purchase_id),
    INDEX idx_purchase_items_product (product_id)
);


-- ============================================================
-- 13. STOCK MOVEMENTS
-- ============================================================

CREATE TABLE stock_movements (
    movement_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    product_id INT UNSIGNED NOT NULL,

    movement_type ENUM(
        'purchase',
        'sale',
        'return',
        'adjustment',
        'damage',
        'transfer'
    ) NOT NULL,

    quantity INT NOT NULL,

    stock_before INT NOT NULL,

    stock_after INT NOT NULL,

    reference_type VARCHAR(50),

    reference_id INT UNSIGNED,

    created_by INT UNSIGNED,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_stock_movements_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_stock_movements_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_stock_movements_user
        FOREIGN KEY (created_by)
        REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_stock_before
        CHECK (stock_before >= 0),

    CONSTRAINT chk_stock_after
        CHECK (stock_after >= 0),

    INDEX idx_stock_movements_store (store_id),
    INDEX idx_stock_movements_product (product_id),
    INDEX idx_stock_movements_type (movement_type),
    INDEX idx_stock_movements_date (created_at)
);


-- ============================================================
-- 14. STOCK HEALTH
-- ============================================================

CREATE TABLE stock_health (
    health_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    product_id INT UNSIGNED NOT NULL,

    current_stock INT NOT NULL DEFAULT 0,

    sales_velocity DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    days_since_last_sale INT,

    stock_turnover DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    health_score DECIMAL(5,2) NOT NULL DEFAULT 0.00,

    health_status ENUM(
        'healthy',
        'monitor',
        'slow_moving',
        'critical',
        'dead_stock'
    ) NOT NULL DEFAULT 'healthy',

    calculated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_stock_health_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_stock_health_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT uq_stock_health_product
        UNIQUE (store_id, product_id),

    CONSTRAINT chk_health_score
        CHECK (health_score >= 0 AND health_score <= 100),

    CONSTRAINT chk_health_stock
        CHECK (current_stock >= 0),

    CONSTRAINT chk_sales_velocity
        CHECK (sales_velocity >= 0),

    INDEX idx_stock_health_store (store_id),
    INDEX idx_stock_health_status (health_status),
    INDEX idx_stock_health_score (health_score)
);


-- ============================================================
-- 15. ALERTS
-- ============================================================

CREATE TABLE alerts (
    alert_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    product_id INT UNSIGNED,

    alert_type ENUM(
        'low_stock',
        'out_of_stock',
        'slow_moving',
        'dead_stock',
        'purchase_pending'
    ) NOT NULL,

    severity ENUM(
        'info',
        'warning',
        'critical'
    ) NOT NULL DEFAULT 'info',

    title VARCHAR(200) NOT NULL,

    message TEXT NOT NULL,

    is_read BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    read_at TIMESTAMP NULL,

    CONSTRAINT fk_alerts_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_alerts_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    INDEX idx_alerts_store (store_id),
    INDEX idx_alerts_product (product_id),
    INDEX idx_alerts_type (alert_type),
    INDEX idx_alerts_severity (severity),
    INDEX idx_alerts_read (is_read),
    INDEX idx_alerts_date (created_at)
);


-- ============================================================
-- 16. STORE SETTINGS
-- ============================================================

CREATE TABLE store_settings (
    setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    store_id INT UNSIGNED NOT NULL,

    setting_key VARCHAR(100) NOT NULL,

    setting_value TEXT,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_store_settings_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT uq_store_setting
        UNIQUE (store_id, setting_key),

    INDEX idx_store_settings_store (store_id)
);


-- ============================================================
-- SCHEMA COMPLETE
-- ============================================================

SELECT 'SRISHMS database schema created successfully!' AS message;