USE [Featherman_Analytics];
DECLARE @Sales TABLE ([Sub Category] nvarchar(50)
, [Model] nvarchar(50), [ProductID] int
, [Product] nvarchar(50), [Reseller Profit] decimal(10,2)
, [Internet Profit] decimal(10,2), [Total Profit] decimal(10,2)
, [Reseller %] decimal(10,2), [Internet %] decimal(10,2)
, [Channel Preference] nvarchar(50))

INSERT INTO @Sales([Sub Category], [Model], [ProductID], [Product]
, [Reseller Profit])
SELECT [Sub Category], [Model], p.[ProductKey]
, [Product], SUM([SalesAmount] - [TotalProductCost])
FROM [dbo].[FactResellerSales] as frs
INNER JOIN [Featherman_Analytics].[dbo].[AW_Products_Flattened] as p
ON frs.ProductKey = p.ProductKey
GROUP BY [Sub Category], [Model],p.[ProductKey], [Product]

UPDATE @Sales SET [Internet Profit]
= (SELECT SUM([SalesAmount] - [TotalProductCost])
FROM [dbo].[FactInternetSales] as i
INNER JOIN [Featherman_Analytics].[dbo].[AW_Products_Flattened] as p
ON i.ProductKey = p.ProductKey
WHERE p.ProductKey = [ProductID])

UPDATE @Sales SET [Total Profit] =
([Reseller Profit] + [Internet Profit])

UPDATE @Sales SET [Reseller %] =
(
CASE 
	WHEN [Reseller Profit] > 0 THEN ([Reseller Profit] / [Total Profit])
	WHEN [Reseller Profit] < 0 THEN 0
	END
)

UPDATE @Sales SET [Internet %] =
(
CASE 
	WHEN [Internet Profit] > 0 THEN ([Internet Profit] / [Total Profit])
	WHEN [Internet Profit] < 0 THEN 0
	END
)

UPDATE @Sales SET [Channel Preference] =
( CASE
	WHEN [Reseller %] > .8 THEN 'Reseller dominant'
	WHEN [Reseller %] BETWEEN .55 AND .799 THEN 'Reseller favored'
	WHEN [Reseller %] BETWEEN .40 AND .50 THEN 'Internet favored'
	WHEN [Reseller %] < .4 THEN 'Internet dominant'
	END
)
SELECT * FROM @Sales
WHERE [Total Profit] IS NOT NULL
ORDER BY [Total Profit] DESC
