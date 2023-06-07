USE [Featherman_Analytics];

DECLARE @Sales TABLE ([Country] NVARCHAR(50)
, [Product] NVARCHAR(50), [Model] NVARCHAR(50)
,[Totals] decimal)

INSERT INTO @Sales ([Country],[Product],[Model],[Totals])
SELECT * FROM [featherman].[BikeSales_Australia]
UNION SELECT * FROM [featherman].[BikeSales_Canada]
UNION SELECT * FROM [featherman].[BikeSales_France]
UNION SELECT * FROM [featherman].[BikeSales_Germany]
UNION SELECT * FROM [featherman].[BikeSales_UK]

DECLARE @TotalSales decimal
= (SELECT SUM([Totals]) FROM @Sales)

SELECT [Country], [Model]
, SUM([Totals]) as [Totals]
, FORMAT(SUM([Totals])/@TotalSales,'P2') as [% Total]
FROM @Sales

GROUP BY [Country], [Model]
ORDER BY [Country], [Model]