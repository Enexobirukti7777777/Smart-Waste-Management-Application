// src/pages/ContactUs.jsx
import { Link } from "react-router-dom"; // ← This was missing!
import { GeoAltFill, TelephoneFill, EnvelopeFill } from "react-bootstrap-icons";

export default function ContactUs() {
  return (
    <div className="container-fluid px-3 px-md-5 py-5">
      <div className="text-center mb-5">
        <h1 className="display-5 fw-bold text-success">Contact Us</h1>
        <p className="lead text-muted mt-3">
          We're here to help. Reach out with questions, feedback, or partnership
          ideas.
        </p>
      </div>

      <div className="row justify-content-center">
        <div className="col-12 col-lg-8">
          <div className="card border-0 shadow-sm rounded-4 p-4 p-md-5">
            <div className="row g-4 text-center text-md-start">
              {/* Address */}
              <div className="col-md-4">
                <div className="d-flex flex-column align-items-center align-items-md-start gap-3">
                  <div className="rounded-circle bg-success-subtle p-3">
                    <GeoAltFill size={32} className="text-success" />
                  </div>
                  <div>
                    <h5 className="fw-bold">Our Address</h5>
                    <p className="text-muted mb-1">
                      EcoCity Headquarters
                      <br />
                      Main Street, Kebele 05
                      <br />
                      Adama, Oromia, Ethiopia
                    </p>
                  </div>
                </div>
              </div>

              {/* Phone */}
              <div className="col-md-4">
                <div className="d-flex flex-column align-items-center align-items-md-start gap-3">
                  <div className="rounded-circle bg-success-subtle p-3">
                    <TelephoneFill size={32} className="text-success" />
                  </div>
                  <div>
                    <h5 className="fw-bold">Phone</h5>
                    <p className="text-muted mb-1">
                      +251 911 234 567
                      <br />
                      Mon–Fri: 8:30 AM – 5:30 PM
                    </p>
                  </div>
                </div>
              </div>

              {/* Email */}
              <div className="col-md-4">
                <div className="d-flex flex-column align-items-center align-items-md-start gap-3">
                  <div className="rounded-circle bg-success-subtle p-3">
                    <EnvelopeFill size={32} className="text-success" />
                  </div>
                  <div>
                    <h5 className="fw-bold">Email</h5>
                    <p className="text-muted mb-1">
                      hello@ecocity.et
                      <br />
                      support@ecocity.et
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Back button */}
      <div className="text-center mt-5">
        <Link to="/" className="btn btn-outline-success px-4 py-2">
          ← Back to Home
        </Link>
      </div>
    </div>
  );
}
