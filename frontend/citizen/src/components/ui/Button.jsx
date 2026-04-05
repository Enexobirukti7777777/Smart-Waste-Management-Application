// Button.jsx
import React from "react";
import "../../styles/Button.css";

const Button = ({ text, onClick, variant = "primary" }) => {
  return (
    <button className={`base-button ${variant}`} onClick={onClick}>
      {text}
    </button>
  );
};

export default Button;
