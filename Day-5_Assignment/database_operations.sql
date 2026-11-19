--user-defined database
CREATE DATABASE hospital_demo;

USE hospital_demo;

SHOW DATABASES;
--a temporary table
CREATE TABLE Patient_Record (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100)
);

INSERT INTO Patient_Record
VALUES (1, 'Rahul');

SHOW TABLES;
--Rename the table
RENAME TABLE Patient_Record TO Patient;

SHOW TABLES;

SELECT * FROM Patient;
--Drop the database
DROP DATABASE hospital_demo;

SHOW DATABASES;
--Recreate the database
CREATE DATABASE hospital_demo;

USE hospital_demo;

SHOW TABLES;