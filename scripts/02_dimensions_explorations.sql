USE DataWarehouseAnalytics;

-- =============================================================
-- DIMENSIONS EXPLORATION
-- =============================================================

-- Question 1: Which countries do our customers come from?
SELECT DISTINCT country
FROM dim_customers
ORDER BY country IS NULL, country;

-- Question 2: What are the major product divisions (categories)?
SELECT DISTINCT category
FROM dim_products
ORDER BY category IS NULL, category;

-- Question 3: What subcategories exist within each category?
SELECT DISTINCT category, subcategory
FROM dim_products
ORDER BY category IS NULL, category, 
         subcategory IS NULL, subcategory;

-- Question 4: What products exist under each category and subcategory?
SELECT DISTINCT category, subcategory, product_name
FROM dim_products
ORDER BY category IS NULL,    category,
         subcategory IS NULL, subcategory,
         product_name IS NULL, product_name;

-- Question 5: How many unique categories, subcategories and products do we have in total?
SELECT
    COUNT(DISTINCT category)     AS total_categories,
    COUNT(DISTINCT subcategory)  AS total_subcategories,
    COUNT(DISTINCT product_name) AS total_products
FROM dim_products;

-- Question 6: How many unique customers do we have per country?
SELECT
    country,
    COUNT(DISTINCT customer_key) AS total_customers
FROM dim_customers
GROUP BY country
ORDER BY country IS NULL, total_customers DESC;

-- Question 7: What genders exist in our customer base?
SELECT DISTINCT gender
FROM dim_customers
ORDER BY gender IS NULL, gender;

-- Question 8: What marital statuses exist in our customer base?
SELECT DISTINCT marital_status
FROM dim_customers
ORDER BY marital_status IS NULL, marital_status;

-- Question 9: What product lines do we sell?
SELECT DISTINCT product_line
FROM dim_products
ORDER BY product_line IS NULL, product_line;


-- Question 10: What is the full product hierarchy?
SELECT DISTINCT category, subcategory, product_name
FROM dim_products
ORDER BY category IS NULL,     category,
         subcategory IS NULL,  subcategory,
         product_name IS NULL, product_name;

