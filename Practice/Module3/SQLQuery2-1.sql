USE [Featherman_Analytics];

-- create and load a 1-column array with a list of the unique years that there were sales in the table sorted by year
DECLARE @Array TABLE ([Year] decimal(4))
INSERT INTO @Array([Year])
SELECT DISTINCT([Year]) FROM [featherman].[sales] ORDER BY [Year]

--now we have to load the years into a string so we can concatenate it
-- QUOTENAME() is bracket
DECLARE @PivotColumns as NVARCHAR(MAX)
SELECT @PivotColumns = COALESCE(@PivotColumns + ',', '') + QUOTENAME([Year]) FROM @Array
PRINT @PivotColumns

DECLARE @SqlQuery as NVARCHAR(MAX)
SET @SqlQuery = N'SELECT * FROM
( SELECT c.[CustomerName],Year,[Total_Sale]
FROM [featherman].[sales] AS s
INNER JOIN [featherman].[Customers] as c
ON c.[CustomerID] = s.[CustomerID]
) 
AS DataTable
PIVOT(
COUNT([Total_Sale])
FOR YEAR IN (' + @PivotColumns + ')
)
AS PivotTable'
EXECUTE sp_executeSQL @SqlQuery

