-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & DỮ LIỆU MẪU ĐỂ CHẠY THỬ
-- =========================================================================
CREATE DATABASE IF NOT EXISTS quan_ly_ban_hang_join;
USE quan_ly_ban_hang_join;

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
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 3. Bảng Chi tiết mặt hàng trong đơn (Sửa lại cấu trúc hợp lý từ mô tả bài toán)
CREATE TABLE order_items (
    order_id VARCHAR(20),
    product_name VARCHAR(150),
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (order_id, product_name),
    CONSTRAINT fk_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Thêm dữ liệu mẫu
INSERT INTO customers VALUES 
('C001', 'Nguyen Van A'),
('C002', 'Tran Thi B');

INSERT INTO orders VALUES 
('HD001', '2026-07-01', 'C001'),
('HD002', '2026-07-02', 'C002');

INSERT INTO order_items VALUES 
('HD001', 'iPhone 15 Pro', 1, 25000000.00), -- Tổng đơn HD001 = 25M (>10M)
('HD001', 'Ốp lưng Silicon', 2, 250000.00),
('HD002', 'Chuột không dây', 1, 350000.00);    -- Tổng đơn HD002 = 350k (<10M)


-- =========================================================================
-- ĐOẠN 2: TRUY VẤN DỮ LIỆU LIÊN KẾT NHIỀU BẢNG (JOIN)
-- =========================================================================

-- Yêu cầu 1: Hiển thị mã đơn hàng, ngày đặt hàng, tên khách hàng (Gộp 2 bảng)
SELECT 
    o.order_id, 
    o.order_date, 
    c.customer_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;


-- Yêu cầu 2: Hiển thị danh sách sản phẩm trong mỗi đơn hàng (Gộp 2 bảng)
SELECT 
    oi.order_id, 
    oi.product_name, 
    oi.quantity, 
    oi.price
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id;


-- Yêu cầu 3: Tính tổng tiền của mỗi đơn hàng (Số lượng * Đơn giá và gom nhóm)
SELECT 
    oi.order_id, 
    SUM(oi.quantity * oi.price) AS tong_tien_don_hang
FROM order_items oi
GROUP BY oi.order_id;


-- Yêu cầu 4: Hiển thị các đơn hàng có tổng tiền lớn hơn 10.000.000 (Dùng HAVING sau GROUP BY)
SELECT 
    oi.order_id, 
    SUM(oi.quantity * oi.price) AS tong_tien_don_hang
FROM order_items oi
GROUP BY oi.order_id
HAVING SUM(oi.quantity * oi.price) > 10000000.00;
