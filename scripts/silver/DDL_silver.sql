/*
===============================================================================
DDL Script: Create Silver Layer Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
===============================================================================
*/

-- Drop and Create silver_book_details
IF OBJECT_ID('silver.book_details', 'U') IS NOT NULL
    DROP TABLE silver.book_details;
GO

CREATE TABLE silver.book_details (
    book_id         INT,
    title           NVARCHAR(255),
    isbn13          NVARCHAR(13),
    language_code   NVARCHAR(10),
    language_name   NVARCHAR(100),
    num_pages       INT,
    publication_date DATE,
    publisher_name  NVARCHAR(255),
    author_id       INT,
    author_name     NVARCHAR(255)
);
GO

-- Drop and Create silver_customer_data
IF OBJECT_ID('silver.customer_data', 'U') IS NOT NULL
    DROP TABLE silver.customer_data;
GO

CREATE TABLE silver.customer_data (
    customer_id     INT,
    first_name      NVARCHAR(100),
    last_name       NVARCHAR(100),
    email           NVARCHAR(255),
    address_id      INT,
    street_number   NVARCHAR(50),
    street_name     NVARCHAR(255),
    city           NVARCHAR(100),
    country_name    NVARCHAR(100),
    address_status  NVARCHAR(50)
);
GO

-- Drop and Create silver_orders
IF OBJECT_ID('silver.orders', 'U') IS NOT NULL
    DROP TABLE silver.orders;
GO

CREATE TABLE silver.orders (
    order_id        INT,
    order_date      DATE,
    customer_id     INT,
    book_id         INT,
    price          DECIMAL(10,2),
    status_id       INT,
    status_value    NVARCHAR(50),
    status_date     DATE
);
GO

-- Drop and Create silver_shipping
IF OBJECT_ID('silver.shipping', 'U') IS NOT NULL
    DROP TABLE silver.shipping;
GO

CREATE TABLE silver.shipping (
    order_id        INT,
    shipping_method NVARCHAR(100),
    cost           DECIMAL(10,2)
);
GO
