USE [AdventureWorksDW2012];

DECLARE @Year int = 2007

DECLARE @RSSales TABLE ([ProductKey] int, [Reseller Units] decimal (10,2))
DECLARE @INETSales TABLE ([ProductKey] int, [Internet Units] decimal (10,2))

INSERT INTO @RSSales ([ProductKey], [Reseller Units])
SELECT [ProductKey], ISNULL(SUM([OrderQuantity]), 0)
FROM [dbo].[FactResellerSales]
WHERE DATEPART(year, [OrderDate]) = @Year
GROUP BY [ProductKey]

INSERT INTO @INETSales ([ProductKey], [Internet Units])
SELECT [ProductKey], ISNULL(SUM([OrderQuantity]), 0)
FROM [dbo].[FactInternetSales]
WHERE DATEPART(year, [OrderDate]) = @Year
GROUP BY [ProductKey]

SELECT rs.[ProductKey]
, rs.[Reseller Units] as [Reseller Units]
, ISNULL(inet.[Internet Units], 0) as [Internet Units]
, rs.[Reseller Units] + ISNULL(inet.[Internet Units],0) AS [Total Units]
, FORMAT(rs.[Reseller Units]/
(rs.[Reseller Units] + ISNULL(inet.[Internet Units], 0)), 'p1')
AS [% Reseller Channel]
, FORMAT (ISNULL(inet.[Internet Units],0)/
(rs.[Reseller Units] + ISNULL(inet.[Internet Units], 0)), 'p1')
AS [% Internet Channel]
FROM @RSSales as rs
FULL JOIN @INETSales as inet 
ON rs.ProductKey = inet.ProductKey
WHERE rs.ProductKey IS NOT NULL
ORDER BY rs.ProductKey

