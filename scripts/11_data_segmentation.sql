USE DataWarehouseAnalytics;

-- =============================================================
-- DATA SEGMENTATION ANALYSIS
-- =============================================================

-- -------------------------------------------------------
--  Segment Products into Cost Ranges
-- -------------------------------------------------------


WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100                    THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500      THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000     THEN '500-1000'
            ELSE'Above 1000'
        END AS cost_range
    FROM dim_products
)
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

-- -------------------------------------------------------
--  Segment Customers by Spending Behavior
-- -------------------------------------------------------
-- VIP      → lifespan >= 12 months AND spending > 5000
-- Regular  → lifespan >= 12 months AND spending <= 5000
-- New      → lifespan < 12 months


WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount)                                        AS total_spending,
        TIMESTAMPDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan
    FROM fact_sales f
    LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE
            WHEN lifespan >= 12 AND total_spending > 5000  THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE                                                'New'
        END AS customer_segment
    FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY total_customers DESC;