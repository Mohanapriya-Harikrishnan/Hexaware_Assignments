--Query 1 – Top five products by revenue
SELECT p.product_name,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 5;


--Query 2 – Month-wise sales--
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

--Query 3 – Customers with more than three orders--
SELECT c.customer_id,
       c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 3;

--Query 4 – Average basket value per city
SELECT c.city,
       ROUND(
           SUM(oi.quantity * oi.unit_price) /
           COUNT(DISTINCT o.order_id), 2
       ) AS average_basket_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.city;


--Query 5 – Orders without payment--
SELECT o.order_id,
       c.customer_name,
       o.order_date
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
LEFT JOIN payments p
ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;

--Query 6 – Customers with no orders--
SELECT c.customer_id,
       c.customer_name,
       c.city
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--Query 7 – Product-category revenue share--

SELECT p.category,
       SUM(oi.quantity * oi.unit_price) AS revenue,
       ROUND(
           SUM(oi.quantity * oi.unit_price) * 100 /
           (SELECT SUM(quantity * unit_price)
            FROM order_items), 2
       ) AS revenue_share
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;

--Query 8 – Day with the highest sales
SELECT o.order_date,
       SUM(oi.quantity * oi.unit_price) AS daily_sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY daily_sales DESC
LIMIT 1;