const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');
const pool = require('../db/pool');

router.post('/', async (req, res) => {
  try {
    // 🛡️ Fix: Support both naming styles
    const clientName = req.body.client_name || req.body.clientName; 
    const contact = req.body.contact;
    const pickupTime = req.body.pickup_time || req.body.pickupTime;
    const dropoffTime = req.body.dropoff_time || req.body.dropoffTime;

    // 🔍 debug
    console.log('Processed Data:', { clientName, contact, pickupTime, dropoffTime });

    const result = await pool.query(
      `
      INSERT INTO bookings (
        client_name,
        contact,
        pickup_time,
        dropoff_time
      )
      VALUES ($1, $2, $3, $4)
      RETURNING *
      `,
      [clientName, contact, pickupTime, dropoffTime]
    );

    res.status(201).json({
      message: 'Booking created',
      booking: result.rows[0],
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

router.get('/', bookingController.getBookings);

module.exports = router;
