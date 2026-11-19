USE hospital_db;

INSERT INTO Patient (patient_name, address)
VALUES
('Rahul', 'Chennai'),
('Anitha', 'Madurai'),
('Kumar', 'Chennai'),
('Divya', 'Coimbatore'),
('Arun', 'Salem');
INSERT INTO Department (department_name)
VALUES
('Cardiology'),
('General Medicine'),
('Neurology'),
('Orthopaedics');
INSERT INTO Doctor (doctor_name, department_id)
VALUES
('Dr. Ravi', 1),
('Dr. Priya', 2),
('Dr. Suresh', 3),
('Dr. Meena', 1),
('Dr. Karthik', 4);
INSERT INTO Visit
(patient_id, doctor_id, visit_date, diagnosis, prescription)
VALUES
(1, 1, '2026-11-01', 'Chest Pain', 'Further examination'),
(2, 2, '2026-11-03', 'Fever', 'Prescribed medication'),
(3, 3, '2026-11-05', 'Migraine', 'Prescribed medication'),
(4, 4, '2026-10-10', 'High BP', 'Regular monitoring'),
(1, 2, '2026-11-10', 'Cold', 'Prescribed medication'),
(5, 2, '2026-11-12', 'Fever', 'Prescribed medication'),
(3, 5, '2026-11-15', 'Joint Pain', 'Physiotherapy');
INSERT INTO Billing (visit_id, bill_amount)
VALUES
(1, 1500),
(2, 500),
(3, 2000),
(4, 1200),
(5, 400),
(6, 600),
(7, 1800);
SELECT * FROM Patient;
SELECT * FROM Department;
SELECT * FROM Doctor;
SELECT * FROM Visit;
SELECT * FROM Billing;