USE [Featherman_Analytics];
--insert into @arrayname SELECT FROM
DECLARE @Sales TABLE ([Country] nvarchar(50), [Product] nvarchar(50),
[Model] nvarchar(50), [Totals] decimal(10,2), [%Total] decimal(10,2))

DECLARE @TotalSalesA decimal =
(SELECT SUM([Product Totals]) FROM [featherman].[BikeSales_Australia])

DECLARE @TotalSalesC decimal =
(SELECT SUM([Product Totals]) FROM [featherman].[BikeSales_Canada])

DECLARE @TotalSalesF decimal =
(SELECT SUM([Product Totals]) FROM [featherman].[BikeSales_France])

DECLARE @TotalSalesG decimal =
(SELECT SUM([Product Totals]) FROM [featherman].[BikeSales_Germany])

DECLARE @TotalSalesU decimal =
(SELECT SUM([Product Totals]) FROM [featherman].[BikeSales_UK])

INSERT INTO @Sales ([Country],[Product],[Model],[Totals],[%Total])
SELECT [Country], [ProductAlternateKey]
, [ModelName], [Product Totals]
, [Product Totals]/@TotalSalesA
FROM [featherman].[BikeSales_Australia]

UNION SELECT [Country], [ProductAlternateKey]
, [ModelName], [Product Totals]
, [Product Totals]/@TotalSalesC
FROM [featherman].[BikeSales_Canada]

UNION SELECT [Country], [ProductAlternateKey]
, [ModelName], [Product Totals]
, [Product Totals]/@TotalSalesF
FROM [featherman].[BikeSales_France]

UNION SELECT [Country], [ProductAlternateKey]
, [ModelName], [Product Totals]
, [Product Totals]/@TotalSalesG
FROM [featherman].[BikeSales_Germany]

UNION SELECT [Country], [ProductAlternateKey]
, [ModelName], [Product Totals]
, [Product Totals]/@TotalSalesU
FROM [featherman].[BikeSales_UK]

--here we add the metric columns
SELECT [Country], [Model], SUM([Totals]) as [Totals]
, FORMAT(SUM([%Total]), 'P2') as [% Total]
FROM @Sales
GROUP BY [Country], [Model]
ORDER BY [Country], [Model]
