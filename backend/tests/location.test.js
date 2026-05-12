const request = require('supertest');
const { app } = require('../app');

jest.mock('../models', () => ({
  Collector: {
    findByPk: jest.fn(async (id) => {
      if (String(id) === '1') return { id: 1, latitude: null, longitude: null, save: async function() { return this; } };
      return null;
    })
  }
}));

describe('Location route', () => {
  test('POST /api/collector/location updates location', async () => {
    const res = await request(app).post('/api/collector/location').set('x-collector-id', '1').send({ latitude: 1.23, longitude: 4.56 });
    expect(res.statusCode).toBe(200);
    expect(res.body.message).toMatch(/Location updated/);
  });

  test('POST /api/collector/location returns 404 for missing collector', async () => {
    const res = await request(app).post('/api/collector/location').set('x-collector-id', '999').send({ latitude: 1.23, longitude: 4.56 });
    expect(res.statusCode).toBe(404);
  });
});
