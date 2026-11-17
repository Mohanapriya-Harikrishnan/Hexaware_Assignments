USE retail_sales;
--NULL behaviour in SQL

--COUNT(*) vs COUNT(column)
SELECT COUNT(*) AS total_customers,
       COUNT(email) AS customers_with_email,
       COUNT(*) - COUNT(email) AS missing_email
FROM customers;

--NULL behaviour in SUM and AVG
SELECT COUNT(*) AS total_orders,
       COUNT(p.amount) AS paid_orders,
       SUM(p.amount) AS total_payment,
       ROUND(AVG(p.amount), 2) AS average_payment
FROM orders o
LEFT JOIN payments p
ON o.order_id = p.order_id;

--Replacing NULL with zero
SELECT ROUND(AVG(amount), 2) AS average_payment,
       ROUND(AVG(COALESCE(amount, 0)), 2)
       AS average_per_order
FROM orders o
LEFT JOIN payments p
ON o.order_id = p.order_id;