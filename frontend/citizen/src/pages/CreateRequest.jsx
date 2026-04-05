import React, { useState } from "react";
import { useNavigate } from "react-router-dom"; // Import useNavigate
import CheckboxCard from "../components/ui/CheckboxCard";
import InputField from "../components/ui/InputField";
import Button from "../components/ui/Button";
import "../styles/CreateRequest.css";

const CreateRequest = () => {
  const navigate = useNavigate(); // Initialize navigation

  // Logic for allowing multiple categories (Recyclable and Non-Recyclable)
  const [categories, setCategories] = useState({
    recyclable: false,
    nonRecyclable: false,
  });

  // Logic for multiple waste types
  const [wasteTypes, setWasteTypes] = useState({
    plastic: false,
    metal: false,
    others: false,
  });

  const [weight, setWeight] = useState("");
  const [isSubmitted, setIsSubmitted] = useState(false);

  const toggleCategory = (key) => {
    setCategories((prev) => ({ ...prev, [key]: !prev[key] }));
  };

  const toggleType = (key) => {
    setWasteTypes((prev) => ({ ...prev, [key]: !prev[key] }));
  };

  const handleSubmit = () => {
    const hasCategory = Object.values(categories).some((val) => val === true);
    const hasType = Object.values(wasteTypes).some((val) => val === true);

    if (hasCategory && hasType && weight) {
      setIsSubmitted(true);
    } else {
      alert("Please fill in all fields before submitting.");
    }
  };

  // SUCCESS VIEW (Triggered after Submit)
  if (isSubmitted) {
    return (
      <div className="request-success-container">
        <div className="success-icon-wrapper">✓</div>
        <h2 className="success-message">
          Your order is submitted successfully!
        </h2>
        <div className="success-actions">
          {/* Modified to navigate to my-requests page */}
          <Button text="Show Status" onClick={() => navigate("/requests")} />
        </div>
      </div>
    );
  }

  // MAIN FORM VIEW
  return (
    <div className="create-request-page">
      <div className="request-form-card">
        <h1 className="request-page-title">Pickup Request</h1>

        {/* Step 1: Category Selection */}
        <div className="request-section category-group">
          <CheckboxCard
            label="Recyclable"
            selected={categories.recyclable}
            onChange={() => toggleCategory("recyclable")}
          />
          <CheckboxCard
            label="Non-Recyclable"
            selected={categories.nonRecyclable}
            onChange={() => toggleCategory("nonRecyclable")}
          />
        </div>

        {/* Step 2: Waste Type Selection */}
        <div className="request-section type-list">
          <h3 className="request-section-label">Type</h3>
          {["plastic", "metal", "others"].map((type) => (
            <label key={type} className="type-option">
              <input
                type="checkbox"
                checked={wasteTypes[type]}
                onChange={() => toggleType(type)}
              />
              <span className="type-text">{type}</span>
            </label>
          ))}
        </div>

        {/* Step 3: Weight Entry */}
        <InputField
          label="weight in kg"
          type="number"
          placeholder="0.0"
          value={weight}
          onChange={(e) => setWeight(e.target.value)}
        />

        {/* Step 4: Page Actions */}
        <div className="request-form-buttons">
          <Button text="Submit" onClick={handleSubmit} />
          {/* Modified to navigate to my-requests page */}
          <Button
            text="Show Status"
            variant="secondary"
            onClick={() => navigate("/my-requests")}
          />
        </div>
      </div>
    </div>
  );
};

export default CreateRequest;
