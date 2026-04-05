// CheckboxCard.jsx
import React from "react";
import "../../styles/CheckboxCard.css";

const CheckboxCard = ({ label, selected, onChange }) => {
  return (
    <div
      className={`checkbox-card-container ${selected ? "is-selected" : ""}`}
      onClick={onChange}
    >
      <div className={`custom-checkbox-box ${selected ? "is-checked" : ""}`}>
        {selected && <span className="checkmark-icon">✓</span>}
      </div>
      <span className="checkbox-card-label">{label}</span>
    </div>
  );
};

export default CheckboxCard;
