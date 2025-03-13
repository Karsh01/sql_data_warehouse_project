/*
===============================================================================
DDL Script: Create Gold Layer Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'gold' schema, dropping existing tables 
    if they already exist.
===============================================================================
*/

-- Drop and Create fact_sales
IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales (
    order_id        INT,
    order_date      DATE,
    customer_id     INT,
    book_id         INT,
    price          DECIMAL(10,2),
    status_id       INT,
    status_value    NVARCHAR(50),
    shipping_method NVARCHAR(100),
    shipping_cost   DECIMAL(10,2)
);
GO

-- Drop and Create dim_customers
IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
    DROP TABLE gold.dim_customers;
GO

CREATE TABLE gold.dim_customers (
    customer_id     INT PRIMARY KEY,
    full_name       NVARCHAR(255),
    email           NVARCHAR(255),
    city           NVARCHAR(100),
    country_name    NVARCHAR(100),
    address_status  NVARCHAR(50)
);
GO

-- Drop and Create dim_books
IF OBJECT_ID('gold.dim_books', 'U') IS NOT NULL
    DROP TABLE gold.dim_books;
GO

CREATE TABLE gold.dim_books (
    book_id         INT PRIMARY KEY,
    title           NVARCHAR(255),
    isbn13          NVARCHAR(13),
    author_name     NVARCHAR(255),
    language_name   NVARCHAR(100),
    num_pages       INT,
    publication_date DATE,
    publisher_name  NVARCHAR(255)
);
GO

-- Drop and Create dim_orders
IF OBJECT_ID('gold.dim_orders', 'U') IS NOT NULL
    DROP TABLE gold.dim_orders;
GO

CREATE TABLE gold.dim_orders (
    order_id        INT PRIMARY KEY,
    order_date      DATE,
    customer_id     INT,
    status_value    NVARCHAR(50),
    shipping_method NVARCHAR(100)
);
GO
