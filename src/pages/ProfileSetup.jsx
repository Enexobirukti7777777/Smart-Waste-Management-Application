import React, { useState } from "react";
import InputField from "../components/ui/InputField";
import SelectField from "../components/ui/SelectField";
import Button from "../components/ui/Button";
import Card from "../components/ui/Card";
import "../styles/ProfileSetup.css";

const ProfileSetup = () => {
  const [formData, setFormData] = useState({
    subcity: "",
    district: "",
    houseNumber: "",
    userType: "",
    wasteType: "",
  });

  const [errors, setErrors] = useState({});

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const validate = () => {
    const newErrors = {};

    if (!formData.subcity) newErrors.subcity = "Subcity is required";
    if (!formData.district) newErrors.district = "District is required";
    if (!formData.houseNumber)
      newErrors.houseNumber = "House number is required";
    if (!formData.userType) newErrors.userType = "User type is required";

    return newErrors;
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    const validationErrors = validate();
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      return;
    }

    // Save to localStorage (temporary)
    localStorage.setItem("userProfile", JSON.stringify(formData));

    console.log("Profile Saved:", formData);

    // TODO: navigate to dashboard or profile page
    // navigate("/dashboard");
  };

  return (
    <div className="profile-page">
      <Card>
        <h2>Complete Your Profile</h2>

        <form onSubmit={handleSubmit}>
          {/* Address Section */}
          <div className="form-section">
            <h4>Address Information</h4>

            <InputField
              label="Subcity"
              name="subcity"
              value={formData.subcity}
              onChange={handleChange}
              error={errors.subcity}
              required
            />

            <InputField
              label="District (Woreda)"
              name="district"
              value={formData.district}
              onChange={handleChange}
              error={errors.district}
              required
            />

            <InputField
              label="House Number"
              name="houseNumber"
              value={formData.houseNumber}
              onChange={handleChange}
              error={errors.houseNumber}
              required
            />
          </div>

          {/* User Type */}
          <div className="form-section">
            <SelectField
              label="User Type"
              name="userType"
              value={formData.userType}
              onChange={handleChange}
              options={[
                { label: "Home", value: "home" },
                { label: "Business", value: "business" },
              ]}
            />
            {errors.userType && (
              <p className="error-message">{errors.userType}</p>
            )}
          </div>

          {/* Waste Type */}
          <div className="form-section">
            <SelectField
              label="Waste Type (Optional)"
              name="wasteType"
              value={formData.wasteType}
              onChange={handleChange}
              options={[
                { label: "Organic", value: "organic" },
                { label: "Plastic", value: "plastic" },
                { label: "Metal", value: "metal" },
                { label: "Mixed", value: "mixed" },
              ]}
            />
          </div>

          <Button text="Save & Continue" type="submit" />
        </form>
      </Card>
    </div>
  );
};

export default ProfileSetup;
