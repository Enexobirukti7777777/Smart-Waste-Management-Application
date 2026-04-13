import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';

dotenv.config();

const sequelize = new Sequelize(process.env.DB_NAME || 'smart_waste_db', process.env.DB_USER || 'postgres', process.env.DB_PASSWORD, {
  host: process.env.DB_HOST || 'localhost',
  dialect: 'postgres',
  port: process.env.DB_PORT || 5432
});

export default sequelize;

