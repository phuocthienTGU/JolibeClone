import express from "express";
import pool from "../config/db.js";

const router = express.Router();

/* ============================
   1. LẤY TẤT CẢ ĐƠN HÀNG
============================ */
router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT dh.*, u.HoTen 
       FROM DonHang dh
       LEFT JOIN User u ON dh.MaUser = u.MaUser
       ORDER BY dh.NgayDat DESC`
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Lỗi lấy đơn hàng" });
  }
});

/* ============================
   2. LẤY ĐƠN HÀNG THEO MÃ
============================ */
router.get("/:ma", async (req, res) => {
  try {
    const { ma } = req.params;

    const [rows] = await pool.query(
      `SELECT dh.*, u.HoTen 
       FROM DonHang dh
       LEFT JOIN User u ON dh.MaUser = u.MaUser
       WHERE dh.MaDonHang = ?`,
      [ma]
    );

    if (rows.length === 0)
      return res.status(404).json({ error: "Không tìm thấy đơn hàng" });

    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Lỗi lấy đơn hàng theo mã" });
  }
});

/* ============================
   3. THÊM ĐƠN HÀNG
============================ */
router.post("/", async (req, res) => {
  try {
    const { MaUser, TongTien, TrangThai } = req.body;

    if (!MaUser || !TongTien) {
      return res.status(400).json({ error: "Thiếu dữ liệu bắt buộc" });
    }

    const [result] = await pool.query(
      `INSERT INTO DonHang (MaUser, TongTien, TrangThai, NgayDat)
       VALUES (?, ?, ?, NOW())`,
      [MaUser, TongTien, TrangThai || "cho_duyet"]
    );

    res.json({
      message: "Thêm đơn hàng thành công",
      id: result.insertId,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Lỗi thêm đơn hàng" });
  }
});

/* ============================
   4. CẬP NHẬT ĐƠN HÀNG
============================ */
router.put("/:ma", async (req, res) => {
  try {
    const { ma } = req.params;
    const { MaUser, TongTien, TrangThai } = req.body;

    await pool.query(
      `UPDATE DonHang 
       SET MaUser=?, TongTien=?, TrangThai=? 
       WHERE MaDonHang=?`,
      [MaUser, TongTien, TrangThai, ma]
    );

    res.json({ message: "Cập nhật đơn hàng thành công" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Lỗi cập nhật đơn hàng" });
  }
});

/* ============================
   5. XÓA ĐƠN HÀNG
============================ */
router.delete("/:ma", async (req, res) => {
  try {
    const { ma } = req.params;

    // ⭐ Để tránh lỗi khóa ngoại, phải xóa chi tiết trước:
    await pool.query(`DELETE FROM DonHangCT WHERE MaDonHang = ?`, [ma]);

    await pool.query(`DELETE FROM DonHang WHERE MaDonHang = ?`, [ma]);

    res.json({ message: "Xóa đơn hàng thành công" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Lỗi xóa đơn hàng" });
  }
});

export default router;
