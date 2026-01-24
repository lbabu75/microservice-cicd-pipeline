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

// package.json test scripts
{
  "scripts": {
    "test": "jest --coverage",
    "test:unit": "jest tests/unit --coverage",
    "test:integration": "jest tests/integration",
    "test:watch": "jest --watch",
    "lint": "eslint . --ext .js",
    "lint:fix": "eslint . --ext .js --fix"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "supertest": "^6.3.0",
    "eslint": "^8.0.0"
  }
}

// jest.config.js
module.exports = {
  testEnvironment: 'node',
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'app/**/*.js',
    '!app/node_modules/**',
    '!app/coverage/**'
  ],
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70
    }
  },
  testMatch: [
    '**/tests/**/*.test.js'
  ]
};

// .eslintrc.js
module.exports = {
  env: {
    node: true,
    es2021: true,
    jest: true
  },
  extends: 'eslint:recommended',
  parserOptions: {
    ecmaVersion: 12
  },
  rules: {
    'no-console': 'warn',
    'no-unused-vars': 'error',
    'semi': ['error', 'always'],
    'quotes': ['error', 'single']
  }
};
