-- intro to PIVOT() queries which are similar to pivot tables in excel

USE [AdventureWorksDW2014]
-- we need to specify three columns 
-- a) row heading b) column heading c) numeric column to aggregate
-- in the first example years, months, total sales
SELECT * FROM
(SELECT [BusinessType], [EnglishCountryRegionName] as [Country]
, [SalesAmount]
FROM [dbo].[FactResellerSales] as s
INNER JOIN [dbo].[DimReseller] as r
ON r.ResellerKey = s.ResellerKey
INNER JOIN [dbo].[DimGeography] as g
ON g.GeographyKey = r.GeographyKey
)
AS BaseDataTable --this name is arbitrary - but we are 'creating an array'
PIVOT
(SUM([SalesAmount])
FOR [Country] IN (Canada,France,Germany, Australia, [United Kingdom], [United States])
) AS Pivottable
