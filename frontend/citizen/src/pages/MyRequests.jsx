import React from "react";
import RequestCard from "../components/layout/RequestCard";
import "../styles/MyRequests.css";

const MyRequests = () => {
  const testData = {
    id: 1,
    wasteType: "Plastic",
    location: "Adama",
    quantity: "2 bags",
    status: "Pending",
  };

  return (
    <div>
      <h2>My Requests</h2>

      <RequestCard request={testData} />
    </div>
  );
};

export default MyRequests;
