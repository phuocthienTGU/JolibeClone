import React, { createContext, useState, useEffect } from "react";
import axios from "axios";

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios
      .get("http://localhost:5000/api/auth/me", { withCredentials: true })
      .then((res) => {
        if (res.data.loggedIn) setUser(res.data.user);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  const login = async (taikhoan, matkhau) => {
    const res = await axios.post(
      "http://localhost:5000/api/auth/login",
      { taikhoan, matkhau },
      { withCredentials: true }
    );
    setUser(res.data.user);
    return res.data;
  };

  const logout = async () => {
    await axios.post(
      "http://localhost:5000/api/auth/logout",
      {},
      { withCredentials: true }
    );
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, loading }}>
      {children}
    </AuthContext.Provider>
  );
};
