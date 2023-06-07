-- WHERE NOT IN

USE [AdventureWorksDW2012];

SELECT COUNT(DISTINCT(i.[ProductKey])) as [Internet Products]
FROM [dbo].[FactInternetSales] as i
WHERE i.[ProductKey] NOT IN --when you see another SELECT statement then you have a subquery
(SELECT DISTINCT([ProductKey]) from [dbo].[FactResellerSales])

USE [AdventureWorksDW2012]
-- what products that are selling well on the internet should also be sold at stores?
SELECT i.[ProductKey] as [Product ID]
, [EnglishProductName], [ListPrice]
, SUM([OrderQuantity]) as [Web Units]
, FORMAT(SUM([UnitPrice] - [TotalProductCost]), 'N0') as [Profit]
FROM [dbo].[FactInternetSales] as i
INNER JOIN [dbo].[DimProduct] as p ON i.ProductKey = p.ProductKey
-- the real star hear is the WHERE NOT IN subquery
WHERE i.[ProductKey] NOT IN
(SELECT DISTINCT([ProductKey]) FROM [dbo].[FactResellerSales])
GROUP BY i.[ProductKey], [EnglishProductName], [ListPrice] --in this case the numeric column is an attribute (specific detail) of a dimension (we are not adding it)
ORDER BY SUM([UnitPrice] - [TotalProductCost]) DESC