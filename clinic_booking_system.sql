-- Create a database for a clinic 
CREATE DATABASE CLINIC_db 

-- Drop tables if they exist
DROP TABLE IF EXISTS prescriptions, appointments, doctor_specializations, specializations, rooms, patients, doctors;

-- Patients Table
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctors Table
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL
);

-- Specializations Table
CREATE TABLE specializations (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Doctor-Specializations (M-M relationship)
CREATE TABLE doctor_specializations (
    doctor_id INT,
    specialization_id INT,
    PRIMARY KEY (doctor_id, specialization_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (specialization_id) REFERENCES specializations(specialization_id) ON DELETE CASCADE
);

-- Rooms Table
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    type ENUM('Consultation', 'Surgery', 'Examination') NOT NULL
);

-- Appointments Table
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    room_id INT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Prescriptions Table (1-to-1 with appointments)
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT UNIQUE NOT NULL,
    medication TEXT NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    instructions TEXT,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE
);


-- Insert sample patients
INSERT INTO patients (first_name, last_name, date_of_birth, gender, phone, email)
VALUES 
('Ruth', 'Mutua', '1985-04-12', 'Female', '0742345678', 'mutuaruth@gmail.com'),
('Zablon', 'Ogiri', '1990-07-22', 'Male', '0723456789', 'zablonogiri@gmail.com');

-- Insert sample doctors
INSERT INTO doctors (first_name, last_name, phone, email, hire_date)
VALUES 
('Emily', 'Clark', '0734567890', 'emily.clark@gmail.com', '2020-01-15'),
('Michael', 'Brown', '0745678901', 'michael.brown@gmail.com', '2018-03-10');

-- Insert sample specializations
INSERT INTO specializations (name)
VALUES 
('Cardiology'),
('Pediatrics'),
('Dermatology');

-- Map doctors to specializations
INSERT INTO doctor_specializations (doctor_id, specialization_id)
VALUES 
(1, 1), -- Emily -> Cardiology
(1, 3), -- Emily -> Dermatology
(2, 2); -- Michael -> Pediatrics

-- Insert sample rooms
INSERT INTO rooms (room_number, type)
VALUES 
('101A', 'Consultation'),
('202B', 'Surgery');

-- Insert sample appointments
INSERT INTO appointments (patient_id, doctor_id, room_id, appointment_date, appointment_time, status)
VALUES 
(1, 1, 1, '2025-05-15', '10:00:00', 'Scheduled'),
(2, 2, 2, '2025-05-16', '11:30:00', 'Scheduled');

-- Insert sample prescriptions
INSERT INTO prescriptions (appointment_id, medication, dosage, instructions)
VALUES 
(1, 'Aspirin', '100mg', 'Take one tablet daily after meals'),
(2, 'Amoxicillin', '500mg', 'Take one capsule three times a day for 7 days');

-- =====================================
-- Example Queries
-- =====================================

-- 1. List all upcoming appointments for a specific doctor
SELECT 
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.appointment_date,
    a.appointment_time,
    r.room_number
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN rooms r ON a.room_id = r.room_id
WHERE a.doctor_id = 1 AND a.appointment_date >= CURDATE()
ORDER BY a.appointment_date, a.appointment_time;

-- 2. View a doctor's specializations
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    s.name AS specialization
FROM doctors d
JOIN doctor_specializations ds ON d.doctor_id = ds.doctor_id
JOIN specializations s ON ds.specialization_id = s.specialization_id
WHERE d.doctor_id = 1;

-- 3. Get prescriptions given to a patient
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.appointment_date,
    pr.medication,
    pr.dosage,
    pr.instructions
FROM prescriptions pr
JOIN appointments a ON pr.appointment_id = a.appointment_id
JOIN patients p ON a.patient_id = p.patient_id
WHERE p.patient_id = 1;

-- 4. Show all appointments with doctor and patient names
SELECT 
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
ORDER BY a.appointment_date;
