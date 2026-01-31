// tests/integration/api.integration.test.js

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

    // Verify user was created
    const getRes = await request(app)
      .get(`/api/users/${userId}`)
      .expect(200);
    
    expect(getRes.body.name).toBe(newUser.name);
  });
});
