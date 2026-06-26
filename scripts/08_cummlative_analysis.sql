USE DataWarehouseAnalytics;

-- Question 1: Calculate total sales per month (basic grouping)

SELECT
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
    SUM(sales_amount)                   AS total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY DATE_FORMAT(order_date, '%Y-%m-01');

-- Question 2: Calculate total sales per month with running total over time

SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (
        ORDER BY order_date
    ) AS running_total_sales
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
        SUM(sales_amount)                   AS total_sales
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
) t
ORDER BY order_date;

-- Question 3: Running total PARTITIONED by month

SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (
        PARTITION BY order_date
        ORDER BY order_date
    ) AS running_total_sales
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
        SUM(sales_amount)                   AS total_sales
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
) t
ORDER BY order_date;

-- Question 4: Running total by YEAR

SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (
        PARTITION BY order_date
        ORDER BY order_date
    ) AS running_total_sales
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
        SUM(sales_amount)                   AS total_sales
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
) t
ORDER BY order_date;

-- Question 5: Running total by YEAR (cumulative across years)

SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (
        ORDER BY order_date
    ) AS running_total_sales
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
        SUM(sales_amount)                   AS total_sales
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
) t
ORDER BY order_date;

-- Question 6: Running total + Moving average price by year

SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (
        ORDER BY order_date
    )                           AS running_total_sales,
    AVG(avg_price) OVER (
        ORDER BY order_date
    )                           AS moving_average_price
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
        SUM(sales_amount)                   AS total_sales,
        AVG(price)                          AS avg_price
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
) t
ORDER BY order_date;

-- Question 7: Full cumulative dashboard by month
SELECT
    order_date,
    total_sales,
    total_customers,
    total_quantity,
    -- Running totals
    SUM(total_sales) OVER (
        ORDER BY order_date
    )                           AS running_total_sales,
    SUM(total_customers) OVER (
        ORDER BY order_date
    )                           AS running_total_customers,
    SUM(total_quantity) OVER (
        ORDER BY order_date
    )                           AS running_total_quantity,
    -- Moving averages
    AVG(total_sales) OVER (
        ORDER BY order_date
    )                           AS moving_avg_sales,
    AVG(avg_price) OVER (
        ORDER BY order_date
    )                           AS moving_avg_price
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
        SUM(sales_amount)                   AS total_sales,
        COUNT(DISTINCT customer_key)        AS total_customers,
        SUM(quantity)                       AS total_quantity,
        AVG(price)                          AS avg_price
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
) t
ORDER BY order_date;