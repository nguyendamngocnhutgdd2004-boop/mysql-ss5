-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & DỮ LIỆU MẪU ĐỂ CHẠY THỬ
-- =========================================================================
CREATE DATABASE IF NOT EXISTS phan_tich_doanh_thu;
USE phan_tich_doanh_thu;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- 1. Bảng Khách hàng
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

-- 2. Bảng Đơn hàng
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(20),
    CONSTRAINT fk_orders_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 3. Bảng Chi tiết mặt hàng trong đơn
CREATE TABLE order_items (
    order_id VARCHAR(20),
    product_name VARCHAR(150),
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (order_id, product_name),
    CONSTRAINT fk_items_ord FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Thêm dữ liệu mẫu thực tế để kiểm tra chính xác các hạn mức doanh thu
INSERT INTO customers VALUES 
('C001', 'Nguyen Van A'),
('C002', 'Tran Thi B'),
('C003', 'Le Van C');

INSERT INTO orders VALUES 
('HD001', '2026-07-01', 'C001'),
('HD002', '2026-07-02', 'C002'),
('HD003', '2026-07-02', 'C001'); -- Khách C001 mua thêm đơn thứ 2

INSERT INTO order_items VALUES 
('HD001', 'iPhone 15 Pro', 1, 25000000.00), -- Đơn HD001 = 25M (C001)
('HD002', 'Laptop Dell', 1, 15000000.00),     -- Đơn HD002 = 15M (C002)
('HD003', 'Chuột không dây', 2, 500000.00);    -- Đơn HD003 = 1M  (C001)

-- Thống kê thực tế: 
-- + Khách C001 tổng doanh thu = 25M + 1M = 26M (>20M - Cao nhất)
-- + Khách C002 tổng doanh thu = 15M (<20M)
-- + Khách C003 tổng doanh thu = 0


-- =========================================================================
-- ĐOẠN 2: CÁC CÂU LỆNH SQL PHÂN TÍCH DOANH THU
-- =========================================================================

-- Yêu cầu 1: Hiển thị mã đơn hàng, tên khách hàng, tổng tiền của đơn hàng
SELECT 
    o.order_id, 
    c.customer_name, 
    SUM(oi.quantity * oi.price) AS tong_tien_don_hang
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_name;


-- Yêu cầu 2: Tính tổng doanh thu của mỗi khách hàng
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.price) AS tong_doanh_thu
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name;


-- Yêu cầu 3: Chỉ hiển thị các khách hàng có tổng doanh thu lớn hơn 20.000.000
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.price) AS tong_doanh_thu
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(oi.quantity * oi.price) > 20000000.00;


-- Yêu cầu 4: Hiển thị khách hàng có doanh thu cao nhất (Dùng Subquery)
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.price) AS doanh_thu_cao_nhat
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(oi.quantity * oi.price) = (
    SELECT MAX(doanh_thu_tung_khach) 
    FROM (
        SELECT SUM(oi2.quantity * oi2.price) AS doanh_thu_tung_khach
        FROM orders o2
        INNER JOIN order_items oi2 ON o2.order_id = oi2.order_id
        GROUP BY o2.customer_id
    ) AS bang_tam
);
