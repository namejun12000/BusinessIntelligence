-- DATEDIFF() - used to calcualte # days, etc
-- between two dates - useful in accounts receivable (like: age)
-- many more options with DatePart - inside Group By queries

USE [AdventureWorksDW2014];


SELECT [Title], [LastName],[FirstName],[SickLeaveHours]
,[BirthDate], FORMAT([BaseRate], 'N2') as [Pay rate]
, DATEDIFF(year, [BirthDate], GETDATE()) as Age -- get data same as NOW() or TODAY() in excel or VB
, DATEDIFF(year, [HireDate], GETDATE()) as Tenure
FROM [dbo].[DimEmployee] as e
WHERE [BaseRate] BETWEEN 20 and 30
ORDER BY DATEDIFF(year, [HireDate], GETDATE())
