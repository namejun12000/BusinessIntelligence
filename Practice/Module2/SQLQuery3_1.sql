USE [AdventureWorksDW2014];

SELECT [EnglishCountryRegionName]
,FORMAT(SUM([OrderQuantity] * [UnitPrice]), 'N0') as [Total]
, COUNT([SalesOrderLineNumber]) as [# Line Items]
, SUM([OrderQuantity] * [UnitPrice]) /COUNT([SalesOrderLineNumber]) as [Avg $ per Line]
, SUM([OrderQuantity]) as [Total Units]
, FORMAT(SUM(([UnitPrice] - [ProductStandardCost]) *[OrderQuantity]), 'N0') as [Profit]
FROM [dbo].[FactResellerSales] as s
INNER JOIN [dbo].[DimReseller] as r
ON s.[ResellerKey] = r.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g
ON g.[GeographyKey] = r.[GeographyKey]

GROUP BY [EnglishCountryRegionName]
ORDER BY [EnglishCountryRegionName]
-- The same base query can provvide grouped totals by 
-- a) product ID, saelsOrder, Reseller, OrderDate, Business type, Country etc.
