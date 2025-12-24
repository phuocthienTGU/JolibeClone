import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import db from "../config/db.js";

const router = express.Router();

router.get("/", (req, res) => {
  res.json({
    status: "OK",
    message: "Gio hang API dang hoat dong",
    huongDan: "Dung /api/giohang/user/:maUser",
  });
});

// 📌 API ĐĂNG KÝ (SIGN UP)
router.post("/signup", async (req, res) => {
  try {
    const { TaiKhoan, MatKhau, HoTen, Email, DienThoai, DiaChi, MaXa, VaiTro } =
      req.body;

    if (!TaiKhoan || !MatKhau || !HoTen) {
      return res.status(400).json({ message: "Thiếu dữ liệu!" });
    }

    const [exists] = await db.query("SELECT * FROM user WHERE TaiKhoan = ?", [
      TaiKhoan,
    ]);
    if (exists.length > 0)
      return res.status(409).json({ message: "Tài khoản đã tồn tại!" });

    await db.query(
      `INSERT INTO user 
      (TaiKhoan, MatKhau, HoTen, Email, DienThoai, DiaChi, MaXa, VaiTro) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        TaiKhoan,
        MatKhau,
        HoTen,
        Email,
        DienThoai,
        DiaChi || null,
        MaXa || null,
        VaiTro,
      ]
    );

    res.json({ message: "Đăng ký thành công!" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server!" });
  }
});

// ================= ADMIN =================

// ADMIN - lấy danh sách người dùng
router.get("/admin/users", async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT 
        MaUser,
        TaiKhoan,
        HoTen,
        Email,
        DienThoai,

        DiaChi,
        VaiTro,
        NgayTao,
        MaXa
      FROM user
      ORDER BY MaUser DESC
    `);

    res.json(rows); // ⚠️ TRẢ VỀ MẢNG
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi lấy danh sách user" });
  }
});

// ADMIN - cập nhật user (PUT)
router.put("/admin/users/:maUser", async (req, res) => {
  try {
    const { maUser } = req.params;
    const { TaiKhoan, MatKhau, HoTen, Email, DienThoai, DiaChi, VaiTro } =
      req.body;

    if (!TaiKhoan || !HoTen || !VaiTro) {
      return res.status(400).json({ message: "Thiếu dữ liệu bắt buộc!" });
    }

    let sql = `UPDATE user SET TaiKhoan=?, HoTen=?, Email=?, DienThoai=?, DiaChi=?, VaiTro=?, NgayTao=?, MaXa=?`;
    let values = [
      TaiKhoan,
      HoTen,
      Email || null,
      DienThoai || null,
      DiaChi || null,
      VaiTro,

      new Date(),
      req.body.MaXa || null,
    ];

    if (MatKhau && MatKhau.trim() !== "") {
      // Chỉ update mật khẩu nếu có giá trị
      sql += `, MatKhau=?`;
      values.push(MatKhau);
    }

    sql += ` WHERE MaUser=?`;
    values.push(maUser);

    const [result] = await db.query(sql, values);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy user!" });
    }

    res.json({ message: "Cập nhật user thành công!" });
  } catch (err) {
    console.error("Lỗi update user:", err);
    res.status(500).json({ message: "Lỗi server!" });
  }
});

// ADMIN - xóa user (DELETE)
router.delete("/admin/users/:maUser", async (req, res) => {
  try {
    const { maUser } = req.params;

    const [result] = await db.query("DELETE FROM user WHERE MaUser = ?", [
      maUser,
    ]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy user!" });
    }

    res.json({ message: "Xóa user thành công!" });
  } catch (err) {
    console.error("Lỗi delete user:", err);
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
        Email: user.Email,
        DienThoai: user.DienThoai,
        DiaChi: user.DiaChi,
        MaXa: user.MaXa,
        NgayTao: user.NgayTao,
      },
    });
  } catch (err) {
    console.error("Lỗi login:", err);
    res.status(500).json({ message: "Lỗi server!" });
  }
});

// 📌 API LẤY THÔNG TIN MỘT USER THEO MaUser (dùng cho hiển thị nhân viên giao hàng)
router.get("/user/:maUser", async (req, res) => {
  try {
    const { maUser } = req.params;

    const [rows] = await db.query(
      `SELECT MaUser, HoTen, DienThoai, Email, VaiTro 
       FROM user 
       WHERE MaUser = ?`,
      [maUser]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy người dùng" });
    }

    res.json(rows[0]);
  } catch (err) {
    console.error("Lỗi lấy thông tin user:", err);
    res.status(500).json({ message: "Lỗi server" });
  }
});

// QUAN TRỌNG: ESM phải export default
export default router;
