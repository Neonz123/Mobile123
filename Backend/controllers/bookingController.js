const pool = require('../db/pool');

// bookingController.js
exports.createBooking = async (req, res) => {
  console.log("📥 Incoming Data:", req.body); // This shows in your terminal!
  try {
    const { client_name, contact, pickup_time, dropoff_time } = req.body;
    const result = await pool.query(
      "INSERT INTO bookings (client_name, contact, pickup_time, dropoff_time) VALUES ($1, $2, $3, $4) RETURNING *",
      [client_name, contact, pickup_time, dropoff_time]
    );
    console.log("✅ Saved to DB:", result.rows[0]);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error("❌ Error:", err.message);
    res.status(500).send("Server Error");
  }
};

exports.getBookings = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM bookings ORDER BY id DESC");
    res.json(result.rows);
  } catch (err) {
    res.status(500).send("Server Error");
  }
};