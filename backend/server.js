const { createServer } = require('./app');
const db = require('./models');

const { server } = createServer();

const PORT = process.env.PORT || 5000;

if (require.main === module) {
  db.sequelize.authenticate()
    .then(() => {
      console.log('PostgreSQL connection established');

      const shouldSync = process.env.DB_SYNC === 'true' || process.env.DB_SYNC_ALTER === 'true';
      if (!shouldSync) {
        return null;
      }

      return db.sequelize.sync({ alter: process.env.DB_SYNC_ALTER === 'true' });
    })
    .then(() => {
      
      server.listen(PORT, '0.0.0.0', () => {
        console.log(`Server running on port ${PORT}`);
      });
    })
    .catch((err) => {
      console.error('Failed to connect to PostgreSQL:', err);
      process.exit(1);
    });
}

module.exports = { server };
