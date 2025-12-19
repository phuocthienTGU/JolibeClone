// server.js
import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";

import AuthRouter from "./routes/Auth.js";

import SanPhamRouter from "./routes/sanpham.js";

import ComboRouter from "./routes/Combo.js";

import DanhMucRouter from "./routes/DanhMuc.js";
import orderRouter from "./routes/order.js";
import DonHangRouter from "./routes/DonHang.js";
import DonHangChiTietRouter from "./routes/DonHangChiTiet.js";
//import UserRouter from "./routes/User.js";

//import ChiTietDonHangRouter from "./routes/ChiTietDonHang.js";

import giohangRouter from "./routes/giohang.js";

// Load biến môi trường .env
dotenv.config();
const app = express();
// Fix __dirname khi dùng ES module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const publicPath = path.resolve(__dirname, "../my-new-app/public");

app.use(express.static(publicPath));

// Cho phép upload / hiển thị ảnh
app.use("/images", express.static(path.join(process.cwd(), "images")));

app.use(cors());
app.use(bodyParser.json());

// Định nghĩa route API
app.use("/auth", AuthRouter);

app.use("/api/sanpham", SanPhamRouter);
app.use("/api/combo", ComboRouter);
app.use("/api/danhmuc", DanhMucRouter);

app.use("/api/order", orderRouter);

app.use("/api/donhang", DonHangRouter);
app.use("/api/donhangchitiet", DonHangChiTietRouter);
//app.use("/api/user", UserRouter);
//app.use("/api/chitietdonhang", ChiTietDonHangRouter);
app.use("/api/giohang", giohangRouter);

// Test server
app.get("/", (req, res) => {
  res.send("Server Jollibee Backend đang chạy!");
});

// Nếu có PORT trong .env → dùng, không có thì dùng 5000
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server chạy tại http://localhost:${PORT}`);
});
