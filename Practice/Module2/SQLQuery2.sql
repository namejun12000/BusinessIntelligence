USE [AdventureWorksDW2012];

SELECT [EnglishCountryRegionName] as [Country], [StateProvinceName] as [State]
, SUM([OrderQuantity]) as [Total Units]
, AVG([OrderQuantity]) as [Avg Units]
, SUM([SalesAmount]) as [Total revenue]
, AVG([SalesAmount]) as [Avg revenue]
, COUNT(DISTINCT([SalesOrderNumber])) as [#Invoices]
, COUNT([SalesOrderNumber]) as [# line items]


FROM [dbo].[FactResellerSales] as s
INNER JOIN [dbo].[DimReseller] as r ON s.[ResellerKey] = r.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g ON r.[GeographyKey] = g.[GeographyKey]

--WHERE [EnglishCountryRegionName] = 'Germany'

GROUP BY [EnglishCountryRegionName], [StateProvinceName]

HAVING AVG([OrderQuantity]) > 3

ORDER BY [EnglishCountryRegionName], [StateProvinceName]

