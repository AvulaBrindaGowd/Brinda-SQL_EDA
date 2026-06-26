/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.


===============================================================================
*/
USE DataWarehouseAnalytics;

-- All tables in database
SELECT TABLE_NAME, TABLE_TYPE, TABLE_ROWS
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'DataWarehouseAnalytics';

-- All columns with data types
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'DataWarehouseAnalytics'
ORDER BY TABLE_NAME, ORDINAL_POSITION;