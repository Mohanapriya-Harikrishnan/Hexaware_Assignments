-- ADVANCED REPORTS | Logistics Shipment Analysis | MySQL 8.0+
create database logistics_analysis;
USE logistics_analysis;

-- ==========================================================
-- TASK 1: TEN BUSINESS QUESTIONS USING JOINS
-- ==========================================================

-- Q1 INNER JOIN: delivered shipments delayed MORE THAN 2 days, with carrier names.
SELECT s.shipment_id, c.carrier_name, s.expected_delivery, s.actual_delivery,
       DATEDIFF(s.actual_delivery,s.expected_delivery) AS delay_days
FROM shipments s INNER JOIN carriers c ON s.carrier_id=c.carrier_id
WHERE s.actual_delivery IS NOT NULL
  AND DATEDIFF(s.actual_delivery,s.expected_delivery)>2
ORDER BY delay_days DESC, s.shipment_id;

-- Q2 LEFT JOIN: hubs without ANY outbound shipments.
SELECT h.hub_id,h.hub_name
FROM hubs h LEFT JOIN shipments s ON h.hub_id=s.origin_hub_id
WHERE s.shipment_id IS NULL;

-- Q3 SELF LEFT JOIN: every employee and their supervisor (including top-level employees).
SELECT e.employee_id,e.employee_name,COALESCE(m.employee_name,'No supervisor') AS supervisor
FROM employees e LEFT JOIN employees m ON e.supervisor_id=m.employee_id
ORDER BY e.employee_id;

-- Q4 INNER JOIN: shipment details, customer and destination hub.
SELECT s.shipment_id,c.customer_name,h.hub_name AS destination_hub,s.shipping_cost
FROM shipments s INNER JOIN customers c ON c.customer_id=s.customer_id
INNER JOIN hubs h ON h.hub_id=s.destination_hub_id
ORDER BY s.shipment_id;

-- Q5 LEFT JOIN: every customer, including those with no shipments.
SELECT c.customer_id,c.customer_name,COUNT(s.shipment_id) AS shipment_count
FROM customers c LEFT JOIN shipments s ON s.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name ORDER BY c.customer_id;

-- Q6 RIGHT JOIN: all carriers, including unused carriers.
SELECT c.carrier_id,c.carrier_name,COUNT(s.shipment_id) AS shipment_count
FROM shipments s RIGHT JOIN carriers c ON s.carrier_id=c.carrier_id
GROUP BY c.carrier_id,c.carrier_name ORDER BY c.carrier_id;

-- Q7 INNER JOIN: delivered shipments and their DELIVERED tracking events.
SELECT s.shipment_id,c.customer_name,de.event_date
FROM delivery_events de INNER JOIN shipments s ON de.shipment_id=s.shipment_id
INNER JOIN customers c ON s.customer_id=c.customer_id
WHERE de.event_type='DELIVERED' ORDER BY de.event_date,s.shipment_id;

-- Q8 LEFT JOIN: all shipments, including those without any tracking events.
SELECT s.shipment_id,COUNT(de.event_id) AS tracking_event_count
FROM shipments s LEFT JOIN delivery_events de ON s.shipment_id=de.shipment_id
GROUP BY s.shipment_id ORDER BY s.shipment_id;

-- Q9 INNER JOIN: carrier-wise total shipping revenue (only active carriers).
SELECT c.carrier_name,COUNT(*) AS shipment_count,SUM(s.shipping_cost) AS total_revenue
FROM carriers c INNER JOIN shipments s ON c.carrier_id=s.carrier_id
GROUP BY c.carrier_id,c.carrier_name ORDER BY total_revenue DESC;

-- Q10 SELF JOIN: unique employee pairs reporting to the same supervisor.
SELECT a.employee_name AS employee_1,b.employee_name AS employee_2,
       m.employee_name AS shared_supervisor
FROM employees a INNER JOIN employees b
 ON a.supervisor_id=b.supervisor_id AND a.employee_id<b.employee_id
INNER JOIN employees m ON m.employee_id=a.supervisor_id
ORDER BY shared_supervisor,employee_1;

-- ==========================================================
-- TASK 2: IN, EXISTS, ANY, ALL
-- ==========================================================

-- Q1 IN: customers who have shipped to at least one hub in Mumbai or Kochi.
SELECT customer_id,customer_name FROM customers
WHERE customer_id IN (
 SELECT s.customer_id FROM shipments s
 WHERE s.destination_hub_id IN (SELECT hub_id FROM hubs WHERE city IN ('Mumbai','Kochi'))
) ORDER BY customer_id;

-- Q2 EXISTS with double NOT EXISTS (relational division):
-- customers who have shipped to EVERY hub (destination). Includes all 6 hubs.
SELECT c.customer_id,c.customer_name FROM customers c
WHERE NOT EXISTS (
 SELECT 1 FROM hubs h
 WHERE NOT EXISTS (
  SELECT 1 FROM shipments s
  WHERE s.customer_id=c.customer_id AND s.destination_hub_id=h.hub_id
 )
) ORDER BY c.customer_id;

-- Q3 ANY: shipments whose cost exceeds at least one shipment cost from carrier 2.
SELECT s.shipment_id,s.shipping_cost FROM shipments s
WHERE s.shipping_cost > ANY (
 SELECT shipping_cost FROM shipments WHERE carrier_id=2
) ORDER BY s.shipment_id;

-- Q4 ALL: shipments costing more than EVERY shipment handled by carrier 2.
SELECT s.shipment_id,s.shipping_cost FROM shipments s
WHERE s.shipping_cost > ALL (
 SELECT shipping_cost FROM shipments WHERE carrier_id=2
) ORDER BY s.shipment_id;

-- Q5 Correlated aggregate: carriers whose AVG completed-shipment delay exceeds
-- the overall AVG completed-shipment delay (days). Early arrivals count negative.
SELECT c.carrier_id,c.carrier_name,
 ROUND(AVG(DATEDIFF(s.actual_delivery,s.expected_delivery)),2) AS avg_delay_days
FROM carriers c INNER JOIN shipments s ON s.carrier_id=c.carrier_id
WHERE s.actual_delivery IS NOT NULL
GROUP BY c.carrier_id,c.carrier_name
HAVING AVG(DATEDIFF(s.actual_delivery,s.expected_delivery)) > (
 SELECT AVG(DATEDIFF(actual_delivery,expected_delivery))
 FROM shipments WHERE actual_delivery IS NOT NULL
) ORDER BY avg_delay_days DESC;

-- ==========================================================
-- TASK 3: REWRITE TWO SUBQUERIES AS JOINS
-- ==========================================================

-- Rewrite A (subquery): customers with >= 1 shipment.
SELECT c.customer_id,c.customer_name FROM customers c
WHERE c.customer_id IN (SELECT s.customer_id FROM shipments s)
ORDER BY c.customer_id;

-- Rewrite A (join): DISTINCT prevents duplicate customers from multiple shipments.
SELECT DISTINCT c.customer_id,c.customer_name
FROM customers c INNER JOIN shipments s ON s.customer_id=c.customer_id
ORDER BY c.customer_id;

-- Rewrite B (subquery): hubs with NO outbound shipments.
SELECT h.hub_id,h.hub_name FROM hubs h
WHERE NOT EXISTS (SELECT 1 FROM shipments s WHERE s.origin_hub_id=h.hub_id)
ORDER BY h.hub_id;

-- Rewrite B (join): anti-join via LEFT JOIN + IS NULL.
SELECT h.hub_id,h.hub_name FROM hubs h
LEFT JOIN shipments s ON s.origin_hub_id=h.hub_id
WHERE s.shipment_id IS NULL ORDER BY h.hub_id;

-- Compare plans on YOUR MySQL server; EXPLAIN is not a runtime benchmark.
EXPLAIN SELECT c.customer_id,c.customer_name FROM customers c
WHERE c.customer_id IN (SELECT s.customer_id FROM shipments s);
EXPLAIN SELECT DISTINCT c.customer_id,c.customer_name FROM customers c
INNER JOIN shipments s ON s.customer_id=c.customer_id;
EXPLAIN SELECT h.hub_id,h.hub_name FROM hubs h
WHERE NOT EXISTS (SELECT 1 FROM shipments s WHERE s.origin_hub_id=h.hub_id);
EXPLAIN SELECT h.hub_id,h.hub_name FROM hubs h
LEFT JOIN shipments s ON s.origin_hub_id=h.hub_id WHERE s.shipment_id IS NULL;

-- ==========================================================
-- TASK 4: NESTED SUBQUERY - SECOND-HIGHEST DISTINCT COST PER ORIGIN HUB
-- ==========================================================
-- Correlated nested subquery: MAX cost strictly below the hub's MAX cost.
-- Returns NULL if a hub has fewer than two distinct shipment costs.
SELECT h.hub_id,h.hub_name,
 (SELECT MAX(s1.shipping_cost)
  FROM shipments s1
  WHERE s1.origin_hub_id=h.hub_id
    AND s1.shipping_cost < (
     SELECT MAX(s2.shipping_cost)
     FROM shipments s2 WHERE s2.origin_hub_id=h.hub_id
    )
 ) AS second_highest_shipping_cost
FROM hubs h ORDER BY h.hub_id;


