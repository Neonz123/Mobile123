const express = require("express");
const router = express.Router();
const authenticateToken = require("../middleware/auth");
const { rentMoto, myRentals } = require("../controllers/rentalController");
const db = require("../db/pool");

// POST /api/rent -> rent a motorcycle
router.post("/rentals",  rentMoto);

router.get('/my-rentals', async (req, res) => {
  try {
    // We update the query to pull names from the 'bookings' table (b)
    // instead of the 'rentals' table (r)
    const result = await db.query(`
      SELECT 
        r.id, 
        r.start_date, 
        r.end_date, 
        r.total_price, 
        b.client_name,      -- 👈 Changed from r.client_name to b.client_name
        b.contact,          -- 👈 Changed from r.contact to b.contact
        m.name AS moto_name, 
        m.image AS moto_image
      FROM rentals r
      JOIN bookings b ON r.booking_id = b.id  -- 👈 Added this JOIN to link the tables
      JOIN motos m ON r.moto_id = m.id
      WHERE r.returned = false
      ORDER BY r.created_at DESC;
    `);
    res.json(result.rows);
  } catch (err) {
    console.error("❌ Fetch Error:", err.message);
    res.status(500).json({ error: err.message });
  }
});

// Inside your existing rentals router file (e.g., routes/rentals.js)

// ✅ 1. Get Rental History
router.get('/history', async (req, res) => {
  try {
    const result = await db.query( // 👈 Fixed: changed pool to db
      `SELECT r.*, 
              COALESCE(b.client_name, 'Unknown') as client_name, 
              COALESCE(b.contact, 'N/A') as contact, 
              m.name as moto_name, 
              m.image as moto_image -- 👈 Fixed: matched your /my-rentals column name
              FROM rentals r
              LEFT JOIN bookings b ON r.booking_id = b.id    
              JOIN motos m ON r.moto_id = m.id -- 👈 Fixed: changed m_moto to motos
              WHERE r.returned = true
              ORDER BY r.end_date DESC`
    );
    res.json(result.rows);
  } catch (err) {
    console.error("❌ History Error:", err.message);
    res.status(500).json({ error: err.message });
  }
});
module.exports = router;
