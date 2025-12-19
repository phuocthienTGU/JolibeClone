-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 05, 2025 at 01:42 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jollibee`
--

-- --------------------------------------------------------

--
-- Table structure for table `combo`
--

CREATE TABLE `combo` (
  `MaCombo` char(10) NOT NULL,
  `TenCombo` varchar(150) NOT NULL,
  `GiaCombo` decimal(10,2) NOT NULL,
  `MoTa` text DEFAULT NULL,
  `HinhAnh` varchar(255) DEFAULT NULL,
  `TrangThai` enum('hienthi','an') DEFAULT 'hienthi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `combo`
--

INSERT INTO `combo` (`MaCombo`, `TenCombo`, `GiaCombo`, `MoTa`, `HinhAnh`, `TrangThai`) VALUES
('CB001', 'Combo 2 gà + 1 mì nhỏ', 90000.00, 'Combo tiết kiệm', 'cb1.jpg', 'hienthi'),
('CB002', 'Combo burger + nước', 70000.00, 'Burger + nước uống', 'cb2.jpg', 'hienthi');

--
-- Triggers `combo`
--
DELIMITER $$
CREATE TRIGGER `trg_Combo_Before_Insert` BEFORE INSERT ON `combo` FOR EACH ROW BEGIN
    IF NEW.MaCombo IS NULL OR NEW.MaCombo = '' THEN
        SET NEW.MaCombo = (
            SELECT CONCAT('CB', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaCombo, 3) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM Combo
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `combochitiet`
--

CREATE TABLE `combochitiet` (
  `MaComboChiTiet` char(10) NOT NULL,
  `MaCombo` char(10) NOT NULL,
  `MaSanPham` char(10) NOT NULL,
  `SoLuong` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `combochitiet`
--

INSERT INTO `combochitiet` (`MaComboChiTiet`, `MaCombo`, `MaSanPham`, `SoLuong`) VALUES
('CTCB001', 'CB001', 'SP001', 2),
('CTCB002', 'CB001', 'SP003', 1),
('CTCB003', 'CB002', 'SP006', 1),
('CTCB004', 'CB002', 'SP005', 1);

--
-- Triggers `combochitiet`
--
DELIMITER $$
CREATE TRIGGER `trg_ComboChiTiet_Before_Insert` BEFORE INSERT ON `combochitiet` FOR EACH ROW BEGIN
    IF NEW.MaComboChiTiet IS NULL OR NEW.MaComboChiTiet = '' THEN
        SET NEW.MaComboChiTiet = (
            SELECT CONCAT('CTCB', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaComboChiTiet, 5) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM ComboChiTiet
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `danhmuc`
--

CREATE TABLE `danhmuc` (
  `MaDanhMuc` char(10) NOT NULL,
  `TenDanhMuc` varchar(100) NOT NULL,
  `MoTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `danhmuc`
--

INSERT INTO `danhmuc` (`MaDanhMuc`, `TenDanhMuc`, `MoTa`) VALUES
('DM001', 'Gà rán', 'Các món gà rán'),
('DM002', 'Mì Ý', 'Các món mì'),
('DM003', 'Nước uống', 'Các loại nước'),
('DM004', 'Burger', 'Các loại burger');

--
-- Triggers `danhmuc`
--
DELIMITER $$
CREATE TRIGGER `trg_DanhMuc_Before_Insert` BEFORE INSERT ON `danhmuc` FOR EACH ROW BEGIN
    IF NEW.MaDanhMuc IS NULL OR NEW.MaDanhMuc = '' THEN
        SET NEW.MaDanhMuc = (
            SELECT CONCAT('DM', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaDanhMuc, 3) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM DanhMuc
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `donhang`
--

CREATE TABLE `donhang` (
  `MaDonHang` char(10) NOT NULL,
  `MaUser` char(10) DEFAULT NULL,
  `TongTien` decimal(12,2) NOT NULL,
  `TrangThai` enum('cho_duyet','dang_giao','hoan_thanh','huy') DEFAULT 'cho_duyet',
  `NgayDat` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donhang`
--

INSERT INTO `donhang` (`MaDonHang`, `MaUser`, `TongTien`, `TrangThai`, `NgayDat`) VALUES
('DH001', 'US003', 125000.00, 'hoan_thanh', '2025-11-28 19:37:23');

--
-- Triggers `donhang`
--
DELIMITER $$
CREATE TRIGGER `trg_DonHang_Before_Insert` BEFORE INSERT ON `donhang` FOR EACH ROW BEGIN
    IF NEW.MaDonHang IS NULL OR NEW.MaDonHang = '' THEN
        SET NEW.MaDonHang = (
            SELECT CONCAT('DH', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaDonHang, 3) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM DonHang
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `donhangchitiet`
--

CREATE TABLE `donhangchitiet` (
  `MaChiTiet` char(10) NOT NULL,
  `MaDonHang` char(10) NOT NULL,
  `LoaiSanPham` enum('sanpham','combo') NOT NULL,
  `MaSanPham` char(10) DEFAULT NULL,
  `MaCombo` char(10) DEFAULT NULL,
  `SoLuong` int(11) NOT NULL,
  `DonGia` decimal(10,2) NOT NULL,
  `ThanhTien` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donhangchitiet`
--

INSERT INTO `donhangchitiet` (`MaChiTiet`, `MaDonHang`, `LoaiSanPham`, `MaSanPham`, `MaCombo`, `SoLuong`, `DonGia`, `ThanhTien`) VALUES
('CTDH001', 'DH001', 'sanpham', 'SP002', NULL, 1, 38000.00, 38000.00),
('CTDH002', 'DH001', 'combo', NULL, 'CB001', 1, 90000.00, 90000.00);

--
-- Triggers `donhangchitiet`
--
DELIMITER $$
CREATE TRIGGER `trg_DonHangChiTiet_Before_Insert` BEFORE INSERT ON `donhangchitiet` FOR EACH ROW BEGIN
    IF NEW.MaChiTiet IS NULL OR NEW.MaChiTiet = '' THEN
        SET NEW.MaChiTiet = (
            SELECT CONCAT('CTDH', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaChiTiet, 5) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM DonHangChiTiet
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `donhangcombochitiet`
--

CREATE TABLE `donhangcombochitiet` (
  `MaCTCombo` char(10) NOT NULL,
  `MaChiTiet` char(10) NOT NULL,
  `MaSanPham` char(10) NOT NULL,
  `SoLuong` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donhangcombochitiet`
--

INSERT INTO `donhangcombochitiet` (`MaCTCombo`, `MaChiTiet`, `MaSanPham`, `SoLuong`) VALUES
('CTCBX001', 'CTDH002', 'SP004', 1);

--
-- Triggers `donhangcombochitiet`
--
DELIMITER $$
CREATE TRIGGER `trg_DonHangComboChiTiet_Before_Insert` BEFORE INSERT ON `donhangcombochitiet` FOR EACH ROW BEGIN
    IF NEW.MaCTCombo IS NULL OR NEW.MaCTCombo = '' THEN
        SET NEW.MaCTCombo = (
            SELECT CONCAT('CTCBX', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaCTCombo, 6) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM DonHangComboChiTiet
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `giohang`
--

CREATE TABLE `giohang` (
  `MaGioHang` char(10) NOT NULL,
  `MaUser` char(10) NOT NULL,
  `NgayTao` datetime DEFAULT current_timestamp(),
  `TrangThai` enum('dang_su_dung','da_dat_hang') DEFAULT 'dang_su_dung'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `giohang`
--
DELIMITER $$
CREATE TRIGGER `trg_GioHang_Before_Insert` BEFORE INSERT ON `giohang` FOR EACH ROW BEGIN
    IF NEW.MaGioHang IS NULL OR NEW.MaGioHang = '' THEN
        SET NEW.MaGioHang = (
            SELECT CONCAT('GH', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaGioHang, 3) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM giohang
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `giohangchitiet`
--

CREATE TABLE `giohangchitiet` (
  `MaChiTiet` char(10) NOT NULL,
  `MaGioHang` char(10) NOT NULL,
  `LoaiSanPham` enum('sanpham','combo') NOT NULL,
  `MaSanPham` char(10) DEFAULT NULL,
  `MaCombo` char(10) DEFAULT NULL,
  `SoLuong` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `giohangchitiet`
--
DELIMITER $$
CREATE TRIGGER `trg_GioHangChiTiet_Before_Insert` BEFORE INSERT ON `giohangchitiet` FOR EACH ROW BEGIN
    IF NEW.MaChiTiet IS NULL OR NEW.MaChiTiet = '' THEN
        SET NEW.MaChiTiet = (
            SELECT CONCAT('CTGH', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaChiTiet, 5) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM giohangchitiet
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sanpham`
--

CREATE TABLE `sanpham` (
  `MaSanPham` char(10) NOT NULL,
  `MaDanhMuc` char(10) DEFAULT NULL,
  `TenSanPham` varchar(150) NOT NULL,
  `MoTa` text DEFAULT NULL,
  `Gia` decimal(10,2) NOT NULL,
  `HinhAnh` varchar(255) DEFAULT NULL,
  `TrangThai` enum('hienthi','an') DEFAULT 'hienthi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sanpham`
--

INSERT INTO `sanpham` (`MaSanPham`, `MaDanhMuc`, `TenSanPham`, `MoTa`, `Gia`, `HinhAnh`, `TrangThai`) VALUES
('SP001', 'DM001', 'Gà rán thường', NULL, 35000.00, 'miysotcay.jpg', 'hienthi'),
('SP002', 'DM001', 'Gà cay', 'Gà rán vị cay', 38000.00, 'ga_cay.jpg', 'hienthi'),
('SP003', 'DM002', 'Mì Ý nhỏ', 'Mì Ý size nhỏ', 30000.00, 'mi_nho.jpg', 'hienthi'),
('SP004', 'DM002', 'Mì Ý lớn', 'Mì Ý size lớn', 45000.00, 'mi_lon.jpg', 'hienthi'),
('SP005', 'DM003', 'Coca nhỏ', 'Chai nhỏ', 15000.00, 'coca.jpg', 'hienthi'),
('SP006', 'DM004', 'Burger bò', 'Burger bò nướng', 55000.00, 'burger_bo.jpg', 'hienthi'),
('SP007', 'DM002', 'mỳ ý sốt cay', 'mỳ ý cay bùng vị', 40000.00, 'miysotcay.jpg', 'an'),
('SP008', 'DM002', 'mỳ ý sốt cay', 'my y cay bung vi\n', 40000.00, 'miysotcay.jpg', 'hienthi');

--
-- Triggers `sanpham`
--
DELIMITER $$
CREATE TRIGGER `trg_SanPham_Before_Insert` BEFORE INSERT ON `sanpham` FOR EACH ROW BEGIN
    IF NEW.MaSanPham IS NULL OR NEW.MaSanPham = '' THEN
        SET NEW.MaSanPham = (
            SELECT CONCAT('SP', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaSanPham, 3) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM SanPham
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `MaUser` char(10) NOT NULL,
  `TaiKhoan` varchar(100) NOT NULL,
  `MatKhau` varchar(255) NOT NULL,
  `HoTen` varchar(150) NOT NULL,
  `Email` varchar(150) DEFAULT NULL,
  `DienThoai` varchar(20) DEFAULT NULL,
  `DiaChi` varchar(255) DEFAULT NULL,
  `VaiTro` enum('admin','nhanvien','khachhang') DEFAULT 'khachhang',
  `NgayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`MaUser`, `TaiKhoan`, `MatKhau`, `HoTen`, `Email`, `DienThoai`, `DiaChi`, `VaiTro`, `NgayTao`) VALUES
('US001', 'admin', '123456', 'Quản trị viên', 'admin@jb.com', '0900000001', 'TP.HCM', 'admin', '2025-11-28 19:32:28'),
('US002', 'nhanvien01', '123456', 'Nhân viên A', 'nv01@jb.com', '0900000002', 'TP.HCM', 'nhanvien', '2025-11-28 19:32:28'),
('US003', 'khach001', '123456', 'Nguyễn Văn A', 'a@gmail.com', '0900000003', 'Hà Nội', 'khachhang', '2025-11-28 19:32:28'),
('US004', 'nghi', '123', 'nghi', 'nghi@gmail.com', '0962320196', 'tien giang', 'khachhang', '2025-12-01 20:46:56'),
('US005', 'thien', '123', 'thien', 'thien@gmail.com', '0962320196', 'tien giang', 'khachhang', '2025-12-04 21:59:27');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `trg_User_Before_Insert` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
    IF NEW.MaUser IS NULL OR NEW.MaUser = '' THEN
        SET NEW.MaUser = (
            SELECT CONCAT('US', LPAD(
                IFNULL(MAX(CAST(SUBSTRING(MaUser, 3) AS UNSIGNED)), 0) + 1,
            3, '0'))
            FROM User
        );
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `combo`
--
ALTER TABLE `combo`
  ADD PRIMARY KEY (`MaCombo`);

--
-- Indexes for table `combochitiet`
--
ALTER TABLE `combochitiet`
  ADD PRIMARY KEY (`MaComboChiTiet`),
  ADD KEY `MaCombo` (`MaCombo`),
  ADD KEY `MaSanPham` (`MaSanPham`);

--
-- Indexes for table `danhmuc`
--
ALTER TABLE `danhmuc`
  ADD PRIMARY KEY (`MaDanhMuc`);

--
-- Indexes for table `donhang`
--
ALTER TABLE `donhang`
  ADD PRIMARY KEY (`MaDonHang`),
  ADD KEY `MaUser` (`MaUser`);

--
-- Indexes for table `donhangchitiet`
--
ALTER TABLE `donhangchitiet`
  ADD PRIMARY KEY (`MaChiTiet`),
  ADD KEY `MaDonHang` (`MaDonHang`),
  ADD KEY `MaSanPham` (`MaSanPham`),
  ADD KEY `MaCombo` (`MaCombo`);

--
-- Indexes for table `donhangcombochitiet`
--
ALTER TABLE `donhangcombochitiet`
  ADD PRIMARY KEY (`MaCTCombo`),
  ADD KEY `MaChiTiet` (`MaChiTiet`),
  ADD KEY `MaSanPham` (`MaSanPham`);

--
-- Indexes for table `giohang`
--
ALTER TABLE `giohang`
  ADD PRIMARY KEY (`MaGioHang`),
  ADD KEY `MaUser` (`MaUser`);

--
-- Indexes for table `giohangchitiet`
--
ALTER TABLE `giohangchitiet`
  ADD PRIMARY KEY (`MaChiTiet`),
  ADD KEY `MaGioHang` (`MaGioHang`),
  ADD KEY `MaSanPham` (`MaSanPham`),
  ADD KEY `MaCombo` (`MaCombo`);

--
-- Indexes for table `sanpham`
--
ALTER TABLE `sanpham`
  ADD PRIMARY KEY (`MaSanPham`),
  ADD KEY `MaDanhMuc` (`MaDanhMuc`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`MaUser`),
  ADD UNIQUE KEY `TaiKhoan` (`TaiKhoan`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `combochitiet`
--
ALTER TABLE `combochitiet`
  ADD CONSTRAINT `combochitiet_ibfk_1` FOREIGN KEY (`MaCombo`) REFERENCES `combo` (`MaCombo`),
  ADD CONSTRAINT `combochitiet_ibfk_2` FOREIGN KEY (`MaSanPham`) REFERENCES `sanpham` (`MaSanPham`);

--
-- Constraints for table `donhang`
--
ALTER TABLE `donhang`
  ADD CONSTRAINT `donhang_ibfk_1` FOREIGN KEY (`MaUser`) REFERENCES `user` (`MaUser`);

--
-- Constraints for table `donhangchitiet`
--
ALTER TABLE `donhangchitiet`
  ADD CONSTRAINT `donhangchitiet_ibfk_1` FOREIGN KEY (`MaDonHang`) REFERENCES `donhang` (`MaDonHang`),
  ADD CONSTRAINT `donhangchitiet_ibfk_2` FOREIGN KEY (`MaSanPham`) REFERENCES `sanpham` (`MaSanPham`),
  ADD CONSTRAINT `donhangchitiet_ibfk_3` FOREIGN KEY (`MaCombo`) REFERENCES `combo` (`MaCombo`);

--
-- Constraints for table `donhangcombochitiet`
--
ALTER TABLE `donhangcombochitiet`
  ADD CONSTRAINT `donhangcombochitiet_ibfk_1` FOREIGN KEY (`MaChiTiet`) REFERENCES `donhangchitiet` (`MaChiTiet`),
  ADD CONSTRAINT `donhangcombochitiet_ibfk_2` FOREIGN KEY (`MaSanPham`) REFERENCES `sanpham` (`MaSanPham`);

--
-- Constraints for table `giohang`
--
ALTER TABLE `giohang`
  ADD CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`MaUser`) REFERENCES `user` (`MaUser`);

--
-- Constraints for table `giohangchitiet`
--
ALTER TABLE `giohangchitiet`
  ADD CONSTRAINT `giohangchitiet_ibfk_1` FOREIGN KEY (`MaGioHang`) REFERENCES `giohang` (`MaGioHang`),
  ADD CONSTRAINT `giohangchitiet_ibfk_2` FOREIGN KEY (`MaSanPham`) REFERENCES `sanpham` (`MaSanPham`),
  ADD CONSTRAINT `giohangchitiet_ibfk_3` FOREIGN KEY (`MaCombo`) REFERENCES `combo` (`MaCombo`);

--
-- Constraints for table `sanpham`
--
ALTER TABLE `sanpham`
  ADD CONSTRAINT `sanpham_ibfk_1` FOREIGN KEY (`MaDanhMuc`) REFERENCES `danhmuc` (`MaDanhMuc`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
