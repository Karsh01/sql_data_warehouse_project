/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'silver' schema from the 'bronze' layer. 
    It performs the following actions:
    - Truncates the silver tables before loading data.
    - Uses INSERT INTO ... SELECT statements to transform and load data from bronze tables.

Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        -- Load silver_book_details
        PRINT '>> Truncating Table: silver.book_details';
        TRUNCATE TABLE silver.silver_book_details;
        PRINT '>> Inserting Data Into: silver.book_details';
        INSERT INTO silver.book_details
        SELECT
            b.book_id,
            b.title,
            b.isbn13,
            bl.language_code,
            bl.language_name,
            b.num_pages,
            b.publication_date,
            p.publisher_name,
            ba.author_id,
            a.author_name
        FROM bronze.book b
        JOIN bronze.book_author ba ON b.book_id = ba.book_id
        JOIN bronze.author a ON ba.author_id = a.author_id
        JOIN bronze.book_language bl ON b.language_id = bl.language_id
        JOIN bronze.publisher p ON b.publisher_id = p.publisher_id;
        PRINT '>> silver_book_details Loaded';
        
        -- Load silver_customer_data
        PRINT '>> Truncating Table: silver.customer_data';
        TRUNCATE TABLE silver.customer_data;
        PRINT '>> Inserting Data Into: silver.customer_data';
        INSERT INTO silver.customer_data
        SELECT
            c.customer_id,
            c.first_name,
            c.last_name,
            c.email,
            ca.address_id,
            a.street_number,
            a.street_name,
            a.city,
            co.country_name,
            ast.address_status
        FROM bronze.customer c
        JOIN bronze.customer_address ca ON c.customer_id = ca.customer_id
        JOIN bronze.address a ON ca.address_id = a.address_id
        JOIN bronze.country co ON a.country_id = co.country_id
        JOIN bronze.address_status ast ON ca.status_id = ast.status_id;
        PRINT '>> silver_customer_data Loaded';
        
        -- Load silver_orders
        PRINT '>> Truncating Table: silver.orders';
        TRUNCATE TABLE silver.orders;
        PRINT '>> Inserting Data Into: silver.orders';
        INSERT INTO silver.orders
        SELECT
            o.order_id,
            o.order_date,
            o.customer_id,
            ol.book_id,
            ol.price,
            oh.status_id,
            os.status_value,
            oh.status_date
        FROM bronze.cust_order o
        JOIN bronze.order_line ol ON o.order_id = ol.order_id
        JOIN bronze.order_history oh ON o.order_id = oh.order_id
        JOIN bronze.order_status os ON oh.status_id = os.status_id;
        PRINT '>> silver_orders Loaded';
        
        -- Load silver_shipping
        PRINT '>> Truncating Table: silver.shipping';
        TRUNCATE TABLE silver.shipping;
        PRINT '>> Inserting Data Into: silver.shipping';
        INSERT INTO silver.shipping
        SELECT
            o.order_id,
            sm.method_name,
            sm.cost
        FROM bronze.cust_order o
        JOIN bronze.shipping_method sm ON o.shipping_method_id = sm.method_id;
        PRINT '>> silver_shipping Loaded';
        
        SET @batch_end_time = GETDATE();
        PRINT '=========================================='
        PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '=========================================='
    END TRY
    BEGIN CATCH
        PRINT '=========================================='
        PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
    END CATCH
END;
GO
