import { useEffect } from "react";
import { useLocation, Link } from "react-router-dom";
import FeatureCard from "./FeatureCard";
import { MegaphoneFill, Recycle, BellFill } from "react-bootstrap-icons";

import "../styles/index.css";

export default function Home() {
  const location = useLocation();

  useEffect(() => {
    if (location.hash) {
      const id = location.hash.replace("#", "");
      const element = document.getElementById(id);
      if (element) {
        element.scrollIntoView({ behavior: "smooth" });
      }
    }
  }, [location]);

  return (
    <div className="home-container">
      {/* HERO SECTION */}
      <div className="leaf-bg position-relative">
        <div className="container py-5">
          <div className="row justify-content-center">
            <div className="col-12 col-xl-10">
              {/* Welcome Card */}
              <div className="welcome-card text-center mb-5 p-5">
                <h1 className="display-4 fw-bold text-success mb-4">
                  Welcome to City Kuralewo!
                </h1>
                <p className="lead text-muted">
                  The best designed center to become uppercaring in its
                  formation.
                </p>
              </div>

              {/* Feature Cards */}
              <div className="row g-4">
                <div className="col-lg-4 col-md-6">
                  <FeatureCard
                    icon={MegaphoneFill}
                    title="Pickup Request"
                    description="Send a pickup request and our driver will come to your location."
                    buttonText="Request"
                    buttonVariant="success"
                    linkTo="/pickup-request"
                  />
                </div>
                <div className="col-lg-4 col-md-6">
                  <FeatureCard
                    icon={Recycle}
                    title="Track Collectors"
                    description="Track the location and status of collectors in real time."
                    buttonText="Locate"
                    buttonVariant="outline-primary"
                  />
                </div>
                <div className="col-lg-4 col-md-6">
                  <FeatureCard
                    icon={BellFill}
                    title="Stay Updated"
                    description="Keep up to date on all the latest support status."
                    buttonText="View Updates"
                    buttonVariant="outline-warning"
                  />
                </div>
              </div>

              {/* CTA Button */}
              <div className="text-center mt-5">
                <Link to="/login">
                  <button className="cta-btn text-white fs-5 px-5 py-3 shadow-lg">
                    Get Started
                  </button>
                </Link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
