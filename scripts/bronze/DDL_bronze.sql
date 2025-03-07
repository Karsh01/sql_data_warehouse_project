/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
===============================================================================
*/

IF OBJECT_ID('bronze.address', 'U') IS NOT NULL
    DROP TABLE bronze.address;
GO

CREATE TABLE bronze.address (
    address_id      INT,
    street_number   NVARCHAR(10),
    street_name     NVARCHAR(255),
    city           NVARCHAR(100),
    country_id      INT
);
GO

IF OBJECT_ID('bronze.address_status', 'U') IS NOT NULL
    DROP TABLE bronze.address_status;
GO

CREATE TABLE bronze.address_status (
    status_id       INT,
    address_status  NVARCHAR(10)
);
GO

IF OBJECT_ID('bronze.author', 'U') IS NOT NULL
    DROP TABLE bronze.author;
GO

CREATE TABLE bronze.author (
    author_id   INT,
    author_name NVARCHAR(255)
);
GO

IF OBJECT_ID('bronze.book_author', 'U') IS NOT NULL
    DROP TABLE bronze.book_author;
GO

CREATE TABLE bronze.book_author (
    book_id    INT,
    author_id  INT
);
GO

IF OBJECT_ID('bronze.book_language', 'U') IS NOT NULL
    DROP TABLE bronze.book_language;
GO

CREATE TABLE bronze.book_language (
    language_id   INT,
    language_code NVARCHAR(10),
    language_name NVARCHAR(100)
);
GO

IF OBJECT_ID('bronze.book', 'U') IS NOT NULL
    DROP TABLE bronze.book;
GO

CREATE TABLE bronze.book (
    book_id           INT,
    title            NVARCHAR(255),
    isbn13           NVARCHAR(13),
    language_id      INT,
    num_pages        INT,
    publication_date DATE,
    publisher_id     INT
);
GO

IF OBJECT_ID('bronze.country', 'U') IS NOT NULL
    DROP TABLE bronze.country;
GO

CREATE TABLE bronze.country (
    country_id   INT,
    country_name NVARCHAR(100)
);
GO

IF OBJECT_ID('bronze.cust_order', 'U') IS NOT NULL
    DROP TABLE bronze.cust_order;
GO

CREATE TABLE bronze.cust_order (
    order_id          INT,
    order_date        DATE,
    customer_id       INT,
    shipping_method_id INT,
    dest_address_id   INT
);
GO

IF OBJECT_ID('bronze.customer_address', 'U') IS NOT NULL
    DROP TABLE bronze.customer_address;
GO

CREATE TABLE bronze.customer_address (
    customer_id INT,
    address_id  INT,
    status_id   INT
);
GO

IF OBJECT_ID('bronze.customer', 'U') IS NOT NULL
    DROP TABLE bronze.customer;
GO

CREATE TABLE bronze.customer (
    customer_id INT,
    first_name  NVARCHAR(100),
    last_name   NVARCHAR(100),
    email       NVARCHAR(255)
);
GO

IF OBJECT_ID('bronze.order_history', 'U') IS NOT NULL
    DROP TABLE bronze.order_history;
GO

CREATE TABLE bronze.order_history (
    history_id  INT,
    order_id    INT,
    status_id   INT,
    status_date DATE
);
GO

IF OBJECT_ID('bronze.order_line', 'U') IS NOT NULL
    DROP TABLE bronze.order_line;
GO

CREATE TABLE bronze.order_line (
    line_id  INT,
    order_id INT,
    book_id  INT,
    price    DECIMAL(10,2)
);
GO

IF OBJECT_ID('bronze.order_status', 'U') IS NOT NULL
    DROP TABLE bronze.order_status;
GO

CREATE TABLE bronze.order_status (
    status_id    INT,
    status_value NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.publisher', 'U') IS NOT NULL
    DROP TABLE bronze.publisher;
GO

CREATE TABLE bronze.publisher (
    publisher_id   INT,
    publisher_name NVARCHAR(255)
);
GO

IF OBJECT_ID('bronze.shipping_method', 'U') IS NOT NULL
    DROP TABLE bronze.shipping_method;
GO

CREATE TABLE bronze.shipping_method (
    method_id   INT,
    method_name NVARCHAR(100),
    cost        DECIMAL(10,2)
);
GO
