
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



CREATE TABLE product_categories (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    product_id INT, 
    category_id INT, 
    FOREIGN KEY (product_id) REFERENCES products(id), 
    FOREIGN KEY (category_id) REFERENCES categories(id)
); 


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












    
