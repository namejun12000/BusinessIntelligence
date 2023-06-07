USE [Featherman_Analytics];

DECLARE @TotalBikeUnits decimal --this is loading a value into a local variable
= (SELECT SUM(rs.[OrderQuantity])
FROM [dbo].[FactResellerSales] as rs
INNER JOIN [dbo].[AW_Products_Flattened] as p
ON p.[ProductKey] = rs.[ProductKey]
WHERE [Category] = 'Bikes')
PRINT @TotalBikeUnits

-- this is declaring the array
DECLARE @BikesData TABLE ([Channel] nvarchar(15),
[Model] nvarchar(25), 
[#Units] decimal(10),
[% total Units] nvarchar(8))

INSERT INTO @BikesData ([Model], [#Units])
SELECT [Model], SUM(rs.[OrderQuantity]) --no need to declare a column name, data is going into the array
FROM [dbo].[FactResellerSales] as rs
INNER JOIN [dbo].[AW_Products_Flattened] as p
ON p.[ProductKey] = rs.[ProductKey]
WHERE [Category] = 'Bikes'
GROUP BY [Model]

UPDATE @BikesData SET [Channel] = 'Reseller',
[% total Units] = FORMAT(([#Units]/@TotalBikeUnits), 'P1')

SELECT * FROM @BikesData