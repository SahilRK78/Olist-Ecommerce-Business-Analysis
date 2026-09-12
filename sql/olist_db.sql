CREATE DATABASE olist_ecommerce;
USE olist_ecommerce;
-- customers table
CREATE TABLE customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
);

-- SHOW VARIABLES LIKE 'local_infile';
-- SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/91776/Downloads/Olist-Ecommerce-Business-Analysis/data/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);

-- geolocation table
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DOUBLE,
    geolocation_lng DOUBLE,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2)
);

LOAD DATA LOCAL INFILE 'C:/Users/91776/Downloads/Olist-Ecommerce-Business-Analysis/data/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state);

-- order_items table
CREATE TABLE order_items (
    order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date DATETIME,
    price DOUBLE,
    freight_value DOUBLE
);
LOAD DATA LOCAL INFILE 'C:/Users/91776/Downloads/Olist-Ecommerce-Business-Analysis/data/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value);

-- orders table
CREATE TABLE orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);
LOAD DATA LOCAL INFILE 'C:/Users/91776/Downloads/Olist-Ecommerce-Business-Analysis/data/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @purchase,
    @approved,
    @carrier,
    @customer_delivery,
    @estimated
)
SET
    order_purchase_timestamp = NULLIF(@purchase, ''),
    order_approved_at = NULLIF(@approved, ''),
    order_delivered_carrier_date = NULLIF(@carrier, ''),
    order_delivered_customer_date = NULLIF(@customer_delivery, ''),
    order_estimated_delivery_date = NULLIF(@estimated, '');

SELECT COUNT(*) AS missing_delivery_dates
FROM orders
WHERE order_delivered_customer_date IS NULL;

-- order_payments table
CREATE TABLE order_payments (
    order_id VARCHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DOUBLE
);

LOAD DATA LOCAL INFILE 'C:/Users/91776/Downloads/Olist-Ecommerce-Business-Analysis/data/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
);

-- order_reviews table
CREATE TABLE order_reviews (
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
-- use temporary variables '@' for the date columns because some values may be missing:
LOAD DATA LOCAL INFILE 'C:/Users/91776/Downloads/Olist-Ecommerce-Business-Analysis/data/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    @review_creation,
    @review_answer
)
SET
    review_creation_date = NULLIF(@review_creation, ''),
    review_answer_timestamp = NULLIF(@review_answer, '');

-- products table
CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:/Users/91776/Downloads/Olist-Ecommerce-Business-Analysis/data/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
);

-- sellers table
CREATE TABLE sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);
LOAD DATA LOCAL INFILE 'C:/Users/91776/Downloads/Olist-Ecommerce-Business-Analysis/data/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
);

-- category translation table
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
LOAD DATA LOCAL INFILE 'C:/Users/91776/Downloads/Olist-Ecommerce-Business-Analysis/data/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_category_name,
    product_category_name_english
);

SHOW TABLES;
SELECT COUNT(*) FROM customers;

SELECT COUNT(*) FROM geolocation;

SELECT COUNT(*) FROM orders;

SELECT COUNT(*) FROM order_items;

SELECT COUNT(*) FROM order_payments;

SELECT COUNT(*) FROM order_reviews;

SELECT COUNT(*) FROM products;

SELECT COUNT(*) FROM sellers;

SELECT COUNT(*) FROM product_category_name_translation;

-- Table structure
DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE products;
DESCRIBE order_payments;

-- Data validation
-- Orders and Customers
SELECT
	o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
LIMIT 10;

-- Orders and Order Items
SELECT
    o.order_id,
    o.order_status,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
LIMIT 10;

-- Orders and Payments
SELECT
    o.order_id,
    o.order_status,
    p.payment_type,
    p.payment_installments,
    p.payment_value
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
LIMIT 10;

-- 1. Calculate total orders, total payment value and average order value (AOV).
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(SUM(payment_value) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM order_payments;

-- 2. Monthly revenue analysis: Analyze how payment value changes month by month based on the order purchase date.
SELECT 
	DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM orders o
JOIN order_payments p
	ON o.order_id = p.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;

-- 3. Monthly order volume analysis: Analyze the number of orders placed each month based on the order purchase date.
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY month;

-- 4. Revenue by product category: Identify which product categories generate the highest sales value.
SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS category,
    ROUND(SUM(oi.price), 2) AS sales_value
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    )
ORDER BY sales_value DESC
LIMIT 10;


-- 5. Top product categories by order volume: Identify which product categories have the highest number of orders.
SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    )
ORDER BY total_orders DESC
LIMIT 10;

-- 6. Orders by customer state: Identify which Brazilian states generate the highest number of orders.
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;


-- 7. Revenue by customer state: Identify which customer states generate the highest total payment value.
SELECT 
	c.customer_state,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
JOIN order_payments p
	ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC; 

-- 8. Repeat customer analysis: Identify how many unique customers placed more than one order.
SELECT 
	COUNT(*) AS repeat_customers
FROM (
	SELECT
		c.customer_unique_id
	FROM customers c
    JOIN orders o
		ON c.customer_id = o.customer_id
	GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id)>1
) AS repeat_customer_list;

-- 9. Payment method distribution: Identify the most frequently used payment methods across the Olist marketplace.
SELECT 
	payment_type,
    COUNT(*) AS payment_count,
    ROUND(
		100 * COUNT(*) / (SELECT COUNT(*) FROM order_payments),
        2
    ) AS percentage
FROM order_payments
GROUP BY payment_type
ORDER BY payment_count DESC;

-- 10. Payment installment analysis: Understand the distribution of payment installments used by customers, especially for credit-card purchases.
SELECT 
	payment_installments,
    COUNT(*) AS payment_count,
    ROUND(
		100 * COUNT(*) / (SELECT COUNT(*) FROM order_payments),
        2
    ) AS percentage
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- 11. Top sellers by sales value: Identify sellers generating the highest product sales value and the number of orders they handle.
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS sales_value,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY sales_value DESC
LIMIT 10;


-- 12. Seller performance and average order value: Compare sellers based on total sales value, order volume, and average sales value per order.
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS sales_value,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT oi.order_id),
        2
    ) AS avg_sales_per_order
FROM order_items oi
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT oi.order_id) >= 100
ORDER BY avg_sales_per_order DESC
LIMIT 10;

-- 13. Average delivery time: Measure the average number of days taken to deliver orders from purchase to customer delivery.
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


-- 14. Delivery performance: Classify delivered orders as on-time or late compared with the estimated delivery date.
SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status
ORDER BY order_count DESC;


-- 15. Review score distribution: Understand how customers rate their overall shopping experience.
SELECT
    review_score,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;

-- 16. Delivery performance vs customer review score: Compare customer ratings for on-time and late deliveries to understand whether delivery delays are associated with lower customer satisfaction.
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders o
JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status
ORDER BY average_review_score DESC;


-- 17. Negative review rate: Measure the percentage of reviews that are classified as negative (1 or 2 stars).
SELECT
    COUNT(*) AS total_reviews,
    SUM(CASE
            WHEN review_score IN (1, 2) THEN 1
            ELSE 0
        END) AS negative_reviews,
    ROUND(
        100.0 * SUM(CASE
                        WHEN review_score IN (1, 2) THEN 1
                        ELSE 0
                    END) / COUNT(*),
        2
    ) AS negative_review_percentage
FROM order_reviews;

-- 18. Month-over-month revenue growth: Calculate monthly revenue and compare it with the previous month's revenue to identify growth and decline periods.
WITH monthly_revenue AS (
	SELECT
		DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        ROUND(SUM(p.payment_value), 2) AS revenue
	FROM orders o
    JOIN order_payments p
		ON o.order_id = p.order_id
	GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT 
	month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(
		100 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / LAG(revenue) OVER (ORDER BY month),
        2
    ) AS mom_growth_percentage
FROM monthly_revenue
ORDER BY month;

-- 19. Product category ranking: Rank product categories based on total product sales value to identify the strongest categories.
WITH category_sales AS (
    SELECT
        COALESCE(
            t.product_category_name_english,
            p.product_category_name,
            'Unknown'
        ) AS category,
        SUM(oi.price) AS sales_value
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation t
        ON p.product_category_name = t.product_category_name
    GROUP BY
        COALESCE(
            t.product_category_name_english,
            p.product_category_name,
            'Unknown'
        )
)

SELECT
    category,
    ROUND(sales_value, 2) AS sales_value,
    RANK() OVER (ORDER BY sales_value DESC) AS sales_rank
FROM category_sales
ORDER BY sales_rank
LIMIT 10;







