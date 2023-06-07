USE [Featherman_Analytics];

SELECT c.[CustomerID], [CustomerName]
, SUM([Total_Sale]) as [Total Sales]
, COUNT([Sale_ID]) as [Number Orders]
, FORMAT(SUM([Total_Sale])/ COUNT([Sale_ID]), 'N0') as [Avg. Sale]

FROM [featherman].[Customers] as c
LEFT JOIN 
--LEFT JOIN (use of the term left belows means retrieve EVERY Cutomer from the table on the left)
-- RIGHT JOIN (get every record from the table on the right of the join)
[featherman].[sales] as s
ON c.[CustomerID] = s.[CustomerID]

--WHERE c.[CustomerID] = 3

GROUP BY c.[CustomerID], [CustomerName]

ORDER BY SUM([Total_Sale])/ COUNT([Sale_ID]) DESC

