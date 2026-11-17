--Task 2: SQL functions--
USE retail_sales;

--UPPER()
SELECT customer_id,
       UPPER(customer_name) AS customer_name
FROM customers;

--CONCAT()

SELECT CONCAT(customer_name, ' - ', city)
       AS customer_details
FROM customers;

--DATEDIFF()
SELECT o.order_id,
       DATEDIFF(p.payment_date, o.order_date)
       AS payment_delay
FROM orders o
JOIN payments p
ON o.order_id = p.order_id;
--DATE_FORMAT()
SELECT order_id,
       DATE_FORMAT(order_date, '%d %M %Y')
       AS formatted_date
FROM orders;

--ROUND()
SELECT ROUND(AVG(price), 2)
       AS average_product_price
FROM products;


