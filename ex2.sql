-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & DỮ LIỆU MẪU ĐỂ CHẠY THỬ
-- =========================================================================
CREATE DATABASE IF NOT EXISTS quan_ly_nhan_su_nang_cao;
USE quan_ly_nhan_su_nang_cao;

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(15, 2) NOT NULL
);

-- Thêm dữ liệu mẫu (Cố tình tạo phòng ban có nhiều/ít nhân viên và mức lương khác nhau để test HAVING)
INSERT INTO employees (emp_id, full_name, department, salary) VALUES
('NV001', 'Nguyen Van A', 'IT', 15000000.00),
('NV002', 'Tran Thi B', 'IT', 18000000.00),
('NV003', 'Le Van C', 'IT', 20000000.00),
('NV004', 'Pham Minh D', 'IT', 14000000.00),       -- Phòng IT có 4 người, lương TB > 12M
('NV005', 'Hoang Ngoc E', 'HR', 11000000.00),
('NV006', 'Vuong Duc F', 'HR', 12000000.00),
('NV007', 'Doan Quoc G', 'HR', 10000000.00),
('NV008', 'Nguyen Thuy H', 'HR', 9000000.00),       -- Phòng HR có 4 người, lương TB < 12M
('NV009', 'Bui Van I', 'Sales', 25000000.00),
('NV010', 'Dang Kim J', 'Sales', 21000000.00);      -- Phòng Sales có 2 người, lương TB > 12M


-- =========================================================================
-- ĐOẠN 2: TRUY VẤN SỬ DỤNG GROUP BY VÀ HAVING
-- =========================================================================

-- Yêu cầu 1 & 2: Thống kê số nhân viên và mức lương trung bình của TỪNG phòng ban
SELECT 
    department AS phong_ban,
    COUNT(emp_id) AS so_luong_nhan_vien,
    AVG(salary) AS luong_trung_binh
FROM employees
GROUP BY department;


-- Yêu cầu 3: Chỉ hiển thị các phòng ban có TRÊN 3 nhân viên
SELECT 
    department AS phong_ban,
    COUNT(emp_id) AS so_luong_nhan_vien
FROM employees
GROUP BY department
HAVING COUNT(emp_id) > 3;


-- Yêu cầu 4: Chỉ hiển thị các phòng ban có lương trung bình LỚN HƠN 12.000.000
SELECT 
    department AS phong_ban,
    AVG(salary) AS luong_trung_binh
FROM employees
GROUP BY department
HAVING AVG(salary) > 10000000.00;
