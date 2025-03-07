/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from CSV files to bronze tables.

Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';

        DECLARE @table_name NVARCHAR(255), @file_path NVARCHAR(255);
        DECLARE table_cursor CURSOR FOR
        SELECT table_name, file_path FROM (
            VALUES 
                ('address', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_entities\address.csv'),
                ('address_status', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_metadata\address_status.csv'),
                ('author', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_entities\author.csv'),
                ('book_author', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_entites\book_author.csv'),
                ('book_language', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_metadata\book_language.csv'),
                ('book', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_entites\book.csv'),
                ('country', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_metadata\country.csv'),
                ('cust_order', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_transactions\cust_order.csv'),
                ('customer_address', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_entities\customer_address.csv'),
                ('customer', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_entities\customer.csv'),
                ('order_history', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_transactions\order_history.csv'),
                ('order_line', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_transactions\order_line.csv'),
                ('order_status', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_metadata\order_status.csv'),
                ('publisher', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_metadata\publisher.csv'),
                ('shipping_method', '\Users\karsh\Downloads\sql-data-warehouse-project\raw_metadata\shipping_method.csv')
        ) AS table_files (table_name, file_path);

        OPEN table_cursor;
        FETCH NEXT FROM table_cursor INTO @table_name, @file_path;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @start_time = GETDATE();
            PRINT '>> Truncating Table: bronze.' + @table_name;
            EXEC('TRUNCATE TABLE bronze.' + @table_name);
            
            PRINT '>> Inserting Data Into: bronze.' + @table_name;
            EXEC(
                'BULK INSERT bronze.' + @table_name + 
                ' FROM ''' + @file_path + ''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK)'
            );
            
            SET @end_time = GETDATE();
            PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
            PRINT '>> -------------';
            
            FETCH NEXT FROM table_cursor INTO @table_name, @file_path;
        END

        CLOSE table_cursor;
        DEALLOCATE table_cursor;

        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';
    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;
GO
