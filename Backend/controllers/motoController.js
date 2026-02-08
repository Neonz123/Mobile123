const pool = require("../db/pool");
const autoReturnMoto = require("../utils/autoReturnMoto");

const getMotos = async (req, res) => {
  try {
    await autoReturnMoto();
    
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

// controllers/motoController.js
const getMotoById = async (req, res) => {
  const { id } = req.params;

  // 🛡️ Check if the ID is a valid number before hitting the database
  if (isNaN(id) || parseInt(id) <= 0) {
    return res.status(400).json({ message: "Invalid Moto ID format" });
  }

  try {
    const result = await pool.query("SELECT * FROM motos WHERE id = $1", [parseInt(id)]);
    // ... rest of your logic
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Server Error" });
  }
};

module.exports = { getMotos, getMotoById };
