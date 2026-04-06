const express = require("express");
const sqlite3 = require("sqlite3").verbose();
const bcrypt = require("bcryptjs");
const nodemailer = require("nodemailer");
const cors = require("cors");
const dotenv = require("dotenv");

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(
  cors({
    origin: process.env.FRONTEND_URL || "http://localhost:3000",
    credentials: true,
  }),
);
app.use(express.json());

// SQLite Database
const db = new sqlite3.Database("./eco.db", (err) => {
  if (err) console.error("Database error:", err);
  else console.log("✅ Connected to SQLite database");
});

// Create Tables
db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      full_name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      phone TEXT,
      password_hash TEXT NOT NULL,
      user_type TEXT CHECK(user_type IN ('company', 'home')) NOT NULL,
      city TEXT,
      street_address TEXT,
      home_number TEXT,
      is_verified INTEGER DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS otps (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      otp TEXT NOT NULL,
      expires_at DATETIME NOT NULL,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
    )
  `);
});

// Nodemailer Transporter (console fallback if no credentials)
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// Send OTP Function
const sendOtpEmail = async (email, otp) => {
  const mailOptions = {
    from: '"Eco Recycle" <noreply@ecorecycle.com>',
    to: email,
    subject: "Your Signup OTP Code",
    html: `
      <h2>Welcome to Eco Recycle!</h2>
      <p>Your verification code is: <strong>${otp}</strong></p>
      <p>This code will expire in 60 seconds.</p>
      <p>Thank you for joining us in saving the planet 🌍</p>
    `,
  };

  try {
    if (process.env.EMAIL_USER && process.env.EMAIL_PASS) {
      await transporter.sendMail(mailOptions);
      console.log(`📧 Real OTP sent to ${email}`);
    } else {
      console.log(`\n🔥 DEMO MODE - OTP for ${email}: ${otp}\n`);
    }
  } catch (error) {
    console.error("Email sending failed:", error);
    console.log(`\n🔥 FALLBACK - OTP for ${email}: ${otp}\n`);
  }
};

// ====================== REGISTER + SEND OTP ======================
app.post("/api/register", async (req, res) => {
  const {
    fullName,
    email,
    phone,
    password,
    userType,
    city,
    streetAddress,
    homeNumber,
  } = req.body;

  if (!fullName || !email || !password || !userType) {
    return res
      .status(400)
      .json({
        message: "Full name, email, password and user type are required",
      });
  }

  try {
    // Check if user already exists
    const existing = await new Promise((resolve, reject) => {
      db.get(
        "SELECT id, is_verified FROM users WHERE email = ?",
        [email],
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        },
      );
    });

    let userId;

    if (existing) {
      if (existing.is_verified) {
        return res
          .status(409)
          .json({ message: "Email already registered and verified" });
      }
      userId = existing.id;
    } else {
      // Hash password
      const salt = await bcrypt.genSalt(10);
      const passwordHash = await bcrypt.hash(password, salt);

      // Insert new user (unverified)
      const result = await new Promise((resolve, reject) => {
        db.run(
          `
          INSERT INTO users (full_name, email, phone, password_hash, user_type, city, street_address, home_number)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `,
          [
            fullName,
            email,
            phone || null,
            passwordHash,
            userType,
            city || null,
            streetAddress || null,
            homeNumber || null,
          ],
          function (err) {
            if (err) reject(err);
            else resolve(this.lastID);
          },
        );
      });
      userId = result;
    }

    // Generate 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 60 * 1000).toISOString();

    // Delete old OTPs for this user
    await new Promise((resolve) =>
      db.run("DELETE FROM otps WHERE user_id = ?", [userId], resolve),
    );

    // Save new OTP
    await new Promise((resolve, reject) => {
      db.run(
        "INSERT INTO otps (user_id, otp, expires_at) VALUES (?, ?, ?)",
        [userId, otp, expiresAt],
        (err) => (err ? reject(err) : resolve()),
      );
    });

    await sendOtpEmail(email, otp);

    res.status(200).json({
      success: true,
      userId: userId,
      message: "OTP sent successfully to your email",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
});

// ====================== VERIFY OTP ======================
app.post("/api/verify-otp", async (req, res) => {
  const { userId, otp } = req.body;

  if (!userId || !otp || otp.length !== 6) {
    return res
      .status(400)
      .json({ message: "User ID and valid 6-digit OTP are required" });
  }

  try {
    // Check OTP
    const otpRecord = await new Promise((resolve, reject) => {
      db.get(
        "SELECT * FROM otps WHERE user_id = ? AND otp = ?",
        [userId, otp],
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        },
      );
    });

    if (!otpRecord) {
      return res.status(400).json({ message: "Invalid OTP" });
    }

    if (new Date(otpRecord.expires_at) < new Date()) {
      return res
        .status(400)
        .json({ message: "OTP has expired. Please request a new one." });
    }

    // Mark user as verified
    await new Promise((resolve, reject) => {
      db.run(
        "UPDATE users SET is_verified = 1 WHERE id = ?",
        [userId],
        (err) => {
          if (err) reject(err);
          else resolve();
        },
      );
    });

    // Delete used OTP
    await new Promise((resolve) =>
      db.run("DELETE FROM otps WHERE user_id = ?", [userId], resolve),
    );

    res.json({
      success: true,
      message: "Account verified successfully!",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Verification failed" });
  }
});

// Health Check
app.get("/api/health", (req, res) => {
  res.json({
    status: "OK",
    database: "SQLite",
    time: new Date().toISOString(),
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Eco Recycle Backend running on http://localhost:${PORT}`);
  console.log("📧 OTP will be sent via email or shown in console");
});
