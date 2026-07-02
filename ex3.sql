-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & DỮ LIỆU MẪU ĐỂ CHẠY THỬ
-- =========================================================================
CREATE DATABASE IF NOT EXISTS quan_ly_kho_subquery;
USE quan_ly_kho_subquery;

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(15, 2) NOT NULL
);

INSERT INTO products (product_id, product_name, category, price) VALUES
('P001', 'iPhone 15 Pro Max', 'Phone', 30000000.00), -- Loại Phone (>20M)
('P002', 'Samsung Galaxy S23', 'Phone', 18000000.00),
('P003', 'Oppo Reno 10', 'Phone', 10000000.00),
('P004', 'MacBook Air M2', 'Laptop', 26000000.00),   -- Loại Laptop (>20M)
('P005', 'Asus Vivobook', 'Laptop', 15000000.00),
('P006', 'iPad Gen 9', 'Tablet', 7000000.00),       -- Loại Tablet (Không có cái nào >20M)
('P007', 'Samsung Galaxy Tab S9', 'Tablet', 13000000.00);

-- Giá trung bình toàn bộ sản phẩm ở đây là: ~18.428.571


-- =========================================================================
-- ĐOẠN 2: TRUY VẤN LỒNG (SUBQUERY)
-- =========================================================================

-- Yêu cầu 1: Hiển thị sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
SELECT * 
FROM products
WHERE price > (SELECT AVG(price) FROM products);


-- Yêu cầu 2: Hiển thị sản phẩm có giá cao nhất trong từng loại sản phẩm (Subquery tương quan)
SELECT p1.* 
FROM products p1
WHERE p1.price = (
    SELECT MAX(p2.price) 
    FROM products p2 
    WHERE p2.category = p1.category
);


-- Yêu cầu 3: Hiển thị các sản phẩm thuộc loại có ít nhất một sản phẩm giá trên 20.000.000
SELECT * 
FROM products
WHERE category IN (
    SELECT DISTINCT category 
    FROM products 
    WHERE price > 20000000.00
);
