USE DataWarehouseAnalytics;
-- =============================================================
-- DATE EXPLORATION
-- =============================================================

-- Question 1: What are all the order dates in our sales data?
SELECT order_date
FROM fact_sales;

-- Question 2: What is the date of the first (earliest) order?
SELECT MIN(order_date) AS first_order_date
FROM fact_sales;

-- Question 3: What is the date of the first and last order?
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM fact_sales;

-- Question 4: How many years of sales data do we have?
SELECT
    MIN(order_date)   AS first_order_date,
    MAX(order_date)   AS last_order_date,
    TIMESTAMPDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM fact_sales;

-- Question 5: How many months of sales data do we have?
SELECT
    MIN(order_date)  AS first_order_date,
    MAX(order_date)  AS last_order_date,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM fact_sales;

-- Question 6: What are the birthdates of the oldest 
--             and youngest customers?
SELECT
    MIN(birthdate) AS oldest_birthdate,
    MAX(birthdate) AS youngest_birthdate
FROM dim_customers;

-- Question 7: What is the age of the oldest customer?
SELECT
    MIN(birthdate) AS oldest_birthdate,
    TIMESTAMPDIFF(YEAR, MIN(birthdate), CURDATE())  AS oldest_age,
    MAX(birthdate) AS youngest_birthdate
FROM dim_customers;

-- Question 8: What are the ages of the oldest and youngest customers?
SELECT
    MIN(birthdate) AS oldest_birthdate,
    TIMESTAMPDIFF(YEAR, MIN(birthdate), CURDATE())  AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    TIMESTAMPDIFF(YEAR, MAX(birthdate), CURDATE())  AS youngest_age
FROM dim_customers;