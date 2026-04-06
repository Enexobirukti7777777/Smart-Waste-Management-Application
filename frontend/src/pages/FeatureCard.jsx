// src/pages/FeatureCard.jsx
import { useNavigate } from "react-router-dom";

export default function FeatureCard({
  icon: Icon,
  title,
  description,
  buttonText,
  buttonVariant = "outline-success",
  linkTo = null, // New prop: path to navigate to
  onClick = null, // Alternative: custom onClick function
}) {
  const navigate = useNavigate();

  const handleClick = () => {
    if (onClick) {
      onClick();
    } else if (linkTo) {
      navigate(linkTo);
    }
  };

  return (
    <div className="feature-card p-4 text-center h-100 shadow-sm border rounded-3 hover:shadow-md transition-all">
      <div
        className="icon-circle mx-auto mb-3 d-flex align-items-center justify-content-center bg-light rounded-circle"
        style={{ width: "70px", height: "70px" }}
      >
        <Icon size={32} className="text-success" />
      </div>

      <h5 className="fw-bold mb-3">{title}</h5>
      <p className="text-muted small mb-4">{description}</p>

      <button
        onClick={handleClick}
        className={`btn btn-${buttonVariant} rounded-pill w-100 py-2 fw-medium`}
      >
        {buttonText}
      </button>
    </div>
  );
}
