USE AdventureWorksDW2014;

DECLARE @decEuropeUnits as decimal =
(
SELECT sum([OrderQuantity]) as [Total]
FROM [dbo].[DimReseller] as r
INNER JOIN [dbo].[FactResellerSales] as s
ON r.[ResellerKey] = s.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g
ON r.[GeographyKey] = g.[GeographyKey]
WHERE [EnglishCountryRegionName] IN ('France', 'Germany', 'United Kingdom')
)

DECLARE @decNorthAmericaUnits as decimal =
(
SELECT sum([OrderQuantity]) as [Total]
FROM [dbo].[DimReseller] as r
INNER JOIN [dbo].[FactResellerSales] as s
ON r.[ResellerKey] = s.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g
ON r.[GeographyKey] = g.[GeographyKey]
WHERE [EnglishCountryRegionName] IN ('Canada', 'United States')
)

DECLARE @decAllUnits as decimal =
(
SELECT sum([OrderQuantity]) as [Total]
FROM [dbo].[DimReseller] as r
INNER JOIN [dbo].[FactResellerSales] as s
ON r.[ResellerKey] = s.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g
ON r.[GeographyKey] = g.[GeographyKey]
)

-- now to demonstrate that the sub queries worked
PRINT 'Europe - total units: ' + FORMAT(@decEuropeUnits, 'N0') -- still important to understand CAST()
PRINT 'Europe - % total units for company: ' 
+ CAST(FORMAT(@decEuropeUnits/ @decAllUnits, 'P2') as varchar(10)) 
PRINT 'North America - total units: ' + CAST(@decNorthAmericaUnits as varchar(10))
PRINT 'North America - % total units for company: '
+ CAST(FORMAT(@decNorthAmericaUnits/@decAllUnits, 'P2') as varchar(10))

-- now use the variables in new calculations
-- this is a new SQL sql that runs after the others and can leverage our local variables (totals)
SELECT [EnglishCountryRegionName]
, FORMAT(SUM([OrderQuantity]/@decAllUnits), 'P2') as [% Total]
-- CASE statements enable more analysis
, CASE
	WHEN [EnglishCountryRegionName] IN ('France', 'Germany', 'United Kingdom')
	THEN FORMAT(SUM([OrderQuantity]/@decEuropeUnits), 'P2')
	WHEN [EnglishCountryRegionName] IN ('Canada', 'United States')
	THEN FORMAT(SUM([OrderQuantity]/@decNorthAmericaUnits), 'P2')
	WHEN [EnglishCountryRegionName] = 'Australia' THEN '100%'
END as [% Region Total]

FROM [dbo].[DimReseller] as r
INNER JOIN [dbo].[FactResellerSales] as s
ON r.[ResellerKey] = s.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g
ON r.[GeographyKey] = g.[GeographyKey]
GROUP BY [EnglishCountryRegionName]