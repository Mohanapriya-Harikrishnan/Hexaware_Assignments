USE retail_sales;
--Difference between WHERE and HAVING

--WHERE – Filters individual rows
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM orders
WHERE MONTH(order_date) = 9
GROUP BY customer_id;

--HAVING – Filters grouped results
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 3;

