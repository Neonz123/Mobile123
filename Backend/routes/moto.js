const express = require("express");
const db = require("../db/pool");
const router = express.Router();
// const { getMotoById } = require("../controllers/motoController");

router.get("/", async (req, res) => {
  try {
    console.log("Fetching all motos..."); // Look for this in your terminal
    const result = await db.query("SELECT * FROM motos ORDER BY id");
    return res.status(200).json(result.rows);
  } catch (err) {
    console.error("❌ ERROR:", err.message);
    return res.status(500).json({ error: err.message });
  }
});
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query("SELECT * FROM motos WHERE id = $1", [id]);
    if (result.rows.length === 0) return res.status(404).send("Not Found");
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
