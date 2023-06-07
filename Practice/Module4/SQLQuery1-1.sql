USE [AdventureWorksDW2012];

SELECT [Title], CONCAT([LastName], ' ', [FirstName]) as [Employee]
, [SickLeaveHours]
, FORMAT([BaseRate], 'N2') as [Pay Rate]
, DATEDIFF(year, [BirthDate],GETDATE()) as [Age]
, CASE 
WHEN DATEDIFF(year, [BirthDate],GETDATE()) < 30 THEN 'Emerging Leader'
WHEN DATEDIFF(year, [BirthDate],GETDATE()) BETWEEN 31 and 40 THEN 'Mgmt Material'
WHEN DATEDIFF(year, [BirthDate],GETDATE()) BETWEEN 41 and 55 THEN 'Sr.Mgmt'
WHEN DATEDIFF(year, [BirthDate],GETDATE()) > 55 THEN 'Strategic Level'
END as [Age Group]
-- new function (group)
, NTILE(4) OVER(ORDER BY (DATEDIFF(year, [BirthDate],GETDATE()))) as [Quartile#]
, CASE NTILE(4) OVER(ORDER BY (DATEDIFF(year, [BirthDate],GETDATE())))
WHEN 1 THEN 'Young employee'
WHEN 2 THeN 'Emerging leader'
WHEN 3 THEN 'Mid-career'
WHEN 4 THEN 'Sr.Level'
END AS [Quartiles]
FROM [dbo].[DimEmployee]
