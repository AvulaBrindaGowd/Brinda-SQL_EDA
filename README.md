markdown
# 📊 SQL Data Analytics Project

A comprehensive data analytics project built on a **Gold Layer Data Warehouse** 
using **MySQL Workbench**, analyzing sales, customer, and product performance 
across multiple dimensions.

---

## 📁 Project Structure

```
sql-data-analytics-project/
│
├── datasets/
│   └── csv-files/
│       ├── gold.dim_customers.csv
│       ├── gold.dim_products.csv
│       └── gold.fact_sales.csv
│
├── scripts/
│   ├── 01_create_database.sql
│   ├── 02_dimensions_exploration.sql
│   ├── 03_date_exploration.sql
│   ├── 04_measures_exploration.sql
│   ├── 05_magnitude_analysis.sql
│   ├── 06_ranking_analysis.sql
│   ├── 07_change_over_time.sql
│   ├── 08_cumulative_analysis.sql
│   ├── 09_performance_analysis.sql
│   ├── 10_part_to_whole.sql
│   ├── 11_data_segmentation.sql
│   ├── 12_report_customers.sql
│   └── 13_report_products.sql
│
└── README.md
```

---

## 🗄️ Database Schema

**Database:** `DataWarehouseAnalytics`

### `dim_customers`
| Column | Type | Description |
|--------|------|-------------|
| customer_key | INT | Primary key |
| customer_id | INT | Business identifier |
| customer_number | VARCHAR(50) | Customer code |
| first_name | VARCHAR(50) | First name |
| last_name | VARCHAR(50) | Last name |
| country | VARCHAR(50) | Country |
| marital_status | VARCHAR(50) | Marital status |
| gender | VARCHAR(50) | Gender |
| birthdate | DATE | Date of birth |
| create_date | DATE | Account creation date |

### `dim_products`
| Column | Type | Description |
|--------|------|-------------|
| product_key | INT | Primary key |
| product_id | INT | Business identifier |
| product_number | VARCHAR(50) | Product code |
| product_name | VARCHAR(50) | Product name |
| category_id | VARCHAR(50) | Category code |
| category | VARCHAR(50) | Category |
| subcategory | VARCHAR(50) | Subcategory |
| maintenance | VARCHAR(50) | Maintenance type |
| cost | INT | Product cost |
| product_line | VARCHAR(50) | Product line |
| start_date | DATE | Launch date |

### `fact_sales`
| Column | Type | Description |
|--------|------|-------------|
| order_number | VARCHAR(50) | Order identifier |
| product_key | INT | FK → dim_products |
| customer_key | INT | FK → dim_customers |
| order_date | DATE | Order date |
| shipping_date | DATE | Shipping date |
| due_date | DATE | Due date |
| sales_amount | INT | Revenue |
| quantity | TINYINT | Units sold |
| price | INT | Selling price |

---

## 📊 Dimensions vs Measures

### Dimensions (Descriptive)
| Table | Columns |
|-------|---------|
| dim_customers | country, gender, marital_status, birthdate, create_date |
| dim_products | category, subcategory, product_name, product_line, maintenance |
| fact_sales | order_number, order_date, shipping_date, due_date |

### Measures (Numeric)
| Table | Column | Aggregation |
|-------|--------|-------------|
| dim_products | cost | AVG, SUM |
| fact_sales | sales_amount | SUM |
| fact_sales | quantity | SUM |
| fact_sales | price | AVG |

---

## 🔍 Analysis Performed

### 1. 🌍 Dimensions Exploration
- Countries customers come from
- Product categories, subcategories, full hierarchy
- Gender and marital status distribution
- Product lines available

### 2. 📅 Date Exploration
- First and last order dates
- Sales date range in years and months
- Oldest and youngest customer ages

### 3. 📐 Measures Exploration
- Total sales revenue
- Total items sold
- Average selling price
- Total orders, products, customers

### 4. 📏 Magnitude Analysis
- Customers by country and gender
- Products by category
- Revenue by category and customer
- Items sold distribution by country

### 5. 🏆 Ranking Analysis
- Top 5 highest revenue products
- Bottom 5 worst performing products
- Top and bottom customers by revenue
- Countries and categories ranked by revenue

### 6. 📈 Change Over Time Analysis
- Yearly and monthly sales trends
- Month over month growth rate
- Yearly sales pivot by month
- Best and worst performing months per year

### 7. 📊 Cumulative Analysis
- Monthly running total of sales
- Yearly cumulative running total
- Moving average price over time
- Full cumulative dashboard

### 8. ⚡ Performance Analysis
- Yearly product sales vs product average
- Above Avg / Below Avg / Avg labels
- Year over year comparison using LAG
- Increase / Decrease / No Change labels

### 9. 🥧 Part-to-Whole Analysis
- Category % contribution to total sales
- Subcategory % within each category
- Country % of total sales
- Gender % of total sales
- Product line % of total sales

### 10. 🎯 Data Segmentation
- Products segmented into cost ranges
- Customers segmented by spending behavior

---

## 📋 Reports (Views)

### `report_customers`
Consolidates key customer metrics and behaviors.

| Column | Description |
|--------|-------------|
| customer_segment | VIP / Regular / New |
| age_group | Under 20 / 20-29 / 30-39 / 40-49 / 50+ |
| recency | Months since last order |
| lifespan | Months from first to last order |
| total_orders | Count of distinct orders |
| total_sales | Total revenue generated |
| total_quantity | Total units purchased |
| total_products | Distinct products bought |
| avg_order_value | Total sales / Total orders |
| avg_monthly_spend | Total sales / Lifespan |

```sql
-- Use the report
SELECT * FROM report_customers 
ORDER BY total_sales DESC;
```

### `report_products`
Consolidates key product metrics and behaviors.

| Column | Description |
|--------|-------------|
| product_segment | High-Performer / Mid-Range / Low-Performer |
| recency_in_months | Months since last sale |
| lifespan | Months from first to last sale |
| total_orders | Count of distinct orders |
| total_sales | Total revenue generated |
| total_quantity | Total units sold |
| total_customers | Unique customers who bought |
| avg_selling_price | Average price per unit sold |
| avg_order_revenue | Total sales / Total orders |
| avg_monthly_revenue | Total sales / Lifespan |

```sql
-- Use the report
SELECT * FROM report_products 
ORDER BY total_sales DESC;
```

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| MySQL Workbench 8.0 | Query writing and execution |
| MySQL 8.0 | Database engine |
| CSV Files | Data source (Gold layer) |

---

## ⚙️ How to Run

### Step 1: Prerequisites
- Install **MySQL 8.0**
- Install **MySQL Workbench 8.0**
- Enable local file loading in MySQL Workbench:
  - Edit → Preferences → SQL Editor
  - Add `OPT_LOCAL_INFILE=1` in connection settings

### Step 2: Setup Database
```sql
-- Run: 01_create_database.sql
-- Creates database, tables, loads CSV data,
-- cleans NULL values, converts date columns
```

### Step 3: Run Explorations
```sql
-- Run in order:
-- 02_dimensions_exploration.sql
-- 03_date_exploration.sql
-- 04_measures_exploration.sql
-- 05_magnitude_analysis.sql
```

### Step 4: Run Analysis
```sql
-- Run in order:
-- 06_ranking_analysis.sql
-- 07_change_over_time.sql
-- 08_cumulative_analysis.sql
-- 09_performance_analysis.sql
-- 10_part_to_whole.sql
-- 11_data_segmentation.sql
```

### Step 5: Generate Reports
```sql
-- Run:
-- 12_report_customers.sql
-- 13_report_products.sql

-- Then query:
SELECT * FROM report_customers ORDER BY total_sales DESC;
SELECT * FROM report_products  ORDER BY total_sales DESC;
```

---

## 📈 Key Business Insights

| Insight | Finding |
|---------|---------|
| 🚲 **Top Category** | Bikes contribute 96.46% of total revenue |
| 📅 **Peak Year** | 2013 had highest sales of 16.3 Million |
| 👥 **Customer Base** | 18,484 total customers |
| 📦 **Product Range** | 295 products across 4 categories |
| 🗓️ **Date Range** | December 2010 to January 2014 (37 months) |
| 🆕 **Largest Segment** | New customers — 14,631 |
| 💎 **VIP Customers** | 1,655 high-value customers |
| 🌍 **Top Market** | United States leads in revenue |

---

## 👩‍💻 Author

**Brinda Gowd Avula**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/avulabrindagowd)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/AvulaBrindaGowd)

---

