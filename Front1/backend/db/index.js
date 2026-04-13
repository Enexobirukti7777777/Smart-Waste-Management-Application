import fs from "fs";
import path from "path";

const USERS_DB_FILE = path.join(process.cwd(), "users.db.json");
const PICKUPS_DB_FILE = path.join(process.cwd(), "pickups.db.json");

// Load DB with safety checks
// Load users DB
export const loadUsersDB = () => {
  let dbRaw = fs.existsSync(USERS_DB_FILE)
    ? JSON.parse(fs.readFileSync(USERS_DB_FILE, "utf8"))
    : {};
  return {
    users: dbRaw.users || [],
    nextId: dbRaw.nextId || 1,
  };
};

// Load pickups DB
export const loadPickupsDB = () => {
  let dbRaw = fs.existsSync(PICKUPS_DB_FILE)
    ? JSON.parse(fs.readFileSync(PICKUPS_DB_FILE, "utf8"))
    : {};
  return {
    requests: dbRaw.requests || [],
    nextId: dbRaw.nextId || 1,
  };
};

// Save users DB
export const saveUsersDB = (db) => {
  fs.writeFileSync(USERS_DB_FILE, JSON.stringify(db, null, 2));
};

// Save pickups DB
export const savePickupsDB = (db) => {
  fs.writeFileSync(PICKUPS_DB_FILE, JSON.stringify(db, null, 2));
};

// Get users
export const getUsers = () => loadUsersDB().users;

// Find user by email
export const findUserByEmail = (email) => {
  const db = loadUsersDB();
  return db.users.find((u) => u.email === email);
};

// Create or update user
export const upsertUser = (userData) => {
  const db = loadUsersDB();
  let user = db.users.find((u) => u.email === userData.email);
  if (!user) {
    user = { id: db.nextId++, ...userData };
    db.users.push(user);
  } else {
    Object.assign(user, userData);
  }
  saveUsersDB(db);
  return user;
};

// Update user
export const updateUser = (email, updates) => {
  const db = loadUsersDB();
  const user = db.users.find((u) => u.email === email);
  if (user) {
    Object.assign(user, updates);
    saveUsersDB(db);
    return user;
  }
  return null;
};

// Get requests (pickup requests)
export const getRequests = () => loadPickupsDB().requests || [];

// Create request (pickup)
export const createRequest = (requestData) => {
  const db = loadPickupsDB();
  const request = {
    id: db.nextId++,
    ...requestData,
    status: "pending",
    createdAt: new Date().toISOString(),
  };
  db.requests = db.requests || [];
  db.requests.push(request);
  savePickupsDB(db);
  return request;
};

// Notifications DB
const NOTIFICATIONS_DB_FILE = path.join(process.cwd(), "notifications.db.json");

export const loadNotificationsDB = () => {
  let dbRaw = fs.existsSync(NOTIFICATIONS_DB_FILE)
    ? JSON.parse(fs.readFileSync(NOTIFICATIONS_DB_FILE, "utf8"))
    : {};
  return {
    notifications: dbRaw.notifications || [],
    nextId: dbRaw.nextId || 1,
  };
};

export const saveNotificationsDB = (db) => {
  fs.writeFileSync(NOTIFICATIONS_DB_FILE, JSON.stringify(db, null, 2));
};

export const createNotification = (notifData) => {
  const db = loadNotificationsDB();
  const notification = {
    id: db.nextId++,
    pickupId: notifData.pickupId,
    userEmail: notifData.userEmail,
    kg: notifData.kg,
    price: notifData.price,
    status: "pending",
    createdAt: new Date().toISOString(),
  };
  db.notifications.push(notification);
  saveNotificationsDB(db);
  return notification;
};

export const updateNotificationStatus = (id, status) => {
  const db = loadNotificationsDB();
  const notif = db.notifications.find((n) => n.id === id);
  if (notif) {
    notif.status = status;
    notif.updatedAt = new Date().toISOString();
    saveNotificationsDB(db);
    return notif;
  }
  return null;
};

export const getUserNotifications = (userEmail) => {
  const db = loadNotificationsDB();
  return db.notifications
    .filter((n) => n.userEmail === userEmail)
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
};
