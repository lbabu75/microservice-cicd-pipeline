// tests/unit/server.test.js

const request = require('supertest');
const app = require('../../app/server');

describe('Sample Microservice API', () => {
  
  describe('Health Endpoints', () => {
    it('should return healthy status', async () => {
      const res = await request(app)
        .get('/health')
        .expect(200);
      
      expect(res.body).toHaveProperty('status', 'healthy');
      expect(res.body).toHaveProperty('timestamp');
    });

    it('should return ready status', async () => {
      const res = await request(app)
        .get('/ready')
        .expect(200);
      
      expect(res.body).toHaveProperty('status', 'ready');
    });
  });

  describe('User Endpoints', () => {
    it('should get all users', async () => {
      const res = await request(app)
        .get('/api/users')
        .expect(200);
      
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body.length).toBeGreaterThan(0);
    });

    it('should get user by id', async () => {
      const res = await request(app)
        .get('/api/users/1')
        .expect(200);
      
      expect(res.body).toHaveProperty('id', 1);
      expect(res.body).toHaveProperty('name');
    });

    it('should create new user', async () => {
      const newUser = {
        name: 'Test User',
        email: 'test@example.com'
      };

      const res = await request(app)
        .post('/api/users')
        .send(newUser)
        .expect(201);
      
      expect(res.body).toHaveProperty('id');
      expect(res.body).toHaveProperty('name', newUser.name);
    });
  });

  describe('Metrics Endpoint', () => {
    it('should return prometheus metrics', async () => {
      const res = await request(app)
        .get('/metrics')
        .expect(200);
      
      expect(res.text).toContain('http_requests_total');
      expect(res.text).toContain('http_request_duration_seconds');
    });
  });
});

