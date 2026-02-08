const pool = require("../db/pool");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

require('dotenv').config();

const register = async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password)
    return res.status(400).json({ message: "Missing fields" });

  try {
    const userExist = await pool.query("SELECT * FROM users WHERE email=$1", [email]);
    if (userExist.rows.length > 0)
      return res.status(400).json({ message: "User already exists" });

    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await pool.query(
      "INSERT INTO users (name,email,password) VALUES ($1,$2,$3) RETURNING id,name,email",
      [name, email, hashedPassword]
    );

    res.json({ message: "Register successful", user: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

const login = async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.status(400).json({ message: "Missing fields" });

  try {
    const userRes = await pool.query("SELECT * FROM users WHERE email=$1", [email]);
    if (userRes.rows.length === 0)
      return res.status(400).json({ message: "Invalid credentials" });

    const user = userRes.rows[0];
    const valid = await bcrypt.compare(password, user.password);
    if (!valid) return res.status(400).json({ message: "Invalid credentials" });

    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: "1d" });
    res.json({ token, user: { id: user.id, name: user.name, email: user.email } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { register, login };
