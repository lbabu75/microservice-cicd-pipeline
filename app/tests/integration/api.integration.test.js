// tests/integration/api.integration.test.js

const request = require('supertest');
const app = require('../../server'); // Use the fixed path below

describe('Integration Tests', () => {
  beforeAll(async () => {
    // Setup test database or mock services
  });

  afterAll(async () => {
    // Cleanup
  });

  it('should handle complete user workflow', async () => {
    // Get initial users
    const initialUsers = await request(app)
      .get('/api/users')
      .expect(200);
    
    const initialCount = initialUsers.body.length;

    // Create new user
    const newUser = {
      name: 'Integration Test User',
      email: 'integration@example.com'
    };
   
    const createRes = await request(app)
      .post('/api/users')
      .send(newUser)
      .expect(201);

    const userId = createRes.body.id;

    // Verify list count increased
    const finalUsers = await request(app)
      .get('/api/users')
      .expect(200);
    expect(finalUsers.body.length).toBe(initialCount + 1);
    
    // Verify user was created
    const getRes = await request(app)
      .get(`/api/users/${userId}`)
      .expect(200);
    
    expect(getRes.body.name).toBe(newUser.name);
  });
});
