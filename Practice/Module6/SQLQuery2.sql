USE [Featherman_Analytics];

--DECLARE @SubCategory nvarchar(30) = 'Mountain Bikes'
DECLARE @DP decimal = 1000

SELECT [Model], SUM(OrderQuantity) as [Total]
FROM FactResellerSales as s
INNER JOIN [dbo].[AW_Products_Flattened] as p
ON p.ProductKey = s.ProductKey
--WHERE [Sub Category] = @SubCategory
WHERE [Dealer Price] > @DP
GROUP BY [Model]