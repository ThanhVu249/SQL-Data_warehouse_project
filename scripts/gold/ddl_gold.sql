/*
====================================================================================
DDL Scripts: Create Gold Views
====================================================================================
Script Purpose:
  This script create views for the Gold Layer in the data warehouse.
  The gold layer represents the final dimension and fact tables (Star Schema)

  Each view performs transformations to product and combines data from the Silver Layer to produce a clean, enriched, and business-ready dataset.

Usage:
  - These views can be queried directly for analytics and reporting.
=====================================================================================
*/

--==================================================================================
-- Create Dimension: gold.dim_customers
--==================================================================================
If objectID('gold.dim_customers', 'V') is not null
  drop view gold.dim_customers;
go


create view gold.dim_customers as
select 
    row_number() over (order by cst_id) as customer_key,
    ci.cst_id as customer_id,
    ci.cst_key as customer_number,
    ci.cst_first_name as customer_first_name,
    ci.cst_last_name as customer_last_name,
    ci.cst_material_status as customer_marital_status,
    ci.cst_create_date as customer_create_date,
    ca.bdate as birth_date,
    case when ci.cst_gender != 'Unknown' then ci.cst_gender -- CRM is the Master for the gender info
    else coalesce(ca.gen, 'Unknown')
    end as customer_gender,
    la.cntry as country
from silver.crm_customer_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la   
on ci.cst_key = la.cid;

--==================================================================================
-- Create Dimension: gold.dim_products
--==================================================================================
If objectID('gold.dim_products', 'V') is not null
  drop view gold.dim_products;
go
create view gold.dim_products as
select
    row_number() over (order by pn.prd_start desc) as Product_key,
    pn.prd_id as Product_Id,
    pn.prd_key Product_Number,
    pn.prd_nm Product_Name,
    pn.cat_id Cateogory_Id,
    pc.cat Category,
    pc.subcat Subcategory,
    pc.maintainance Maintenance,
    pn.prd_cost Product_Cost,
    pn.prd_line Product_Line,
    pn.prd_start as start_date
from silver.crm_product_info pn 
left join silver.erp_PX_CAT_G1V2 pc
on pn.cat_id = pc.id
where prd_end_dt is null;
  
--==================================================================================
-- Create Fact: gold.fact_sales
--==================================================================================
If objectID('gold.fact_sales', 'V') is not null
  drop view gold.fact_sales;
go
create view gold.fact_sales as
SELECT
    sd.sls_ord_num as Order_Number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt as Order_Date,
    sd.sls_ship_dt as Ship_Date,
    sd.sls_due_dt as Due_Date,
    sd.sls_sales as Sales,
    sd.sls_quantity as Quantity,
    sd.sls_price as Price
from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id
