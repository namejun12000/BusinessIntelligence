USE [AdventureWorksDW2014];

SELECT [SalesOrderNumber], [OrderDate]
, FORMAT([OrderDate], 'd', 'en-US') as [Order Date]
--DatePart and DataName
, DATEPART(day, [OrderDate]) AS [Day of Month]
, DATEPART(month, [OrderDate]) as [Month]
, DATENAME(month, [OrderDate]) as [Month Name]

, DATEPART(year, [OrderDate]) as [Year]
, CONCAT('Q', DATEPART(quarter, [OrderDate])) as [Qtr]

, DATEPART(WEEKDAY, [OrderDate]) as [Day # of Week]
, DATENAME(WEEKDAY, [OrderDate]) as [Week day name]
, DATEPART(DAYOFYEAR, [OrderDate]) as [Day of Year]
, DATEPART(WEEK, [OrderDate]) as [Week # of Year]

, MONTH([OrderDate]) as [Month Num]
, DAY([OrderDate]) as [Day Num]
, YEAR([OrderDate]) as [Year Num]
FROM [dbo].[FactInternetSales]
