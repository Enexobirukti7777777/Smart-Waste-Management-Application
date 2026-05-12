const request = require('supertest');
const mockBcrypt = require('bcryptjs');
const { app } = require('../app');

jest.mock('../models', () => ({
  Collector: {
    findOne: jest.fn(async ({ where: { email } }) => {
      if (email === 'exists@example.com') {
        return { id: 1, name: 'Test', email, password: mockBcrypt.hashSync('password123', 8) };
      }
      return null;
    })
  }
}));

describe('Auth routes', () => {
  test('POST /api/auth/collector/send-otp returns placeholder message', async () => {
    const res = await request(app).post('/api/auth/collector/send-otp').send({ email: 'a@b.com' });
    expect(res.statusCode).toBe(200);
    expect(res.body.message).toMatch(/OTP sent/);
  });

  test('POST /api/auth/collector/login success', async () => {
    const res = await request(app).post('/api/auth/collector/login').send({ email: 'exists@example.com', password: 'password123' });
    expect(res.statusCode).toBe(200);
    expect(res.body.token).toBeDefined();
    expect(res.body.collector).toBeDefined();
  });

  test('POST /api/auth/collector/login failure', async () => {
    const res = await request(app).post('/api/auth/collector/login').send({ email: 'nope@example.com', password: 'x' });
    expect(res.statusCode).toBe(404);
  });
});
