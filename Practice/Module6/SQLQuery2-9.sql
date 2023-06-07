USE [AdventureWorksDW2012];

DECLARE @SalesPerformance TABLE ([EmployeeID] INT
, [Name] NVARCHAR(75), [CalendarYear] INT
, [CalendarQuarter] INT, [SalesAmountQuota] DECIMAL
, [SalesAmountActual] DECIMAL
, [Performance to goal] DECIMAL, [Sales KPI] NVARCHAR(10))

INSERT INTO @SalesPerformance ([EmployeeID], [Name], [CalendarYear]
, [CalendarQuarter], [SalesAmountQuota])
SELECT q.[EmployeeKey], CONCAT([FirstName], ' ',[LastName]) AS Name
, [CalendarYear], [CalendarQuarter], [SalesAmountQuota]
FROM [dbo].[FactSalesQuota] as q
INNER JOIN [dbo].[DimEmployee] as e 
ON e.[EmployeeKey] = q.[EmployeeKey]

UPDATE @SalesPerformance SET[SalesAmountActual]
= (SELECT SUM([SalesAmount])
FROM [dbo].[FactResellerSales]
WHERE [EmployeeKey] = [EmployeeID] 
AND DATEPART(year, [OrderDate]) = [CalendarYear]
AND DATEPART(quarter, [OrderDate]) = [CalendarQuarter]
GROUP BY [EmployeeKey], DATEPART(year, [OrderDate]), DATEPART(quarter, [OrderDate]))

UPDATE @SalesPerformance SET [Performance to goal]
= ([SalesAmountActual] - [SalesAmountQuota])

UPDATE @SalesPerformance SET [Sales KPI]
= FORMAT([SalesAmountActual] / [SalesAmountQuota], 'p1')

SELECT * FROM @SalesPerformance