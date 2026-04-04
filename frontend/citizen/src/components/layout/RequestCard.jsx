import React from "react";
import { useNavigate } from "react-router-dom";
import StatusBadge from "./StatusBadge";
import "../../styles/RequestCard.css";

const RequestCard = ({ request }) => {
  const navigate = useNavigate();

  return (
    <div
      className="request-card"
      onClick={() => navigate(`/request/${request.id}`)}
    >
      <h3>{request.wasteType}</h3>
      <p>Location: {request.location}</p>
      <p>Quantity: {request.quantity}</p>

      <StatusBadge status={request.status} />
    </div>
  );
};

export default RequestCard;
