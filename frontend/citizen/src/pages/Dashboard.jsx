import React from "react";
import { useNavigate } from "react-router-dom";
import Navbar from "../components/layout/Navbar";
import "../styles/dashboard.css";

const Dashboard = () => {
  const navigate = useNavigate();

  const cards = [
    {
      title: "Pickup Request",
      description: "Create a new waste pickup request",
      path: "/create-request",
    },
    {
      title: "Track Requests",
      description: "View and track your requests",
      path: "/requests",
    },
    {
      title: "Reward",
      description: "View your rewards and points",
      path: "/rewards",
    },
    {
      title: "AI Chatbot",
      description: "Get help from assistant",
      path: "/chat",
    },
  ];

  return (
    <div>
      <div className="dashboard-container">
        <div className="card-grid">
          {cards.map((card, index) => (
            <div
              key={index}
              className="dashboard-card"
              onClick={() => navigate(card.path)}
            >
              <h2>{card.title}</h2>
              <p>{card.description}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
