-- =====================================================
-- AMAZON SALES DATA ANALYSIS
-- SQL BUSINESS ANALYSIS
-- =====================================================

USE amazon_sales;


-- =====================================================
-- 01. DATABASE SETUP
-- =====================================================

-- Check the structure of the main sales table

DESCRIBE amazon_data;

-- =====================================================
-- 02. DATA OVERVIEW
-- =====================================================

-- Check the total number of records in the dataset

SELECT COUNT(*) AS Total_Rows
FROM amazon_data;

-- Check missing values in important columns

SELECT
    SUM(`Order ID` IS NULL OR `Order ID` = '') AS Missing_Order_ID,
    SUM(`Date` IS NULL OR `Date` = '') AS Missing_Date,
    SUM(`Status` IS NULL OR `Status` = '') AS Missing_Status,
    SUM(`Amount` IS NULL OR `Amount` = '') AS Missing_Amount,
    SUM(`Qty` IS NULL) AS Missing_Qty,
    SUM(`Category` IS NULL OR `Category` = '') AS Missing_Category,
    SUM(`SKU` IS NULL OR `SKU` = '') AS Missing_SKU
FROM amazon_data;


-- Check for duplicate Order IDs

SELECT
    `Order ID`,
    COUNT(*) AS Order_Count
FROM amazon_data
WHERE `Order ID` IS NOT NULL
  AND `Order ID` <> ''
GROUP BY `Order ID`
HAVING COUNT(*) > 1
ORDER BY Order_Count DESC
LIMIT 10;


-- =====================================================
-- 03. OVERALL SALES ANALYSIS
-- =====================================================

-- Calculate total sales, total quantity, and average order value

SELECT
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    SUM(Qty) AS Total_Quantity,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE `Amount` IS NOT NULL
  AND `Amount` <> '';
  
  -- =====================================================
-- 04. CATEGORY PERFORMANCE ANALYSIS
-- =====================================================

-- Sales, orders and quantity by category

SELECT
    Category,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE Category IS NOT NULL
  AND `Amount` IS NOT NULL
  AND `Amount` <> ''
GROUP BY Category
ORDER BY Total_Sales DESC;

-- =====================================================
-- 05. SALES CHANNEL ANALYSIS
-- =====================================================

-- Compare sales performance between sales channels

SELECT
    `Sales Channel`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE `Sales Channel` IS NOT NULL
  AND `Amount` IS NOT NULL
  AND `Amount` <> ''
GROUP BY `Sales Channel`
ORDER BY Total_Sales DESC;

-- Check all sales channels, including records with missing Amount

SELECT
    `Sales Channel`,
    COUNT(*) AS Total_Rows,
    SUM(`Amount` IS NULL OR `Amount` = '') AS Missing_Amount_Rows
FROM amazon_data
GROUP BY `Sales Channel`
ORDER BY Total_Rows DESC;


-- =====================================================
-- 06. ORDER STATUS ANALYSIS
-- =====================================================

-- Analyze orders and sales by order status

SELECT
    Status,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE Status IS NOT NULL
  AND `Amount` IS NOT NULL
  AND `Amount` <> ''
GROUP BY Status
ORDER BY Total_Orders DESC;

-- =====================================================
-- 07. MONTHLY SALES ANALYSIS
-- =====================================================

-- Analyze sales performance by month

SELECT
    DATE_FORMAT(STR_TO_DATE(`Date`, '%m-%d-%y'), '%Y-%m') AS Sales_Month,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE `Date` IS NOT NULL
  AND `Date` <> ''
  AND `Amount` IS NOT NULL
  AND `Amount` <> ''
GROUP BY Sales_Month
ORDER BY Sales_Month;

-- Check the minimum and maximum dates in the dataset

SELECT
    MIN(STR_TO_DATE(`Date`, '%m-%d-%y')) AS Minimum_Date,
    MAX(STR_TO_DATE(`Date`, '%m-%d-%y')) AS Maximum_Date
FROM amazon_data
WHERE `Date` IS NOT NULL
  AND `Date` <> '';
  
  -- Check the number of records by year

SELECT
    YEAR(STR_TO_DATE(`Date`, '%m-%d-%y')) AS Sales_Year,
    COUNT(*) AS Total_Rows,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales
FROM amazon_data
WHERE `Date` IS NOT NULL
  AND `Date` <> ''
  AND `Amount` IS NOT NULL
  AND `Amount` <> ''
GROUP BY Sales_Year
ORDER BY Sales_Year;

-- Final monthly sales analysis

SELECT
    DATE_FORMAT(
        STR_TO_DATE(`Date`, '%m-%d-%y'),
        '%Y-%m'
    ) AS Sales_Month,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE `Date` IS NOT NULL
  AND `Date` <> ''
  AND `Amount` IS NOT NULL
  AND `Amount` <> ''
GROUP BY Sales_Month
ORDER BY Sales_Month;

-- =====================================================
-- 08. STATE-WISE SALES ANALYSIS
-- =====================================================

-- Analyze sales performance by state

SELECT
    `ship-state` AS State,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE `ship-state` IS NOT NULL
  AND `ship-state` <> ''
  AND `Amount` IS NOT NULL
  AND `Amount` <> ''
GROUP BY `ship-state`
ORDER BY Total_Sales DESC;

-- Top 10 states by total sales

SELECT
    `ship-state` AS State,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE `ship-state` IS NOT NULL
  AND `ship-state` <> ''
  AND `Amount` IS NOT NULL
  AND `Amount` <> ''
GROUP BY `ship-state`
ORDER BY Total_Sales DESC
LIMIT 10;

-- =====================================================
-- 09. CITY-WISE SALES ANALYSIS
-- =====================================================

-- Analyze sales performance by city

SELECT
    `ship-city` AS City,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE `ship-city` IS NOT NULL
  AND `ship-city` <> ''
  AND `Amount` IS NOT NULL
  AND `Amount` <> ''
GROUP BY `ship-city`
ORDER BY Total_Sales DESC
LIMIT 10;

-- =====================================================
-- 10. SKU PERFORMANCE ANALYSIS
-- =====================================================

-- Top 10 SKUs by total sales

SELECT
    SKU,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        SUM(Qty),
        2
    ) AS Average_Selling_Price
FROM amazon_data
WHERE SKU IS NOT NULL
  AND SKU <> ''
  AND Amount IS NOT NULL
  AND Amount <> ''
GROUP BY SKU
ORDER BY Total_Sales DESC
LIMIT 10;

-- =====================================================
-- 11. SIZE PERFORMANCE ANALYSIS
-- =====================================================

-- Analyze sales performance by product size

SELECT
    Size,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        SUM(Qty),
        2
    ) AS Average_Selling_Price
FROM amazon_data
WHERE Size IS NOT NULL
  AND Size <> ''
  AND Amount IS NOT NULL
  AND Amount <> ''
GROUP BY Size
ORDER BY Total_Quantity DESC;

-- =====================================================
-- 12. CATEGORY QUANTITY ANALYSIS
-- =====================================================

-- Compare category demand using quantity per order

SELECT
    Category,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    ROUND(
        SUM(Qty) / COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Quantity_Per_Order
FROM amazon_data
WHERE Category IS NOT NULL
  AND Category <> ''
GROUP BY Category
ORDER BY Total_Quantity DESC;

-- =====================================================
-- 13. B2B SALES ANALYSIS
-- =====================================================

-- Compare B2B and B2C sales performance

SELECT
    B2B,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE B2B IS NOT NULL
  AND B2B <> ''
  AND Amount IS NOT NULL
  AND Amount <> ''
GROUP BY B2B
ORDER BY Total_Sales DESC;

-- =====================================================
-- 14. COURIER STATUS ANALYSIS
-- =====================================================

-- Analyze orders by courier status

SELECT
    `Courier Status`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales
FROM amazon_data
WHERE `Courier Status` IS NOT NULL
  AND `Courier Status` <> ''
  AND Amount IS NOT NULL
  AND Amount <> ''
GROUP BY `Courier Status`
ORDER BY Total_Orders DESC;

-- =====================================================
-- 15. TOP PRODUCTS BY QUANTITY
-- =====================================================

-- Identify the top 10 SKUs by units sold

SELECT
    SKU,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        SUM(Qty),
        2
    ) AS Average_Selling_Price
FROM amazon_data
WHERE SKU IS NOT NULL
  AND SKU <> ''
  AND Qty IS NOT NULL
  AND Amount IS NOT NULL
  AND Amount <> ''
GROUP BY SKU
ORDER BY Total_Quantity DESC
LIMIT 10;

-- =====================================================
-- 16. PROMOTION ANALYSIS
-- =====================================================

-- Compare orders with and without promotions

SELECT
    CASE
        WHEN `promotion-ids` IS NULL
             OR `promotion-ids` = ''
        THEN 'No Promotion'
        ELSE 'Promotion Used'
    END AS Promotion_Status,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    SUM(CAST(`Amount` AS DECIMAL(15,2))) AS Total_Sales,
    ROUND(
        SUM(CAST(`Amount` AS DECIMAL(15,2))) /
        COUNT(DISTINCT `Order ID`),
        2
    ) AS Average_Order_Value
FROM amazon_data
WHERE Amount IS NOT NULL
  AND Amount <> ''
GROUP BY Promotion_Status
ORDER BY Total_Sales DESC;

-- =====================================================
-- 17. DATA QUALITY ANALYSIS
-- =====================================================

-- Check missing values in important columns

SELECT
    COUNT(*) AS Total_Rows,

    SUM(`Order ID` IS NULL OR `Order ID` = '') AS Missing_Order_ID,

    SUM(`Date` IS NULL OR `Date` = '') AS Missing_Date,

    SUM(Status IS NULL OR Status = '') AS Missing_Status,

    SUM(Category IS NULL OR Category = '') AS Missing_Category,

    SUM(SKU IS NULL OR SKU = '') AS Missing_SKU,

    SUM(Qty IS NULL) AS Missing_Qty,

    SUM(Amount IS NULL OR Amount = '') AS Missing_Amount,

    SUM(`ship-city` IS NULL OR `ship-city` = '') AS Missing_City,

    SUM(`ship-state` IS NULL OR `ship-state` = '') AS Missing_State
FROM amazon_data;

