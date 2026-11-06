-- 1. Create the schema if it does not exist.
CREATE DATABASE IF NOT EXISTS mysql_shorts;

-- 2. Switch to the schema.
USE mysql_shorts;

-- 3. Remove the demo table before recreating it.
-- Destructive: recreate this episode's demo table.
DROP TABLE IF EXISTS lag_daily_sales;

-- 4. Create the daily sales table.
CREATE TABLE lag_daily_sales (
    sale_date DATE PRIMARY KEY,
    sales_total DECIMAL(10, 2) NOT NULL
);

-- 5. Add daily sales totals.
INSERT INTO lag_daily_sales (sale_date, sales_total)
VALUES
    ('2026-11-01', 1000.00),
    ('2026-11-02', 1250.00),
    ('2026-11-03', 1100.00),
    ('2026-11-04', 1100.00),
    ('2026-11-05', 1500.00);

-- 6. Show daily sales totals in date order.
SELECT sale_date, sales_total
FROM lag_daily_sales
ORDER BY sale_date;

-- 7. Retrieve the preceding row's sales total using LAG().
SELECT
    sale_date,
    sales_total,
    LAG(sales_total) OVER (
        ORDER BY sale_date
    ) AS previous_total
FROM lag_daily_sales
ORDER BY sale_date;

-- 8. Calculate the change from the preceding row's sales total.
SELECT
    sale_date,
    sales_total,
    LAG(sales_total) OVER (
        ORDER BY sale_date
    ) AS previous_total,
    sales_total - LAG(sales_total) OVER (
        ORDER BY sale_date
    ) AS daily_change
FROM lag_daily_sales
ORDER BY sale_date;
