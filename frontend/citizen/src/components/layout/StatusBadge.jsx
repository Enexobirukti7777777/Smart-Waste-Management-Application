import React from "react";
import "../../styles/StatusBadge.css";

const StatusBadge = ({ status }) => {
  return <span className={`badge ${status.toLowerCase()}`}>{status}</span>;
};

export default StatusBadge;
