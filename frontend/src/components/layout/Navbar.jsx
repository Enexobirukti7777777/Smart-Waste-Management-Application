import { useState, useEffect } from "react";
import { List, Bell } from "react-bootstrap-icons";
import { NavLink } from "react-router-dom";
import io from "socket.io-client";

const SOCKET_URL = "http://localhost:3000"; // Change to your production backend URL later

export default function Navbar({ onMenuClick }) {
  const [notifications, setNotifications] = useState([
    {
      id: 1,
      type: "pickup",
      title: "Pickup Schedule Approval",
      message: "Weekly pickup request for tomorrow at 10:00 AM",
      time: "5 min ago",
      read: false,
      actionable: true,
    },
    {
      id: 2,
      type: "payment",
      title: "Payment Approval Request",
      message: "Your payment of 450 ETB needs confirmation",
      time: "1 hour ago",
      read: false,
      actionable: true,
    },
  ]);

  const unreadCount = notifications.filter((n) => !n.read).length;
  const [showNotifications, setShowNotifications] = useState(false);
  const [socket, setSocket] = useState(null);

  // Mark as read
  const markAsRead = (id) => {
    setNotifications((prev) =>
      prev.map((notif) => (notif.id === id ? { ...notif, read: true } : notif)),
    );
  };

  // Approve / Reject (placeholder - replace with real API later)
  const handleApprove = (id) => {
    alert(`Approved notification #${id}`);
    markAsRead(id);
    setShowNotifications(false);
  };

  const handleReject = (id) => {
    alert(`Rejected notification #${id}`);
    markAsRead(id);
    setShowNotifications(false);
  };

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (e) => {
      if (!e.target.closest(".notification-wrapper")) {
        setShowNotifications(false);
      }
    };
    document.addEventListener("click", handleClickOutside);
    return () => document.removeEventListener("click", handleClickOutside);
  }, []);

  // Socket.io Connection + Real-time Listeners
  useEffect(() => {
    const newSocket = io(SOCKET_URL, {
      transports: ["websocket"], // Optional: helps with some proxy issues
    });

    setSocket(newSocket);

    newSocket.on("connect", () => {
      console.log("✅ Connected to notification backend via Socket.io");
    });

    newSocket.on("payment", (data) => {
      console.log("🔔 New payment notification:", data);

      const newNotif = {
        id: Date.now(), // Simple unique ID
        type: "payment",
        title: "Payment Confirmed",
        message: `Your payment of $${data.amount} (ID: ${data.paymentId}) has been confirmed!`,
        time: "Just now",
        read: false,
        actionable: false, // or true if you want approve/reject
      };

      setNotifications((prev) => [newNotif, ...prev]); // Add to top
    });

    newSocket.on("otp", (data) => {
      console.log("🔔 New OTP notification:", data);

      const newNotif = {
        id: Date.now(),
        type: "otp",
        title: "OTP Sent",
        message: data.message || "A new OTP has been sent to your email.",
        time: "Just now",
        read: false,
        actionable: false,
      };

      setNotifications((prev) => [newNotif, ...prev]);
    });

    newSocket.on("disconnect", () => {
      console.log("❌ Socket disconnected");
    });

    // Cleanup on unmount (prevents duplicate listeners)
    return () => {
      newSocket.disconnect();
    };
  }, []);

  return (
    <nav className="navbar navbar-light bg-white border-bottom px-3 px-md-4 py-3 position-sticky top-0 z-3 shadow-sm">
      <div className="container-fluid d-flex align-items-center">
        {/* Left: Hamburger + Logo */}
        <div className="d-flex align-items-center flex-shrink-0">
          <button
            className="navbar-toggler border-0 me-3"
            type="button"
            onClick={onMenuClick}
            aria-label="Toggle menu"
          >
            <List size={28} />
          </button>
          <NavLink
            to="/"
            className="navbar-brand d-flex align-items-center gap-2 text-success fw-bold fs-4"
          >
            <i className="bi bi-tree-fill fs-3"></i>
            Kuralewo
          </NavLink>
        </div>

        {/* Navigation Links */}
        <div className="d-flex mx-auto align-items-center gap-3 gap-md-5 flex-nowrap overflow-x-auto hide-scrollbar">
          <NavLink
            to="/"
            className="nav-link fw-medium text-dark mobile-nav"
            end
          >
            Home
          </NavLink>
          <NavLink
            to="/about"
            className="nav-link fw-medium text-dark mobile-nav"
          >
            About
          </NavLink>
          <NavLink
            to="/contact"
            className="nav-link fw-medium text-dark mobile-nav"
          >
            Contact
          </NavLink>
          <NavLink
            to="/dashboard"
            className="nav-link fw-medium text-dark mobile-nav"
          >
            Dashboard
          </NavLink>
        </div>

        {/* Right Side */}
        <div className="d-flex align-items-center gap-4 flex-shrink-0">
          {/* Notifications */}
          <div className="position-relative notification-wrapper">
            <button
              className="btn btn-link p-0 border-0"
              onClick={() => setShowNotifications(!showNotifications)}
            >
              <Bell size={24} className="text-success" />
              {unreadCount > 0 && (
                <span className="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                  {unreadCount}
                </span>
              )}
            </button>

            {/* Notification Dropdown */}
            {showNotifications && (
              <div
                className="notification-dropdown position-absolute end-0 mt-2 bg-white rounded-3 shadow-lg p-3"
                style={{
                  width: "340px",
                  zIndex: 1100,
                  maxHeight: "420px",
                  overflowY: "auto",
                }}
              >
                <h6 className="fw-bold mb-3 px-2">Notifications</h6>
                {notifications.length === 0 ? (
                  <p className="text-muted text-center py-4">
                    No new notifications
                  </p>
                ) : (
                  notifications.map((notif) => (
                    <div
                      key={notif.id}
                      className={`notification-item p-3 rounded-3 mb-2 ${notif.read ? "bg-light" : "bg-white border"}`}
                    >
                      <div className="d-flex justify-content-between">
                        <strong>{notif.title}</strong>
                        <small className="text-muted">{notif.time}</small>
                      </div>
                      <p className="text-muted small mt-1 mb-3">
                        {notif.message}
                      </p>
                      {notif.actionable && (
                        <div className="d-flex gap-2">
                          <button
                            className="btn btn-success btn-sm flex-grow-1"
                            onClick={() => handleApprove(notif.id)}
                          >
                            Approve
                          </button>
                          <button
                            className="btn btn-outline-danger btn-sm flex-grow-1"
                            onClick={() => handleReject(notif.id)}
                          >
                            Reject
                          </button>
                        </div>
                      )}
                    </div>
                  ))
                )}
              </div>
            )}
          </div>

          {/* Sign In Button */}
          <NavLink to="/login">
            <button className="cta-btn text-white rounded-pill px-4 py-2 fw-medium">
              Sign In
            </button>
          </NavLink>
        </div>
      </div>
    </nav>
  );
}
