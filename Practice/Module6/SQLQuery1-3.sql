USE [Featherman_Analytics]; --create the array

DECLARE @Summary TABLE([Channel] nvarchar(10)
, [# SubCat] decimal(4)
, [# Units] decimal(10)
, [% Total] decimal(8,2)
, [Profit] decimal(10,2)
, [% Profit] decimal(8,2))
DECLARE @TotalUnits decimal(8), @Profit decimal(8), @AvgSubCat decimal(8)

--retrieve data from one table into the array - create one compiled row of data
INSERT INTO @Summary([Channel], [# SubCat],[# Units],[Profit])
SELECT 'Reseller', COUNT(DISTINCT(p.[Sub Category]))
, SUM(rs.[OrderQuantity])
, SUM(CAST([SalesAmount] - [TotalProductCost] AS decimal))
FROM [dbo].[FactResellerSales] as rs
INNER JOIN [dbo].[AW_Products_Flattened] as p
ON p.ProductKey = rs.ProductKey

-- create a second row of data display data from a second data source
-- you will often need to integrate data from different data sources into one dataset to enable further analytics and reporting
INSERT INTO  @Summary([Channel], [# SubCat],[# Units],[Profit])
SELECT 'Web', COUNT(DISTINCT(p.[Sub Category]))
, SUM(i.[OrderQuantity])
, SUM(CAST([SalesAmount] - [TotalProductCost] AS decimal))
FROM [dbo].[FactInternetSales] as i
INNER JOIN [dbo].[AW_Products_Flattened] as p
ON p.ProductKey = i.ProductKey

-- calculate and store values into three local variables
SET @TotalUnits = (SELECT SUM([# Units]) FROM @Summary)
SET @Profit = (SELECT SUM([Profit]) FROM @Summary)
SET @AvgSubCat = (SELECT AVG([# SubCat]) FROM @Summary)

--you can always see the values of a local variable using the PRINT command

-- calculate the values for two columns of analytics
UPDATE @Summary SET [% Total] = ([# Units]/@TotalUnits)
, [% Profit] = ([Profit] / @Profit)

-- add a summary row to the datatable to display the calculated totals
INSERT INTO @Summary
VALUES('Total', @AvgSubCat, @TotalUnits,1,@Profit,1)

-- Display nicely formatted data -leaving the underlying data in numeric columns
SELECT [Channel], [# SubCat] 
,FORMAT([# Units], 'N0') as [Total #Units]
,FORMAT([% Total], 'P1') as [% Total Units]
,FORMAT([Profit], 'N0') as [Total Profit]
,FORMAT([% Profit], 'P1') as [% Total Profit]
FROM @Summary
