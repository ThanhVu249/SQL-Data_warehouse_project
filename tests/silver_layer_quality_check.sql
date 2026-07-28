/*
===============================================================================
Data Quality Checks - Silver Layer
===============================================================================
Purpose:
    This script contains various data quality checks to validate the integrity, 
    consistency, and standardization of the data in the Silver Layer.
    These checks ensure that the cleansing and transformation logic 
    applied during the Bronze to Silver process worked as expected.
===============================================================================
*/

-- ====================================================================
-- 1. Table: silver.crm_customer_info
-- ====================================================================

-- Check for Duplicates or NULLs in Primary Key (cst_id)
-- Expectation: No results should be returned (0 rows)
SELECT 
    cst_id,
    COUNT(*) as count_duplicate
FROM silver.crm_customer_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted leading/trailing spaces in string columns
-- Expectation: No results should be returned
SELECT cst_first_name, cst_last_name
FROM silver.crm_customer_info
WHERE cst_first_name != TRIM(cst_first_name)
   OR cst_last_name != TRIM(cst_last_name);

-- Check Data Standardization for Gender and Marital Status
-- Expectation: Only predefined values should exist
-- Marital: 'Single', 'Married', 'Unknown'
-- Gender: 'Male', 'Female', 'Unknown'
SELECT DISTINCT cst_material_status FROM silver.crm_customer_info;
SELECT DISTINCT cst_gender FROM silver.crm_customer_info;


-- ====================================================================
-- 2. Table: silver.crm_product_info
-- ====================================================================

-- Check for Duplicates or NULLs in Primary Key (prd_id)
-- Expectation: No results should be returned
SELECT 
    prd_id,
    COUNT(*) as count_duplicate
FROM silver.crm_product_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for negative costs
-- Expectation: No results should be returned (cost should be >= 0)
SELECT prd_id, prd_cost
FROM silver.crm_product_info
WHERE prd_cost < 0;

-- Check Date Logic: prd_end_dt should not be earlier than prd_start
-- Expectation: No results should be returned
SELECT prd_id, prd_start, prd_end_dt
FROM silver.crm_product_info
WHERE prd_end_dt < prd_start;

-- Check Data Standardization for Product Line
-- Expectation: Only valid mapped values like 'Mountain', 'Road', 'Touring', 'Other Sales', 'Unknown'
SELECT DISTINCT prd_line FROM silver.crm_product_info;


-- ====================================================================
-- 3. Table: silver.crm_sales_details
-- ====================================================================

-- Check for negative values in Sales, Quantity, or Price
-- Expectation: No results should be returned
SELECT sls_ord_num, sls_sales, sls_quantity, sls_price
FROM silver.crm_sales_details
WHERE sls_sales < 0 OR sls_quantity < 0 OR sls_price < 0;

-- Check Sales Calculation Consistency
-- Expectation: sls_sales should equal sls_quantity * sls_price
SELECT sls_ord_num, sls_sales, sls_quantity, sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
  AND sls_sales IS NOT NULL 
  AND sls_quantity IS NOT NULL 
  AND sls_price IS NOT NULL;

-- Check Date Logic: Order Date should not be after Shipping or Due Date
-- Expectation: No results should be returned
SELECT sls_ord_num, sls_order_dt, sls_ship_dt, sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;


-- ====================================================================
-- 4. Table: silver.erp_cust_az12
-- ====================================================================

-- Check Data Standardization for Gender
-- Expectation: 'Male', 'Female', 'n/a'
SELECT DISTINCT gen 
FROM silver.erp_cust_az12;

-- Check Out-of-Range Dates (Birthdates)
-- Expectation: No dates in the future or unreasonably old (e.g., before 1924)
SELECT cid, bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE() 
   OR bdate < '1924-01-01';


-- ====================================================================
-- 5. Table: silver.erp_loc_a101
-- ====================================================================

-- Check Data Standardization for Country
-- Expectation: Standardized country names ('USA', 'Germany', 'n/a')
SELECT DISTINCT cntry 
FROM silver.erp_loc_a101;
