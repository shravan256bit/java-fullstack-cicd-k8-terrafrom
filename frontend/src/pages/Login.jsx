import { useState } from "react";
import { login } from "../api/auth";
import { useNavigate } from "react-router-dom";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [show, setShow] = useState(false);
  const [loading, setLoading] = useState(false);

  const navigate = useNavigate();

  const submit = async () => {
    setLoading(true);
    try {
      await login({ email, password });
      navigate("/home");
    } catch {
      alert("Invalid credentials");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page">
      <div className="card">
        <h2>Login 🔐</h2>

        <input
          placeholder="Email"
          onChange={e => setEmail(e.target.value)}
        />

        <input
          type={show ? "text" : "password"}
          placeholder="Password"
          onChange={e => setPassword(e.target.value)}
        />

        <button onClick={() => setShow(!show)}>
          {show ? "Hide Password" : "Show Password"}
        </button>

        <br /><br />

        <button onClick={submit} disabled={loading}>
          {loading ? "Logging in..." : "Login"}
        </button>

        <button
          className="link-btn"
          onClick={() => navigate("/register")}
        >
          Create new account
        </button>
      </div>
    </div>
  );
}
