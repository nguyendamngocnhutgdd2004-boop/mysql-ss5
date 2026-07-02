-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & DỮ LIỆU MẪU ĐỂ KIỂM TRA
-- =========================================================================
CREATE DATABASE IF NOT EXISTS quan_ly_sinh_vien_ham;
USE quan_ly_sinh_vien_ham;

DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_year INT,
    gender VARCHAR(10),
    score DECIMAL(4, 2) -- Điểm trung bình có 2 chữ số thập phân
);

INSERT INTO students (student_id, full_name, birth_year, gender, score) VALUES
('SV001', 'Nguyen Van Anh', 2005, 'Nam', 8.46),
('SV002', 'tran thi mai', 2004, 'Nu', 6.12),
('SV003', 'Le Hoang Bao', 2003, 'Nam', 9.55),
('SV004', 'pham minh tuan', 2005, 'Nam', 4.89),
('SV005', 'Hoang Thu Thao', 2006, 'Nu', 7.74);


-- =========================================================================
-- ĐOẠN 2: TRUY VẤN SỬ DỤNG CÁC HÀM SQL THÔNG DỤNG
-- =========================================================================

-- Yêu cầu 1: Hiển thị mã sinh viên và họ tên viết hoa toàn bộ (Hàm UPPER)
SELECT 
    student_id, 
    UPPER(full_name) AS ho_ten_viet_hoa
FROM students;


-- Yêu cầu 2: Hiển thị họ tên và số tuổi của sinh viên dựa vào năm hiện tại (Hàm YEAR và NOW)
SELECT 
    full_name, 
    (YEAR(NOW()) - birth_year) AS tuoi_sinh_vien
FROM students;


-- Yêu cầu 3: Hiển thị điểm trung bình được làm tròn 1 chữ số thập phân (Hàm ROUND)
SELECT 
    student_id,
    full_name,
    ROUND(score, 1) AS diem_lam_tron
FROM students;


-- Yêu cầu 4: Hiển thị tổng số sinh viên, điểm cao nhất, điểm thấp nhất (Hàm COUNT, MAX, MIN)
SELECT 
    COUNT(student_id) AS tong_so_sinh_vien,
    MAX(score) AS diem_cao_nhat,
    MIN(score) AS diem_thap_nhat
FROM students;
