-- same as SQLQuery2-1

USE Featherman_Analytics;
SELECT * FROM
( SELECT c.[CustomerName],Year,[Total_Sale]
FROM [featherman].[sales] AS s
INNER JOIN [featherman].[Customers] as c
ON c.[CustomerID] = s.[CustomerID]
) 
AS DataTable
PIVOT(
COUNT([Total_Sale])
FOR YEAR IN ([2021],[2022],[2023])
)
AS PivotTable