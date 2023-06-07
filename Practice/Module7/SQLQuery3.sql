USE [MF31namjun.lee];

SELECT * INTO [MF31namjun.lee].[dbo].[DimProductSubCategory]

-- thisi s the table you are copying
FROM [Featherman_Analytics].[dbo].[DimProductSubCategory]

USE [MF31namjun.lee];
GO
CREATE PROCEDURE spVideo1
AS
BEGIN
SELECT [ProductSubcategoryKey] as [SubCatID]
, [EnglishProductSubcategoryName] as [Sub Cat]
FROM [dbo].[DimProductSubCategory]
END