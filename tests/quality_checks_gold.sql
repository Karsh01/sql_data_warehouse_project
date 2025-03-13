/*
===============================================================================
Quality Checks Script: Gold Layer
===============================================================================
Script Purpose:
    This script performs data quality checks on the 'gold' schema tables to ensure
    data integrity before reporting and analytics.
    - Checks for NULL or duplicate primary keys.
    - Checks for unwanted spaces in string fields.
    - Ensures data standardization and consistency.
    - Validates date ranges and logical order constraints.
    - Ensures data consistency between related fields.

Usage Notes:
    - Run these checks after data loading into the Gold Layer.
===============================================================================
*/

-- ====================================================================
-- Checking 'fact_sales'
-- ====================================================================
PRINT 'Checking fact_sales';

-- Check for NULLs in critical fields
SELECT order_id, COUNT(*) 
FROM gold.fact_sales 
WHERE order_id IS NULL OR customer_id IS NULL OR book_id IS NULL OR price IS NULL;

-- Check for Duplicate Orders
SELECT order_id, COUNT(*) 
FROM gold.fact_sales 
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- Check for Invalid Date Orders (Order Date > Current Date)
SELECT * FROM gold.fact_sales 
WHERE order_date > GETDATE();

-- Check Data Consistency: Sales = Price Validation
SELECT * FROM gold.fact_sales 
WHERE price <= 0 OR price IS NULL;

-- ====================================================================
-- Checking 'dim_customers'
-- ====================================================================
PRINT 'Checking dim_customers';

-- Check for NULLs or Duplicates in Primary Key
SELECT customer_id, COUNT(*) 
FROM gold.dim_customers 
GROUP BY customer_id 
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- Check for Unwanted Spaces
SELECT full_name FROM gold.dim_customers WHERE full_name != TRIM(full_name);

-- Check for Address Consistency
SELECT DISTINCT address_status FROM gold.dim_customers;

-- ====================================================================
-- Checking 'dim_books'
-- ====================================================================
PRINT 'Checking dim_books';

-- Check for NULLs or Duplicates in Primary Key
SELECT book_id, COUNT(*) 
FROM gold.dim_books 
GROUP BY book_id 
HAVING COUNT(*) > 1 OR book_id IS NULL;

-- Check for Unwanted Spaces in Title
SELECT title FROM gold.dim_books WHERE title != TRIM(title);

-- Validate ISBN Format (13 characters)
SELECT * FROM gold.dim_books WHERE LEN(isbn13) != 13;

-- ====================================================================
-- Checking 'dim_orders'
-- ====================================================================
PRINT 'Checking dim_orders';

-- Check for NULLs in critical fields
SELECT order_id FROM gold.dim_orders WHERE order_date IS NULL;

-- Check for Unwanted Spaces in Status
SELECT status_value FROM gold.dim_orders WHERE status_value != TRIM(status_value);

-- Validate Shipping Methods Consistency
SELECT DISTINCT shipping_method FROM gold.dim_orders;

-- ====================================================================
-- Foreign Key Integrity Checks
-- ====================================================================
PRINT 'Checking foreign key integrity';

-- Validate Orders have Customers
SELECT f.order_id FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Validate Orders have Books
SELECT f.book_id FROM gold.fact_sales f
LEFT JOIN gold.dim_books b ON f.book_id = b.book_id
WHERE b.book_id IS NULL;

-- Validate Orders in dim_orders match fact_sales
SELECT d.order_id FROM gold.dim_orders d
LEFT JOIN gold.fact_sales f ON d.order_id = f.order_id
WHERE f.order_id IS NULL;

-- ====================================================================
-- Completeness Checks
-- ====================================================================
PRINT 'Checking completeness of data';
SELECT 'fact_sales' AS Table_Name, COUNT(*) AS Record_Count FROM gold.fact_sales;
SELECT 'dim_customers' AS Table_Name, COUNT(*) AS Record_Count FROM gold.dim_customers;
SELECT 'dim_books' AS Table_Name, COUNT(*) AS Record_Count FROM gold.dim_books;
SELECT 'dim_orders' AS Table_Name, COUNT(*) AS Record_Count FROM gold.dim_orders;

PRINT 'Gold Layer Data Quality Checks Completed Successfully';