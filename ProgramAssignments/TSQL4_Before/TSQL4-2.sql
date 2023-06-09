USE [AdventureWorksDW2019];

-- Top level Subquery
-- Change data for better viewing and add units to percentages (% of total)
SELECT Color, CONCAT('$ ',FORMAT([Reseller Total Sales],'N0')) as [Reseller Total Sales]
, CONCAT('$ ',FORMAT([Internet Total Sales], 'N0')) as [Internet Total Sales]
, [Reseller Total Units Sold], [Internet Total Units Sold]
, CONCAT('$ ',FORMAT([Total Bike Sales], 'N0')) as [Total Bike Sales], [Total Bike Units Sold]
, FORMAT(CAST([Reseller Total Units Sold] as decimal)/CAST([Total Bike Units Sold] as decimal),'p2') as [% Reseller Total Units Sold]
, FORMAT(CAST([Internet Total Units Sold] as decimal)/CAST([Total Bike Units Sold] as decimal),'p2') as [% Internet Total Units Sold]
FROM 
(
-- Level 3 Subquery
-- total bike sales and total units sold
SELECT *
, ([Reseller Total Sales] + [Internet Total Sales]) as [Total Bike Sales]
, ([Reseller Total Units Sold] + [Internet Total Units Sold]) as [Total Bike Units Sold]
FROM
(
-- Level 2 Subquery
-- bike sales and units sold by color
SELECT [Color]
,SUM([Reseller Sales]) as [Reseller Total Sales]
, SUM([Internet Sales]) as [Internet Total Sales]
, SUM([Reseller Units Sold]) as [Reseller Total Units Sold]
, SUM([Internet Units Sold]) as [Internet Total Units Sold]
FROM
(
-- Level 1 Subquery
-- all bike sales and units sold
SELECT d.[Color], d.[EnglishProductName]
, (SELECT ISNULL(SUM([SalesAmount]),0)
FROM [dbo].[FactResellerSales] as s
WHERE s.ProductKey = d.ProductKey
) as [Reseller Sales]
, (SELECT ISNULL(SUM([SalesAmount]),0)
FROM [dbo].[FactInternetSales] as i
WHERE i.ProductKey = d.ProductKey
) as [Internet Sales]
, (SELECT ISNULL(SUM([OrderQuantity]),0)
FROM [dbo].[FactResellerSales] as s
WHERE s.ProductKey = d.ProductKey
) as [Reseller Units Sold]
, (SELECT ISNULL(SUM([OrderQuantity]),0)
FROM [dbo].[FactInternetSales] as i
WHERE i.ProductKey = d.ProductKey
) as [Internet Units Sold]
FROM [dbo].[DimProduct] as d
INNER JOIN [dbo].[DimProductSubCategory] as ds ON ds.[ProductSubcategoryKey] = d.[ProductSubcategoryKey]
INNER JOIN [dbo].[DimProductCategory] as dc ON dc.ProductCategoryKey = ds.ProductCategoryKey
WHERE [Color] <> 'NA'
AND  [EnglishProductCategoryName] =  'Bikes'
) sub1
GROUP BY Color
) sub2
) sub3
