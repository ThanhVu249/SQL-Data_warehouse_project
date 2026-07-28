/*
==========================================================
DDL Script: Create Silver Tables
==========================================================
Script Purpose:
  This script creates tables in the 'silver' schema, dropping existing tables if they already exist
 Run this script to re-define the DDL structure of 'silver' tables
==========================================================
*/

if object_id('silver.crm_customer_info', 'U') is NOT NULL
drop table silver.crm_customer_info
create table silver.crm_customer_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_first_name NVARCHAR(100),
    cst_last_name NVARCHAR(100),
    cst_material_status nvarchar(50),
    cst_gender nvarchar(20),
    cst_create_date DATE,
    dwh_create_date datetime2 default getdate() -- when the data is inserted into the table
);
GO

if object_id('silver.crm_product_info', 'U') is NOT NULL
drop table silver.crm_product_info
create table silver.crm_product_info(
    prd_id INT,
    cat_id nvarchar(50),
    prd_key nvarchar(50),
    prd_nm nvarchar(100),
    prd_cost INT,
    prd_line nvarchar(50),
    prd_start DATE,
    prd_end_dt DATE,
    dwh_create_date datetime2 default getdate()
);
GO

if object_id('silver.crm_sales_details', 'U') is NOT NULL
drop table silver.crm_sales_details
create table silver.crm_sales_details (
    sls_ord_num nvarchar(50),
    sls_prd_key nvarchar(50),
    sls_cust_id int,
    sls_order_dt date,
    sls_ship_dt date,
    sls_due_dt date, 
    sls_sales int,
    sls_quantity int, 
    sls_price int,
    dwh_create_date datetime2 default getdate()
);
GO

if object_id('silver.erp_cust_az12', 'U') is NOT NULL
drop table silver.erp_cust_az12
create table silver.erp_cust_az12(
    cid nvarchar(50),
    bdate date,
    gen nvarchar(50),
    dwh_create_date datetime2 default getdate()
);
GO

if object_id('silver.erp_loc_a101', 'U') is NOT NULL
drop table silver.erp_loc_a101
create table silver.erp_loc_a101(
    cid nvarchar(50),
    cntry nvarchar(50),
    dwh_create_date datetime2 default getdate()
);
GO

if object_id('silver.erp_PX_CAT_G1V2', 'U') is NOT NULL
drop table silver.erp_PX_CAT_G1V2
create table silver.erp_PX_CAT_G1V2(
    id nvarchar(50),
    cat nvarchar (50),
    subcat nvarchar(50),
    maintainance nvarchar(50),
    dwh_create_date datetime2 default getdate()
);
GO
