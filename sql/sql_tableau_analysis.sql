USE olist_ecommerce;

-- =========================================================
-- Create Tableau-ready view
-- =========================================================
CREATE OR REPLACE VIEW tableau_olist AS
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,

    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    c.customer_state,

    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS product_category_name,

    oi.price,
    oi.freight_value,

    DATEDIFF(
        DATE(o.order_delivered_customer_date),
        DATE(o.order_purchase_timestamp)
    ) AS delivery_days,

    CASE
        WHEN o.order_delivered_customer_date IS NULL
            THEN 'Not Delivered'
        WHEN o.order_delivered_customer_date
             <= o.order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,

    r.avg_review_score AS review_score,
    r.review_count

FROM order_items oi

LEFT JOIN orders o
    ON oi.order_id = o.order_id

LEFT JOIN customers c
    ON o.customer_id = c.customer_id

LEFT JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name

LEFT JOIN (
    SELECT
        order_id,
        ROUND(AVG(review_score), 2) AS avg_review_score,
        COUNT(*) AS review_count
    FROM order_reviews
    GROUP BY order_id
) r
    ON oi.order_id = r.order_id;
	
-- =========================================================
-- Validate Tableau-ready view
-- Expected row count: 112,650
-- =========================================================
SELECT COUNT(*)
FROM tableau_olist;    

-- Verify one unique row per order item
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(order_id, '-', order_item_id)) AS unique_order_items
FROM tableau_olist;

-- Review final structure
DESCRIBE tableau_olist;


SELECT *
FROM tableau_olist;

SELECT *
FROM tableau_olist;

SELECT *
FROM tableau_olist
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tableau_olist.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';







