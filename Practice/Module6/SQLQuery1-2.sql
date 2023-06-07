USE [Featherman_Analytics];
DECLARE @TotalBikeUnits decimal
DECLARE @BikesData TABLE([Channel] nvarchar(15),
	[Model] nvarchar(25),
	[#Units] decimal(10), 
	[% Total Units] decimal(8,2))

INSERT INTO @BikesData ([Model], [#Units])
SELECT [Model], SUM(rs.[OrderQuantity])
FROM [dbo].[FactResellerSales] as rs
INNER JOIN [dbo].[AW_Products_Flattened] as p
ON p.[ProductKey] = rs.[ProductKey]
WHERE p.[Sub Category] LIKE '%Road%' AND p.Category = 'Bikes'
GROUP BY [Model]
-- we have the column of data in the array so we can total it as shown next
--this is sort of a big deal, once you have the data in your array you can shape it, and create new analytics more easily
SET @TotalBikeUnits = (SELECT SUM([#Units]) FROM @BikesData)

UPDATE @BikesData SET [Channel] ='Reseller'
, [% Total Units] = ([#Units]/@TotalBikeUnits)

-- we are adding a row at a different level of granularity - helpful!
INSERT INTO @BikesData
VALUES ('Reseller', 'All Models', @TotalBikeUnits, 1)

SELECT [Channel], [Model], FORMAT([#Units], 'N0') as [# Units], FORMAT([% Total Units], 'P1') as [% Total]
FROM @BikesData