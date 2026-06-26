USE DataWarehouseAnalytics;



-- Question 1: Which 5 products generate the highest revenue?
SELECT 
    p.product_name,
    p.category,
    p.subcategory,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY 
    p.product_name,
    p.category,
    p.subcategory
ORDER BY total_revenue DESC
LIMIT 5;

-- Question 2: What are the 5 worst-performing products 
--             in terms of sales?
SELECT 
    p.product_name,
    p.category,
    p.subcategory,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY 
    p.product_name,
    p.category,
    p.subcategory
ORDER BY total_revenue ASC
LIMIT 5;

-- Question 3: Rank ALL products by revenue (best to worst)
SELECT 
    RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS revenue_rank,
    p.product_name,
    p.category,
    p.subcategory,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY 
    p.product_name,
    p.category,
    p.subcategory
ORDER BY revenue_rank;

-- Question 4: Rank products within each category 
--             (which product is #1 in each category?)
SELECT 
    RANK() OVER (
        PARTITION BY p.category 
        ORDER BY SUM(f.sales_amount) DESC
    )                       AS rank_within_category,
    p.category,
    p.product_name,
    SUM(f.sales_amount)     AS total_revenue
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY 
    p.category,
    p.product_name
ORDER BY p.category, rank_within_category;

-- Question 5: Which 5 customers generate the highest revenue?
SELECT 
    RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS revenue_rank,
    c.customer_key,
    c.first_name,
    c.last_name,
    c.country,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name,
    c.country
ORDER BY total_revenue DESC
LIMIT 5;

-- Question 6: Which 5 customers are the lowest spenders?
SELECT 
    RANK() OVER (ORDER BY SUM(f.sales_amount) ASC) AS revenue_rank,
    c.customer_key,
    c.first_name,
    c.last_name,
    c.country,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name,
    c.country
ORDER BY total_revenue ASC
LIMIT 5;

-- Question 7: Which countries rank highest by total revenue?
SELECT 
    RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS revenue_rank,
    c.country,
    SUM(f.sales_amount)            AS total_revenue,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.quantity)                AS total_items_sold
FROM fact_sales f
JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY revenue_rank;

-- Question 8: Which categories rank highest by total revenue?
SELECT 
    RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS revenue_rank,
    p.category,
    SUM(f.sales_amount)            AS total_revenue,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.quantity)                AS total_items_sold
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY revenue_rank;