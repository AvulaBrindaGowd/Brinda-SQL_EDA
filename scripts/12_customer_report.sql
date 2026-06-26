USE DataWarehouseAnalytics;

-- =============================================================
-- Customer Report
-- =============================================================
-- Purpose:
--     This report consolidates key customer metrics and behaviors
-- Highlights:
--     1. Gathers essential fields such as names, ages, and
--        transaction details.
--     2. Segments customers into categories (VIP, Regular, New)
--        and age groups.
--     3. Aggregates customer-level metrics:
--        - total orders
--        - total sales
--        - total quantity purchased
--        - total products
--        - lifespan (in months)
--     4. Calculates valuable KPIs:
--        - recency (months since last order)
--        - average order value
--        - average monthly spend
-- =============================================================

-- =============================================================
-- Create Report View: report_customers
-- =============================================================

DROP VIEW IF EXISTS report_customers;

CREATE VIEW report_customers AS

WITH base_query AS (
-- ---------------------------------------------------------------------------
-- 1) Base Query: Retrieves core columns from tables
-- ---------------------------------------------------------------------------
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name)          AS customer_name,
        TIMESTAMPDIFF(YEAR, c.birthdate, CURDATE())      AS age,
        c.country,
        c.marital_status,
        c.gender
    FROM fact_sales f
    LEFT JOIN dim_customers c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),

customer_aggregation AS (
-- ---------------------------------------------------------------------------
-- 2) Customer Aggregations: Summarizes key metrics at customer level
-- ---------------------------------------------------------------------------
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        country,
        marital_status,
        gender,
        COUNT(DISTINCT order_number)                     AS total_orders,
        SUM(sales_amount)                                AS total_sales,
        SUM(quantity)                                    AS total_quantity,
        COUNT(DISTINCT product_key)                      AS total_products,
        MAX(order_date)                                  AS last_order_date,
        TIMESTAMPDIFF(
            MONTH, MIN(order_date), MAX(order_date)
        )                                                AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age,
        country,
        marital_status,
        gender
)

-- ---------------------------------------------------------------------------
-- 3) Final Output: Segments + KPIs
-- ---------------------------------------------------------------------------
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    country,
    marital_status,
    gender,

    -- Age Group Segmentation
    CASE
        WHEN age < 20              THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE                            '50 and above'
    END                                                  AS age_group,

    -- Customer Segmentation
    CASE
        WHEN lifespan >= 12
             AND total_sales > 5000  THEN 'VIP'
        WHEN lifespan >= 12
             AND total_sales <= 5000 THEN 'Regular'
        ELSE                              'New'
    END                                                  AS customer_segment,

    -- Date Metrics
    last_order_date,

    -- Recency: months since last order
    TIMESTAMPDIFF(
        MONTH, last_order_date, CURDATE()
    )                                                    AS recency,

    -- Transaction Metrics
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    -- KPI: Average Order Value (AOV)
    ROUND(
        CASE
            WHEN total_orders = 0 THEN 0
            ELSE total_sales / total_orders
        END, 2
    )                                                    AS avg_order_value,

    -- KPI: Average Monthly Spend
    ROUND(
        CASE
            WHEN lifespan = 0 THEN total_sales
            ELSE total_sales / lifespan
        END, 2
    )                                                    AS avg_monthly_spend

FROM customer_aggregation;

-- =============================================================
-- USE THE VIEW
-- =============================================================

SELECT * FROM report_customers
ORDER BY total_sales DESC;