import { useState } from "react";
import { useNavigate } from "react-router-dom";

export default function Home() {
  const [likes, setLikes] = useState(0);
  const navigate = useNavigate();

  return (
    <div className="page">
      <div className="card">
        <h2>Home 🏠</h2>
        <p>Welcome! This is you are logined!!</p>

        <p>👍 Likes: {likes}</p>
        <button onClick={() => setLikes(likes + 1)}>
          Like
        </button>

        <br /><br />

        <button onClick={() => navigate("/login")}>
          Logout
        </button>
      </div>
    </div>
  );
}
