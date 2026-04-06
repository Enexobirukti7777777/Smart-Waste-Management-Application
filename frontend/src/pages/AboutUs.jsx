// src/pages/AboutUs.jsx
import { Link } from "react-router-dom";
import {
  HeartFill,
  ShieldCheck,
  PeopleFill,
  Globe,
} from "react-bootstrap-icons";

export default function AboutUs() {
  return (
    <div className="container-fluid px-3 px-md-5 py-4">
      {/* Header */}
      <div className="text-center mb-5">
        <h1 className="display-5 fw-bold text-success">About EcoCity</h1>
        <p
          className="lead text-muted mt-3"
          style={{ maxWidth: "720px", margin: "0 auto" }}
        >
          We are building a cleaner, smarter, and more sustainable future for
          cities — one report, one recycle point, and one community action at a
          time.
        </p>
      </div>

      {/* 4 Mission Cards */}
      <div className="row g-4 justify-content-center">
        {/* Card 1 */}
        <div className="col-12 col-md-6 col-lg-3">
          <div className="feature-card p-4 text-center h-100 shadow-sm border-0 rounded-4">
            <div className="icon-circle mx-auto mb-3 bg-success-subtle">
              <HeartFill size={36} className="text-success" />
            </div>
            <h5 className="fw-bold mb-3">Community First</h5>
            <p className="text-muted small">
              Empowering residents to take ownership of their environment
              through easy reporting and collective action.
            </p>
          </div>
        </div>

        {/* Card 2 */}
        <div className="col-12 col-md-6 col-lg-3">
          <div className="feature-card p-4 text-center h-100 shadow-sm border-0 rounded-4">
            <div className="icon-circle mx-auto mb-3 bg-success-subtle">
              <ShieldCheck size={36} className="text-success" />
            </div>
            <h5 className="fw-bold mb-3">Transparency & Trust</h5>
            <p className="text-muted small">
              Every reported issue is tracked publicly — real-time status
              updates so you always know what's happening.
            </p>
          </div>
        </div>

        {/* Card 3 */}
        <div className="col-12 col-md-6 col-lg-3">
          <div className="feature-card p-4 text-center h-100 shadow-sm border-0 rounded-4">
            <div className="icon-circle mx-auto mb-3 bg-success-subtle">
              <PeopleFill size={36} className="text-success" />
            </div>
            <h5 className="fw-bold mb-3">Collaboration</h5>
            <p className="text-muted small">
              Connecting citizens, local governments, and recyclers to solve
              urban waste challenges together.
            </p>
          </div>
        </div>

        {/* Card 4 */}
        <div className="col-12 col-md-6 col-lg-3">
          <div className="feature-card p-4 text-center h-100 shadow-sm border-0 rounded-4">
            <div className="icon-circle mx-auto mb-3 bg-success-subtle">
              <Globe size={36} className="text-success" />
            </div>
            <h5 className="fw-bold mb-3">Sustainability</h5>
            <p className="text-muted small">
              Reducing waste, promoting recycling, and protecting the planet —
              step by step, city by city.
            </p>
          </div>
        </div>
      </div>

      {/* Call to action / next step */}
      <div className="text-center mt-5 pt-4">
        <p className="lead mb-4">Ready to make your city cleaner?</p>
        <Link to="/contact">
          <button className="btn btn-success btn-lg px-5 py-3 rounded-pill">
            Contact Us →
          </button>
        </Link>
      </div>
    </div>
  );
}
