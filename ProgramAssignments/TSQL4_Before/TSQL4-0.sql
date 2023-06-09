USE [AdventureWorksDW2019];
-- Identify which products sold in Germany are sold on the internet but not in a physical store
SELECT DISTINCT(i.[ProductKey]) as [Product Key]
,[EnglishProductName] as [Product Name]
, SUM([OrderQuantity]) as [# Unit Sold]
FROM [dbo].[FactInternetSales] as i
INNER JOIN [dbo].[DimProduct] as p ON p.[ProductKey] = i.[ProductKey]
INNER JOIN [dbo].[DimGeography] as geo ON geo.[SalesTerritoryKey]= i.[SalesTerritoryKey]
WHERE [EnglishCountryRegionName] = 'Germany'
AND i.[ProductKey] NOT IN
(
SELECT DISTINCT(s.[ProductKey]) 
FROM [dbo].[FactResellerSales] as s
INNER JOIN [dbo].[DimReseller] as rs ON rs.ResellerKey = s.ResellerKey
INNER JOIN [dbo].[DimGeography] as g ON g.[GeographyKey] = rs.[GeographyKey]
WHERE g.[EnglishCountryRegionName] = geo.[EnglishCountryRegionName]
)
GROUP BY i.[ProductKey], [EnglishProductName]
ORDER BY SUM([OrderQuantity]) DESC


