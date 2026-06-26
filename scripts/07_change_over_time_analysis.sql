USE DataWarehouseAnalytics;

-- Question 1: How have total sales changed year over year?
SELECT 
    YEAR(order_date)    AS order_year,
    SUM(sales_amount)   AS total_sales,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(quantity)       AS total_items_sold
FROM fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Question 2: How have total sales changed month over month?
SELECT 
    YEAR(order_date)    AS order_year,
    MONTH(order_date)   AS order_month,
    SUM(sales_amount)   AS total_sales,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(quantity)       AS total_items_sold
FROM fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;

-- Question 3: How have total sales changed year-month 
--             (formatted for readability)?
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS yearmonth,
    SUM(sales_amount)                AS total_sales,
    COUNT(DISTINCT order_number)     AS total_orders,
    SUM(quantity)                    AS total_items_sold
FROM fact_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY yearmonth;

-- Question 4: What is the monthly sales trend per year 
--             (compare same month across years)?
SELECT 
    MONTH(order_date)                    AS order_month,
    MONTHNAME(order_date)                AS month_name,
    SUM(CASE WHEN YEAR(order_date) = 2011 THEN sales_amount ELSE 0 END) AS sales_2011,
    SUM(CASE WHEN YEAR(order_date) = 2012 THEN sales_amount ELSE 0 END) AS sales_2012,
    SUM(CASE WHEN YEAR(order_date) = 2013 THEN sales_amount ELSE 0 END) AS sales_2013,
    SUM(CASE WHEN YEAR(order_date) = 2014 THEN sales_amount ELSE 0 END) AS sales_2014
FROM fact_sales
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY order_month;

-- Question 5: How has revenue trended by category over the years?
SELECT 
    YEAR(f.order_date)  AS order_year,
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY YEAR(f.order_date), p.category
ORDER BY order_year, total_revenue DESC;

-- Question 6: How has the number of customers grown over the years?
SELECT 
    YEAR(f.order_date)               AS order_year,
    COUNT(DISTINCT f.customer_key)   AS total_customers,
    COUNT(DISTINCT f.order_number)   AS total_orders,
    SUM(f.sales_amount)              AS total_revenue
FROM fact_sales f
GROUP BY YEAR(f.order_date)
ORDER BY order_year;

-- Question 7: What is the monthly average sales trend?
SELECT 
    YEAR(order_date)    AS order_year,
    MONTH(order_date)   AS order_month,
    MONTHNAME(order_date) AS month_name,
    SUM(sales_amount)   AS total_sales,
    AVG(sales_amount)   AS avg_sales_per_order,
    COUNT(DISTINCT order_number) AS total_orders
FROM fact_sales
GROUP BY YEAR(order_date), MONTH(order_date), MONTHNAME(order_date)
ORDER BY order_year, order_month;

-- Question 8: Which month of the year consistently 
--             generates the highest sales?
SELECT 
    MONTH(order_date)     AS order_month,
    MONTHNAME(order_date) AS month_name,
    SUM(sales_amount)     AS total_sales,
    AVG(sales_amount)     AS avg_sales,
    COUNT(DISTINCT order_number) AS total_orders
FROM fact_sales
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY total_sales DESC;

-- Question 9: What is the year over year growth rate in sales?
SELECT 
    order_year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY order_year) AS prev_year_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY order_year) AS sales_growth,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY order_year)) 
        / LAG(total_sales) OVER (ORDER BY order_year) * 100, 2
    ) AS growth_rate_pct
FROM (
    SELECT 
        YEAR(order_date) AS order_year,
        SUM(sales_amount) AS total_sales
    FROM fact_sales
    GROUP BY YEAR(order_date)
) yearly_sales
ORDER BY order_year;

USE DataWarehouseAnalytics;

-- Question 10: What is the running total of sales over time?
SELECT 
    DATE_FORMAT(order_date, '%Y-%m')    AS yearmonth,
    SUM(sales_amount)                   AS monthly_sales,
    SUM(SUM(sales_amount)) OVER (
        ORDER BY DATE_FORMAT(order_date, '%Y-%m')
    )                                   AS running_total_sales
FROM fact_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY yearmonth;