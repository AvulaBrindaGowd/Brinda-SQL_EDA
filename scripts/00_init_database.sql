DROP DATABASE IF EXISTS DataWarehouseAnalytics;
CREATE DATABASE DataWarehouseAnalytics;
USE DataWarehouseAnalytics;

CREATE TABLE dim_customers (
    customer_key     INT,
    customer_id      INT,
    customer_number  VARCHAR(50),
    first_name       VARCHAR(50),
    last_name        VARCHAR(50),
    country          VARCHAR(50),
    marital_status   VARCHAR(50),
    gender           VARCHAR(50),
    birthdate        VARCHAR(50),
    create_date      VARCHAR(50)
);

CREATE TABLE dim_products (
    product_key     INT,
    product_id      INT,
    product_number  VARCHAR(50),
    product_name    VARCHAR(50),
    category_id     VARCHAR(50),
    category        VARCHAR(50),
    subcategory     VARCHAR(50),
    maintenance     VARCHAR(50),
    cost            INT,
    product_line    VARCHAR(50),
    start_date      VARCHAR(50)
);

CREATE TABLE fact_sales (
    order_number   VARCHAR(50),
    product_key    INT,
    customer_key   INT,
    order_date     VARCHAR(50),
    shipping_date  VARCHAR(50),
    due_date       VARCHAR(50),
    sales_amount   INT,
    quantity       TINYINT,
    price          INT
);

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Load dim_customers
TRUNCATE TABLE dim_customers;
LOAD DATA LOCAL INFILE 'C:/Users/Brindagowd/Documents/sql-data-analytics-project-main/datasets/csv-files/gold.dim_customers.csv'
INTO TABLE dim_customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Load dim_products
TRUNCATE TABLE dim_products;
LOAD DATA LOCAL INFILE 'C:/Users/Brindagowd/Documents/sql-data-analytics-project-main/datasets/csv-files/gold.dim_products.csv'
INTO TABLE dim_products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Load fact_sales
TRUNCATE TABLE fact_sales;
LOAD DATA LOCAL INFILE 'C:/Users/Brindagowd/Documents/sql-data-analytics-project-main/datasets/csv-files/gold.fact_sales.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

UPDATE dim_customers SET birthdate   = NULL WHERE birthdate   = '';
UPDATE dim_customers SET create_date = NULL WHERE create_date = '';
ALTER TABLE dim_customers MODIFY birthdate   DATE;
ALTER TABLE dim_customers MODIFY create_date DATE;

UPDATE fact_sales SET order_date    = NULL WHERE order_date    = '';
UPDATE fact_sales SET shipping_date = NULL WHERE shipping_date = '';
UPDATE fact_sales SET due_date      = NULL WHERE due_date      = '';
ALTER TABLE fact_sales MODIFY order_date    DATE;
ALTER TABLE fact_sales MODIFY shipping_date DATE;
ALTER TABLE fact_sales MODIFY due_date      DATE;

UPDATE dim_products SET start_date = NULL WHERE start_date = '';
ALTER TABLE dim_products MODIFY start_date DATE;

-- Check if NULLs exist
SELECT 
    SUM(CASE WHEN category    IS NULL THEN 1 ELSE 0 END) AS null_categories,
    SUM(CASE WHEN subcategory IS NULL THEN 1 ELSE 0 END) AS null_subcategories,
    SUM(CASE WHEN category    = ''    THEN 1 ELSE 0 END) AS blank_categories,
    SUM(CASE WHEN subcategory = ''    THEN 1 ELSE 0 END) AS blank_subcategories
FROM dim_products;

-- TO FIX THE BLANKS IN CATEGORY AND SUBCATEGORY
UPDATE dim_products SET category    = NULL WHERE category    = '';
UPDATE dim_products SET subcategory = NULL WHERE subcategory = '';
-- Fix gender
UPDATE dim_customers SET gender = NULL 
WHERE gender IN ('n/a', 'N/A', 'na', 'NA', 'none', 'None', '-', '');

-- Fix country
UPDATE dim_customers SET country = NULL 
WHERE country IN ('n/a', 'N/A', 'na', 'NA', 'none', 'None', '-', '');

-- Fix marital_status
UPDATE dim_customers SET marital_status = NULL 
WHERE marital_status IN ('n/a', 'N/A', 'na', 'NA', 'none', 'None', '-', '');

-- Fix product_line
UPDATE dim_products 
SET product_line = NULL 
WHERE product_line IN ('n/a', 'N/A', 'na', 'NA', 'none', 'None', '-', '');

-- Re-enable safe mode (good practice)
SET SQL_SAFE_UPDATES = 1;


-- Verify
SELECT 'dim_customers' AS table_name, COUNT(*) AS total_rows FROM dim_customers
UNION ALL
SELECT 'dim_products',                COUNT(*)               FROM dim_products
UNION ALL
SELECT 'fact_sales',                  COUNT(*)               FROM fact_sales;