USE [AdventureWorksDW2014];
-- now change the granularity from Buiness Type to Business Type & Year to Busness Type & Year & Month

SELECT [BusinessType]
, DATEPART(week, [OrderDate]) as [Week]
, (DATEPART(Year, [OrderDate]) *100) + DATEPART(week, [OrderDate]) as [Year Week]
, YEAR([OrderDate]) as [Year]
, MONTH([OrderDate]) as [Month#]
, (YEAR([OrderDate]) * 100) + MONTH([OrderDate]) as [YearMonth]
, CAST( (YEAR([OrderDate]) * 100) + MONTH([OrderDate]) as nvarchar(6)) as [YearMonth#]
, DATENAME(month, [OrderDate]) as [Month]
,COUNT(DISTINCT([SalesOrderNumber])) as [# Invoices]
, SUM([OrderQuantity]) as [# Units]
, COUNT([SalesOrderLineNumber]) as [# Items on Order]
, SUM([SalesAmount]) as [Total Sales]
, SUM([SalesAmount]) / COUNT([SalesOrderLineNumber]) as [Avg. Price Item]
, SUM([SalesAmount]) / COUNT(DISTINCT([SalesOrderNumber])) as [Invoice Avg.]
FROM [dbo].[FactResellerSales] as s
INNER JOIN  [dbo].[DimReseller] as r
ON r.[ResellerKey] = s.[ResellerKey]
-- now the data is at teh rifht level so that we can genderate different analystics
GROUP BY [BusinessType]
,DATEPART(week, [OrderDate])
, (DATEPART(Year, [OrderDate]) *100) + DATEPART(week, [OrderDate])
,YEAR([OrderDate]), MONTH([OrderDate]), DATENAME(month, [OrderDate])
,(YEAR([OrderDate]) * 100) + MONTH([OrderDate])
,CAST( (YEAR([OrderDate]) * 100) + MONTH([OrderDate]) as nvarchar(6))


ORDER BY [BusinessType],DATEPART(week, [OrderDate])