
USE Featherman_Analytics;
SELECT [CustomerID], [CustomerName] -- this is the grain the level of granularity
, (SELECT SUM([Total_Sale]) --each subquery creates a new column of data, hmm
FROM [featherman].[Sales] as s
WHERE [Paid] = 0 AND (GETDATE() - [Invoice_Date]) BETWEEN 0 AND 30 AND c.[CustomerID] = s.CustomerID) as [0-30]
-- so its just the ame code over and each building a new column based on the time period you nee
-- each subquery is a group by query!
, ISNULL((SELECT SUM([Total_Sale])
FROM [featherman].[Sales] as s
WHERE [Paid] = 0 AND (GETDATE() - [Invoice_Date]) BETWEEN 31 AND 60 AND c.[CustomerID] = s.CustomerID), 0) as [31-60]

, ISNULL((SELECT SUM([Total_Sale])
FROM [featherman].[Sales] as s
WHERE [Paid] = 0 AND (GETDATE() - [Invoice_Date]) BETWEEN 61 AND 90 AND c.[CustomerID] = s.CustomerID),0) as [61-90]

, ISNULL((SELECT SUM([Total_Sale])
FROM [featherman].[Sales] as s
WHERE [Paid] = 0 AND (GETDATE() - [Invoice_Date]) BETWEEN 91 AND 120 AND c.[CustomerID] = s.CustomerID),0) as [91-120]

, ISNULL((SELECT SUM([Total_Sale])
FROM [featherman].[Sales] as s
WHERE [Paid] = 0 AND (GETDATE() - [Invoice_Date]) BETWEEN 121 AND 180 AND c.[CustomerID] = s.CustomerID),0) as [121-180]

, ISNULL((SELECT SUM([Total_Sale])
FROM [featherman].[Sales] as s
WHERE [Paid] = 0 AND (GETDATE() - [Invoice_Date]) BETWEEN 181 AND 360 AND c.[CustomerID] = s.CustomerID),0) as [181-360]

, ISNULL((SELECT FORMAT(SUM([Total_Sale]), 'N0')
FROM [featherman].[Sales] as s
WHERE [Paid] = 0 AND (GETDATE() - [Invoice_Date]) BETWEEN 0 AND 360 AND c.[CustomerID] = s.CustomerID),0) as [Total Unpaid Last Year]

FROM [featherman].[Customers] as c