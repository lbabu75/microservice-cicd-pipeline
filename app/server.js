// app/server.js

const express = require('express');
const promClient = require('prom-client');
const winston = require('winston');

const app = express();
const port = process.env.PORT || 3000;

// Prometheus metrics
const register = new promClient.Registry();
promClient.collectDefaultMetrics({ register });

const httpRequestCounter = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status'],
  registers: [register]
});

const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status'],
  registers: [register]
});

// Logger configuration
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.Console({
      format: winston.format.simple()
    })
  ]
});

// Middleware
app.use(express.json());

// Request logging and metrics middleware
app.use((req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    const route = req.route ? req.route.path : req.path;
    
    httpRequestCounter.labels(req.method, route, res.statusCode).inc();
    httpRequestDuration.labels(req.method, route, res.statusCode).observe(duration);
    
    logger.info({
      method: req.method,
      path: req.path,
      status: res.statusCode,
      duration: `${duration}s`
    });
  });
  
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Readiness check endpoint
app.get('/ready', (req, res) => {
  res.status(200).json({ status: 'ready', timestamp: new Date().toISOString() });
});

// Metrics endpoint for Prometheus
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

// 1. Add a simple in-memory data store at the top of the file
const users = [
  { id: 1, name: 'John Doe', email: 'john@example.com' },
  { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
];

// 2. Update GET all users
app.get('/api/users', (req, res) => {
  res.json(users);
});

// 3. Update GET user by ID
app.get('/api/users/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  const user = users.find(u => u.id === userId); // Look up the actual user
  
  if (user) {
    res.json(user);
  } else {
    res.status(404).json({ error: 'User not found' });
  }
});

// 4. Update POST user
app.post('/api/users', (req, res) => {
  const newUser = {
    id: users.length + 1, // Generate a real ID
    ...req.body
  };
  users.push(newUser); // Save it to the array
  logger.info('Creating new user', { user: newUser });
  res.status(201).json(newUser);
});

// Error handling
app.use((err, req, res, next) => {
  logger.error('Error occurred', { error: err.message, stack: err.stack });
  res.status(500).json({ error: 'Internal server error' });
});

let server; // 1. Declare server variable in outer scope

// Start server
if (require.main === module) {
  server = app.listen(port, () => {
  logger.info(`Server running on port ${port}`);
  });
}

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  if (server) { // 3. Check if server exists (it won't exist during tests)
  server.close(() => {
    logger.info('HTTP server closed');
    process.exit(0);
  });
  } else {
    process.exit(0);
  }
});

module.exports = app;
