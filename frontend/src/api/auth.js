import axios from "axios";

const API = axios.create({
  baseURL: process.env.REACT_APP_API_BASE_URL
});

export const register = (data) => API.post("/register", data);
export const login = (data) => API.post("/login", data);