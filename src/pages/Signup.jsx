import React, { useState } from "react";
import Button from "../components/ui/Button";
import InputField from "../components/ui/InputField";
import Card from "../components/ui/Card";
import "../styles/Signup.css";
import { useNavigate } from "react-router-dom";
import { BuildingFill, HouseFill } from "react-bootstrap-icons";

const Signup = () => {
  const [step, setStep] = useState("choice"); // "choice" or "form"
  const [userType, setUserType] = useState(""); // "home" or "company"
  const [formData, setFormData] = useState({
    fullName: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
  });
  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const navigate = useNavigate();

  const handleChoice = (type) => {
    setUserType(type);
    setStep("form");
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: "" }));
    }
  };

  const validateForm = () => {
    const newErrors = {};
    if (!formData.fullName.trim()) newErrors.fullName = "Full name is required";
    if (!formData.email.trim()) newErrors.email = "Email is required";
    else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = "Email is invalid";
    }
    if (!formData.password) {
      newErrors.password = "Password is required";
    } else if (formData.password.length < 6) {
      newErrors.password = "Password must be at least 6 characters";
    }
    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = "Passwords do not match";
    }
    return newErrors;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const formErrors = validateForm();
    if (Object.keys(formErrors).length > 0) {
      setErrors(formErrors);
      return;
    }
    setIsSubmitting(true);
    await new Promise((resolve) => setTimeout(resolve, 1000));
    console.log(`Form submitted as ${userType}:`, formData);
    setIsSubmitting(false);
    navigate("/profile-setup");
  };

  const goBack = () => {
    setStep("choice");
    setUserType("");
  };

  // ====================== CHOICE SCREEN ======================
  if (step === "choice") {
    return (
      <div
        className="signup-page min-vh-100 d-flex align-items-center justify-content-center py-5"
        style={{ backgroundColor: "#3C8D3E" }}
      >
        <div className="container">
          <div className="text-center mb-5">
            <h1 className="display-5 fw-bold text-white">Saving Our Planet</h1>
            <p className="lead text-white">Choose an option to sign up</p>
          </div>

          <div className="row justify-content-center g-4">
            {/* Company Card */}
            <div className="col-12 col-md-5">
              <Card>
                <div
                  className="text-center p-4"
                  onClick={() => handleChoice("company")}
                  style={{ cursor: "pointer" }}
                >
                  <BuildingFill size={70} className="text-success mb-3" />
                  <h4 className="fw-bold">Company</h4>
                  <p className="text-muted">Sign up as a company</p>
                  <Button
                    text="Continue as Company"
                    variant="success"
                    className="w-100 mt-3"
                  />
                </div>
              </Card>
            </div>

            {/* Homeowner Card */}
            <div className="col-12 col-md-5">
              <Card>
                <div
                  className="text-center p-4"
                  onClick={() => handleChoice("home")}
                  style={{ cursor: "pointer" }}
                >
                  <HouseFill size={70} className="text-success mb-3" />
                  <h4 className="fw-bold">Home</h4>
                  <p className="text-muted">Sign up as a homeowner</p>
                  <Button
                    text="Continue as Homeowner"
                    variant="success"
                    className="w-100 mt-3"
                  />
                </div>
              </Card>
            </div>
          </div>

          <div className="text-center mt-4">
            <p className="text-white">
              Already have an account?{" "}
              <a href="/login" className="login-link text-white fw-bold">
                Login
              </a>
            </p>
          </div>
        </div>
      </div>
    );
  }

  // ====================== FORM SCREEN ======================
  return (
    <div className="signup-page">
      <Card>
        <div className="signup-header">
          <h1 className="logo">Kuralewo</h1>
          <h2 className="signup-title">
            Create {userType === "company" ? "Company" : "Homeowner"} Account
          </h2>
          <p className="signup-description">
            {userType === "company"
              ? "Join as a company and help manage waste collection efficiently."
              : "Create an account to report waste and help keep your city clean."}
          </p>
        </div>

        <button className="btn btn-link text-muted mb-3" onClick={goBack}>
          ← Back to selection
        </button>

        <form onSubmit={handleSubmit} className="signup-form">
          <InputField
            label={userType === "company" ? "Company Name" : "Full Name"}
            name="fullName"
            type="text"
            placeholder={
              userType === "company"
                ? "Enter company name"
                : "Enter your full name"
            }
            value={formData.fullName}
            onChange={handleChange}
            error={errors.fullName}
          />
          <InputField
            label="Email"
            name="email"
            type="email"
            placeholder="Enter your email"
            value={formData.email}
            onChange={handleChange}
            error={errors.email}
          />
          <InputField
            label="Phone"
            name="phone"
            type="tel"
            placeholder="Enter your phone number"
            value={formData.phone}
            onChange={handleChange}
          />
          <InputField
            label="Password"
            name="password"
            type="password"
            placeholder="Create a password"
            value={formData.password}
            onChange={handleChange}
            error={errors.password}
          />
          <InputField
            label="Confirm Password"
            name="confirmPassword"
            type="password"
            placeholder="Confirm your password"
            value={formData.confirmPassword}
            onChange={handleChange}
            error={errors.confirmPassword}
          />

          <Button
            text={isSubmitting ? "Creating Account..." : "Sign Up"}
            type="submit"
            disabled={isSubmitting}
          />

          <div className="signup-footer">
            <p>
              Already have an account?{" "}
              <a href="/login" className="login-link">
                Login
              </a>
            </p>
          </div>
        </form>
      </Card>
    </div>
  );
};

export default Signup;
