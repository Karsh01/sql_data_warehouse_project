/*
===============================================================================
Quality Checks Script: Silver Layer
===============================================================================
Script Purpose:
    This script performs data quality checks on the 'silver' schema tables to ensure
    data integrity before loading into the Gold Layer.
    - Checks for NULL or duplicate primary keys.
    - Checks for unwanted spaces in string fields.
    - Ensures data standardization and consistency.
    - Validates date ranges and logical order constraints.
    - Ensures data consistency between related fields.

Usage Notes:
    - Run these checks after data loading into the Silver Layer.
===============================================================================
*/

-- ====================================================================
-- Checking 'book_details'
-- ====================================================================
PRINT 'Checking book_details';

-- Check for NULLs or Duplicates in Primary Key
SELECT book_id, COUNT(*) 
FROM silver.book_details 
GROUP BY book_id 
HAVING COUNT(*) > 1 OR book_id IS NULL;

-- Check for Unwanted Spaces
SELECT title FROM silver.book_details WHERE title != TRIM(title);

-- Data Standardization & Consistency
SELECT DISTINCT language_name FROM silver.book_details;

-- ====================================================================
-- Checking 'customer_data'
-- ====================================================================
PRINT 'Checking customer_data';

-- Check for NULLs or Duplicates in Primary Key
SELECT customer_id, COUNT(*) 
FROM silver.customer_data 
GROUP BY customer_id 
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- Check for Unwanted Spaces
SELECT first_name FROM silver.customer_data WHERE first_name != TRIM(first_name);

-- Check for Address Consistency
SELECT DISTINCT address_status FROM silver.customer_data;

-- ====================================================================
-- Checking 'orders'
-- ====================================================================
PRINT 'Checking orders';

-- Check for NULLs in critical fields
SELECT order_id, COUNT(*) 
FROM silver.orders 
WHERE order_id IS NULL OR customer_id IS NULL OR book_id IS NULL OR price IS NULL;

-- Check for Duplicate Orders
SELECT order_id, COUNT(*) 
FROM silver.orders 
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- Check for Invalid Date Orders (Order Date > Status Date)
SELECT * FROM silver.orders 
WHERE order_date > status_date;

-- ====================================================================
-- Checking 'shipping'
-- ====================================================================
PRINT 'Checking shipping';

-- Check for NULL values in critical fields
SELECT order_id FROM silver.shipping WHERE shipping_method IS NULL;

-- Check for Unwanted Spaces in Shipping Method
SELECT shipping_method FROM silver.shipping WHERE shipping_method != TRIM(shipping_method);

-- ====================================================================
-- Foreign Key Integrity Checks
-- ====================================================================
PRINT 'Checking foreign key integrity';

-- Validate Orders have Customers
SELECT o.order_id FROM silver.orders o
LEFT JOIN silver.customer_data c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Validate Orders have Books
SELECT o.book_id FROM silver.orders o
LEFT JOIN silver.book_details b ON o.book_id = b.book_id
WHERE b.book_id IS NULL;

-- Validate Shipping Matches Orders
SELECT s.order_id FROM silver.shipping s
LEFT JOIN silver.orders o ON s.order_id = o.order_id
WHERE o.order_id IS NULL;

-- ====================================================================
-- Completeness Checks
-- ====================================================================
PRINT 'Checking completeness of data';
SELECT 'silver_book_details' AS Table_Name, COUNT(*) AS Record_Count FROM silver.book_details;
SELECT 'silver_customer_data' AS Table_Name, COUNT(*) AS Record_Count FROM silver.customer_data;
SELECT 'silver_orders' AS Table_Name, COUNT(*) AS Record_Count FROM silver.orders;
SELECT 'silver_shipping' AS Table_Name, COUNT(*) AS Record_Count FROM silver.shipping;

PRINT 'Data Quality Checks Completed Successfully';
