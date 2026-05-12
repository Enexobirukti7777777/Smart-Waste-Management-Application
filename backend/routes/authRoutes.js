const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../models');

// Collector login
router.post('/collector/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const collector = await db.Collector.findOne({ where: { email } });
    if (!collector) return res.status(404).json({ message: 'Collector not found' });

    const isMatch = await bcrypt.compare(password, collector.password);
    if (!isMatch) return res.status(401).json({ message: 'Invalid credentials' });

    const token = jwt.sign({ id: collector.id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    res.json({ token, collector: { id: collector.id, name: collector.name, email: collector.email } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Send OTP (placeholder)
router.post('/collector/send-otp', async (req, res) => {
  const { email } = req.body;
  // Placeholder: integrate SMS/email provider
  res.json({ message: `OTP sent to ${email} (placeholder)` });
});

module.exports = router;
