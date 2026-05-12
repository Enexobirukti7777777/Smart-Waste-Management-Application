const express = require('express');
const router = express.Router();
const db = require('../models');
const collectorAuth = require('../middleware/collectorAuth');
const assignmentService = require('../services/assignmentService');

function buildEarningsSummary(collectorId) {
  return db.WasteRequest.findAll({
    where: { collectorId, status: 'completed' },
  }).then((requests) => {
    const completedJobs = requests.length;
    const estimatedEarnings = completedJobs * 100;

    return {
      totalCompletedJobs: completedJobs,
      estimatedEarnings,
      currency: 'USD',
      breakdown: requests.map((request) => ({
        requestId: request.id,
        amount: 100,
        status: request.status,
      })),
    };
  });
}

function buildDashboard(collectorId) {
  return Promise.all([
    db.WasteRequest.count({ where: { collectorId, status: 'completed' } }),
    db.WasteRequest.count({ where: { collectorId, status: 'assigned' } }),
    db.WasteRequest.count({ where: { collectorId, status: 'on_the_way' } }),
    db.WasteRequest.count({ where: { collectorId, status: 'arrived' } }),
    buildEarningsSummary(collectorId),
  ]).then(([completedJobs, assignedJobs, onTheWayJobs, arrivedJobs, earnings]) => ({
    todayJobs: completedJobs + assignedJobs + onTheWayJobs + arrivedJobs,
    earnings,
    pendingAssignments: assignedJobs,
    activeJobs: onTheWayJobs + arrivedJobs,
    completedJobs,
  }));
}

router.get('/available-requests', collectorAuth, async (req, res) => {
  try {
    const requests = await db.WasteRequest.findAll({
      where: { status: 'pending' },
    });

    res.json(requests);
  } catch (error) {
    console.error('available-requests error:', error);
    res.status(500).json({ message: 'Failed to fetch available requests' });
  }
});

router.get('/my-tasks', collectorAuth, async (req, res) => {
  try {
    const tasks = await db.WasteRequest.findAll({
      where: { collectorId: req.collector.id },
      order: [['id', 'DESC']],
    });

    res.json(tasks);
  } catch (error) {
    console.error('my-tasks error:', error);
    res.status(500).json({ message: 'Failed to fetch assigned tasks' });
  }
});

router.get('/dashboard', collectorAuth, async (req, res) => {
  try {
    const dashboard = await buildDashboard(req.collector.id);
    res.json(dashboard);
  } catch (error) {
    console.error('dashboard error:', error);
    res.status(500).json({ message: 'Failed to fetch dashboard summary' });
  }
});

router.get('/earnings', collectorAuth, async (req, res) => {
  try {
    const earnings = await buildEarningsSummary(req.collector.id);
    res.json(earnings);
  } catch (error) {
    console.error('earnings error:', error);
    res.status(500).json({ message: 'Failed to fetch earnings' });
  }
});

router.get('/profile', collectorAuth, async (req, res) => {
  res.json({
    id: req.collector.id,
    name: req.collector.name,
    email: req.collector.email,
    latitude: req.collector.latitude,
    longitude: req.collector.longitude,
    isAvailable: req.collector.isAvailable,
  });
});

router.put('/profile', collectorAuth, async (req, res) => {
  try {
    const { name, email, latitude, longitude, isAvailable } = req.body;
    await req.collector.update({
      name: name ?? req.collector.name,
      email: email ?? req.collector.email,
      latitude: latitude ?? req.collector.latitude,
      longitude: longitude ?? req.collector.longitude,
      isAvailable: typeof isAvailable === 'boolean' ? isAvailable : req.collector.isAvailable,
    });

    res.json({
      message: 'Profile updated',
      collector: {
        id: req.collector.id,
        name: req.collector.name,
        email: req.collector.email,
        latitude: req.collector.latitude,
        longitude: req.collector.longitude,
        isAvailable: req.collector.isAvailable,
      },
    });
  } catch (error) {
    console.error('profile update error:', error);
    res.status(500).json({ message: 'Failed to update profile' });
  }
});

router.post('/requests/:requestId/accept', collectorAuth, async (req, res) => {
  try {
    const result = await assignmentService.acceptRequest(req.params.requestId, req.collector.id, req.app.get('io'));
    res.json(result);
  } catch (error) {
    console.error('accept error:', error);
    res.status(400).json({ message: error.message || 'Failed to accept request' });
  }
});

router.post('/requests/:requestId/reject', collectorAuth, async (req, res) => {
  try {
    const result = await assignmentService.rejectRequest(req.params.requestId, req.collector.id);
    res.json(result);
  } catch (error) {
    console.error('reject error:', error);
    res.status(400).json({ message: error.message || 'Failed to reject request' });
  }
});

router.put('/requests/:requestId/status', collectorAuth, async (req, res) => {
  try {
    const result = await assignmentService.updateRequestStatus(
      req.params.requestId,
      req.collector.id,
      req.body.status,
    );
    res.json(result);
  } catch (error) {
    console.error('status update error:', error);
    res.status(400).json({ message: error.message || 'Failed to update request status' });
  }
});

router.post('/requests/:requestId/upload-proof', collectorAuth, async (req, res) => {
  try {
    const result = await assignmentService.uploadProof(req.params.requestId, req.collector.id, req.body.proof);
    res.json(result);
  } catch (error) {
    console.error('upload-proof error:', error);
    res.status(400).json({ message: error.message || 'Failed to upload proof' });
  }
});

// Backward-compatible aliases for earlier paths.
router.post('/accept', collectorAuth, async (req, res) => {
  try {
    const result = await assignmentService.acceptRequest(req.body.requestId, req.collector.id, req.app.get('io'));
    res.json(result);
  } catch (error) {
    console.error('accept alias error:', error);
    res.status(400).json({ message: error.message || 'Failed to accept request' });
  }
});

router.post('/reject', collectorAuth, async (req, res) => {
  try {
    const result = await assignmentService.rejectRequest(req.body.requestId, req.collector.id);
    res.json(result);
  } catch (error) {
    console.error('reject alias error:', error);
    res.status(400).json({ message: error.message || 'Failed to reject request' });
  }
});

router.put('/status', collectorAuth, async (req, res) => {
  try {
    const result = await assignmentService.updateRequestStatus(req.body.requestId, req.collector.id, req.body.status);
    res.json(result);
  } catch (error) {
    console.error('status alias error:', error);
    res.status(400).json({ message: error.message || 'Failed to update request status' });
  }
});

router.post('/upload-proof', collectorAuth, async (req, res) => {
  try {
    const result = await assignmentService.uploadProof(req.body.requestId, req.collector.id, req.body.proof);
    res.json(result);
  } catch (error) {
    console.error('upload-proof alias error:', error);
    res.status(400).json({ message: error.message || 'Failed to upload proof' });
  }
});

module.exports = router;
