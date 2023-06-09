USE [AdventureWorksDW2019];

-- List of the TOP 10 products (Current or Current not) sold in physical stores in all countries
SELECT Top(10) p.[ProductKey] as [Product Key]
,[EnglishProductName] as [Product Name]
, ISNULL([Status], 'X') as [Status]
, ISNULL((SELECT SUM([OrderQuantity]) FROM [dbo].[FactResellerSales] as rs
INNER JOIN [dbo].[DimReseller] as dr ON rs.[ResellerKey] = dr.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as geo ON geo.[GeographyKey] = dr.[GeographyKey]
WHERE rs.ProductKey = p.ProductKey
AND [EnglishCountryRegionName]
IN ('Australia','Canada', 'France', 'Germany', 'United Kingdom', 
'United States')), '') as [# Units Sold]
FROM [dbo].[DimProduct] as p
ORDER BY [# Units Sold]  DESC

-- List of the TOP 10 products (Current or Current not) sold in physical retail stores in Germany
SELECT TOP(10) p.[ProductKey] as [Product Key]
,[EnglishProductName] as [Product Name]
, ISNULL([Status], 'X') as [Status]
, ISNULL((SELECT SUM([OrderQuantity]) 
FROM [dbo].[FactResellerSales] as rs
INNER JOIN [dbo].[DimReseller] as r
ON rs.[ResellerKey] = r.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g
ON g.[GeographyKey] = r.[GeographyKey]
WHERE rs.ProductKey = p.ProductKey
AND [EnglishCountryRegionName] = 'Germany'), '') as [# Units Sold]
FROM [dbo].[DimProduct] as p
ORDER BY [# Units Sold]  DESC

-- check the top 10 best-selling products in the entire country that are also selling in Germany
SELECT p.[ProductKey] as [Product Key]
,[EnglishProductName] as [Product Name]
, ISNULL([Status], 'X') as [Status]
, ISNULL((SELECT SUM([OrderQuantity]) 
FROM [dbo].[FactResellerSales] as rs
INNER JOIN [dbo].[DimReseller] as r
ON rs.[ResellerKey] = r.[ResellerKey]
INNER JOIN [dbo].[DimGeography] as g
ON g.[GeographyKey] = r.[GeographyKey]
WHERE rs.ProductKey = p.ProductKey
AND [EnglishCountryRegionName] = 'Germany'), '') as [# Units Sold]
FROM [dbo].[DimProduct] as p
WHERE p.[ProductKey] IN (471, 491, 470, 474, 476, 483, 225, 234,477,490)
ORDER BY [# Units Sold] DESC