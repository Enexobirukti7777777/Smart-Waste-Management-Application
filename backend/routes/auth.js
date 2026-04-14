import express from 'express';
import bcrypt from 'bcryptjs';
import crypto from 'crypto';
import { open } from 'sqlite';
import sqlite3 from 'sqlite3';

const router = express.Router();
const dbPromise = open({
  filename: './smart-waste.db',
  driver: sqlite3.Database
});

// Generate OTP
const generateOTP = () => crypto.randomInt(100000, 999999).toString();

// Mock email
const sendOTP = async (email, otp) => {
  console.log(`🔥 OTP for ${email}: ${otp}`);
  return true;
};

// POST /api/auth/send-otp
router.post('/send-otp', async (req, res) => {
  try {
    const { name, email } = req.body;
    if (!name || !email) return res.status(400).json({ error: 'Name & email required' });

    const db = await dbPromise;
    const existing = await db.get('SELECT * FROM users WHERE email = ? AND isVerified = 1', email);
    if (existing) return res.status(400).json({ error: 'User exists' });

    const otp = generateOTP();
    const otpExpires = Date.now() + 10 * 60 * 1000;

    await db.run(`
      INSERT OR REPLACE INTO users (name, email, otp, otp_expires, isVerified) 
      VALUES (?, ?, ?, ?, 0)
    `, name, email, otp, otpExpires);

    await sendOTP(email, otp);
    res.json({ success: true, message: 'OTP sent - DB saved' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/auth/verify-otp
router.post('/verify-otp', async (req, res) => {
  try {
    const { email, otp, password } = req.body;
    if (!email || !otp || !password) return res.status(400).json({ error: 'All fields required' });

    const db = await dbPromise;
    const user = await db.get(`
      SELECT * FROM users 
      WHERE email = ? AND otp = ? AND otp_expires > ? AND isVerified = 0
    `, email, otp, Date.now());

    if (!user) return res.status(400).json({ error: 'Invalid OTP' });

    const hashedPassword = await bcrypt.hash(password, 12);

    await db.run(`
      UPDATE users SET 
        password = ?, otp = NULL, otp_expires = NULL, isVerified = 1, role = 'citizen'
      WHERE id = ?
    `, hashedPassword, user.id);

    console.log(`✅ DB User created: ${user.name}`);

    res.json({ success: true, message: 'Signup complete - DB saved!' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;

