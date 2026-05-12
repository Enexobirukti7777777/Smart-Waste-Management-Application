const { Sequelize, DataTypes } = require('sequelize');
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env') });

const databaseUrl = process.env.DB_URL || process.env.DATABASE_URL;

if (!databaseUrl) {
  throw new Error('Missing DB_URL or DATABASE_URL for PostgreSQL connection');
}

const sequelizeOptions = {
  dialect: 'postgres',
  logging: false,
};

if (process.env.DB_SSL === 'true') {
  sequelizeOptions.dialectOptions = {
    ssl: {
      require: true,
      rejectUnauthorized: false,
    },
  };
}

const sequelize = new Sequelize(databaseUrl, sequelizeOptions);

const db = {};
db.Sequelize = Sequelize;
db.sequelize = sequelize;

db.Collector = require('./collector')(sequelize, DataTypes);
db.WasteRequest = require('./wasteRequest')(sequelize, DataTypes);

// Associations
db.Collector.hasMany(db.WasteRequest, { foreignKey: 'collectorId' });
db.WasteRequest.belongsTo(db.Collector, { foreignKey: 'collectorId' });

module.exports = db;
