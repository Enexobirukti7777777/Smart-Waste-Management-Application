import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import {
  BuildingFill,
  HouseFill,
  CheckCircleFill,
  Clock,
} from "react-bootstrap-icons";
import Button from "../components/ui/Button";
import InputField from "../components/ui/InputField";
import Card from "../components/ui/Card";
import "../styles/Signup.css";

const BASE_URL = "http://localhost:5000"; // Updated for backend

const Signup = () => {
  const [step, setStep] = useState(1);
  const [userType, setUserType] = useState("");
  const [otp, setOtp] = useState("");
  const [timeLeft, setTimeLeft] = useState(60);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errors, setErrors] = useState({});
  const [registeredUserId, setRegisteredUserId] = useState(null); // ← Important

  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    fullName: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
    city: "",
    streetAddress: "",
    homeNumber: "",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
    if (errors[name]) setErrors((prev) => ({ ...prev, [name]: "" }));
  };

  const handleOtpChange = (e) => {
    setOtp(e.target.value.replace(/\D/g, "").slice(0, 6));
  };

  const handleChoice = (type) => {
    setUserType(type);
    setStep(2);
  };

  // Validation for Step 2
  const validateStep2 = () => {
    const newErrors = {};
    if (!formData.fullName.trim()) newErrors.fullName = "Required";
    if (!formData.email.trim()) newErrors.email = "Required";
    else if (!/\S+@\S+\.\S+/.test(formData.email))
      newErrors.email = "Invalid email format";

    if (!formData.password) newErrors.password = "Required";
    else if (formData.password.length < 6)
      newErrors.password = "Password must be at least 6 characters";

    if (formData.password !== formData.confirmPassword)
      newErrors.confirmPassword = "Passwords do not match";

    if (
      formData.phone &&
      !/^\d{10,15}$/.test(formData.phone.replace(/\D/g, ""))
    ) {
      newErrors.phone = "Invalid phone number";
    }

    return newErrors;
  };

  const handleNext = () => {
    const formErrors = validateStep2();
    if (Object.keys(formErrors).length > 0) {
      setErrors(formErrors);
      return;
    }
    setStep(3);
  };

  // ====================== REGISTER + SEND OTP ======================
  const sendOtp = async () => {
    if (!formData.email) {
      alert("Email is required");
      return;
    }

    setIsSubmitting(true);
    try {
      const response = await fetch(`${BASE_URL}/api/register`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          fullName: formData.fullName,
          email: formData.email,
          phone: formData.phone,
          password: formData.password,
          userType: userType,
          city: formData.city,
          streetAddress: formData.streetAddress,
          homeNumber: formData.homeNumber,
        }),
      });

      const result = await response.json();

      if (response.ok) {
        setRegisteredUserId(result.userId); // ← Save userId from backend
        setTimeLeft(60);
        setOtp("");
        setStep(5);
        alert(`OTP sent to ${formData.email}`);
      } else {
        alert(result.message || "Failed to send OTP");
      }
    } catch (err) {
      console.error(err);
      alert(
        "Cannot connect to backend. Make sure the server is running on port 5000.",
      );
    } finally {
      setIsSubmitting(false);
    }
  };

  // ====================== VERIFY OTP ======================
  const verifyOtpAndRegister = async () => {
    if (!registeredUserId) {
      alert("Session expired. Please start over.");
      setStep(1);
      return;
    }

    if (otp.length !== 6) {
      alert("Please enter 6-digit OTP");
      return;
    }

    setIsSubmitting(true);
    try {
      const response = await fetch(`${BASE_URL}/api/verify-otp`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          userId: registeredUserId,
          otp,
        }),
      });

      const result = await response.json();

      if (response.ok) {
        const newUser = {
          name: formData.fullName,
          role: userType === "company" ? "Company Member" : "Eco Warrior",
          avatar: `https://i.pravatar.cc/48?u=${formData.email}`,
        };
        localStorage.setItem("user", JSON.stringify(newUser));
        setStep(6);
      } else {
        alert(result.message || "Invalid OTP");
      }
    } catch (err) {
      console.error(err);
      alert("Verification failed. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const resendOtp = () => {
    setOtp("");
    sendOtp(); // Reuses the same data
  };

  // OTP Timer
  useEffect(() => {
    if (step === 5 && timeLeft > 0) {
      const timer = setTimeout(() => setTimeLeft(timeLeft - 1), 1000);
      return () => clearTimeout(timer);
    } else if (timeLeft === 0 && step === 5) {
      alert("OTP expired. Please request a new one.");
      setStep(4);
    }
  }, [timeLeft, step]);

  const goBack = () => {
    if (step === 2) {
      setStep(1);
      setUserType("");
    } else if (step === 3) setStep(2);
    else if (step === 4 || step === 5) setStep(3);
    else if (step === 6) navigate("/login");
  };

  // Step 1: User Type Choice
  if (step === 1) {
    return (
      <div
        className="signup-page min-vh-100 d-flex align-items-center justify-content-center py-5"
        style={{ backgroundColor: "#3C8D3E" }}
      >
        <div className="container">
          <div className="text-center mb-5">
            <img
              src="/recycle-logo.jpg"
              alt="Logo"
              style={{ width: "90px" }}
              className="mb-4"
            />
            <h1 className="display-5 fw-bold text-white">Saving Our Planet</h1>
            <p className="lead text-white-50">Choose how you want to join</p>
          </div>
          <div className="row justify-content-center g-4">
            <div className="col-12 col-md-5">
              <Card className="h-100">
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
            <div className="col-12 col-md-5">
              <Card className="h-100">
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
        </div>
      </div>
    );
  }

  // Step 4: Send OTP Screen
  if (step === 4) {
    return (
      <div
        className="signup-page min-vh-100 d-flex align-items-center justify-content-center py-5"
        style={{ backgroundColor: "#f8fff8" }}
      >
        <Card style={{ maxWidth: "420px", width: "100%" }}>
          <div className="text-center mb-4">
            <img src="/recycle-logo.jpg" alt="Logo" style={{ width: "80px" }} />
            <h2 className="fw-bold text-success mt-3">Email Verification</h2>
            <p className="text-muted mt-3">
              Click below to receive OTP at <strong>{formData.email}</strong>
            </p>
          </div>
          <Button
            text={isSubmitting ? "Sending OTP..." : "Send OTP"}
            variant="success"
            className="w-100 py-3"
            onClick={sendOtp}
            disabled={isSubmitting}
          />
          <div className="text-center mt-4">
            <button className="btn btn-link text-muted" onClick={goBack}>
              ← Back to Address
            </button>
          </div>
        </Card>
      </div>
    );
  }

  // Step 5: Enter OTP
  if (step === 5) {
    return (
      <div
        className="signup-page min-vh-100 d-flex align-items-center justify-content-center py-5"
        style={{ backgroundColor: "#f8fff8" }}
      >
        <Card style={{ maxWidth: "420px", width: "100%" }}>
          <div className="text-center mb-4">
            <img src="/recycle-logo.jpg" alt="Logo" style={{ width: "80px" }} />
            <h2 className="fw-bold text-success mt-3">Enter OTP</h2>
            <p className="text-muted">We sent a 6-digit code to your email</p>
          </div>
          <InputField
            label="6-Digit OTP"
            type="text"
            placeholder="Enter the OTP code"
            value={otp}
            onChange={handleOtpChange}
            maxLength={6}
          />
          <div className="d-flex align-items-center justify-content-center gap-2 my-3 text-muted">
            <Clock size={18} />
            <span>Expires in {timeLeft} seconds</span>
          </div>
          <Button
            text={
              isSubmitting
                ? "Verifying..."
                : "Verify OTP & Complete Registration"
            }
            variant="success"
            className="w-100 py-3"
            onClick={verifyOtpAndRegister}
            disabled={isSubmitting || otp.length !== 6}
          />
          <div className="text-center mt-3">
            <button
              className="btn btn-link text-success"
              onClick={resendOtp}
              disabled={isSubmitting}
            >
              Resend OTP
            </button>
          </div>
          <div className="text-center mt-2">
            <button className="btn btn-link text-muted" onClick={goBack}>
              ← Back
            </button>
          </div>
        </Card>
      </div>
    );
  }

  // Step 6: Success
  if (step === 6) {
    return (
      <div
        className="min-vh-100 d-flex align-items-center justify-content-center py-5"
        style={{ backgroundColor: "#f8fff8" }}
      >
        <div className="text-center">
          <CheckCircleFill size={110} className="text-success mb-4" />
          <h2 className="fw-bold text-success mb-3">
            Registration Successful!
          </h2>
          <p className="text-muted mb-4">
            Your account has been created and verified.
          </p>
          <Button
            text="Go to Login"
            variant="success"
            className="px-5 py-3"
            onClick={() => navigate("/login")}
          />
        </div>
      </div>
    );
  }

  // Steps 2 & 3 - Form
  return (
    <div
      className="signup-page min-vh-100 d-flex align-items-center justify-content-center py-5"
      style={{ backgroundColor: "#f8fff8" }}
    >
      <Card style={{ maxWidth: "420px", width: "100%" }}>
        <div className="text-center mb-4">
          <img src="/recycle-logo.jpg" alt="Logo" style={{ width: "80px" }} />
          <h2 className="fw-bold text-success mt-3">
            {step === 2
              ? `Create ${userType === "company" ? "Company" : "Homeowner"} Account`
              : "Address Information"}
          </h2>
        </div>

        <form>
          {step === 2 && (
            <>
              <InputField
                label={userType === "company" ? "Company Name" : "Full Name"}
                name="fullName"
                type="text"
                placeholder={
                  userType === "company"
                    ? "Company name"
                    : "Enter your full name"
                }
                value={formData.fullName}
                onChange={handleChange}
                error={errors.fullName}
              />
              <InputField
                label="Email Address"
                name="email"
                type="email"
                placeholder="Enter your email"
                value={formData.email}
                onChange={handleChange}
                error={errors.email}
              />
              <InputField
                label="Phone Number"
                name="phone"
                type="tel"
                placeholder="Enter phone number"
                value={formData.phone}
                onChange={handleChange}
                error={errors.phone}
              />
              <InputField
                label="Password"
                name="password"
                type="password"
                placeholder="Enter password"
                value={formData.password}
                onChange={handleChange}
                error={errors.password}
              />
              <InputField
                label="Confirm Password"
                name="confirmPassword"
                type="password"
                placeholder="Confirm password"
                value={formData.confirmPassword}
                onChange={handleChange}
                error={errors.confirmPassword}
              />

              <Button
                text="Next"
                variant="success"
                className="w-100 mt-4 py-3"
                onClick={handleNext}
              />
            </>
          )}

          {step === 3 && (
            <>
              <InputField
                label="City"
                name="city"
                type="text"
                placeholder="Enter your city"
                value={formData.city}
                onChange={handleChange}
              />
              <InputField
                label="Street Address"
                name="streetAddress"
                type="text"
                placeholder="Enter street address"
                value={formData.streetAddress}
                onChange={handleChange}
              />
              <InputField
                label="Home Number"
                name="homeNumber"
                type="text"
                placeholder="Enter home number"
                value={formData.homeNumber}
                onChange={handleChange}
              />

              <Button
                text="Continue to OTP Verification"
                variant="success"
                className="w-100 mt-4 py-3"
                onClick={() => setStep(4)}
              />
            </>
          )}
        </form>

        <div className="text-center mt-3">
          <button className="btn btn-link text-muted" onClick={goBack}>
            ← Back
          </button>
        </div>
      </Card>
    </div>
  );
};

export default Signup;
