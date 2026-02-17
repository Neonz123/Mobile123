const express = require("express");
const router = express.Router();
const authenticateToken = require("../middleware/auth");
const { rentMoto, myRentals } = require("../controllers/rentalController");
const db = require("../db/pool");

// POST /api/rent -> rent a motorcycle (protected)
router.post("/rentals", authenticateToken, rentMoto);

// GET /api/my-rentals -> get current user's active rentals (protected)
router.get('/my-rentals', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id; // Extract user ID from JWT token

    const result = await db.query(`
      SELECT 
        r.id, 
        r.start_date, 
        r.end_date, 
        r.total_price, 
        b.client_name,
        b.contact,
        m.name AS moto_name, 
        m.image AS image
      FROM rentals r
      JOIN bookings b ON r.booking_id = b.id
      JOIN motos m ON r.moto_id = m.id
      WHERE r.returned = false AND r.user_id = $1
      ORDER BY r.created_at DESC
    `, [userId]);

    res.json(result.rows);
  } catch (err) {
    console.error("❌ Fetch Error:", err.message);
    res.status(500).json({ error: err.message });
  }
});

// GET /api/history -> get current user's rental history (protected)
router.get('/history', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id; // Extract user ID from JWT token

    const result = await db.query(
      `SELECT r.*, 
              COALESCE(b.client_name, 'Unknown') as client_name, 
              COALESCE(b.contact, 'N/A') as contact, 
              m.name as moto_name, 
              m.image as moto_image
      FROM rentals r
      LEFT JOIN bookings b ON r.booking_id = b.id    
      JOIN motos m ON r.moto_id = m.id
      WHERE r.returned = true AND r.user_id = $1
      ORDER BY r.end_date DESC`,
      [userId]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("❌ History Error:", err.message);
    res.status(500).json({ error: err.message });
  }
});
module.exports = router;
