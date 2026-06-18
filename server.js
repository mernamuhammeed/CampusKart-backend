const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// MongoDB
mongoose.connect('mongodb+srv://GolfCarAdmin:pass1234@golfcar.i9jx33e.mongodb.net/golfcarDB')
  .then(() => console.log('✅ MongoDB Connected'))
  .catch(err => console.log('❌ DB Error:', err));

// Basic route for the root URL
app.get('/', (req, res) => {
  res.send('Welcome to the CampusKart API! The server is running successfully.');
});

// USER SCHEMA + MODEL (IMPORTANT)
const userSchema = new mongoose.Schema({
  email: String,
  password: String
});

const User = mongoose.model('User', userSchema);

// LOGIN ROUTE
app.post('/api/login', async (req, res) => {
  let { email, password } = req.body;

  console.log("LOGIN HIT:", email);

  if (!email || !password) {
    return res.status(400).json({ error: "Empty fields" });
  }

  email = email.trim().toLowerCase();
  password = password.trim();

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(401).json({ error: "User not found" });
    }

    if (user.password !== password) {
      return res.status(401).json({ error: "Wrong password" });
    }

    return res.status(200).json({ message: "Success" });

  } catch (err) {
    console.log(err);
    return res.status(500).json({ error: "Server error" });
  }
});

// START SERVER (VERY IMPORTANT)
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});