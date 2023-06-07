USE AdventureWorksDW2012;

SELECT [StateProvinceName] as [State]
, [City]
, [BusinessType]
, [ResellerName]
, CASE 
WHEN SUM([OrderQuantity]) < 500 THEN 'Small sales'
WHEN SUM([OrderQuantity]) BETWEEN 501 and 1000 THEN 'Mid sales'
WHEN SUM([OrderQuantity]) BETWEEN 1001 and 1500 THEN 'Good sales'
WHEN SUM([OrderQuantity]) BETWEEN 1501 and 2000 THEN 'Top sales'
WHEN SUM([OrderQuantity])> 2000 THEN 'Outstanding sellers'
END as [Sales Categoty]
, SUM([OrderQuantity]) as [Total Units]

FROM [dbo].[FactResellerSales] as s
INNER JOIN [dbo].[DimReseller] as r
ON s.[ResellerKey] = r.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g
ON r.[GeographyKey] = g.[GeographyKey]
WHERE [EnglishCountryRegionName] = 'United States'
GROUP BY [StateProvinceName], [City], [BusinessType],[ResellerName]
ORDER BY [StateProvinceName]
, [City]
, [BusinessType]
, [ResellerName]
