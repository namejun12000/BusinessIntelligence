USE AdventureWorksDW2014;

DECLARE @decEuropeUnits as decimal =
(
SELECT SUM([OrderQuantity]) as [Total]
FROM [dbo].[DimReseller] as r
INNER JOIN [dbo].[FactResellerSales] as s
ON r.[ResellerKey] = s.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g
ON r.[GeographyKey] = g.[GeographyKey]
WHERE [EnglishCountryRegionName] IN ('France', 'Germany', 'United Kingdom')
)
-- the format function turns the decimal variable into a text variable
PRINT '# Units for Europe ' + FORMAT(@decEuropeUnits, 'N0') + ' ok.' 