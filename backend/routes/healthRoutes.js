const express = require('express');
const db = require('../models');

const router = express.Router();

router.get('/', async (req, res) => {
  res.json({ status: 'ok' });
});

router.get('/db', async (req, res) => {
  try {
    await db.sequelize.authenticate();

    res.json({
      status: 'ok',
      database: 'connected',
      dialect: db.sequelize.getDialect(),
    });
  } catch (error) {
    console.error('DB health check failed:', error);
    res.status(500).json({
      status: 'error',
      database: 'disconnected',
      message: error.message,
    });
  }
});

module.exports = router;