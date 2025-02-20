/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema
===============================================================================
*/

-- Create Address Table
CREATE TABLE bronze.address (
    address_id INT PRIMARY KEY,
    street_number VARCHAR(10),
    street_name VARCHAR(255),
    city VARCHAR(100),
    country_id INT
);

-- Create Address Status Table
CREATE TABLE bronze.address_status (
    status_id INT PRIMARY KEY,
    address_status VARCHAR(40)
);

-- Create Author Table
CREATE TABLE bronze.author (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(255)
);

-- Create Book Author Table
CREATE TABLE bronze.book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id)
);

-- Create Book Language Table
CREATE TABLE bronze.book_language (
    language_id INT PRIMARY KEY,
    language_code VARCHAR(10),
    language_name VARCHAR(50)
);

-- Create Book Table
CREATE TABLE bronze.book (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    isbn13 VARCHAR(20),
    language_id INT,
    num_pages INT,
    publication_date DATE,
    publisher_id INT
);

-- Create Country Table
CREATE TABLE bronze.country (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100)
);

-- Create Customer Order Table
CREATE TABLE bronze.cust_order (
    order_id AUTO_INCREMENT INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    shipping_method_id INT,
    dest_address_id INT
);

-- Create Customer Address Table
CREATE TABLE bronze.customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id)
);

-- Create Customer Table
CREATE TABLE bronze.customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255)
);

-- Create Order History Table
CREATE TABLE bronze.order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    status_date TIMESTAMP
);

-- Create Order Line Table
CREATE TABLE bronze.order_line (
    line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    price DECIMAL(10,2)
);

-- Create Order Status Table
CREATE TABLE bronze.order_status (
    status_id INT PRIMARY KEY,
    status_value VARCHAR(50)
);

-- Create Publisher Table
CREATE TABLE bronze.publisher (
    publisher_id INT PRIMARY KEY,
    publisher_name VARCHAR(255)
);

-- Create Shipping Method Table
CREATE TABLE bronze.shipping_method (
    method_id INT PRIMARY KEY,
    method_name VARCHAR(100),
    cost DECIMAL(10,2)
);