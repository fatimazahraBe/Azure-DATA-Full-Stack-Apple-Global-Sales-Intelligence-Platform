drop table Dim_Date
SELECT COUNT(*) FROM Dim_Date
CREATE TABLE Dim_Date (
    date_id INT PRIMARY KEY,
    full_date DATE,
    year INT,
    quarter VARCHAR(10),
    month INT,
    month_name VARCHAR(20)
)

INSERT INTO Dim_Date
SELECT DISTINCT
    CAST(REPLACE(CAST(CAST(sale_date AS DATE) AS VARCHAR), '-', '') AS INT) AS date_id,
    CAST(sale_date AS DATE) AS full_date,
    CAST(year AS INT) AS year,
    quarter,
    MONTH(CAST(sale_date AS DATE)) AS month,
    month AS month_name
FROM dbo.staging_sales
---Dim_Product
CREATE TABLE Dim_Product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(100),
    storage VARCHAR(50),
    color VARCHAR(50),
    unit_price_usd FLOAT
)

INSERT INTO Dim_Product (product_name, category, storage, color, unit_price_usd)
SELECT DISTINCT
    product_name,
    category,
    storage,
    color,
    CAST(unit_price_usd AS FLOAT)
FROM dbo.staging_sales
---Dim_Geography
CREATE TABLE Dim_Geography (
    geography_id INT IDENTITY(1,1) PRIMARY KEY,
    country VARCHAR(100),
    region VARCHAR(100),
    city VARCHAR(100)
)

INSERT INTO Dim_Geography (country, region, city)
SELECT DISTINCT
    country,
    region,
    city
FROM dbo.staging_sales
---Dim_Channel
CREATE TABLE Dim_Channel (
    channel_id INT IDENTITY(1,1) PRIMARY KEY,
    sales_channel VARCHAR(100),
    payment_method VARCHAR(100)
)

INSERT INTO Dim_Channel (sales_channel, payment_method)
SELECT DISTINCT
    sales_channel,
    payment_method
FROM dbo.staging_sales
---Dim_CustomerSegment
CREATE TABLE Dim_CustomerSegment (
    segment_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_segment VARCHAR(100),
    customer_age_group VARCHAR(50),
    previous_device_os VARCHAR(100)
)

INSERT INTO Dim_CustomerSegment (customer_segment, customer_age_group, previous_device_os)
SELECT DISTINCT
    customer_segment,
    customer_age_group,
    previous_device_os
FROM dbo.staging_sales
---Fact_Sales
CREATE TABLE Fact_Sales (
    sale_id VARCHAR(50) PRIMARY KEY,
    date_id INT FOREIGN KEY REFERENCES Dim_Date(date_id),
    product_id INT FOREIGN KEY REFERENCES Dim_Product(product_id),
    geography_id INT FOREIGN KEY REFERENCES Dim_Geography(geography_id),
    channel_id INT FOREIGN KEY REFERENCES Dim_Channel(channel_id),
    segment_id INT FOREIGN KEY REFERENCES Dim_CustomerSegment(segment_id),
    units_sold INT,
    unit_price_usd FLOAT,
    discount_pct FLOAT,
    discounted_price_usd FLOAT,
    revenue_usd FLOAT,
    revenue_local_currency FLOAT,
    currency VARCHAR(10),
    fx_rate_to_usd FLOAT,
    customer_rating FLOAT,
    return_status VARCHAR(20)
)

INSERT INTO Fact_Sales
SELECT
    s.sale_id,
    CAST(REPLACE(CAST(CAST(s.sale_date AS DATE) AS VARCHAR), '-', '') AS INT),
    p.product_id,
    g.geography_id,
    c.channel_id,
    cs.segment_id,
    CAST(s.units_sold AS INT),
    CAST(s.unit_price_usd AS FLOAT),
    CAST(s.discount_pct AS FLOAT),
    CAST(s.discounted_price_usd AS FLOAT),
    CAST(s.revenue_usd AS FLOAT),
    CAST(s.revenue_local_currency AS FLOAT),
    s.currency,
    CAST(s.fx_rate_to_usd AS FLOAT),
    CAST(s.customer_rating AS FLOAT),
    s.return_status
FROM dbo.staging_sales s
JOIN Dim_Product p 
    ON s.product_name = p.product_name 
    AND s.color = p.color 
    AND s.storage = p.storage
JOIN Dim_Geography g 
    ON s.country = g.country 
    AND s.city = g.city
JOIN Dim_Channel c 
    ON s.sales_channel = c.sales_channel 
    AND s.payment_method = c.payment_method
JOIN Dim_CustomerSegment cs 
    ON s.customer_segment = cs.customer_segment 
    AND s.customer_age_group = cs.customer_age_group