import { NavLink } from "react-router-dom";
import { HouseDoorFill, GeoAlt, ChatDots, Person } from "react-bootstrap-icons";
import { useState, useEffect } from "react";

export default function Sidebar({ show, onHide }) {
  const [user, setUser] = useState({
    name: "Guest User",
    role: "Eco Warrior",
    avatar: "https://i.pravatar.cc/48?u=guest",
  });

  // Load user from localStorage when sidebar opens
  useEffect(() => {
    const savedUser = localStorage.getItem("user");
    if (savedUser) {
      setUser(JSON.parse(savedUser));
    }
  }, [show]); // Re-load when sidebar is shown

  return (
    <div
      className={`offcanvas offcanvas-start ${show ? "show" : ""}`}
      tabIndex="-1"
      style={{
        width: "260px",
        visibility: show ? "visible" : "hidden",
        zIndex: 1050,
        transition: "transform 0.3s ease-in-out",
        transform: `translateX(${show ? "0" : "-100%"})`,
      }}
    >
      <div className="offcanvas-header border-bottom">
        <NavLink
          to="/"
          className="d-flex align-items-center gap-2 text-decoration-none"
          onClick={onHide}
        >
          <i className="bi bi-tree-fill text-success fs-3"></i>
          <span className="fw-bold fs-4 text-success">Kuralewo</span>
        </NavLink>
        <button
          type="button"
          className="btn-close"
          onClick={onHide}
          aria-label="Close"
        />
      </div>

      <div className="offcanvas-body d-flex flex-column p-0">
        <div className="flex-grow-1 p-3">
          <ul className="nav flex-column">
            <li className="nav-item">
              <NavLink
                to="/"
                className={({ isActive }) =>
                  `nav-link d-flex align-items-center gap-3 ${isActive ? "active bg-success text-white" : "text-dark"} rounded-3 p-3 mb-1`
                }
                onClick={onHide}
              >
                <HouseDoorFill size={22} />
                Home
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                to="/dashboard"
                className={({ isActive }) =>
                  `nav-link d-flex align-items-center gap-3 ${isActive ? "active bg-success text-white" : "text-dark"} rounded-3 p-3 mb-1`
                }
                onClick={onHide}
              >
                <GeoAlt size={22} />
                Dashboard
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                to="/ai-chat"
                className={({ isActive }) =>
                  `nav-link d-flex align-items-center gap-3 ${isActive ? "active bg-success text-white" : "text-dark"} rounded-3 p-3 mb-1`
                }
                onClick={onHide}
              >
                <ChatDots size={22} />
                AI Chat
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                to="/profile"
                className={({ isActive }) =>
                  `nav-link d-flex align-items-center gap-3 ${isActive ? "active bg-success text-white" : "text-dark"} rounded-3 p-3 mb-1`
                }
                onClick={onHide}
              >
                <Person size={22} />
                Profile
              </NavLink>
            </li>
          </ul>
        </div>

        {/* Dynamic User Profile at Bottom */}
        <div className="p-3 border-top mt-auto">
          <div className="d-flex align-items-center gap-3 bg-light rounded-3 p-3">
            <img
              src={user.avatar}
              alt={user.name}
              className="rounded-circle border border-success border-2"
              width={48}
              height={48}
            />
            <div className="flex-grow-1">
              <div className="fw-semibold text-dark">{user.name}</div>
              <small className="text-success">{user.role}</small>
            </div>
            <i className="bi bi-chevron-right text-muted"></i>
          </div>
        </div>
      </div>
    </div>
  );
}
