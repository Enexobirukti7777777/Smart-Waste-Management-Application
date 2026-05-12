Smart Waste Backend

This directory contains a Node.js + Express backend scaffold with Sequelize and Socket.io.

Quick start:

1. Copy `.env` and set a real PostgreSQL connection string in `DB_URL` or `DATABASE_URL`.
2. Run `npm install` in the `backend` folder.
3. Run `npm run dev` or `npm start`.
4. Visit `GET /api/health/db` to confirm the live database connection.

Notes:

- `DB_SYNC=true` enables schema sync on startup.
- `DB_SYNC_ALTER=true` enables `sync({ alter: true })`.
- Set `DB_SSL=true` for hosted PostgreSQL providers that require SSL.
