require('dotenv').config({ path: require('path').join(__dirname, '.env') });
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
app.use(express.json());

// Attach routes (do not start DB or HTTP server here)
app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/collector', require('./routes/collectorRoutes'));
app.use('/api/collector', require('./routes/locationRoutes'));
app.use('/api/health', require('./routes/healthRoutes'));

function createServer() {
  const server = http.createServer(app);
  const io = new Server(server, { cors: { origin: '*' } });
  app.set('io', io);

  io.on('connection', (socket) => {
    console.log('Socket connected:', socket.id);
    socket.on('disconnect', () => console.log('Socket disconnected:', socket.id));
  });

  return { app, server, io };
}

module.exports = { app, createServer };
