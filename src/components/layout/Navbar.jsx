import { List } from "react-bootstrap-icons";
import { NavLink } from "react-router-dom";

export default function Navbar({ onMenuClick }) {
  return (
    <nav className="navbar navbar-light bg-white border-bottom px-3 px-md-4 py-3 position-sticky top-0 z-3 shadow-sm">
      <div className="container-fluid d-flex align-items-center">
        {/* Left: Hamburger + Logo */}
        <div className="d-flex align-items-center flex-shrink-0">
          <button
            className="navbar-toggler border-0 me-3" // ← Removed d-lg-none
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

        {/* Horizontal Navigation Links */}
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

        {/* Right: Sign In */}
        <div className="flex-shrink-0">
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
