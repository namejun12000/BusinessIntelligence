USE [AdventureWorksDW2014]; --sort of a 3-table join
-- Excuse me where is the GROUP BY()??? The granulartiy is stuck at resellerID or name

SELECT [BusinessType], [ResellerKey]
, [ResellerName]

--here sub queries are used fetch summary data...with no GROUP BY terms
, (SELECT COUNT([OrderQuantity]) FROM [dbo].[FactResellerSales] as s
WHERE s.[ResellerKey] = r.[ResellerKey]) AS [Unit Sales]
, (SELECT SUM([SalesAmount]) FROM [dbo].[FactResellerSales] as s
WHERE s.[ResellerKey] = r.[ResellerKey]) AS [Total Revenue]

FROM [dbo].[DimReseller] as r
INNER JOIN [dbo].[DimGeography] as g
ON g.GeographyKey = r.GeographyKey
WHERE [StateProvinceName] = 'Washington'
ORDER BY [BusinessType], [Total Revenue] DESC
