
-- Top 10 Regions by Number of Unique Customers
SELECT TOP 10 
    Region, 
    COUNT(DISTINCT [Customer_ID]) AS UniqueCustomers
FROM Orders
GROUP BY Region
ORDER BY UniqueCustomers DESC;

--  Distribution of Customers Across Regions

SELECT 
    Region, 
    COUNT(DISTINCT [Customer_ID]) AS UniqueCustomers
FROM Orders
GROUP BY Region
ORDER BY UniqueCustomers DESC;

-- Customers with More Than One Order
SELECT 
    [Customer_ID], 
    COUNT(DISTINCT [Order_ID]) AS OrderCount
FROM Orders
GROUP BY [Customer_ID]
HAVING COUNT(DISTINCT [Order_ID]) > 1;

-- Top 5 Customers by Number of Orders

SELECT TOP 5 
    [Customer_ID], 
    [Customer_Name],
    COUNT(DISTINCT [Order_ID]) AS OrderCount
FROM Orders
GROUP BY [Customer_ID], [Customer_Name]
ORDER BY OrderCount DESC;

-- High-Value Customers
-- a. Top 10 Customers by Total Sales
SELECT TOP 10 
    [Customer_ID], 
    [Customer_Name],
    SUM(Sales) AS TotalSales
FROM Orders
GROUP BY [Customer_ID], [Customer_Name]
ORDER BY TotalSales DESC;

--  Product Categories Purchased by High-Value Customers
WITH TopCustomers AS (
    SELECT TOP 10 
        [Customer_ID], 
        SUM(Sales) AS TotalSales
    FROM Orders
    GROUP BY [Customer_ID]
    ORDER BY TotalSales DESC
)
SELECT 
    o.[Customer_ID],
    o.[Customer_Name],
    o.Category,
    COUNT(*) AS NumPurchases,
    SUM(o.Sales) AS CategorySales
FROM Orders o
JOIN TopCustomers tc ON o.[Customer_ID] = tc.[Customer_ID]
GROUP BY o.[Customer_ID], o.[Customer_Name], o.Category
ORDER BY o.[Customer_ID], CategorySales DESC;

-- Average Order Value

WITH OrderTotals AS (
    SELECT 
        [Order_ID], 
        [Customer_ID], 
        SUM(Sales) AS OrderValue
    FROM Orders
    GROUP BY [Order_ID], [Customer_ID]
)
SELECT 
    [Customer_ID], 
    AVG(OrderValue) AS AvgOrderValue
FROM OrderTotals
GROUP BY [Customer_ID];

-- Customer Purchase Frequency
-- a. Average Number of Purchases per Customer
WITH CustomerOrders AS (
    SELECT 
        [Customer_ID], 
        COUNT(DISTINCT [Order_ID]) AS OrderCount
    FROM Orders
    GROUP BY [Customer_ID]
)
SELECT 
    AVG(CAST(OrderCount AS FLOAT)) AS AvgOrdersPerCustomer
FROM CustomerOrders;

-- Purchase Frequency by Segment

WITH SegmentOrders AS (
    SELECT 
        [Customer_ID], 
        Segment,
        COUNT(DISTINCT [Order_ID]) AS OrderCount
    FROM Orders
    GROUP BY [Customer_ID], Segment
)
SELECT 
    Segment,
    AVG(CAST(OrderCount AS FLOAT)) AS AvgOrders
FROM SegmentOrders
GROUP BY Segment;

-- Monthly Purchase Trends
-- a. Sales and Orders by Month

SELECT 
    FORMAT([Order_Date], 'yyyy-MM') AS Month,
    COUNT(DISTINCT [Order_ID]) AS TotalOrders,
    SUM(Sales) AS TotalSales
FROM Orders
GROUP BY FORMAT([Order_Date], 'yyyy-MM')
ORDER BY Month;

-- b. Month with Highest and Lowest Sales
-- Highest
SELECT TOP 1 
    FORMAT([Order_Date], 'yyyy-MM') AS Month,
    SUM(Sales) AS TotalSales
FROM Orders
GROUP BY FORMAT([Order_Date], 'yyyy-MM')
ORDER BY TotalSales DESC;

-- Lowest
SELECT TOP 1 
    FORMAT([Order_Date], 'yyyy-MM') AS Month,
    SUM(Sales) AS TotalSales
FROM Orders
GROUP BY FORMAT([Order_Date], 'yyyy-MM')
ORDER BY TotalSales ASC;



