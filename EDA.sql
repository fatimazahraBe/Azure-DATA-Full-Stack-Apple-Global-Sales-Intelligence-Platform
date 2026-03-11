TRUNCATE TABLE dbo.staging_sales
SELECT COUNT(*) FROM dbo.staging_sales
--les doublents
SELECT sale_id, COUNT(*) as nb
FROM dbo.staging_sales
GROUP BY sale_id
HAVING COUNT(*) > 1

--- les valeurs null 
SELECT 
    column_name,
    SUM(
        CASE 
            WHEN value IS NULL OR LTRIM(RTRIM(value)) = '' THEN 1
            ELSE 0
        END
    ) AS empty_count
FROM dbo.staging_sales
CROSS APPLY (VALUES
    ('sale_id', CAST(sale_id AS VARCHAR(100))),
    ('sale_date', CAST(sale_date AS VARCHAR(100))),
    ('year', CAST(year AS VARCHAR(100))),
    ('quarter', CAST(quarter AS VARCHAR(100))),
    ('month', CAST(month AS VARCHAR(100))),
    ('country', country),
    ('region', region),
    ('city', city),
    ('product_name', product_name),
    ('category', category),
    ('storage', storage),
    ('color', color),
    ('unit_price_usd', CAST(unit_price_usd AS VARCHAR(100))),
    ('discount_pct', CAST(discount_pct AS VARCHAR(100))),
    ('units_sold', CAST(units_sold AS VARCHAR(100))),
    ('discounted_price_usd', CAST(discounted_price_usd AS VARCHAR(100))),
    ('revenue_usd', CAST(revenue_usd AS VARCHAR(100))),
    ('currency', currency),
    ('fx_rate_to_usd', CAST(fx_rate_to_usd AS VARCHAR(100))),
    ('revenue_local_currency', CAST(revenue_local_currency AS VARCHAR(100))),
    ('sales_channel', sales_channel),
    ('payment_method', payment_method),
    ('customer_segment', customer_segment),
    ('customer_age_group', customer_age_group),
    ('previous_device_os', previous_device_os),
    ('customer_rating', CAST(customer_rating AS VARCHAR(100))),
    ('return_status', return_status)
) v(column_name, value)
GROUP BY column_name
ORDER BY empty_count DESC;

--- les valeurs aberrantes
SELECT 
    MIN(revenue_usd) AS min_revenue,
    MAX(revenue_usd) AS max_revenue,
    AVG(revenue_usd) AS avg_revenue,
    MIN(units_sold) AS min_units,
    MAX(units_sold) AS max_units,
    MIN(discount_pct) AS min_discount,
    MAX(discount_pct) AS max_discount
FROM dbo.staging_sales

--- les types invalides
SELECT 
    sale_id,
    sale_date,
    units_sold,
    revenue_usd,
    discount_pct
FROM dbo.staging_sales
WHERE 
    TRY_CAST(units_sold AS INT) IS NULL
    OR TRY_CAST(revenue_usd AS FLOAT) IS NULL
    OR TRY_CAST(discount_pct AS FLOAT) IS NULL