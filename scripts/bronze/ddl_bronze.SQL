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

