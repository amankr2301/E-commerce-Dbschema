
CREATE DATABASE Bluemedix;
USE Bluemedix;

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    email VARCHAR(100) UNIQUE NOT NULL, 
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL, 
    billing_address TEXT NOT NULL, 
    default_shipping_address TEXT NOT NULL, 
    country VARCHAR(100)
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(100) UNIQUE NOT NULL, 
    description TEXT, 
    thumbnail TEXT
); 

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    sku VARCHAR(100) UNIQUE NOT NULL, 
    name VARCHAR(100) NOT NULL, 
    price FLOAT NOT NULL, 
    weight FLOAT NOT NULL, 
    descriptions TEXT, 
    thumbnail TEXT, 
    image VARCHAR(255), 
    create_date DATETIME DEFAULT NOW(), 
    stock INT NOT NULL
); 

-- RELATION WITH PRODUCTS AND CATEGORIES 

CREATE TABLE product_categories (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    product_id INT, 
    category_id INT, 
    FOREIGN KEY (product_id) REFERENCES products(id), 
    FOREIGN KEY (category_id) REFERENCES categories(id)
); 

-- RELATION WITH CUSTOMERS 

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    customer_id INT, 
    amount FLOAT NOT NULL, 
    shipping_address TEXT NOT NULL, 
    order_address TEXT NOT NULL, 
    order_email VARCHAR(100), 
    order_date DATETIME DEFAULT NOW(), 
    order_status VARCHAR(100) NOT NULL, 
    FOREIGN KEY (customer_id) REFERENCES customers(id)
); 

--  RELATION WITH ORDERS AND PRODUCTS 

CREATE TABLE order_details (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    order_id INT, 
    product_id INT, 
    price FLOAT , 
    sku VARCHAR(100), 
    quantity INT NOT NULL, 
    FOREIGN KEY (order_id) REFERENCES orders(id), 
    FOREIGN KEY (product_id) REFERENCES products(id)
); 

CREATE TABLE options (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    option_name VARCHAR(100) NOT NULL
); 

-- RELATION WITH OPTIONS AND PRODUCTS 

CREATE TABLE product_options (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    option_id INT, 
    product_id INT, 
    FOREIGN KEY (option_id) REFERENCES options(id), 
    FOREIGN KEY (product_id) REFERENCES products(id)
);


-- *************************************** queries ***********************************************************************

--  1. Retrieving top-selling medicines per region.

EXPLAIN ANALYZE
WITH RankedProducts AS (
    SELECT 
        c.country AS region,
        p.name AS medicine_name,
        p.sku,
        SUM(od.quantity) AS total_quantity_sold,
        RANK() OVER (PARTITION BY c.country ORDER BY SUM(od.quantity) DESC) AS sales_rank
    FROM orders o
    JOIN customers c ON o.customer_id = c.id
    JOIN order_details od ON o.id = od.order_id
    JOIN products p ON od.product_id = p.id
    WHERE o.order_status = 'Completed'
    GROUP BY c.country, p.id, p.name, p.sku
)
SELECT 
    region,
    medicine_name,
    sku,
    total_quantity_sold
FROM RankedProducts
WHERE sales_rank = 1
ORDER BY region, total_quantity_sold DESC;


--  2. 

SELECT 
    p.id,
    p.name,
    p.sku,
    p.stock AS current_stock,
    COALESCE(SUM(od.quantity), 0) AS total_quantity_sold,
    COALESCE(SUM(od.quantity * od.price), 0) AS cogs,
    p.stock AS average_inventory,
    COALESCE(SUM(od.quantity), 0) / NULLIF(p.stock, 0) AS inventory_turnover_rate
FROM 
    products p
LEFT JOIN 
    order_details od ON p.id = od.product_id
LEFT JOIN 
    orders o ON od.order_id = o.id AND o.order_status = 'Completed'
GROUP BY 
    p.id, p.name, p.sku, p.stock
ORDER BY 
    inventory_turnover_rate DESC;

-- 3.  

SELECT c.id, c.full_name, COUNT(o.id) AS total_orders
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.full_name
ORDER BY total_orders DESC;











    
