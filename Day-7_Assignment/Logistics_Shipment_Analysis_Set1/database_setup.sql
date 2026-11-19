-- Logistics Shipment Analysis | MySQL 8.0+
-- Run this file FIRST. Creates a separate assignment database.
CREATE DATABASE IF NOT EXISTS logistics_analysis;
USE logistics_analysis;
SET FOREIGN_KEY_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE hubs (hub_id INT PRIMARY KEY, hub_name VARCHAR(60) NOT NULL UNIQUE, city VARCHAR(50) NOT NULL);
CREATE TABLE carriers (carrier_id INT PRIMARY KEY, carrier_name VARCHAR(60) NOT NULL UNIQUE);
CREATE TABLE customers (customer_id INT PRIMARY KEY, customer_name VARCHAR(70) NOT NULL, city VARCHAR(50));
CREATE TABLE employees (employee_id INT PRIMARY KEY, employee_name VARCHAR(60) NOT NULL, supervisor_id INT NULL,
 CONSTRAINT fk_supervisor FOREIGN KEY(supervisor_id) REFERENCES employees(employee_id));
CREATE TABLE shipments (
 shipment_id INT PRIMARY KEY, customer_id INT NOT NULL, carrier_id INT NOT NULL,
 origin_hub_id INT NOT NULL, destination_hub_id INT NOT NULL,
 shipped_date DATE NOT NULL, expected_delivery DATE NOT NULL, actual_delivery DATE NULL,
 shipping_cost DECIMAL(10,2) NOT NULL,
 CONSTRAINT chk_cost CHECK(shipping_cost >= 0),
 FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
 FOREIGN KEY(carrier_id) REFERENCES carriers(carrier_id),
 FOREIGN KEY(origin_hub_id) REFERENCES hubs(hub_id),
 FOREIGN KEY(destination_hub_id) REFERENCES hubs(hub_id)
);
CREATE TABLE delivery_events (event_id INT PRIMARY KEY, shipment_id INT NOT NULL,
 event_type VARCHAR(30) NOT NULL, event_date DATE NOT NULL,
 FOREIGN KEY(shipment_id) REFERENCES shipments(shipment_id));

INSERT INTO hubs VALUES (1,'Chennai Central','Chennai'),(2,'Bengaluru Hub','Bengaluru'),
(3,'Hyderabad Hub','Hyderabad'),(4,'Mumbai Hub','Mumbai'),(5,'Kochi Hub','Kochi'),(6,'Jaipur Hub','Jaipur');
INSERT INTO carriers VALUES (1,'Swift Logistics'),(2,'BlueRoute Express'),(3,'Metro Freight'),(4,'NewAge Transport');
INSERT INTO customers VALUES (1,'Apex Retail','Chennai'),(2,'Nova Stores','Bengaluru'),
(3,'GreenMart','Hyderabad'),(4,'Orbit Traders','Mumbai'),(5,'FreshStart','Kochi');
INSERT INTO employees VALUES (1,'Anita',NULL),(2,'Bala',1),(3,'Charu',1),
(4,'Deepak',2),(5,'Esha',2),(6,'Farhan',NULL);
INSERT INTO shipments VALUES
(101,1,1,1,2,'2026-10-01','2026-10-04','2026-10-04',500),
(102,1,1,1,3,'2026-10-02','2026-10-05','2026-10-09',700),
(103,1,2,2,4,'2026-10-03','2026-10-07','2026-10-08',900),
(104,1,2,3,5,'2026-10-04','2026-10-08','2026-10-08',1100),
(105,1,3,4,6,'2026-10-05','2026-10-10','2026-10-12',1300),
(106,1,3,5,1,'2026-10-06','2026-10-10','2026-10-10',1500),
(107,2,1,2,1,'2026-10-07','2026-10-11','2026-10-15',800),
(108,2,2,3,2,'2026-10-08','2026-10-12','2026-10-13',600),
(109,3,1,4,3,'2026-10-09','2026-10-13','2026-10-18',1000),
(110,3,3,1,4,'2026-10-10','2026-10-14','2026-10-14',1200),
(111,4,2,2,5,'2026-10-11','2026-10-15',NULL,400),
(112,4,3,3,1,'2026-10-12','2026-10-16','2026-10-19',950),
(113,2,1,1,3,'2026-10-13','2026-10-17','2026-10-17',650),
(114,3,2,4,2,'2026-10-14','2026-10-18',NULL,750),
(115,4,3,5,4,'2026-10-15','2026-10-20','2026-10-21',1050);
INSERT INTO delivery_events VALUES
(1,101,'PICKED_UP','2026-10-01'),(2,101,'DELIVERED','2026-10-04'),
(3,102,'PICKED_UP','2026-10-02'),(4,102,'DELAY_REPORTED','2026-10-06'),
(5,102,'DELIVERED','2026-10-09'),(6,103,'DELIVERED','2026-10-08'),
(7,107,'DELAY_REPORTED','2026-10-12'),(8,107,'DELIVERED','2026-10-15'),
(9,109,'DELAY_REPORTED','2026-10-14'),(10,111,'IN_TRANSIT','2026-10-13');
CREATE INDEX idx_ship_customer_dest ON shipments(customer_id,destination_hub_id);
CREATE INDEX idx_ship_carrier_delivery ON shipments(carrier_id,expected_delivery,actual_delivery);
CREATE INDEX idx_ship_origin ON shipments(origin_hub_id);
CREATE INDEX idx_ship_destination ON shipments(destination_hub_id);
