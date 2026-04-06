import React from "react";

const InputField = ({
  label,
  type = "text",
  name,
  placeholder,
  value,
  onChange,
  error,
  required,
}) => {
  return (
    <div className="input-field">
      <label className="input-label" htmlFor={name}>
        {label} {required && "*"}
      </label>

      <input
        id={name}
        type={type}
        name={name}
        placeholder={placeholder}
        value={value}
        onChange={onChange}
        required={required}
        className={`input ${error ? "input-error" : ""}`}
      />

      {error && <span className="error-message">{error}</span>}
    </div>
  );
};

export default InputField;
