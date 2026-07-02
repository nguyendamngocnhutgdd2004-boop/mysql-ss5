-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & DỮ LIỆU MẪU ĐỂ CHẠY THỬ
-- =========================================================================
CREATE DATABASE IF NOT EXISTS quan_ly_diem_sinh_vien;
USE quan_ly_diem_sinh_vien;

DROP TABLE IF EXISTS scores;

CREATE TABLE scores (
    student_id VARCHAR(20),
    subject VARCHAR(100),
    score DECIMAL(4, 2) NOT NULL,
    PRIMARY KEY (student_id, subject)
);

-- Thêm dữ liệu mẫu (Có sinh viên điểm cao, điểm thấp để kiểm tra điều kiện)
INSERT INTO scores (student_id, subject, score) VALUES
('SV001', 'Toan', 8.5), ('SV001', 'Van', 7.5),   -- ĐTB SV001 = 8.0
('SV002', 'Toan', 9.0), ('SV002', 'Van', 9.5),   -- ĐTB SV002 = 9.25 (Cao nhất)
('SV003', 'Toan', 6.0), ('SV003', 'Van', 5.0),   -- ĐTB SV003 = 5.5
('SV004', 'Toan', 7.0), ('SV004', 'Van', 7.2);   -- ĐTB SV004 = 7.1

-- ĐTB chung của tất cả các đầu điểm trong hệ thống là: ~7.46
-- ĐTB tính theo từng sinh viên rồi chia trung bình tiếp là: (8.0 + 9.25 + 5.5 + 7.1) / 4 = 7.4625


-- =========================================================================
-- ĐOẠN 2: TRUY VẤN THỐNG KÊ KẾT QUẢ HỌC TẬP
-- =========================================================================

-- Yêu cầu 1: Tính điểm trung bình của mỗi sinh viên
SELECT 
    student_id, 
    AVG(score) AS diem_trung_binh
FROM scores
GROUP BY student_id;


-- Yêu cầu 2: Chỉ hiển thị các sinh viên có điểm trung bình >= 7.0
SELECT 
    student_id, 
    AVG(score) AS diem_trung_binh
FROM scores
GROUP BY student_id;


-- Yêu cầu 3: Hiển thị sinh viên có điểm trung bình cao nhất trong toàn bộ danh sách
-- Cách tối ưu nhất là dùng Subquery để tìm mức ĐTB lớn nhất rồi so sánh
SELECT 
    student_id, 
    AVG(score) AS diem_trung_binh
FROM scores
GROUP BY student_id
HAVING AVG(score) = (
    SELECT MAX(dtb_tung_sv) 
    FROM (
        SELECT AVG(score) AS dtb_tung_sv 
        FROM scores 
        GROUP BY student_id
    ) AS bang_tam
);


-- Yêu cầu 4: Hiển thị các sinh viên có điểm trung bình cao hơn điểm trung bình chung của tất cả sinh viên
-- LƯU Ý: Điểm TB chung của tất cả sinh viên = Tính trung bình của toàn bộ các cột score trong bảng
SELECT 
    student_id, 
    AVG(score) AS diem_trung_binh
FROM scores
GROUP BY student_id
HAVING AVG(score) > (SELECT AVG(score) FROM scores);
