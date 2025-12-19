import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import db from "../config/db.js";

const router = express.Router();
// 📌 API ĐĂNG KÝ (SIGN UP)
router.post("/signup", async (req, res) => {
  try {
    const { TaiKhoan, MatKhau, HoTen, Email, DienThoai, DiaChi, VaiTro } =
      req.body;

    if (!TaiKhoan || !MatKhau || !HoTen)
      return res.status(400).json({ message: "Thiếu dữ liệu!" });

    const [exists] = await db.query("SELECT * FROM user WHERE TaiKhoan = ?", [
      TaiKhoan,
    ]);

    if (exists.length > 0)
      return res.status(409).json({ message: "Tài khoản đã tồn tại!" });

    //const MaUser = "U" + Math.floor(10000 + Math.random() * 90000);

    // Lưu mật khẩu thẳng vào DB (KHÔNG MÃ HÓA)
    await db.query(
      `INSERT INTO user 
      ( TaiKhoan, MatKhau, HoTen, Email, DienThoai, DiaChi, VaiTro) 
      VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [TaiKhoan, MatKhau, HoTen, Email, DienThoai, DiaChi, VaiTro]
    );

    res.json({ message: "Đăng ký thành công!" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server!" });
  }
});

// 📌 API ĐĂNG NHẬP (LOGIN)
router.post("/login", async (req, res) => {
  try {
    console.log("Body login:", req.body);
    const { TaiKhoan, MatKhau } = req.body;

    const [users] = await db.query("SELECT * FROM user WHERE TaiKhoan = ?", [
      TaiKhoan,
    ]);
    console.log("Users found:", users);

    if (users.length === 0)
      return res.status(404).json({ message: "Không tìm thấy tài khoản!" });

    const user = users[0];
    console.log("User:", user);

    const isMatch = MatKhau === user.MatKhau;
    console.log("Password match:", isMatch);

    if (!isMatch) return res.status(401).json({ message: "Sai mật khẩu!" });

    const token = jwt.sign(
      {
        MaUser: user.MaUser,
        VaiTro: user.VaiTro,
      },
      process.env.JWT_SECRET,
      { expiresIn: "24h" }
    );

    res.json({
      message: "Đăng nhập thành công!",
      token,
      user: {
        MaUser: user.MaUser,
        HoTen: user.HoTen,
        VaiTro: user.VaiTro,
      },
    });
  } catch (err) {
    console.error("Lỗi login:", err);
    res.status(500).json({ message: "Lỗi server!" });
  }
});

// QUAN TRỌNG: ESM phải export default
export default router;
