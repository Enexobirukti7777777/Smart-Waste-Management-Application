// InputField.jsx
import React from "react";
import "../../styles/InputField.css";

const InputField = ({ label, placeholder, value, onChange, type = "text" }) => {
  return (
    <div className="input-field-wrapper">
      <label className="field-label">{label}</label>
      <input
        className="styled-input"
        type={type}
        value={value}
        onChange={onChange}
        placeholder={placeholder}
      />
    </div>
  );
};

export default InputField;
