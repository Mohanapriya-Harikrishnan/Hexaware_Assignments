
USE hospital_db;

-- Test 1: Negative bill amount
UPDATE Billing
SET bill_amount = -500
WHERE bill_id = 1;


-- Test 2: Future visit date
UPDATE Visit
SET visit_date = '2099-01-01'
WHERE visit_id = 1;


-- Test 3: Invalid foreign key
INSERT INTO Doctor (doctor_name, department_id)
VALUES ('Dr. Test', 999);


-- Test 4: Duplicate department
INSERT INTO Department (department_name)
VALUES ('Cardiology');


-- Test 5: NOT NULL constraint
INSERT INTO Patient (patient_name, address)
VALUES (NULL, 'Chennai');


-- Test 6: Default status
SELECT * FROM Billing
WHERE status = 'OPEN';


-- Test 7: Invalid billing status
UPDATE Billing
SET status = 'INVALID'
WHERE bill_id = 1;


-- Test 8: Invalid historical visit date
UPDATE Visit
SET visit_date = '1800-01-01'
WHERE visit_id = 1;


-- Test 9: Duplicate primary key
INSERT INTO Patient (patient_id, patient_name, address)
VALUES (1, 'Test Patient', 'Chennai');


-- Test 10: Referential integrity
DELETE FROM Patient
WHERE patient_id = 1;
