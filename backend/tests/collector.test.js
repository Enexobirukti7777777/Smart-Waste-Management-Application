const request = require('supertest');
const { app } = require('../app');

jest.mock('../models', () => ({
  Collector: {
    findByPk: jest.fn(async (id) => {
      if (String(id) === '1') {
        return {
          id: 1,
          name: 'Collector One',
          email: 'collector@example.com',
          latitude: '10.0000000',
          longitude: '20.0000000',
          isAvailable: true,
          update: async function (payload) {
            Object.assign(this, payload);
            return this;
          },
        };
      }

      return null;
    }),
  },
  WasteRequest: {
    findAll: jest.fn(async ({ where }) => {
      if (where && where.status === 'pending') return [{ id: 1, status: 'pending' }];
      if (where && String(where.collectorId) === '1') {
        return [{ id: 2, status: 'assigned', collectorId: 1 }];
      }
      if (where && where.status === 'completed') {
        return [{ id: 3, status: 'completed', collectorId: 1 }];
      }
      return [];
    }),
    count: jest.fn(async ({ where }) => {
      if (where && where.status === 'assigned') return 2;
      if (where && where.status === 'completed') return 4;
      if (where && where.status === 'on_the_way') return 1;
      if (where && where.status === 'arrived') return 1;
      return 5;
    }),
  },
}));

jest.mock('../services/assignmentService', () => ({
  acceptRequest: jest.fn(async (requestId, collectorId) => ({
    message: 'Request accepted',
    request: { id: Number(requestId), collectorId: Number(collectorId), status: 'assigned' },
  })),
  rejectRequest: jest.fn(async (requestId, collectorId) => ({
    message: 'Request rejected',
    request: { id: Number(requestId), collectorId: Number(collectorId), status: 'pending' },
  })),
  updateRequestStatus: jest.fn(async (requestId, collectorId, status) => ({
    message: 'Status updated',
    request: { id: Number(requestId), collectorId: Number(collectorId), status },
  })),
  uploadProof: jest.fn(async (requestId, collectorId) => ({
    message: 'Proof uploaded',
    requestId: Number(requestId),
    collectorId: Number(collectorId),
  })),
}));

describe('Collector routes', () => {
  test('GET /api/collector/available-requests returns list', async () => {
    const res = await request(app).get('/api/collector/available-requests').set('x-collector-id', '1');
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  test('GET /api/collector/dashboard returns stats', async () => {
    const res = await request(app).get('/api/collector/dashboard').set('x-collector-id', '1');
    expect(res.statusCode).toBe(200);
    expect(res.body.completedJobs).toBeDefined();
    expect(res.body.earnings).toBeDefined();
  });

  test('GET /api/collector/earnings returns earnings summary', async () => {
    const res = await request(app).get('/api/collector/earnings').set('x-collector-id', '1');
    expect(res.statusCode).toBe(200);
    expect(res.body.totalCompletedJobs).toBeDefined();
    expect(res.body.estimatedEarnings).toBeDefined();
  });

  test('GET /api/collector/profile returns collector profile', async () => {
    const res = await request(app).get('/api/collector/profile').set('x-collector-id', '1');
    expect(res.statusCode).toBe(200);
    expect(res.body.email).toBe('collector@example.com');
  });

  test('POST /api/collector/requests/:requestId/accept assigns request', async () => {
    const res = await request(app).post('/api/collector/requests/15/accept').set('x-collector-id', '1');
    expect(res.statusCode).toBe(200);
    expect(res.body.request.status).toBe('assigned');
  });

  test('PUT /api/collector/requests/:requestId/status updates request status', async () => {
    const res = await request(app)
      .put('/api/collector/requests/15/status')
      .set('x-collector-id', '1')
      .send({ status: 'completed' });

    expect(res.statusCode).toBe(200);
    expect(res.body.request.status).toBe('completed');
  });
});
