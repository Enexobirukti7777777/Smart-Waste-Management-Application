const express = require('express');
const router = express.Router();
const db = require('../models');
const collectorAuth = require('../middleware/collectorAuth');

// Update collector location
router.post('/location', collectorAuth, async (req, res) => {
  const { latitude, longitude } = req.body;
  try {
    const collector = await db.Collector.findByPk(req.collector.id);
    if (!collector) return res.status(404).json({ message: 'Collector not found' });

    collector.latitude = latitude;
    collector.longitude = longitude;
    await collector.save();

    res.json({ message: 'Location updated' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Error updating location' });
  }
});

module.exports = router;
