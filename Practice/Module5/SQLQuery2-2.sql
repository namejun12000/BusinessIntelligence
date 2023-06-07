-- if data explosion then using sub query

USE [AdventureWorksDW2012]; --here 2 fact tables are connected to a dimension table
SELECT [ModelName], [EnglishProductName]
, r.[ProductKey] as [Reseller Product ID]
, i.[ProductKey] as [Web Prdouct Key]
, ISNULL(SUM(r.[OrderQuantity]), 0) as [Reseller Totals]
, ISNULL(SUM(i.[OrderQuantity]), 0) as [Web Totals]
FROM [dbo].[DimProduct] as p
FULL JOIN [dbo].[FactResellerSales] as r ON r.ProductKey = p.ProductKey
FULL JOIN [dbo].[FactInternetSales] as i ON i.ProductKey = p.ProductKey
WHERE [FinishedGoodsFlag] = 1
GROUP BY [ModelName], [EnglishProductName],r.[ProductKey],i.[ProductKey]
ORDER BY [ModelName]

--when your queirs take longer than normal then you might have data explosion = faulty JOINS....
-- challenge: rewrie this query using 2 subqueries rather than joining 2 facttables to 1 dimension table (we'll wait..)
-- probably the rule is: avoid 2 fact tables in the same query. One can be condensed however, AND JOIN ON PRIMARY KEY

USE [AdventureWorksDW2012]; --here 2 fact tables are connected to a dimension table
SELECT [ModelName], [EnglishProductName]
, p.[ProductKey] as [Web Prdouct Key] -- the level of data is productkey

, (SELECT ISNULL(SUM([OrderQuantity]),0) FROM [dbo].[FactResellerSales] as r WHERE r.ProductKey = p.ProductKey) as [Reseller totals]

, (SELECT ISNULL(SUM([OrderQuantity]),0) FROM [dbo].[FactInternetSales] as i WHERE i.ProductKey = p.ProductKey) as [Web totals] --connect to any table that also have productkey

-- here is the row totlas - other programming language such as DAX simplify this processing
, (SELECT ISNULL(SUM([OrderQuantity]),0) FROM [dbo].[FactResellerSales] as r
WHERE r.productkey = p.productkey) +
(SELECT ISNULL(SUM([OrderQuantity]),0) FROM [dbo].[FactInternetSales] as i
WHERE i.productkey = p.productkey) as [Total Units]

--someday the subquey will save you luke
FROM [dbo].[DimProduct] as p

WHERE [FinishedGoodsFlag] = 1
ORDER BY [ModelName]
-- the sub-query does not cause data explosion