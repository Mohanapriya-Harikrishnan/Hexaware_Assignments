-- Run once on a fresh MySQL 8.0 database.
CREATE DATABASE IF NOT EXISTS telecom_low_balance;
USE telecom_low_balance;
CREATE TABLE plans (plan_id INT PRIMARY KEY, plan_name VARCHAR(50) NOT NULL, amount DECIMAL(10,2) NOT NULL CHECK(amount>0), validity_days INT NOT NULL CHECK(validity_days>0));
CREATE TABLE subscribers (subscriber_id INT PRIMARY KEY, subscriber_name VARCHAR(60) NOT NULL, phone VARCHAR(20) NOT NULL UNIQUE, email VARCHAR(100), account_type ENUM('PREPAID','POSTPAID') NOT NULL, balance DECIMAL(12,2) NOT NULL CHECK(balance>=0), validity_end DATE NOT NULL);
CREATE TABLE recharge_history (recharge_id BIGINT AUTO_INCREMENT PRIMARY KEY, subscriber_id INT NOT NULL, plan_id INT NOT NULL, amount DECIMAL(10,2) NOT NULL, recharged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(subscriber_id) REFERENCES subscribers(subscriber_id), FOREIGN KEY(plan_id) REFERENCES plans(plan_id));
CREATE TABLE notifications (notification_id BIGINT AUTO_INCREMENT PRIMARY KEY, subscriber_id INT NOT NULL, message VARCHAR(150) NOT NULL, method VARCHAR(20) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(subscriber_id) REFERENCES subscribers(subscriber_id));
INSERT INTO plans VALUES (1,'Basic',100,28),(2,'Standard',200,56),(3,'Premium',300,84);
INSERT INTO subscribers VALUES
(101,'Ananya','9000000101','ananya@example.test','PREPAID',25,CURRENT_DATE+INTERVAL 5 DAY),
(102,'Rahul','9000000102','rahul@example.test','PREPAID',45,CURRENT_DATE+INTERVAL 12 DAY),
(103,'Priya','9000000103','priya@example.test','PREPAID',80,CURRENT_DATE+INTERVAL 20 DAY),
(104,'Arjun','9000000104','arjun@example.test','POSTPAID',10,CURRENT_DATE+INTERVAL 10 DAY),
(105,'Divya','9000000105','divya@example.test','PREPAID',0,CURRENT_DATE-INTERVAL 2 DAY),
(106,'Kavin','9000000106','kavin@example.test','PREPAID',50,CURRENT_DATE+INTERVAL 8 DAY),
(107,'Meera','9000000107','meera@example.test','PREPAID',120,CURRENT_DATE+INTERVAL 30 DAY);
INSERT INTO recharge_history(subscriber_id,plan_id,amount) VALUES (101,1,100),(103,2,200),(107,3,300);
