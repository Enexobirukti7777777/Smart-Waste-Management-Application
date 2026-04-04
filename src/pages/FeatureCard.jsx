// src/pages/FeatureCard.jsx  (or wherever you keep it)

export default function FeatureCard({
  icon: Icon,
  title,
  description,
  buttonText,
  buttonVariant = "outline-success",
}) {
  return (
    <div className="feature-card p-4 text-center h-100">
      <div className="icon-circle mx-auto mb-3">
        <Icon size={32} />
      </div>
      <h5 className="fw-bold mb-3">{title}</h5>
      <p className="text-muted small mb-4">{description}</p>

      <button
        className={`btn btn-${buttonVariant} rounded-pill w-100 py-2 fw-medium`}
      >
        {buttonText}
      </button>
    </div>
  );
}
