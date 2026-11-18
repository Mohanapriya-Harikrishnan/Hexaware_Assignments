--CRUD operations
USE hospital_db;
--CREATE (Insert)
INSERT INTO Patient (patient_name, address)
VALUES ('Kavya', 'Trichy');

SELECT * FROM Patient;
--READ (Retrieve)
SELECT * FROM Patient;
--UPDATE (Modify)
UPDATE Patient
SET address = 'Chennai'
WHERE patient_id = 6;

SELECT * FROM Patient;
UPDATE Billing
SET status = 'PAID'
WHERE bill_id = 1;

SELECT * FROM Billing;
--DELETE (Remove)
DELETE FROM Patient
WHERE patient_id = 6;

SELECT * FROM Patient;

--Data retrieval using JOIN

--Retrieve patients visited in November 2026
SELECT DISTINCT p.patient_id, p.patient_name
FROM Patient p
JOIN Visit v
ON p.patient_id = v.patient_id
WHERE MONTH(v.visit_date) = 11
AND YEAR(v.visit_date) = 2026;
--Retrieve doctors by department
SELECT d.doctor_id, d.doctor_name,
       dp.department_name
FROM Doctor d
JOIN Department dp
ON d.department_id = dp.department_id
WHERE dp.department_name = 'Cardiology';
--Retrieve complete hospital patient records
SELECT
    p.patient_name,
    p.address,
    d.doctor_name,
    dp.department_name,
    v.visit_date,
    v.diagnosis,
    v.prescription,
    b.bill_amount,
    b.status
FROM Patient p
JOIN Visit v ON p.patient_id = v.patient_id
JOIN Doctor d ON v.doctor_id = d.doctor_id
JOIN Department dp ON d.department_id = dp.department_id
LEFT JOIN Billing b ON v.visit_id = b.visit_id;
--Calculate total hospital billing
SELECT SUM(bill_amount) AS total_billing
FROM Billing;
--Count patients visited in each department
SELECT dp.department_name,
       COUNT(DISTINCT v.patient_id) AS total_patients
FROM Department dp
JOIN Doctor d
ON dp.department_id = d.department_id
JOIN Visit v
ON d.doctor_id = v.doctor_id
GROUP BY dp.department_name;