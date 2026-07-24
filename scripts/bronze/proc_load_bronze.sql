/*
=======================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=======================================================================================
Script Purpose:
  This stored procedure loads data from the external csv files into the 'bronze' schema.
  It performs the following actions:
  - Truncate the bronze tables before loading the data
  - Uses the 'BULK INSERT' command to load data from csv files to bronze tables.
Parameters:
  None.
This stored procedure does not accept any parameters or return any values.
Usage examples:
  Exec bronze.load_bronze;
=======================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
    DECLARE @start_time DATETIME;
    DECLARE @end_time DATETIME;
    declare @batch_start_time datetime;
    declare @batch_end_time datetime;

    BEGIN TRY
        set @batch_start_time = getdate();
        PRINT'=======================================================';
        PRINT 'Loading Bronze Layer';
        PRINT'========================================================';

        PRINT'--------------------------------------------------------';
        PRINT'Loading CRM table';
        PRINT'--------------------------------------------------------';
        
        SET @start_time = GETDATE();
        PRINT'>> Truncating table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_customer_info;
        
        print'>> Inserting data into table: bronze.crm_cust_info';
        bulk insert bronze.crm_customer_info
        from 'C:\Users\ace\Desktop\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        with(
        firstrow=2,
        fieldterminator=',',
        tablock
        );
        set @end_time = getdate();
        print'>> Total time to load data into table: bronze.crm_customer_info' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>>----------';

        set @start_time = getdate();
        print'>> Truncating table: bronze.crm_product_info';
        truncate table bronze.crm_product_info;

        set @start_time = getdate();
        print'>> Inserting data into table: bronze.crm_product_info';
        bulk insert bronze.crm_product_info
        from 'C:\Users\ace\Desktop\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        with(
        firstrow=2,
        fieldterminator=',',
        tablock
        );
        set @end_time = getdate();
        print'>> Total time to load data into table: bronze.crm_product_info' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>>----------';
        
        set @start_time = getdate();
        print'>> Truncating table: bronze.crm_sales_details';
        truncate table bronze.crm_sales_details;
        print'>> Inserting data into table: bronze.crm_sales_details';
        bulk insert bronze.crm_sales_details
        from 'C:\Users\ace\Desktop\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        with(
        firstrow=2,
        fieldterminator=',',
        tablock
        );
        set @end_time = getdate();
        print'>> Total time to load data into table: bronze.crm_sales_details' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>>----------';

        print'-------------------------------------------------------';
        print'Loading ERP table';
        print'-------------------------------------------------------';
        
        set @start_time = getdate();
        print'>> Truncating table: bronze.erp_cust_az12';
        truncate table bronze.erp_cust_az12;

        print'>> Inserting data into table: bronze.erp_cust_az12';
        bulk insert bronze.erp_cust_az12
        from 'C:\Users\ace\Desktop\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
        with(
        firstrow=2,
        fieldterminator=',',
        tablock
        );
        set @end_time = getdate();
        print'>> Total time to load data into table: bronze.erp_cust_az12' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>>--------------';

        set @start_time = getdate();
        print'>> Truncating table: bronze.erp_loc_a101';
        truncate table bronze.erp_loc_a101;

        print'>> Inserting data into table: bronze.erp_loc_a101';
        bulk insert bronze.erp_loc_a101
        from 'C:\Users\ace\Desktop\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
        with(
        firstrow=2,
        fieldterminator=',',
        tablock
        );
        set @end_time = getdate();
        print'>> Total time to load data into table: bronze.erp_loc_a101' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>>---------------'; 

        set @start_time = getdate();
        print'>> Truncating table: bronze.erp_PX_CAT_G1V2';
        truncate table bronze.erp_PX_CAT_G1V2;

        print'>> Inserting data into table: bronze.erp_PX_CAT_G1V2';
        bulk insert bronze.erp_PX_CAT_G1V2
        from 'C:\Users\ace\Desktop\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
        with(
        firstrow=2,
        fieldterminator=',',
        tablock
        );
        set @end_time = getdate();
        print'>> Total time to load data into table: bronze.erp_PX_CAT_G1V2' + ' ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>>---------------';

        set @batch_end_time = getdate();
        print '--------------------------';
        print 'Loading Bronze Layer is Completed'
        print'>> Total time to load data into table: bronze.load_bronze' + ' ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds';
        print'---------------------------';
    END TRY
        BEGIN CATCH
            print '=======================================================';
            print 'Error occured during loading Bronze Layer';
            print 'Error message: ' + ERROR_MESSAGE();
            print 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
            print 'Error line: ' + CAST(ERROR_LINE() AS NVARCHAR);
            print '========================================================';
        END CATCH
    END
    GO

exec bronze.load_bronze
