const express = require("express");
const router = express.Router();
const { register, login } = require("../controllers/authController");

// /api/register
router.post("/register", register);

// /api/login
router.post("/login", login);

module.exports = router;
