SELECT table_name
FROM
    INFORMATION_SCHEMA.TABLES
WHERE 
    table_type = 'BASE TABLE';


SELECT TABLE_NAME
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_TYPE = 'BASE TABLE' 
    AND 
    table_schema = 'public'
ORDER BY
    table_name;

 
-- Saved in tables_and_columns as Milestone10.csv 
-- Do the same for all other tables, but save as their table name.

SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'orders'
ORDER BY
    COLUMN_NAME;

SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'country_region'
ORDER BY
    COLUMN_NAME;

SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'dim_customer'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'dim_date'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'dim_product'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'dim_store'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'forquerying2'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'forview'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'my_store_overviews'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'my_store_overviews_2'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'my_store_overviewsnew'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'new_store_overview'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'test'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'test_store_overviews'
ORDER BY
    COLUMN_NAME;


SELECT COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'test_store_overviews_2'
ORDER BY
    COLUMN_NAME;


SELECT full_region 
FROM 
    dim_store

-- Questions:
-- q1: How many staff are there in all of the UK stores?
SELECT staff_numbers, full_region
FROM
    dim_store
WHERE
    full_region LIKE '%UK%';
    
SELECT sum(staff_numbers) AS Total_UK_Staff
FROM
    dim_store
WHERE
    full_region LIKE '%UK%';

-- q2: Which month in 2022 has had the highest revenue?

SELECT month_name, SUM(product_quantity * sale_price) AS Revenue
FROM 
    forview
WHERE
    dates LIKE '%2022%'
GROUP BY
    month_name
ORDER BY
    Revenue DESC
LIMIT 
    1;


-- q3: Which German store type had the highest revenue for 2022?

SELECT store_type, SUM(product_quantity * sale_price) AS Revenue
FROM 
    forview
WHERE
    dates LIKE '%2022%'
    AND
    country = 'Germany'
GROUP BY
    store_type
ORDER BY
    Revenue DESC
LIMIT 1;

-- q4: Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders

CREATE VIEW StoreSalesView AS
SELECT
    store_type,
    SUM(product_quantity * sale_price) AS Total_Sales,
    (SUM(product_quantity * sale_price) / (SELECT SUM(product_quantity * sale_price) FROM forview)) * 100 AS Percentage_Of_Total_Sales,
    COUNT(*) AS Order_Count
FROM
    forview
GROUP BY
    store_type;

SELECT * FROM StoreSalesView;


-- q5: Which product category generated the most profit for the "Wiltshire, UK" region in 2021?

SELECT category, SUM((product_quantity * sale_price) - cost_price) AS profit
FROM
    forview
WHERE
    full_region = 'Wiltshire, UK' AND dates LIKE '%2021%'
GROUP BY
    category
ORDER BY
    profit DESC
LIMIT 
    1;