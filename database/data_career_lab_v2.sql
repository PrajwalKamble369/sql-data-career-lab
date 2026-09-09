-- ============================================================
-- DATA CAREER LAB v2
-- Realistic PostgreSQL SQL Practice Database
-- For Data Analyst / Data Scientist / AI/ML preparation
-- ============================================================
--
-- STEP 1:
-- Run only the DATABASE CREATION section while connected to postgres.
--
-- STEP 2:
-- Connect to data_career_lab in pgAdmin.
--
-- STEP 3:
-- Run everything from DATABASE OBJECTS onward.
--
-- The data is synthetic, but the schema and business relationships
-- are designed to resemble a real e-commerce + digital analytics
-- company.
-- ============================================================


-- ============================================================
-- DATABASE CREATION
-- ============================================================

DROP DATABASE IF EXISTS data_career_lab;
CREATE DATABASE data_career_lab;


-- ============================================================
-- DATABASE OBJECTS
-- Run from here after connecting to data_career_lab
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;


-- ============================================================
-- LOCATION
-- ============================================================

CREATE TABLE locations (
    location_id  BIGSERIAL PRIMARY KEY,
    city         VARCHAR(100) NOT NULL,
    state        VARCHAR(100) NOT NULL,
    country      VARCHAR(100) NOT NULL DEFAULT 'India',
    postal_code  VARCHAR(10),
    region       VARCHAR(30) NOT NULL
);


-- ============================================================
-- CUSTOMERS
-- ============================================================

CREATE TABLE customers (
    customer_id          BIGSERIAL PRIMARY KEY,
    first_name           VARCHAR(50) NOT NULL,
    last_name            VARCHAR(80) NOT NULL,
    email                VARCHAR(150) UNIQUE NOT NULL,
    phone                VARCHAR(20),
    date_of_birth        DATE,
    gender               VARCHAR(20),
    city                 VARCHAR(100),
    state                VARCHAR(100),
    country              VARCHAR(100) NOT NULL DEFAULT 'India',
    registration_date    DATE NOT NULL,
    customer_segment     VARCHAR(30),
    acquisition_channel  VARCHAR(40),
    is_active            BOOLEAN NOT NULL DEFAULT TRUE,
    created_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE addresses (
    address_id     BIGSERIAL PRIMARY KEY,
    customer_id    BIGINT NOT NULL REFERENCES customers(customer_id),
    address_type   VARCHAR(20) NOT NULL,
    address_line1  VARCHAR(200),
    city           VARCHAR(100),
    state          VARCHAR(100),
    postal_code    VARCHAR(10),
    is_default     BOOLEAN NOT NULL DEFAULT FALSE
);


-- ============================================================
-- PRODUCT CATALOG
-- ============================================================

CREATE TABLE categories (
    category_id         BIGSERIAL PRIMARY KEY,
    category_name       VARCHAR(100) NOT NULL,
    parent_category_id  BIGINT REFERENCES categories(category_id)
);


CREATE TABLE sellers (
    seller_id       BIGSERIAL PRIMARY KEY,
    seller_name     VARCHAR(150) NOT NULL,
    city            VARCHAR(100),
    state           VARCHAR(100),
    seller_rating   NUMERIC(3,2) CHECK (seller_rating BETWEEN 1 AND 5),
    joined_date     DATE NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE
);


CREATE TABLE products (
    product_id       BIGSERIAL PRIMARY KEY,
    product_name     VARCHAR(200) NOT NULL,
    category_id      BIGINT NOT NULL REFERENCES categories(category_id),
    seller_id        BIGINT NOT NULL REFERENCES sellers(seller_id),
    brand            VARCHAR(100),
    price            NUMERIC(12,2) NOT NULL CHECK (price > 0),
    cost_price       NUMERIC(12,2) NOT NULL CHECK (cost_price > 0),
    stock_quantity   INTEGER NOT NULL DEFAULT 0,
    launch_date      DATE NOT NULL,
    product_rating   NUMERIC(3,2) CHECK (product_rating BETWEEN 1 AND 5),
    is_active        BOOLEAN NOT NULL DEFAULT TRUE
);


-- ============================================================
-- SALES
-- ============================================================

CREATE TABLE orders (
    order_id          BIGSERIAL PRIMARY KEY,
    customer_id       BIGINT NOT NULL REFERENCES customers(customer_id),
    order_date        TIMESTAMP NOT NULL,
    order_status      VARCHAR(30) NOT NULL,
    shipping_city     VARCHAR(100),
    shipping_state    VARCHAR(100),
    subtotal_amount   NUMERIC(14,2) NOT NULL DEFAULT 0,
    discount_amount   NUMERIC(12,2) NOT NULL DEFAULT 0,
    shipping_amount   NUMERIC(10,2) NOT NULL DEFAULT 0,
    total_amount      NUMERIC(14,2) NOT NULL DEFAULT 0,
    coupon_code       VARCHAR(50),
    sales_channel     VARCHAR(30)
);


CREATE TABLE order_items (
    order_item_id  BIGSERIAL PRIMARY KEY,
    order_id       BIGINT NOT NULL REFERENCES orders(order_id),
    product_id     BIGINT NOT NULL REFERENCES products(product_id),
    quantity       INTEGER NOT NULL CHECK (quantity > 0),
    unit_price     NUMERIC(12,2) NOT NULL CHECK (unit_price > 0),
    discount       NUMERIC(12,2) NOT NULL DEFAULT 0,
    item_status    VARCHAR(30) NOT NULL
);


-- ============================================================
-- PAYMENTS / REFUNDS
-- ============================================================

CREATE TABLE payments (
    payment_id       BIGSERIAL PRIMARY KEY,
    order_id         BIGINT NOT NULL REFERENCES orders(order_id),
    payment_date     TIMESTAMP NOT NULL,
    payment_method   VARCHAR(30) NOT NULL,
    payment_status   VARCHAR(30) NOT NULL,
    amount           NUMERIC(14,2) NOT NULL,
    transaction_ref  VARCHAR(100) UNIQUE NOT NULL
);


CREATE TABLE refunds (
    refund_id       BIGSERIAL PRIMARY KEY,
    payment_id      BIGINT NOT NULL REFERENCES payments(payment_id),
    refund_date     TIMESTAMP NOT NULL,
    refund_amount   NUMERIC(14,2) NOT NULL,
    refund_reason   VARCHAR(100),
    refund_status   VARCHAR(30) NOT NULL
);


-- ============================================================
-- PRODUCT REVIEWS
-- ============================================================

CREATE TABLE reviews (
    review_id          BIGSERIAL PRIMARY KEY,
    customer_id        BIGINT NOT NULL REFERENCES customers(customer_id),
    product_id         BIGINT NOT NULL REFERENCES products(product_id),
    order_id           BIGINT NOT NULL REFERENCES orders(order_id),
    rating             INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_title       VARCHAR(200),
    review_text        TEXT,
    review_date        TIMESTAMP NOT NULL,
    verified_purchase  BOOLEAN NOT NULL DEFAULT TRUE
);


-- ============================================================
-- MARKETING
-- ============================================================

CREATE TABLE marketing_campaigns (
    campaign_id     BIGSERIAL PRIMARY KEY,
    campaign_name   VARCHAR(150) NOT NULL,
    channel         VARCHAR(40) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    budget          NUMERIC(14,2) NOT NULL,
    target_segment  VARCHAR(50)
);


CREATE TABLE campaign_events (
    campaign_event_id  BIGSERIAL PRIMARY KEY,
    campaign_id        BIGINT NOT NULL REFERENCES marketing_campaigns(campaign_id),
    customer_id        BIGINT REFERENCES customers(customer_id),
    event_time         TIMESTAMP NOT NULL,
    event_type         VARCHAR(40) NOT NULL,
    cost               NUMERIC(10,2) NOT NULL DEFAULT 0
);


-- ============================================================
-- DIGITAL / WEB ANALYTICS
-- ============================================================

CREATE TABLE website_sessions (
    session_id       BIGSERIAL PRIMARY KEY,
    customer_id      BIGINT REFERENCES customers(customer_id),
    session_start    TIMESTAMP NOT NULL,
    session_end      TIMESTAMP NOT NULL,
    device_type      VARCHAR(30) NOT NULL,
    traffic_source   VARCHAR(50) NOT NULL,
    landing_page     VARCHAR(100),
    converted        BOOLEAN NOT NULL DEFAULT FALSE
);


CREATE TABLE events (
    event_id         BIGSERIAL PRIMARY KEY,
    session_id       BIGINT NOT NULL REFERENCES website_sessions(session_id),
    customer_id      BIGINT REFERENCES customers(customer_id),
    event_time       TIMESTAMP NOT NULL,
    event_type       VARCHAR(50) NOT NULL,
    product_id       BIGINT REFERENCES products(product_id),
    page_url         VARCHAR(300),
    event_value      NUMERIC(12,2)
);


-- ============================================================
-- COMPANY / HR
-- ============================================================

CREATE TABLE departments (
    department_id    BIGSERIAL PRIMARY KEY,
    department_name  VARCHAR(100) NOT NULL,
    location_id      BIGINT REFERENCES locations(location_id)
);


CREATE TABLE employees (
    employee_id        BIGSERIAL PRIMARY KEY,
    first_name         VARCHAR(50) NOT NULL,
    last_name          VARCHAR(80) NOT NULL,
    department_id      BIGINT REFERENCES departments(department_id),
    manager_id         BIGINT REFERENCES employees(employee_id),
    hire_date          DATE NOT NULL,
    salary             NUMERIC(12,2) NOT NULL,
    job_title          VARCHAR(100) NOT NULL,
    employment_status  VARCHAR(30) NOT NULL
);


-- ============================================================
-- SEED: LOCATIONS
-- ============================================================

INSERT INTO locations
(city, state, country, postal_code, region)
VALUES
('Pune','Maharashtra','India','411001','West'),
('Mumbai','Maharashtra','India','400001','West'),
('Sangli','Maharashtra','India','416416','West'),
('Kolhapur','Maharashtra','India','416001','West'),
('Satara','Maharashtra','India','415001','West'),
('Nagpur','Maharashtra','India','440001','West'),
('Nashik','Maharashtra','India','422001','West'),
('Chhatrapati Sambhajinagar','Maharashtra','India','431001','West'),
('Bengaluru','Karnataka','India','560001','South'),
('Hyderabad','Telangana','India','500001','South'),
('Delhi','Delhi','India','110001','North'),
('Chennai','Tamil Nadu','India','600001','South'),
('Kolkata','West Bengal','India','700001','East'),
('Ahmedabad','Gujarat','India','380001','West'),
('Jaipur','Rajasthan','India','302001','North');


-- ============================================================
-- SEED: CATEGORIES
-- ============================================================

INSERT INTO categories (category_name)
VALUES
('Electronics'),
('Mobiles'),
('Laptops'),
('Home Appliances'),
('Fashion'),
('Footwear'),
('Books'),
('Beauty'),
('Sports'),
('Grocery'),
('Furniture'),
('Gaming'),
('Cameras'),
('Accessories'),
('Kitchen');


-- ============================================================
-- SEED: SELLERS
-- ============================================================

INSERT INTO sellers
(seller_name, city, state, seller_rating, joined_date, is_active)
SELECT
    'Seller ' || gs,
    l.city,
    l.state,
    round((3.0 + random() * 2.0)::numeric, 2),
    DATE '2020-01-01' + floor(random() * 2200)::int,
    random() > 0.08
FROM generate_series(1, 500) gs
CROSS JOIN LATERAL (
    SELECT city, state
    FROM locations
    ORDER BY random()
    LIMIT 1
) l;


-- ============================================================
-- SEED: PRODUCTS
-- Product launch dates are always before the sales period.
-- ============================================================

INSERT INTO products
(product_name, category_id, seller_id, brand, price, cost_price,
 stock_quantity, launch_date, product_rating, is_active)
SELECT
    'Product ' || gs,
    1 + floor(random() * 15)::bigint,
    1 + floor(random() * 500)::bigint,
    (ARRAY[
        'Samsung','Apple','HP','Dell','Lenovo','Sony','Nike','Adidas',
        'LG','Boat','OnePlus','Canon','Philips','IKEA','Generic'
    ])[1 + floor(random() * 15)::int],
    p.price,
    round((p.price * (0.45 + random() * 0.35))::numeric, 2),
    floor(random() * 1000)::int,
    DATE '2019-01-01' + floor(random() * 731)::int,
    round((2.8 + random() * 2.2)::numeric, 2),
    random() > 0.05
FROM generate_series(1, 10000) gs
CROSS JOIN LATERAL (
    SELECT round((199 + random() * 149800)::numeric, 2) AS price
) p;


-- ============================================================
-- SEED: CUSTOMERS
-- Registration dates stay within 2021-2026.
-- ============================================================

INSERT INTO customers
(first_name, last_name, email, phone, date_of_birth, gender,
 city, state, country, registration_date, customer_segment,
 acquisition_channel, is_active)
SELECT
    (ARRAY[
        'Aarav','Vivaan','Aditya','Arjun','Rahul','Rohan','Vikas',
        'Sneha','Priya','Ananya','Neha','Aditi','Kavya','Isha','Riya'
    ])[1 + floor(random() * 15)::int],
    'Customer' || gs,
    'customer' || gs || '@example.com',
    '9' || lpad((100000000 + gs)::text, 9, '0'),
    DATE '1960-01-01' + floor(random() * 18000)::int,
    (ARRAY['Male','Female','Other',NULL])[1 + floor(random() * 4)::int],
    loc.city,
    loc.state,
    'India',
    DATE '2021-01-01' + floor(random() * 1900)::int,
    (ARRAY['Premium','Regular','Budget','New',NULL])[1 + floor(random() * 5)::int],
    (ARRAY[
        'Organic','Google','Facebook','Instagram',
        'Referral','Email','Affiliate','Direct'
    ])[1 + floor(random() * 8)::int],
    random() > 0.12
FROM generate_series(1, 100000) gs
CROSS JOIN LATERAL (
    SELECT city, state
    FROM locations
    ORDER BY random()
    LIMIT 1
) loc;


-- ============================================================
-- SEED: ADDRESSES
-- Most customers get one or two addresses.
-- ============================================================

INSERT INTO addresses
(customer_id, address_type, address_line1, city, state, postal_code, is_default)
SELECT
    c.customer_id,
    'Home',
    'House ' || (100 + floor(random() * 9900)::int) || ', Main Road',
    c.city,
    c.state,
    lpad((100000 + floor(random() * 899999))::int::text, 6, '0'),
    TRUE
FROM customers c;

INSERT INTO addresses
(customer_id, address_type, address_line1, city, state, postal_code, is_default)
SELECT
    c.customer_id,
    'Work',
    'Office ' || (100 + floor(random() * 9900)::int) || ', Business Park',
    c.city,
    c.state,
    lpad((100000 + floor(random() * 899999))::int::text, 6, '0'),
    FALSE
FROM customers c
WHERE random() < 0.45;


-- ============================================================
-- SEED: ORDERS
-- IMPORTANT:
-- Every order date is after that customer's registration date.
-- ============================================================

INSERT INTO orders
(customer_id, order_date, order_status, shipping_city, shipping_state,
 subtotal_amount, discount_amount, shipping_amount, total_amount,
 coupon_code, sales_channel)
SELECT
    c.customer_id,
    c.registration_date::timestamp
        + random() * (TIMESTAMP '2026-09-01' - c.registration_date::timestamp),
    (ARRAY[
        'delivered','delivered','delivered','delivered',
        'shipped','processing','cancelled','returned'
    ])[1 + floor(random() * 8)::int],
    c.city,
    c.state,
    0,
    0,
    round((40 + random() * 300)::numeric, 2),
    0,
    CASE
        WHEN random() < 0.35
        THEN 'SAVE' || (10 + floor(random() * 90))::int
        ELSE NULL
    END,
    (ARRAY['Website','Mobile App','Marketplace','Store'])
        [1 + floor(random() * 4)::int]
FROM generate_series(1, 500000) gs
JOIN customers c
    ON c.customer_id = 1 + floor(random() * 100000)::bigint;


-- ============================================================
-- SEED: ORDER ITEMS
-- Each order receives 1-4 items.
-- Products were launched before the order period.
-- ============================================================

INSERT INTO order_items
(order_id, product_id, quantity, unit_price, discount, item_status)
SELECT
    o.order_id,
    p.product_id,
    x.quantity,
    p.price,
    round((p.price * x.quantity * (random() * 0.15))::numeric, 2),
    CASE
        WHEN o.order_status = 'returned' THEN 'returned'
        WHEN o.order_status = 'cancelled' THEN 'cancelled'
        WHEN o.order_status = 'processing' THEN 'processing'
        WHEN o.order_status = 'shipped' THEN 'shipped'
        ELSE 'delivered'
    END
FROM orders o
CROSS JOIN LATERAL generate_series(
    1, 1 + floor(random() * 4)::int
) item_no
CROSS JOIN LATERAL (
    SELECT
        product_id,
        price,
        1 + floor(random() * 4)::int AS quantity
    FROM products
    WHERE product_id = 1 + floor(random() * 10000)::bigint
) p
CROSS JOIN LATERAL (
    SELECT p.quantity AS quantity
) x;


-- ============================================================
-- UPDATE ORDER TOTALS FROM ACTUAL ORDER ITEMS
-- ============================================================

UPDATE orders o
SET
    subtotal_amount = totals.subtotal_amount,
    discount_amount = totals.discount_amount,
    total_amount =
        GREATEST(
            0,
            totals.subtotal_amount
            - totals.discount_amount
            + o.shipping_amount
        )
FROM (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS subtotal_amount,
        SUM(discount) AS discount_amount
    FROM order_items
    GROUP BY order_id
) totals
WHERE o.order_id = totals.order_id;


-- ============================================================
-- SEED: PAYMENTS
-- Payment amount is based on the actual order total.
-- ============================================================

INSERT INTO payments
(order_id, payment_date, payment_method, payment_status,
 amount, transaction_ref)
SELECT
    o.order_id,
    o.order_date + random() * interval '2 days',
    CASE
        WHEN o.sales_channel = 'Store' AND random() < 0.25
            THEN 'Cash'
        ELSE
            (ARRAY[
                'UPI','Credit Card','Debit Card',
                'Net Banking','Wallet','COD'
            ])[1 + floor(random() * 6)::int]
    END,
    CASE
        WHEN o.order_status = 'cancelled' THEN 'failed'
        WHEN random() < 0.95 THEN 'completed'
        ELSE 'pending'
    END,
    o.total_amount,
    'TXN-' || o.order_id || '-' || encode(gen_random_bytes(8), 'hex')
FROM orders o;


-- ============================================================
-- SEED: REFUNDS
-- Only returned/cancelled orders can receive refunds.
-- Refund never exceeds the payment amount.
-- ============================================================

INSERT INTO refunds
(payment_id, refund_date, refund_amount, refund_reason, refund_status)
SELECT
    p.payment_id,
    p.payment_date + (1 + floor(random() * 30))::int * interval '1 day',
    round((p.amount * (0.25 + random() * 0.75))::numeric, 2),
    (ARRAY[
        'Customer Return',
        'Damaged Product',
        'Wrong Product',
        'Cancellation',
        'Quality Issue'
    ])[1 + floor(random() * 5)::int],
    CASE
        WHEN random() < 0.85 THEN 'completed'
        ELSE 'pending'
    END
FROM payments p
JOIN orders o
    ON o.order_id = p.order_id
WHERE o.order_status IN ('returned','cancelled')
  AND p.payment_status = 'completed'
  AND random() < 0.35;


-- ============================================================
-- SEED: REVIEWS
-- Reviews are tied to real customer/order/product combinations
-- from delivered or returned order items.
-- ============================================================

INSERT INTO reviews
(customer_id, product_id, order_id, rating, review_title,
 review_text, review_date, verified_purchase)
SELECT
    o.customer_id,
    oi.product_id,
    o.order_id,
    CASE
        WHEN random() < 0.10 THEN 1
        WHEN random() < 0.25 THEN 2
        WHEN random() < 0.45 THEN 3
        WHEN random() < 0.80 THEN 4
        ELSE 5
    END,
    (ARRAY[
        'Good product',
        'Average experience',
        'Excellent',
        'Not satisfied',
        'Value for money',
        'Amazing product'
    ])[1 + floor(random() * 6)::int],
    'Synthetic customer review for SQL analytics practice.',
    o.order_date + random() * interval '45 days',
    TRUE
FROM order_items oi
JOIN orders o
    ON o.order_id = oi.order_id
WHERE oi.item_status IN ('delivered','returned')
ORDER BY random()
LIMIT 250000;


-- ============================================================
-- SEED: MARKETING CAMPAIGNS
-- End date is always after start date.
-- ============================================================

INSERT INTO marketing_campaigns
(campaign_name, channel, start_date, end_date, budget, target_segment)
SELECT
    'Campaign ' || gs,
    (ARRAY[
        'Google Ads','Facebook','Instagram',
        'Email','Affiliate','YouTube','Organic'
    ])[1 + floor(random() * 7)::int],
    start_dt,
    start_dt + (30 + floor(random() * 151))::int,
    round((10000 + random() * 500000)::numeric, 2),
    (ARRAY['Premium','Regular','Budget','New','All'])
        [1 + floor(random() * 5)::int]
FROM generate_series(1, 300) gs
CROSS JOIN LATERAL (
    SELECT DATE '2022-01-01' + floor(random() * 1600)::int AS start_dt
) d;


-- ============================================================
-- SEED: CAMPAIGN EVENTS
-- ============================================================

INSERT INTO campaign_events
(campaign_id, customer_id, event_time, event_type, cost)
SELECT
    c.campaign_id,
    CASE
        WHEN random() < 0.92
        THEN 1 + floor(random() * 100000)::bigint
        ELSE NULL
    END,
    c.start_date::timestamp
        + random() * ((c.end_date + 1)::timestamp - c.start_date::timestamp),
    (ARRAY[
        'impression','click','lead',
        'signup','conversion','unsubscribe'
    ])[1 + floor(random() * 6)::int],
    round((random() * 100)::numeric, 2)
FROM generate_series(1, 500000) gs
CROSS JOIN LATERAL (
    SELECT campaign_id, start_date, end_date
    FROM marketing_campaigns
    WHERE campaign_id = 1 + floor(random() * 300)::bigint
) c;


-- ============================================================
-- SEED: WEBSITE SESSIONS
-- Sessions occur after customer registration.
-- ============================================================

INSERT INTO website_sessions
(customer_id, session_start, session_end, device_type,
 traffic_source, landing_page, converted)
SELECT
    CASE
        WHEN random() < 0.90
        THEN c.customer_id
        ELSE NULL
    END,
    session_start,
    session_start + (30 + floor(random() * 900))::int * interval '1 second',
    (ARRAY['Mobile','Desktop','Tablet'])
        [1 + floor(random() * 3)::int],
    (ARRAY[
        'Google','Direct','Facebook','Instagram',
        'Email','Referral','Organic','Affiliate'
    ])[1 + floor(random() * 8)::int],
    (ARRAY[
        '/home','/products','/sale',
        '/electronics','/fashion','/offers'
    ])[1 + floor(random() * 6)::int],
    random() < 0.12
FROM generate_series(1, 1000000) gs
CROSS JOIN LATERAL (
    SELECT
        customer_id,
        registration_date::timestamp
        + random() *
          (TIMESTAMP '2026-09-01' - registration_date::timestamp)
        AS session_start
    FROM customers
    WHERE customer_id = 1 + floor(random() * 100000)::bigint
) c;


-- ============================================================
-- SEED: WEBSITE EVENTS
-- Exactly 3 events per session = ~3 million events.
-- ============================================================

INSERT INTO events
(session_id, customer_id, event_time, event_type,
 product_id, page_url, event_value)
SELECT
    s.session_id,
    s.customer_id,
    s.session_start
        + (random() * EXTRACT(EPOCH FROM
            (s.session_end - s.session_start)))::int
          * interval '1 second',
    event_type,
    CASE
        WHEN event_type IN
            ('product_view','add_to_cart','remove_from_cart',
             'wishlist','purchase')
        THEN 1 + floor(random() * 10000)::bigint
        ELSE NULL
    END,
    page_url,
    CASE
        WHEN event_type = 'purchase'
        THEN round((100 + random() * 25000)::numeric, 2)
        ELSE NULL
    END
FROM website_sessions s
CROSS JOIN LATERAL (
    SELECT
        (ARRAY[
            'page_view',
            'product_view',
            'search',
            'add_to_cart',
            'remove_from_cart',
            'wishlist',
            'checkout',
            'purchase'
        ])[1 + floor(random() * 8)::int] AS event_type,
        (ARRAY[
            '/home','/products','/product',
            '/search','/cart','/checkout','/offers'
        ])[1 + floor(random() * 7)::int] AS page_url
) e
CROSS JOIN generate_series(1,3);


-- ============================================================
-- SEED: DEPARTMENTS
-- ============================================================

INSERT INTO departments
(department_name, location_id)
SELECT
    department_name,
    1 + floor(random() * 15)::bigint
FROM (
    VALUES
    ('Data Analytics'),
    ('Data Science'),
    ('Machine Learning'),
    ('Data Engineering'),
    ('Software Engineering'),
    ('Marketing'),
    ('Finance'),
    ('Sales'),
    ('Operations'),
    ('Product')
) d(department_name);


-- ============================================================
-- SEED: EMPLOYEES
-- 5,000 employees.
-- Managers are assigned after insertion.
-- ============================================================

INSERT INTO employees
(first_name, last_name, department_id, hire_date,
 salary, job_title, employment_status)
SELECT
    (ARRAY[
        'Amit','Rahul','Sneha','Priya','Neha',
        'Rohan','Ananya','Vikas','Kiran','Meera'
    ])[1 + floor(random() * 10)::int],
    'Employee' || gs,
    1 + floor(random() * 10)::bigint,
    DATE '2018-01-01' + floor(random() * 3000)::int,
    round((300000 + random() * 2200000)::numeric, 2),
    (ARRAY[
        'Analyst','Senior Analyst','Data Scientist',
        'ML Engineer','Software Engineer','Manager',
        'Product Manager','Business Analyst','Data Engineer'
    ])[1 + floor(random() * 9)::int],
    (ARRAY[
        'Active','Active','Active','On Leave','Resigned'
    ])[1 + floor(random() * 5)::int]
FROM generate_series(1, 5000) gs;


-- Assign managers from earlier employee IDs.
UPDATE employees e
SET manager_id =
    CASE
        WHEN e.employee_id <= 20 THEN NULL
        ELSE 1 + floor(random() * LEAST(e.employee_id - 1, 20))::bigint
    END;


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_customers_state
    ON customers(state);

CREATE INDEX idx_customers_registration_date
    ON customers(registration_date);

CREATE INDEX idx_customers_segment
    ON customers(customer_segment);

CREATE INDEX idx_customers_acquisition
    ON customers(acquisition_channel);

CREATE INDEX idx_addresses_customer
    ON addresses(customer_id);

CREATE INDEX idx_products_category
    ON products(category_id);

CREATE INDEX idx_products_seller
    ON products(seller_id);

CREATE INDEX idx_products_price
    ON products(price);

CREATE INDEX idx_products_launch_date
    ON products(launch_date);

CREATE INDEX idx_orders_customer
    ON orders(customer_id);

CREATE INDEX idx_orders_date
    ON orders(order_date);

CREATE INDEX idx_orders_status
    ON orders(order_status);

CREATE INDEX idx_orders_customer_date
    ON orders(customer_id, order_date);

CREATE INDEX idx_order_items_order
    ON order_items(order_id);

CREATE INDEX idx_order_items_product
    ON order_items(product_id);

CREATE INDEX idx_payments_order
    ON payments(order_id);

CREATE INDEX idx_payments_date
    ON payments(payment_date);

CREATE INDEX idx_refunds_payment
    ON refunds(payment_id);

CREATE INDEX idx_reviews_customer
    ON reviews(customer_id);

CREATE INDEX idx_reviews_product
    ON reviews(product_id);

CREATE INDEX idx_campaign_events_campaign
    ON campaign_events(campaign_id);

CREATE INDEX idx_campaign_events_customer
    ON campaign_events(customer_id);

CREATE INDEX idx_sessions_customer
    ON website_sessions(customer_id);

CREATE INDEX idx_sessions_start
    ON website_sessions(session_start);

CREATE INDEX idx_events_session
    ON events(session_id);

CREATE INDEX idx_events_customer
    ON events(customer_id);

CREATE INDEX idx_events_product
    ON events(product_id);

CREATE INDEX idx_events_time
    ON events(event_time);


-- ============================================================
-- UPDATE STATISTICS
-- ============================================================

ANALYZE;


-- ============================================================
-- DATA QUALITY / VERIFICATION
-- ============================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'addresses', COUNT(*) FROM addresses
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'refunds', COUNT(*) FROM refunds
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'marketing_campaigns', COUNT(*) FROM marketing_campaigns
UNION ALL
SELECT 'campaign_events', COUNT(*) FROM campaign_events
UNION ALL
SELECT 'website_sessions', COUNT(*) FROM website_sessions
UNION ALL
SELECT 'events', COUNT(*) FROM events
UNION ALL
SELECT 'departments', COUNT(*) FROM departments
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
ORDER BY table_name;


-- ============================================================
-- RELATIONSHIP CHECKS
-- ============================================================

-- Orders before customer registration should be zero.
SELECT COUNT(*) AS invalid_orders_before_registration
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_date::date < c.registration_date;

-- Refunds greater than payment should be zero.
SELECT COUNT(*) AS invalid_refunds
FROM refunds r
JOIN payments p ON p.payment_id = r.payment_id
WHERE r.refund_amount > p.amount;

-- ============================================================
-- END OF DATA CAREER LAB v2
-- ============================================================
