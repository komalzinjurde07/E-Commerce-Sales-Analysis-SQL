
-- =====================================================
-- E-Commerce Sales Analysis using SQL
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS ecommerce_sales_db;

USE ecommerce_sales_db;


-- =====================================================
-- 1. BASIC DATA OVERVIEW
-- =====================================================

-- Total number of orders
SELECT
    COUNT(*) AS total_orders
FROM orders;


-- Total quantity sold
SELECT
    SUM(quantity) AS total_quantity_sold
FROM orders;


-- Total sales
SELECT
    ROUND(SUM(total), 2) AS total_sales
FROM orders;


-- Average order value
SELECT
    ROUND(AVG(total), 2) AS average_order_value
FROM orders;


-- =====================================================
-- 2. ORDER STATUS ANALYSIS
-- =====================================================

SELECT
    status,
    COUNT(*) AS number_of_orders,
    ROUND(SUM(total), 2) AS total_sales
FROM orders
GROUP BY status
ORDER BY number_of_orders DESC;


-- =====================================================
-- 3. DELIVERED ORDER ANALYSIS
-- =====================================================

SELECT
    COUNT(*) AS delivered_orders,
    SUM(quantity) AS delivered_quantity,
    ROUND(SUM(total), 2) AS delivered_sales
FROM orders
WHERE status = 'delivered';


-- =====================================================
-- 4. SKU-WISE SALES ANALYSIS
-- =====================================================

SELECT
    sku,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total), 2) AS total_sales
FROM orders
GROUP BY sku
ORDER BY total_sales DESC;


-- =====================================================
-- 5. TOP 10 SKUs BY SALES
-- =====================================================

SELECT
    sku,
    ROUND(SUM(total), 2) AS total_sales
FROM orders
GROUP BY sku
ORDER BY total_sales DESC
LIMIT 10;


-- =====================================================
-- 6. MONTHLY SALES TREND
-- =====================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    ROUND(SUM(total), 2) AS total_sales
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- =====================================================
-- 7. CUSTOMER-WISE ORDER ANALYSIS
-- =====================================================

SELECT
    customer_id,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total), 2) AS total_sales
FROM orders
GROUP BY customer_id
ORDER BY total_sales DESC;


-- =====================================================
-- 8. TOP 10 CUSTOMERS BY SALES
-- =====================================================

SELECT
    customer_id,
    ROUND(SUM(total), 2) AS total_sales
FROM orders
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;


-- =====================================================
-- 9. CUSTOMER + ORDER JOIN
-- =====================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.country,
    c.city,
    c.plan,
    o.order_id,
    o.order_date,
    o.sku,
    o.status,
    o.quantity,
    o.total
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;


-- =====================================================
-- 10. COUNTRY-WISE SALES
-- =====================================================

SELECT
    c.country,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total), 2) AS total_sales
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_sales DESC;


-- =====================================================
-- 11. CITY-WISE SALES
-- =====================================================

SELECT
    c.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total), 2) AS total_sales
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_sales DESC;


-- =====================================================
-- 12. PLAN-WISE CUSTOMER ANALYSIS
-- =====================================================

SELECT
    c.plan,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    ROUND(SUM(c.mrr), 2) AS total_mrr
FROM customers c
GROUP BY c.plan
ORDER BY total_mrr DESC;


-- =====================================================
-- 13. PLAN-WISE SALES ANALYSIS
-- =====================================================

SELECT
    c.plan,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total), 2) AS total_sales
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.plan
ORDER BY total_sales DESC;


-- =====================================================
-- 14. CUSTOMER SALES RANKING
-- =====================================================

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer_id,
    ROUND(total_sales, 2) AS total_sales,
    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_sales
ORDER BY sales_rank;


-- =====================================================
-- 15. HIGH-VALUE ORDERS
-- =====================================================

SELECT
    order_id,
    customer_id,
    sku,
    order_date,
    quantity,
    total
FROM orders
WHERE total > 1000
ORDER BY total DESC;


-- =====================================================
-- 16. SHIPPING ANALYSIS
-- =====================================================

SELECT
    ROUND(SUM(shipping), 2) AS total_shipping_cost,
    ROUND(AVG(shipping), 2) AS average_shipping_cost
FROM orders;


-- =====================================================
-- 17. DATA QUALITY CHECK
-- =====================================================

-- Orders without a matching customer
SELECT
    o.order_id,
    o.customer_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- =====================================================
-- 18. ORDER CALCULATION CHECK
-- =====================================================

SELECT
    order_id,
    subtotal,
    shipping,
    total,
    ROUND(subtotal + shipping, 2) AS calculated_total
FROM orders
WHERE ROUND(subtotal + shipping, 2) <> ROUND(total, 2);


-- =====================================================
-- END OF ANALYSIS
-- =====================================================)
