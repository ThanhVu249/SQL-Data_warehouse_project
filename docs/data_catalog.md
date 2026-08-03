### Data Dictionary for Gold Layer
---
## Overview
---
The gold layer is the business-level data representation, structured to support analytical and reporting use cases. It contains of dimension tables and fact tables for specific business metrics
---
## 1. gold.dim_customers
- **Purpose**: Stores customer details enriched with demographic and geographic data
- **Columns**:

|**Column Name**|**Data Type**|**Description**|
| --- | --- | --- |
| customer-key|INT|Surrogate key uniquely identifying each customer record in the dimension table.|
| customer_id|INT|Unique numerical identifier assigned to each customer.|
| customer_number|nvarchar(50)| Alphanumeric identifier representing the customer, used for tracking and referencing|
| customer_first_name|nvarchar(50)|The customer's first name, as recorded in the system|
| customer_last_name|nvarchar(50)|The customer's last name, as recorded in the system|
| country|nvarchar(50)|The country of residence for the customer (e.g.,'Australia')|
| customer_marital_status|nvarchar(50)| The marital status of the customer (e.g., 'Married','Single')|
| customer_gender|nvarchar(50)| The gender of the customer (e.g., 'Male', 'Female', 'Unknown')|

## 2. gold.dim_products
- **Purpose**: Stores information about the products and their attributes
- **Columns**:

|**Column Name**|**Date Type**|**Description**|
|---|---|---|
| product_key|INT| Surrogate key uniquely identifying each customer record in the dimension table.|
| Product_Id|INT| Unique numerical identifier assigned to each product.|
| Product_Number|nvarchar(50)| Alphanumeric identifier representing the product, used for tracking and referencing|
| Product_Name|nvarchar(50)| The name of each product, including key details such as type, color and size|
| category_id|nvarchar(50)| A unique identifier for the product's category, linking to its high-level classification|
| category|nvarchar(50)| The boarder classification of the product (e.g., Bikes, Components) to group related items|
| subcategory|nvarchar(50)| A more detailed classification of the product within the category such as product type|
| maintenance|nvarchar(50)| Indicates whether the product requires maintenance (e.g., 'Yes', 'No')|
| product_cost|INT| Indicates the cost or base line of the product, measured in monetary units|
| product_line|nvarchar(50)| The specific product line or series to which the product belongs (e.g., Road, Mountain)|
| start_date|date| the date when the product became available for sale or use, stored in|

## 3. gold.fact_sales
- **purpose**: stores transactional sales data for analytical purposes
- **Columns**:

|**Column Name**|**Data Type**|**Description**|
|---|---|---|
| order_number|nvarchar(50)| A unique alphanumeric identifier for each sales order (e.g., 'SO54496')|
| product_key|INT| Surrogate key uniquely identifying each customer record in the product dimension table.|
| customer-key|INT|Surrogate key uniquely identifying each customer record in the customer dimension table.|
| order_date|Date| The date when the order was placed|
| shipping_date|Date| The date when the order was shipped to the customer|
| due_date|Date| The last date that the customer can make their payment.|
| sales_amount|INT| The total monetary value of the sale for the item, in whole currency unit (e.g., 25)|
| quantity|INT|The number of units of the product ordered for the line item (e.g., 1)|
| price|INT| The price per unit of the product for the line item, in whole currency unit (e.g., 25)|


