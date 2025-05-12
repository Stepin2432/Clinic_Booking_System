# Clinic_Booking_System
# Clinic Booking System (MySQL)

## 📄 Description

This project is a full-featured **Clinic Booking System** implemented using only MySQL. It manages patients, doctors, specializations, appointments, rooms, and prescriptions. The database includes real-world constraints and relationships (1-1, 1-M, M-M), sample data, and useful example queries.

---

## 🚀 Setup Instructions

1. Open **MySQL Workbench**.
2. Create a new schema/database, e.g. `clinic_db`.
3. Import the provided `clinic_booking_system.sql` file:
   - In Workbench: `File > Open SQL Script` → Run the file.
   
The script will:
- Create tables with appropriate constraints.
- Insert sample data (patients, doctors, specializations, etc.).
- Add example SQL queries for testing and reporting.

---

## 📊 ERD (Entity-Relationship Diagram)

**Main Entities & Relationships:**

- **Patients** (1) — (M) **Appointments**
- **Doctors** (1) — (M) **Appointments**
- **Doctors** (M) — (M) **Specializations** (via doctor_specializations)
- **Appointments** (1) — (1) **Prescriptions**
- **Appointments** (M) — (1) **Rooms**

**Tables:**
- `patients`
- `doctors`
- `specializations`
- `doctor_specializations`
- `appointments`
- `prescriptions`
- `rooms`

> You can visualize this using tools like dbdiagram.io or MySQL Workbench's EER Diagram tool.

---
![alt text](<Clinic Booking System ERD.png>)

## ✅ Author
Stephen Machaki
