USE DataWarehouseAnalytics;

-- =============================================================
-- MEASURES EXPLORATION
-- =============================================================

-- Question 1: What is the total sales revenue?
SELECT SUM(sales_amount) AS total_sales
FROM fact_sales;

-- Question 2: How many items have been sold in total?
SELECT SUM(quantity) AS total_items_sold
FROM fact_sales;

-- Question 3: What is the average selling price?
SELECT AVG(price) AS avg_selling_price
FROM fact_sales;

-- Question 4: What is the total number of orders?
SELECT COUNT(DISTINCT order_number) AS total_orders
FROM fact_sales;

-- Question 5: What is the total number of products?
SELECT COUNT(DISTINCT product_key) AS total_products
FROM dim_products;

-- Question 6: What is the total number of customers?
SELECT COUNT(DISTINCT customer_key) AS total_customers
FROM dim_customers;

-- Question 7: What is the total number of customers 
--             that have placed an order?
SELECT COUNT(DISTINCT customer_key) AS total_customers_ordered
FROM fact_sales;

-- Question 8: All measures combined in one summary report
SELECT
    SUM(f.sales_amount)            AS total_sales,
    SUM(f.quantity)                AS total_items_sold,
    AVG(f.price)                   AS avg_selling_price,
    COUNT(DISTINCT f.order_number) AS total_orders,
    COUNT(DISTINCT p.product_key)  AS total_products,
    COUNT(DISTINCT c.customer_key) AS total_customers,
    COUNT(DISTINCT f.customer_key) AS customers_with_orders
FROM fact_sales f
JOIN dim_customers c ON f.customer_key = c.customer_key
JOIN dim_products  p ON f.product_key  = p.product_key;
