# 🏎️ Karting Academy Management Platform

This project is a full-stack web application designed to manage the operations of a karting academy. It integrates a PHP frontend with an Oracle SQL database and is served via Apache. The system covers essential aspects like pilot registration, kart allocation, garage logistics, equipment tracking, and instructor coordination.

## 🔧 Features

- **Pilot management**: Create, read, update, and delete pilot records, including contact info, competition number, and contract duration.
- **Instructor coordination**: Assign instructors to pilots, track contract periods, and validate training sessions via triggers.
- **Kart allocation**: Assign karts based on condition and type (electric vs combustion), with validation rules handled by Oracle triggers.
- **Garage logistics**: Karts are stored in specialized garages (charging, fuel, or service) depending on their model and condition.
- **License and equipment tracking**: Each pilot can hold multiple licenses and equipment items, all with expiration and type validation.
- **Multisite support**: Manages different academy locations (HQ, training centers, circuits, etc.) through a well-structured `SEDIU` table.
- **Data integrity enforced by database triggers**: Ensures logical business rules like valid assignments, contract duration compliance, and kart-garage compatibility.

## 🛠️ Tech Stack

- **PHP** – backend logic and CRUD operations interface  
- **Oracle SQL** – relational database for all academy entities  
- **Apache HTTP Server** – hosts the web application

## 🗂️ Database Highlights

- 12 relational tables with strong referential integrity  
- Complex constraints (e.g., check conditions, unique keys, foreign keys with `ON DELETE CASCADE`)  
- Custom business logic enforced with PL/SQL triggers for:  
  - Garage and kart compatibility  
  - Kart availability for pilots  
  - Valid pilot-instructor assignment periods

## 📋 Notes

- The frontend implements full **CRUD** operations for all major entities (Pilots, Instructors, Karts, Licenses, Equipment).  
- The system is structured and scalable for real-world implementation in sports training environments.
