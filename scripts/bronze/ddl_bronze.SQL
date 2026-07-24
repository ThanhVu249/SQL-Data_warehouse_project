/*
==========================================================
DDL Script: Create Bronze Tables
==========================================================
Script Purpose:
  This script creates tables in the 'bronze' schema, dropping existing tables if they already exist
 Run this script to re-define the DDL structure of 'bronze' tables
==========================================================
*/




if object_id('bronze.crm_customer_info', 'U') is NOT NULL
drop table bronze.crm_customer_info
create table bronze.crm_customer_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_first_name NVARCHAR(100),
    cst_last_name NVARCHAR(100),
    cst_material_status nvarchar(50),
    cst_gender nvarchar(20),
    cst_birth_date DATE
);
GO

create table bronze.crm_product_info(
    prd_id INT,
    prd_key nvarchar(50),
    prd_nm nvarchar(100),
    prd_cost INT,
    prd_line nvarchar(50),
    prd_start DATETIME,
    prd_end_dt DATETIME
);
GO

create table bronze.crm_sales_details (
    sls_ord_num nvarchar(50),
    sls_prd_key nvarchar(50),
    sls_cust_id int,
    sls_order_dt int,
    sls_ship_dt int,
    sls_due_dt int, 
    sls_sales int,
    sls_quantity int, 
    sls_price int
);
GO

create table bronze.erp_cust_az12(
    cid nvarchar(50),
    bdate datetime,
    gen nvarchar(50)
);
GO

create table bronze.erp_loc_a101(
    cid nvarchar(50),
    cntry nvarchar(50)
);
GO

create table bronze.erp_PX_CAT_G1V2(
    id nvarchar(50),
    cat nvarchar (50),
    subcat nvarchar(50),
    maintainance nvarchar(50)
);
GO

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
