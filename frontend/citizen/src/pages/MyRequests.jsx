import React from "react";
import { useNavigate } from "react-router-dom"; // 1. Import the hook
import Button from "../components/ui/Button";
import "../styles/MyRequests.css";

const MyRequest = () => {
  const navigate = useNavigate(); // 2. Initialize the navigate function

  const statusSteps = [
    {
      id: 1,
      label: "Request Submitted",
      time: "09:00 AM",
      status: "completed",
    },
    {
      id: 2,
      label: "Collector Assigned",
      time: "10:30 AM",
      status: "completed",
    },
    { id: 3, label: "In Progress", time: "Pending", status: "active" },
    { id: 4, label: "Completed", time: "--:--", status: "upcoming" },
  ];

  return (
    <div className="my-request-page">
      <div className="status-card">
        <h2 className="status-header">Track My Request</h2>

        <div className="timeline-wrapper">
          {statusSteps.map((step, index) => (
            <div key={step.id} className="timeline-item">
              <div className="timeline-left">
                <div className={`status-node ${step.status}`}>
                  {step.status === "completed" ? "✓" : step.id}
                </div>
                {index !== statusSteps.length - 1 && (
                  <div
                    className={`status-connector ${step.status === "completed" ? "is-filled" : ""}`}
                  ></div>
                )}
              </div>
              <div className="timeline-content">
                <p className={`status-label ${step.status}`}>{step.label}</p>
                <span className="status-timestamp">{step.time}</span>
              </div>
            </div>
          ))}
        </div>

        <div className="my-request-footer">
          {/* 3. Update the onClick to navigate to your dashboard path */}
          <Button
            text="Back to Dashboard"
            onClick={() => navigate("/dashboard")}
            variant="secondary"
          />
        </div>
      </div>
    </div>
  );
};

export default MyRequest;
