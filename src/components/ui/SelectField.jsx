import React from "react";

const SelectField = ({
  label,
  name,
  value,
  onChange,
  options = [],
  required,
  error,
}) => {
  return (
    <div className="input-field">
      <label className="input-label" htmlFor={name}>
        {label} {required && "*"}
      </label>

      <select
        id={name}
        name={name}
        value={value}
        onChange={onChange}
        required={required}
        className={`input ${error ? "input-error" : ""}`}
      >
        <option value="">Select {label}</option>

        {options.map((opt, index) => (
          <option key={index} value={opt.value}>
            {opt.label}
          </option>
        ))}
      </select>

      {error && <span className="error-message">{error}</span>}
    </div>
  );
};

export default SelectField;
