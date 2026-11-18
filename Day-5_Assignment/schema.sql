CREATE DATABASE hospital_db;

USE hospital_db;

SELECT DATABASE();

--Patient table
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL
);
--Department table
CREATE TABLE Department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

--Doctor table
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id)
    REFERENCES Department(department_id)
);
--Visit Table
CREATE TABLE Visit (
    visit_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_date DATE NOT NULL,
    diagnosis VARCHAR(255),
    prescription TEXT,
    FOREIGN KEY (patient_id)
    REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id)
    REFERENCES Doctor(doctor_id),
    CHECK (visit_date >= '1900-01-01')
);
--Billing table
CREATE TABLE Billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    visit_id INT NOT NULL UNIQUE,
    bill_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'OPEN',
    FOREIGN KEY (visit_id)
    REFERENCES Visit(visit_id),
    CHECK (bill_amount >= 0),
    CHECK (status IN ('OPEN', 'PAID', 'CANCELLED'))
);
USE hospital_db;

SHOW TABLES;

DELIMITER //

CREATE TRIGGER validate_visit_insert
BEFORE INSERT ON Visit
FOR EACH ROW
BEGIN
    IF NEW.visit_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Visit date cannot be in the future';
    END IF;
END //

CREATE TRIGGER validate_visit_update
BEFORE UPDATE ON Visit
FOR EACH ROW
BEGIN
    IF NEW.visit_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Visit date cannot be in the future';
    END IF;
END //

DELIMITER ;
SHOW TRIGGERS FROM hospital_db;