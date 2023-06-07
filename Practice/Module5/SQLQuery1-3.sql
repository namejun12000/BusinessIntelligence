USE [AdventureWorksDW2014];
-- Business Requirment: What were the unit sales for each product in either sales channel? Include [Model Name]. Notice the query returns a set of rows based on the INNER JOIN column.

SELECT [ModelName], [ProductKey], [ProductAlternateKey]
, [EnglishProductName]
-- here the data came form 2 tables on the same server, you can also retrieve data from different servers using subqueries. So build the dataset column by column !!!
-- The granulartiy is stuck at product level, we want ModelName to be the level of granularity
-- lets go!!

, ISNULL((SELECT SUM([OrderQuantity]) FROM [dbo].[FactResellerSales] as rs
WHERE rs.ProductKey = p.ProductKey), '') as [Reseller Units]
, ISNULL((SELECT SUM([OrderQuantity]) FROM [dbo].[FactInternetSales] as i
WHERE i.ProductKey = p.ProductKey), 0) as [Web Units]
-- in a future module we will add new columns of metrics to further analyze the commerce channles.
FROM [dbo].[DimProduct] as p
WHERE [FinishedGoodsFlag] = 1
ORDER BY [ModelName]
