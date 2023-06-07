-- DATA explosion

USE [AdventureWorksDW2012];
-- what are the product sales across sales channels? Look at the high numbers -caused by joining 2 FACT TABLES
SELECT DISTINCT  r.[ProductKey] as [Reseller Product ID]
, i.productkey as [Web Product ID]
, ISNULL(SUM(r.[OrderQuantity]),0) as [Reseller totals]
, ISNULL(SUM(i.[OrderQuantity]),0) as [Web totals]
FROM [dbo].[FactResellerSales] as r --we want totals by product
FULL JOIN [dbo].[FactInternetSales] as i
ON r.productkey = i.productkey

--Run this query with an without this next lie to better understand the JOIN.
-- WHERE r.[ProductKey] IS NOT NULL
GROUP BY r.[ProductKey], i.productkey
ORDER BY r.productkey