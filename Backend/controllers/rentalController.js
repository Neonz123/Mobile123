const pool = require("../db/pool");

const rentMoto = async (req, res) => {
  // Use let or const for the incoming fields
  const { moto_id, start_date, end_date, booking_id } = req.body;
  const user_id = 1; // temporary hardcoded user

  if (!moto_id || !start_date || !end_date || !booking_id) {
    return res.status(400).json({ message: "Missing fields" });
  }

  // 🛡️ FIX: Ensure IDs are numbers, not large strings/timestamps
  const clean_moto_id = parseInt(moto_id);
  const clean_booking_id = parseInt(booking_id);

  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    // 🔒 1. BLOCK DOUBLE RENT
    const checkRental = await client.query(
      "SELECT id FROM rentals WHERE booking_id = $1",
      [clean_booking_id]
    );

    if (checkRental.rows.length > 0) {
      await client.query("ROLLBACK");
      return res.status(400).json({ message: "This booking already has a rented moto" });
    }

    // 📅 2. CALCULATE DAYS
    const start = new Date(start_date);
    const end = new Date(end_date);
    const diffMs = end - start;
    const days = Math.ceil(diffMs / (1000 * 60 * 60 * 24));

    if (isNaN(days) || days <= 0) {
      await client.query("ROLLBACK");
      return res.status(400).json({ message: "Invalid rental period" });
    }

    // 🏍️ 3. CHECK MOTO AVAILABILITY
    const motoRes = await client.query(
      `SELECT price_per_day 
       FROM motos 
       WHERE id = $1 AND status = 'available'
       FOR UPDATE`,
      [clean_moto_id]
    );

    if (motoRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(400).json({ message: "Moto not available or already rented" });
    }

    const total_price = motoRes.rows[0].price_per_day * days;

    // 🧾 4. INSERT RENTAL
    const rentalRes = await client.query(
      `INSERT INTO rentals (
        booking_id, user_id, moto_id, days, total_price, start_date, end_date, returned
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, false)
      RETURNING *`,
      [clean_booking_id, user_id, clean_moto_id, days, total_price, start, end]
    );

    // 🔄 5. UPDATE MOTO STATUS
    await client.query(
      "UPDATE motos SET status = 'rented' WHERE id = $1",
      [clean_moto_id]
    );

    // 🔄 6. UPDATE BOOKING STATUS
    const updatedBooking = await client.query(
      "UPDATE bookings SET status = 'rented' WHERE id = $1 RETURNING *",
      [clean_booking_id]
    );

    await client.query("COMMIT");

    return res.status(201).json({
      message: "Rental successful",
      rental: rentalRes.rows[0],
      booking: updatedBooking.rows[0],
    });

  } catch (err) {
    await client.query("ROLLBACK");
    console.error("❌ Rent process error:", err);
    return res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
};

const myRentals = async (req, res) => {
  try {
    const user_id = 1; 

    // 🛡️ FIX: Removed semicolon after WHERE and fixed JOIN to show Booking names
    const result = await pool.query(
      `
      SELECT 
        r.*, 
        m.name AS moto_name, 
        m.image AS moto_image,
        COALESCE(b.client_name, u.fullname) AS client_name, 
        COALESCE(b.contact, u.phone) AS contact
      FROM rentals r
      JOIN motos m ON r.moto_id = m.id
      JOIN users u ON r.user_id = u.id
      LEFT JOIN bookings b ON r.booking_id = b.id
      WHERE r.user_id = $1 AND r.returned = false
      ORDER BY r.created_at DESC
      `,
      [user_id]
    );

    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { rentMoto, myRentals };