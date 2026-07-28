/*
=======================================================================================
Stored Procedure: Load Silver Layer (Bronze layer -> Silver Layer)
=======================================================================================
Script Purpose:
  This stored procedure loads data from the bronze layer into the 'silver' schema.
  It performs the following actions:
  - Truncate the silver tables before loading the data
  - Uses the INSERT command and cleansed the data to load them from bronze files to silver tables.
Parameters:
  None.
This stored procedure does not accept any parameters or return any values.
Usage examples:
  Exec silver.load_silver;
=======================================================================================
*/

create or alter procedure silver.load_silver as
Begin 
    DECLARE @start_time DATETIME;
    DECLARE @end_time DATETIME;
    declare @batch_start_time datetime;
    declare @batch_end_time datetime;
    
    begin try 
        set @batch_start_time = getdate();
            PRINT'=======================================================';
            PRINT'Loading Silver Layer';
            PRINT'========================================================';

        set @start_time = getdate();
        print'>> Truncating Table: silver.crm_customer_info';
        truncate table silver.crm_customer_info;
        print '>> Inserting Data Into: silver.crm_customer_info';
        insert into silver.crm_customer_info (
            cst_id, 
            cst_key, 
            cst_first_name, 
            cst_last_name, 
            cst_material_status, 
            cst_gender, 
            cst_create_date)
        select 
        cst_id,
        cst_key,
        trim(cst_first_name) as cst_first_name, --remove unwanted space in the first_name and last_name
        trim(cst_last_name) as cst_last_name, --remove unwanted space in the first_name and last_name
        case when upper(trim(cst_material_status)) = 'S' then 'Single'
            when upper(trim(cst_material_status)) = 'M' then 'Married'
            else 'Unknown' 
        end cst_material_status,
        case when Upper(trim(cst_gender)) = 'F' then 'Female'
            when Upper(trim(cst_gender)) = 'M' then 'Male'
            else 'Unknown' 
        end cst_gender,
        cst_create_date
        from(
            select *,
            row_number() over (partition by cst_id order by cst_create_date desc) as duplicate_rank
            from bronze.crm_customer_info
        )t where duplicate_rank = 1 and cst_id is not null; -- remove duplicate
        set @end_time = getdate()
        print 'Total Time to truncate and insert into silver.crm_customer_info:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
        print'>>----------';

        set @start_time = getdate()
        print '>>Truncating Table: silver.crm_product_info'
        truncate table silver.crm_product_info;
        print '>> Inserting Data Into: silver.crm_product_info';
        insert into silver.crm_product_info (
            prd_id, 
            cat_id, 
            prd_key, 
            prd_nm, 
            prd_cost, 
            prd_line, 
            prd_start, 
            prd_end_dt)
        SELECT
            prd_id,
            replace(substring(prd_key, 1, 5), '-', '_') as Category_id,
            substring(prd_key,7, len(prd_key)) as prd_key,
            prd_nm,
            isnull(prd_cost, 0) as prd_cost,
            case upper(trim(prd_line)) -- only when mapping value
                when 'M' then 'Mountain'
                when 'R' then 'Road'
                when 'T' then 'Touring'
                when 'S' then 'Other Sales'
                else 'Unknown' 
            end prd_line,
            cast(prd_start as date) as prd_start,
            cast(lead(prd_start) over(partition by prd_key order by prd_start) -1 as date) as prd_end_dt
        FROM bronze.crm_product_info;
        set @end_time = getdate()
        print 'Total Time to truncate and insert into silver.crm_product_info:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
        print'>>----------';

        set @start_time = getdate()
        print '>>Truncating Table: silver.crm_sales_details';
        truncate table silver.crm_sales_details;
        print '>> Inserting Data Into: silver.crm_sales_details';
        insert into silver.crm_sales_details (
            sls_ord_num, 
            sls_prd_key, 
            sls_cust_id, 
            sls_order_dt, 
            sls_ship_dt, 
            sls_due_dt, 
            sls_sales, 
            sls_quantity, 
            sls_price
        )
        select 
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            case when sls_order_dt = 0 or len(sls_order_dt) != 8 then null
                else cast(cast(sls_order_dt as varchar) as date)
            end sls_order_dt,
            case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null
                else cast(cast(sls_ship_dt as varchar) as date)
            end sls_ship_dt,
            case when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
                else cast(cast(sls_due_dt as varchar) as date)
            end sls_due_dt,
            case when sls_sales <=0 or sls_sales is null or sls_sales != sls_quantity * abs(sls_price) then sls_quantity * abs(sls_price)
                else sls_sales
            end as sls_sales,
            sls_quantity,
            case when sls_price <= 0 or sls_price is null then sls_sales/nullif(sls_quantity,0)
            else sls_price
            end as sls_price
        from bronze.crm_sales_details;
        set @end_time = getdate()
        print 'Total time to truncate and insert into silver.crm_sales_details:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
        print'>>----------';

        set @start_time = getdate()
        print '>> Truncating Table: silver.erp_cust_az12';
        truncate table silver.erp_cust_az12;
        print '>> Inserting Data Into: silver.erp_cust_az12';
        insert into silver.erp_cust_az12(
            cid,
            bdate,
            gen
        )
        SELECT 
            case when cid like'NAS%' then substring(cid, 4, len(cid)) -- remove 'NAS' prefix if present
            else cid
        end as cid,
            case when bdate < '1924-01-01' or bdate > getdate() then null
            else cast(bdate as date)
        end as bdate,
        case when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
            when upper(trim(gen)) in ('M', 'MALE') then 'Male'
            else 'n/a'
        end as gen
        from bronze.erp_cust_az12;
        set @end_time = getdate()
        print 'Total time to truncate and insert into silver.erp_cust_az12:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
        print'>>----------';

        set @start_time = getdate()
        print '>> Truncating Table: silver.erp_loc_a101';
        truncate table silver.erp_loc_a101;
        print '>> Inserting Data Into: silver.erp_loc_a101';
        insert into silver.erp_loc_a101 (
            cid,
            cntry
        )
        select 
        replace(cid, '-', '') cid,
        case when trim(cntry) in ('United States', 'US') then 'USA'
            when trim(cntry) = 'DE' then 'Germany'
            when trim(cntry) is null or cntry ='' then 'n/a'
            else trim(cntry)
        end as cntry
        from bronze.erp_loc_a101
        set @end_time = getdate()
        print 'Total time to truncate and insert intto silver.erp_loc_a101: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
        print'>>----------';

        set @start_time = getdate()
        print'>> Truncating table: silver.erp_PX_CAT_G1V2'
        truncate table silver.erp_PX_CAT_G1V2
        print '>> Inserting Data Into: silver.erp_PX_CAT_G1V2'
        insert into silver.erp_PX_CAT_G1V2(
            id,
            cat,
            subcat,
            maintainance
        ) select
        id,
        cat,
        subcat,
        maintainance
        from bronze.erp_PX_CAT_G1V2
        set @end_time = getdate()
        print 'Total time to truncate and insert into silver.erp_PX_CAT_G1V2:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
        print'>>----------';
        set @batch_end_time = getdate()
        print 'Total time of execution:' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds';
        print '========================================================';
    END TRY
        BEGIN CATCH
            print '=======================================================';
            print 'Error occured during loading Silver Layer';
            print 'Error message: ' + ERROR_MESSAGE();
            print 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
            print 'Error line: ' + CAST(ERROR_LINE() AS NVARCHAR);
            print '========================================================';
        END CATCH
end
