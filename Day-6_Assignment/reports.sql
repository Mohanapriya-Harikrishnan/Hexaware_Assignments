CREATE DATABASE retail_sales;
USE retail_sales;

--TABLE CREATION--
--CUSTOMER TABLE--
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    email VARCHAR(100) UNIQUE
);
--PRODUCTS TABLE--
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL
);
--ORDERS TABLE--
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
--Order items table--
CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
--Payments table--
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE,
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

--Insert sample data--
--Customers
INSERT INTO customers VALUES
(1, 'Arun', 'Chennai', 'arun@gmail.com'),
(2, 'Priya', 'Chennai', 'priya@gmail.com'),
(3, 'Rahul', 'Coimbatore', 'rahul@gmail.com'),
(4, 'Sneha', 'Madurai', NULL),
(5, 'Karthik', 'Coimbatore', 'karthik@gmail.com'),
(6, 'Divya', 'Madurai', NULL),
(7, 'Varun', 'Chennai', 'varun@gmail.com'),
(8, 'Meera', 'Trichy', 'meera@gmail.com');

--Products
INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Headphones', 'Electronics', 2000),
(103, 'Smartphone', 'Electronics', 25000),
(104, 'T-Shirt', 'Clothing', 800),
(105, 'Jeans', 'Clothing', 1500),
(106, 'Rice', 'Grocery', 1200),
(107, 'Cooking Oil', 'Grocery', 250),
(108, 'Office Chair', 'Furniture', 5000);

--Orders
INSERT INTO orders VALUES
(1001, 1, '2026-09-05'),
(1002, 2, '2026-09-05'),
(1003, 1, '2026-09-15'),
(1004, 3, '2026-09-20'),
(1005, 4, '2026-10-01'),
(1006, 1, '2026-10-05'),
(1007, 5, '2026-10-10'),
(1008, 2, '2026-10-15'),
(1009, 1, '2026-11-01'),
(1010, 6, '2026-11-05'),
(1011, 3, '2026-11-10'),
(1012, 5, '2026-11-12');

--Order items
INSERT INTO order_items VALUES
(1, 1001, 101, 1, 55000),
(2, 1001, 102, 2, 2000),
(3, 1002, 104, 3, 800),
(4, 1002, 105, 1, 1500),
(5, 1003, 103, 1, 25000),
(6, 1004, 106, 2, 1200),
(7, 1004, 107, 4, 250),
(8, 1005, 108, 2, 5000),
(9, 1006, 102, 3, 2000),
(10, 1007, 105, 2, 1500),
(11, 1008, 106, 1, 1200),
(12, 1008, 107, 2, 250),
(13, 1009, 103, 2, 25000),
(14, 1010, 104, 2, 800),
(15, 1011, 108, 1, 5000),
(16, 1012, 101, 1, 55000);

--Payments
INSERT INTO payments VALUES
(1, 1001, 59000, '2026-09-05'),
(2, 1002, 3900, '2026-09-05'),
(3, 1003, 25000, '2026-09-16'),
(4, 1004, 3400, '2026-09-20'),
(5, 1005, 10000, '2026-10-01'),
(6, 1006, 6000, '2026-10-06'),
(7, 1007, 3000, '2026-10-10'),
(8, 1009, 50000, '2026-11-01'),
(9, 1010, 1600, '2026-11-05'),
(10, 1011, 5000, '2026-11-10');

--SHOW TABLES

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;