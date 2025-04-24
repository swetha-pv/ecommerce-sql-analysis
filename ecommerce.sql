CREATE DATABASE ecommerce;
use ecommerce;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255),
    address TEXT,
    phone_number VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10, 2),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE product_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);
CREATE TABLE product_options (
    option_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    option_name VARCHAR(255),
    option_value VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE option_groups (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL
);


INSERT INTO products (product_name, description, price, stock_quantity) VALUES
('Laptop', 'High-performance laptop with 16GB RAM', 1200.00, 50),
('Smartphone', 'Latest 5G smartphone with OLED display', 800.00, 200),
('Tablet', '10-inch tablet with stylus support', 400.00, 100),
('Headphones', 'Noise-cancelling over-ear headphones', 150.00, 75),
('Gaming Chair', 'Ergonomic chair with lumbar support', 300.00, 20),
('Monitor', '27-inch 4K UHD monitor', 250.00, 30),
('Mouse', 'Wireless ergonomic mouse', 30.00, 150),
('Keyboard', 'Mechanical keyboard with RGB backlight', 45.00, 120),
('External HDD', '2TB portable external hard drive', 100.00, 80),
('Router', 'Dual-band gigabit Wi-Fi router', 80.00, 60);

INSERT INTO users (first_name, last_name, email, password, address, phone_number) VALUES
('John', 'Doe', 'john.doe@example.com', 'pass1234', '123 Elm St, Springfield', '555-0101'),
('Jane', 'Smith', 'jane.smith@example.com', 'pass2345', '456 Oak St, Springfield', '555-0102'),
('Bob', 'Johnson', 'bob.johnson@example.com', 'pass3456', '789 Pine St, Springfield', '555-0103'),
('Alice', 'Williams', 'alice.williams@example.com', 'pass4567', '101 Maple St, Springfield', '555-0104'),
('Charlie', 'Brown', 'charlie.brown@example.com', 'pass5678', '202 Birch St, Springfield', '555-0105'),
('David', 'Davis', 'david.davis@example.com', 'pass6789', '303 Cedar St, Springfield', '555-0106'),
('Emma', 'Martinez', 'emma.martinez@example.com', 'pass7890', '404 Redwood St, Springfield', '555-0107'),
('Frank', 'Garcia', 'frank.garcia@example.com', 'pass8901', '505 Pine St, Springfield', '555-0108'),
('Grace', 'Lopez', 'grace.lopez@example.com', 'pass9012', '606 Cedar St, Springfield', '555-0109'),
('Henry', 'Miller', 'henry.miller@example.com', 'pass0123', '707 Oak St, Springfield', '555-0110');

INSERT INTO orders (user_id, total_amount) VALUES
(1, 1200.00),
(2, 800.00),
(3, 100.00),
(4, 150.00),
(5, 300.00),
(6, 250.00),
(7, 30.00),
(8, 45.00),
(9, 100.00),
(10, 80.00);

INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1200.00),   -- John bought 1 Laptop
(2, 2, 1, 800.00),    -- Jane bought 1 Smartphone
(3, 3, 5,  20.00),    -- Bob bought 5 Tablets (price per unit 20 for example)
(4, 4, 2,  150.00),   -- Alice bought 2 Headphones
(5, 5, 1,  300.00),   -- Charlie bought 1 Gaming Chair
(6, 6, 2,  250.00),   -- David bought 2 Monitors
(7, 7, 3,  30.00),    -- Emma bought 3 Mice
(8, 8, 1,  45.00),    -- Frank bought 1 Keyboard
(9, 9, 2,  100.00),   -- Grace bought 2 External HDDs
(10,10, 1,  80.00);   -- Henry bought 1 Router

INSERT INTO product_categories (category_name) VALUES
('Electronics'),
('Furniture'),
('Accessories');
INSERT INTO product_options (option_name) VALUES
('Color'),
('Size'),
('Storage'),
('Battery Life');

SELECT 
  pc.category_name,
  SUM(od.quantity) AS TotalSold
FROM product_categories pc
JOIN products p 
  ON pc.category_id = pc.category_id
JOIN order_details od 
  ON od.product_id = p.product_id
GROUP BY 
  pc.category_name
HAVING 
  TotalSold > 0
ORDER BY 
  TotalSold DESC;
  

SELECT
  o.order_id,
  u.first_name || ' ' || u.last_name AS customer,
  o.total_amount
FROM orders AS o
INNER JOIN users AS u
  ON o.user_id = u.user_id
WHERE o.order_date <= NOW()
  AND o.total_amount IS NOT NULL
ORDER BY o.order_date DESC;

SELECT
  p.product_name,
  po.option_name,
  po.option_value
FROM products AS p
LEFT JOIN product_options AS po
  ON p.product_id = po.product_id
ORDER BY p.product_name, po.option_name;

SELECT
  og.group_name
FROM option_groups AS og
RIGHT JOIN product_options AS po
  ON og.group_id = po.option_id
WHERE po.product_id IS NULL;


SELECT
  u.user_id, u.first_name, u.last_name
FROM users AS u
WHERE u.user_id IN (
  SELECT o.user_id
  FROM orders AS o
  GROUP BY o.user_id
  HAVING COUNT(*) 
);

SELECT
  p.product_name,
  SUM(od.quantity * od.price) AS revenue
FROM order_details AS od
JOIN products AS p
  ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;


SELECT
  AVG(o.total_amount) AS avg_order_value
FROM orders AS o;


CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
  p.product_id,
  p.product_name,
  COALESCE(SUM(od.quantity), 0)               AS total_units_sold,
  COALESCE(SUM(od.quantity * od.price), 0.00) AS total_revenue
FROM products AS p
LEFT JOIN order_details AS od
  ON p.product_id = od.product_id
GROUP BY
  p.product_id, p.product_name;

SELECT * FROM vw_product_performance;

SELECT * 
FROM vw_product_performance
WHERE total_units_sold > 0
ORDER BY total_revenue DESC;

EXPLAIN SELECT * 
FROM order_details 
WHERE product_id = 123;

EXPLAIN ANALYZE SELECT * 
FROM orders 
WHERE user_id = 456;

ANALYZE TABLE products;
ANALYZE TABLE order_details;
SHOW INDEXES FROM order_details;

