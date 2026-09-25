
CREATE DATABASE ecommerce_sales_db;

USE ecommerce_sales_db;

-- 1. View customer and order details
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    c.state,
    o.order_id,
    o.order_date,
    o.product,
    o.qty,
    o.unit_price
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id;


-- 2. Total number of orders
SELECT
    COUNT(*) AS total_orders
FROM orders;


-- 3. Total sales
SELECT
    ROUND(SUM(qty * unit_price), 2) AS total_sales
FROM orders;


-- 4. Average order value
SELECT
    ROUND(AVG(qty * unit_price), 2) AS average_order_value
FROM orders;


-- 5. Customer-wise sales
SELECT
    c.customer_name,
    ROUND(SUM(o.qty * o.unit_price), 2) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC;


-- 6. State-wise sales
SELECT
    c.state,
    ROUND(SUM(o.qty * o.unit_price), 2) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.state
ORDER BY total_sales DESC;


-- 7. Product-wise sales
SELECT
    o.product,
    SUM(o.qty) AS total_quantity,
    ROUND(SUM(o.qty * o.unit_price), 2) AS total_sales
FROM orders o
GROUP BY o.product
ORDER BY total_sales DESC;


-- 8. Monthly sales
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(qty * unit_price), 2) AS total_sales
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- 9. Top 10 customers
SELECT
    c.customer_name,
    ROUND(SUM(o.qty * o.unit_price), 2) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC
LIMIT 10;


-- 10. Rank customers by sales
WITH customer_sales AS (
    SELECT
        c.customer_name,
        SUM(o.qty * o.unit_price) AS total_sales
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_name
)
SELECT
    customer_name,
    ROUND(total_sales, 2) AS total_sales,
    DENSE_RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_sales
ORDER BY sales_rank;
