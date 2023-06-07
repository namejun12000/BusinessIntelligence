USE [MF31namjun.lee];
GO
CREATE PROCEDURE spVideo2 @subCategoryKey int
AS
BEGIN
SELECT sc.[ProductSubcategoryKey], [ModelName]
, p.[ProductKey], [EnglishProductName]
, SUM([SalesAmount]-[TotalProductCost]) as [Profit]
, SUM([OrderQuantity]) as [Total Units]
FROM [dbo].[FactResellerSales] as f
INNER JOIN [dbo].[DimProduct] as p
ON p.ProductKey = f.ProductKey
INNER JOIN [dbo].[DimProductSubCategory] as sc
ON sc.ProductSubcategoryKey = p.ProductSubcategoryKey
WHERE sc.[ProductSubcategoryKey] = @subCategoryKey
GROUP BY sc.[ProductSubcategoryKey],  [ModelName]
, p.[ProductKey], [EnglishProductName]
END