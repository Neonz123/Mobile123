# 🏍️ Moto Rental Mobile Application

A Full-Stack Moto Rental System developed using Flutter for the mobile application and Node.js with Express for the backend API. The system connects to a PostgreSQL or MySQL database using a provided schema and data dump file.

---

## 📌 Project Overview

This application allows users to:

- View available motos
- Rent motos
- Return motos
- Authenticate (Login / Register if implemented)
- Manage rental records

The backend provides RESTful APIs consumed by the Flutter mobile application.

---

## 🛠️ Technology Stack

### Frontend
- Flutter
- Dart
- HTTP package

### Backend
- Node.js (v20.12.2)
- Express.js
- dotenv
- pg (PostgreSQL) or mysql2 (MySQL)

### Database
- PostgreSQL or MySQL
- Manual schema + data import (No migrations used)

---

## 📂 Project Structure

ASSIGNMENT_MOBILE/
│
├── Backend/
│ ├── controllers/
│ ├── routes/
│ ├── middleware/
│ ├── db/
│ ├── utils/
│ ├── index.js
│ ├── package.json
│ └── .env
│
├── lib/ # Flutter source code
├── assets/
├── android/
├── ios/
└── pubspec.yaml


---

# 🚀 How To Run The Project Locally

---

## 1️⃣ Prerequisites

Make sure you have installed:

- Node.js v20+
- PostgreSQL or MySQL
- Flutter SDK
- Git

Check Node version:

node -v


---

## 2️⃣ Clone The Repository

git clone <your-repository-url>
cd assignment_mobile


---

# 🗄️ Database Setup

⚠️ This project does NOT use migrations.

You must import the provided SQL schema + data file manually.

---

## 🐘 PostgreSQL Setup

### Step 1: Create Database

Open pgAdmin or terminal:

CREATE DATABASE moto_rental;


### Step 2: Import Schema + Data

Using terminal:

psql -U postgres -d moto_rental -f database_dump.sql


Or use pgAdmin Query Tool to execute the provided SQL file.

---

## 🐬 MySQL Setup (Alternative)

### Step 1: Create Database

CREATE DATABASE moto_rental;


### Step 2: Import SQL File

mysql -u root -p moto_rental < database_dump.sql


---

# 🔧 Backend Setup

Go to Backend folder:

cd Backend


Install dependencies:

npm install


---

## Create Environment File

Inside `Backend/`, create a file named:

.env


---

### Example `.env` for PostgreSQL

PORT=5000
DB_TYPE=postgres
DB_HOST=localhost
DB_PORT=5432
DB_USER=your_username
DB_PASSWORD=your_password
DB_NAME=moto_rental
JWT_SECRET=your_secret_key


---

### Example `.env` for MySQL

PORT=5000
DB_TYPE=mysql
DB_HOST=localhost
DB_PORT=3306
DB_USER=your_username
DB_PASSWORD=your_password
DB_NAME=moto_rental
JWT_SECRET=your_secret_key


---

## ▶️ Run Backend Server

npm start


or

node index.js


If successful, you should see:

Server running on http://localhost:5000


---

# 📱 Frontend Setup (Flutter)

Go back to project root:

cd ..


Install dependencies:

flutter pub get


---

## Update API Base URL

Make sure your Flutter app connects to the correct backend URL:

### Android Emulator
http://10.0.2.2:5000


### iOS Simulator
http://localhost:5000


### Physical Device
http://YOUR_LOCAL_IP:5000


---

## ▶️ Run Flutter App

flutter run


---

# 📡 API Endpoints (Example)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/motos | Get all motos |
| GET | /api/motos/:id | Get moto by ID |
| POST | /api/rentals | Create rental |
| POST | /api/auth/login | Login |
| POST | /api/auth/register | Register |

---

# 🛠 Common Issues

### Backend not connecting to database
- Check `.env` file
- Ensure database service is running
- Verify username and password

### Flutter cannot connect to backend
- Use correct IP address
- Ensure backend server is running
- Disable firewall if necessary

---

# 👨‍💻 Author

Developed as part of a Mobile Application Assignment Project.

---

# 📄 License

This project is for educational purposes only.