-- Bước 1: Xóa các bảng cũ theo đúng thứ tự để tránh lỗi ràng buộc khóa ngoại
DROP TABLE IF EXISTS DangKy;
DROP TABLE IF EXISTS MonHoc;
DROP TABLE IF EXISTS SinhVien;

-- Bước 2: Tạo bảng Sinh Viên
CREATE TABLE SinhVien (
    MaSV VARCHAR(15) PRIMARY KEY,       -- Khóa chính
    HoTen VARCHAR(50) NOT NULL,
    NgaySinh DATE,
    GioiTinh VARCHAR(10)
);

-- Bước 3: Tạo bảng Môn Học
CREATE TABLE MonHoc (
    MaMon VARCHAR(15) PRIMARY KEY,      -- Khóa chính
    TenMon VARCHAR(100) NOT NULL,
    SoTinChi INT NOT NULL
);

-- Bước 4: Tạo bảng trung gian Đăng Ký (Giải quyết mối quan hệ N - N)
CREATE TABLE DangKy (
    MaSV VARCHAR(15),
    MaMon VARCHAR(15),
    NgayDangKy DATETIME DEFAULT CURRENT_TIMESTAMP, -- Tự động lấy ngày giờ hiện tại công nghệ mới
    DiemSo DECIMAL(4,2) DEFAULT NULL,             -- Cột điểm số (để trống khi mới đăng ký)
    
    -- Thiết lập khóa chính kết hợp từ hai mã định danh
    PRIMARY KEY (MaSV, MaMon), 
    
    -- Cài đặt khóa ngoại liên kết đồng bộ dữ liệu (Xóa gốc thì ngọn tự mất)
    FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV) ON DELETE CASCADE,
    FOREIGN KEY (MaMon) REFERENCES MonHoc(MaMon) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- CHÈN DỮ LIỆU MẪU ĐỂ BẠN KIỂM TRA THỬ
-- --------------------------------------------------------

-- 1. Thêm dữ liệu Sinh viên
INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh) VALUES
('SV001', 'Nguyen Van A', '2005-01-15', 'Nam'),
('SV002', 'Tran Thi B', '2005-08-22', 'Nu');

-- 2. Thêm dữ liệu Môn học
INSERT INTO MonHoc (MaMon, TenMon, SoTinChi) VALUES
('CSDL01', 'Co so du lieu', 3),
('WEB02', 'Lap trinh Web', 4);

-- 3. Thêm dữ liệu Đăng ký (Sinh viên 1 học 2 môn, môn 1 có 2 sinh viên học)
INSERT INTO DangKy (MaSV, MaMon) VALUES
('SV001', 'CSDL01'),
('SV001', 'WEB02'),
('SV002', 'CSDL01');