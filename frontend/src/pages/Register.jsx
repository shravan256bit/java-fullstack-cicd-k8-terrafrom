import { useState } from "react";
import { register } from "../api/auth";
import { useNavigate } from "react-router-dom";

export default function Register() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const strength =
    password.length < 4 ? "Weak" :
    password.length < 8 ? "Medium" : "Strong";

  const submit = async () => {
    await register({ email, password });
    alert("Registered successfully");
    navigate("/login");
  };

  return (
    <div className="page">
      <div className="card">
        <h2>Register 📝</h2>

        <input
          placeholder="Email"
          onChange={e => setEmail(e.target.value)}
        />

        <input
          type="password"
          placeholder="Password"
          onChange={e => setPassword(e.target.value)}
        />

        <p>Password strength: <b>{strength}</b></p>

        <button onClick={submit}>Register</button>

        <button
          className="link-btn"
          onClick={() => navigate("/login")}
        >
          Back to Login
        </button>
      </div>
    </div>
  );
}
