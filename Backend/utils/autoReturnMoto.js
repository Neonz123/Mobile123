const pool = require("../db/pool");

const autoReturnMoto = async () => {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    // 🔥 Find expired rentals (safe with timezone)
    const expired = await client.query(`
      SELECT moto_id
      FROM rentals
      WHERE returned = false
      AND end_date <= CURRENT_TIMESTAMP
    `);

    if (expired.rows.length === 0) {
      await client.query("COMMIT");
      return;
    }

    const motoIds = expired.rows.map(r => r.moto_id);

    // 🔁 Return motos
    await client.query(`
      UPDATE motos
      SET status = 'available'
      WHERE id = ANY($1)
    `, [motoIds]);

    // ✔ Mark rentals as returned
    await client.query(`
      UPDATE rentals
      SET returned = true
      WHERE moto_id = ANY($1)
    `, [motoIds]);

    await client.query("COMMIT");
    console.log("AUTO RETURN OK:", motoIds);

  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Auto return error:", err);
  } finally {
    client.release();
  }
};

module.exports = autoReturnMoto;
