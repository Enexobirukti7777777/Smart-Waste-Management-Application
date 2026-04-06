// src/components/PickupRequest.jsx
import { useState } from "react";
import { ArrowLeft, Bell } from "react-bootstrap-icons";
import { useNavigate } from "react-router-dom";
import "../styles/pickupRequest.css";

export default function PickupRequest() {
  const navigate = useNavigate();

  const [selectedTypes, setSelectedTypes] = useState({
    recyclable: false,
    nonRecyclable: false,
  });

  const [materialType, setMaterialType] = useState(""); // Only for recyclable
  const [weight, setWeight] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const toggleType = (type) => {
    setSelectedTypes((prev) => ({
      ...prev,
      [type]: !prev[type],
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!selectedTypes.recyclable && !selectedTypes.nonRecyclable) {
      alert("Please select at least one waste type");
      return;
    }
    if (!weight) {
      alert("Please enter the total weight in kg");
      return;
    }

    setIsSubmitting(true);

    setTimeout(() => {
      const types = [];
      if (selectedTypes.recyclable) types.push("Recyclable");
      if (selectedTypes.nonRecyclable) types.push("Non-Recyclable");

      alert(
        `✅ Pickup request submitted successfully!\n\nTypes: ${types.join(" + ")}\nWeight: ${weight} kg`,
      );

      // Reset form
      setSelectedTypes({ recyclable: false, nonRecyclable: false });
      setMaterialType("");
      setWeight("");
      navigate("/");

      setIsSubmitting(false);
    }, 1500);
  };

  const hasRecyclable = selectedTypes.recyclable;

  return (
    <div className="pickup-request-page min-vh-100 d-flex align-items-center justify-content-center py-5">
      <div className="form-card">
        {/* Header */}
        <div className="text-center mb-4">
          <h2 className="kuralewo-title">Kuralewo</h2>
          <p className="subtitle">Request waste pickup</p>
        </div>

        <form onSubmit={handleSubmit}>
          {/* Waste Types - Now using checkboxes for multiple selection */}
          <div className="mb-4">
            <label className="form-label">Type of Waste</label>
            <div className="radio-group">
              <label
                className={`radio-option ${selectedTypes.recyclable ? "selected" : ""}`}
                onClick={() => toggleType("recyclable")}
              >
                <input
                  type="checkbox"
                  checked={selectedTypes.recyclable}
                  readOnly
                />
                <span>Recyclable</span>
              </label>

              <label
                className={`radio-option ${selectedTypes.nonRecyclable ? "selected" : ""}`}
                onClick={() => toggleType("nonRecyclable")}
              >
                <input
                  type="checkbox"
                  checked={selectedTypes.nonRecyclable}
                  readOnly
                />
                <span>Non-Recyclable</span>
              </label>
            </div>
            <small className="text-muted d-block mt-2">
              You can select both if needed
            </small>
          </div>

          {/* Material Type - Only show if Recyclable is selected */}
          {hasRecyclable && (
            <div className="mb-4">
              <label className="form-label">Recyclable Type</label>
              <div className="radio-group">
                {["Plastic", "Metal", "Others"].map((type) => (
                  <label
                    key={type}
                    className={`radio-option ${materialType === type ? "selected" : ""}`}
                    onClick={() => setMaterialType(type)}
                  >
                    <input
                      type="radio"
                      name="material"
                      checked={materialType === type}
                      readOnly
                    />
                    <span>{type}</span>
                  </label>
                ))}
              </div>
            </div>
          )}

          {/* Weight Input */}
          <div className="mb-4">
            <label className="form-label">Total Weight in kg</label>
            <input
              type="number"
              step="0.1"
              value={weight}
              onChange={(e) => setWeight(e.target.value)}
              placeholder="Enter total weight"
              className="form-input"
              required
            />
            <small className="text-muted">
              Combined weight of all selected types
            </small>
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            disabled={isSubmitting}
            className="submit-btn w-100"
          >
            {isSubmitting ? "Submitting..." : "Submit Pickup Request"}
          </button>
        </form>

        <div className="text-center mt-4">
          <button
            className="btn btn-link text-muted"
            onClick={() => navigate(-1)}
          >
            ← Back to Home
          </button>
        </div>
      </div>
    </div>
  );
}
