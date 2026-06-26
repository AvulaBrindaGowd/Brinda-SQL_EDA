USE DataWarehouseAnalytics;

-- =============================================================
-- PART TO WHOLE ANALYSIS
-- =============================================================

-- Question 1: Which categories contribute the most to overall sales?
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_products p ON f.product_key = p.product_key
    WHERE p.category IS NOT NULL
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER ()                        AS overall_sales,
    CONCAT(
        ROUND(
            (CAST(total_sales AS DECIMAL(15,2))
            / SUM(total_sales) OVER ()) * 100, 2
        ), '%'
    )                                               AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;

-- Question 2: Which subcategories contribute the most  within each category?
WITH subcategory_sales AS (
    SELECT
        p.category,
        p.subcategory,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_products p ON f.product_key = p.product_key
    WHERE p.category    IS NOT NULL
    AND   p.subcategory IS NOT NULL
    GROUP BY p.category, p.subcategory
)
SELECT
    category,
    subcategory,
    total_sales,
    SUM(total_sales) OVER ()                        AS overall_sales,
    CONCAT(
        ROUND(
            (CAST(total_sales AS DECIMAL(15,2))
            / SUM(total_sales) OVER ()) * 100, 2
        ), '%'
    )                                               AS pct_of_total,
    CONCAT(
        ROUND(
            (CAST(total_sales AS DECIMAL(15,2))
            / SUM(total_sales) OVER (
                PARTITION BY category
            )) * 100, 2
        ), '%'
    )                                               AS pct_within_category
FROM subcategory_sales
ORDER BY category, total_sales DESC;

-- Question 3: Which countries contribute the most to overall sales?
WITH country_sales AS (
    SELECT
        c.country,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
    WHERE c.country IS NOT NULL
    GROUP BY c.country
)
SELECT
    country,
    total_sales,
    SUM(total_sales) OVER ()                        AS overall_sales,
    CONCAT(
        ROUND(
            (CAST(total_sales AS DECIMAL(15,2))
            / SUM(total_sales) OVER ()) * 100, 2
        ), '%'
    )                                               AS percentage_of_total
FROM country_sales
ORDER BY total_sales DESC;

-- Question 4: Which gender contributes the most to overall sales?
WITH gender_sales AS (
    SELECT
        c.gender,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
    WHERE c.gender IS NOT NULL
    GROUP BY c.gender
)
SELECT
    gender,
    total_sales,
    SUM(total_sales) OVER ()                        AS overall_sales,
    CONCAT(
        ROUND(
            (CAST(total_sales AS DECIMAL(15,2))
            / SUM(total_sales) OVER ()) * 100, 2
        ), '%'
    )                                               AS percentage_of_total
FROM gender_sales
ORDER BY total_sales DESC;

-- Question 5: Which product lines contribute the most to overall sales?
WITH product_line_sales AS (
    SELECT
        p.product_line,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_products p ON f.product_key = p.product_key
    WHERE p.product_line IS NOT NULL
    GROUP BY p.product_line
)
SELECT
    product_line,
    total_sales,
    SUM(total_sales) OVER ()                        AS overall_sales,
    CONCAT(
        ROUND(
            (CAST(total_sales AS DECIMAL(15,2))
            / SUM(total_sales) OVER ()) * 100, 2
        ), '%'
    )                                               AS percentage_of_total
FROM product_line_sales
ORDER BY total_sales DESC;