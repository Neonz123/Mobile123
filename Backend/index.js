const express = require("express");
const cors = require("cors");
require('dotenv').config();

const authRoutes = require("./routes/auth");
const motoRoutes = require("./routes/moto");
const rentalRoutes = require("./routes/rental");  
const autoReturnMoto = require("./utils/autoReturnMoto");
const bookingRoutes = require("./routes/book");

setInterval(() => {
  autoReturnMoto();
}, 60 * 1000); 

const app = express();
app.use(cors());
app.use(express.json());

// Test route
app.get("/", (req, res) => res.send("Moto Rental API is running!"));

// Routes
app.use("/api", authRoutes);

app.use("/api", rentalRoutes);
app.use("/api/motos", motoRoutes);


app.use("/api/bookings", bookingRoutes);

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
