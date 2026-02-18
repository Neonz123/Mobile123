const pool = require("../db/pool");

const autoReturnMoto = async () => {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    // Find expired rentals
    const expired = await client.query(`
      SELECT moto_id 
      FROM rentals 
      WHERE returned = false 
      AND end_date <= CURRENT_TIMESTAMP
    `);

    // If nothing is found, just COMMIT and STOP here.
    if (expired.rows.length === 0) {
      await client.query("COMMIT");
      return; // ⛔ This stops the function. Nothing will be logged.
    }

    const motoIds = expired.rows.map(r => r.moto_id);

    // Update Moto status
    await client.query(`
      UPDATE motos 
      SET status = 'available' 
      WHERE id = ANY($1)
    `, [motoIds]);

    // Mark rentals as returned
    await client.query(`
      UPDATE rentals 
      SET returned = true 
      WHERE moto_id = ANY($1)
    `, [motoIds]);

    await client.query("COMMIT");

    // ✅ This will now ONLY run if bikes were actually returned
    console.log("AUTO RETURN SUCCESS:", motoIds);

  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Auto return error:", err);
  } finally {
    client.release();
  }
};

module.exports = autoReturnMoto;