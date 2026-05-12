const jwt = require('jsonwebtoken');
const db = require('../models');

module.exports = async function collectorAuth(req, res, next) {
  try {
    const header = req.headers.authorization || '';
    const token = header.startsWith('Bearer ') ? header.slice(7) : null;
    const fallbackCollectorId = req.headers['x-collector-id'];

    let collectorId = fallbackCollectorId;

    if (token) {
      if (!process.env.JWT_SECRET) {
        return res.status(500).json({ message: 'JWT secret is not configured' });
      }

      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      collectorId = decoded.id;
    }

    if (!collectorId) {
      return res.status(401).json({ message: 'Collector authentication required' });
    }

    const collector = await db.Collector.findByPk(collectorId);
    if (!collector) {
      return res.status(404).json({ message: 'Collector not found' });
    }

    req.collector = collector;
    next();
  } catch (error) {
    console.error('collectorAuth error:', error);
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
};
