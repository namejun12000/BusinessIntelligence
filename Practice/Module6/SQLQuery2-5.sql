USE [AdventureWorksDW2014];
DECLARE @Year int = 2013
DECLARE @RSSales TABLE ([ProductKey] int, [Reseller Units] decimal(10,2))
DECLARE @INETSales TABLE ([ProductKey] int, [Internet Units] decimal(10,2))
DECLARE @Combined TABLE ([ProductKey] int, [Reseller Units] decimal
, [Internet Units] decimal, [Total Units] decimal
, [% Reseller Channel] nvarchar(8)
, [% Internet Channel] nvarchar(8))

INSERT INTO @RSSales ([ProductKey],[Reseller Units])
SELECT ProductKey, SUM([OrderQuantity])
FROM [dbo].[FactResellerSales]
WHERE DATEPART(year, [OrderDate]) = @Year
GROUP BY ProductKey

INSERT INTO @INETSales ([ProductKey],[Internet Units])
SELECT ProductKey, SUM([OrderQuantity])
FROM [dbo].[FactInternetSales]
WHERE DATEPART(year, [OrderDate]) = @Year
GROUP BY ProductKey

INSERT INTO @Combined ([ProductKey], [Reseller Units], [Internet Units], [Total Units], [% Reseller Channel], [% Internet Channel])

SELECT  rs.[ProductKey], rs.[Reseller Units]
, inet.[Internet Units]
, (rs.[Reseller Units] +inet.[Internet Units]) AS [Total Units]
, FORMAT(rs.[Reseller Units] / (rs.[Reseller Units] + inet.[Internet Units]), 'P2') AS [% Reseller Channel]
, FORMAT(inet.[Internet Units] / (rs.[Reseller Units]+ inet.[Internet Units]), 'P2') AS [% Internet Channel]
FROM @RSSales rs, @INETSales inet
WHERE rs.ProductKey = inet.ProductKey
ORDER BY rs.ProductKey

SELECT * FROM @Combined
