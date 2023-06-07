USE Featherman_Analytics;
SELECT c.[CustomerID], [CustomerName]
,[Sale_ID], [Invoice_Date]
, CAST((GETDATE() - [Invoice_Date]) as decimal(4)) as [Days]
, CAST(CAST((GETDATE() - [Invoice_Date]) as decimal(4)) as nvarchar(4)) as [DaysT] 
, Case
WHEN (GETDATE() - [Invoice_Date]) BETWEEN 0 and 90 THEN 'Current'
WHEN (GETDATE() - [Invoice_Date]) BETWEEN 60 and 90 THEN '60 days late'
WHEN (GETDATE() - [Invoice_Date]) BETWEEN 91 and 121 THEN '90 days late'
WHEN (GETDATE() - [Invoice_Date]) BETWEEN 121 and 180 THEN '1/3 year late'
WHEN (GETDATE() - [Invoice_Date]) BETWEEN 181 and 360 THEN '1/2 year late'
END as [AR Category]
, SUM([Total_Sale]) as [Total Unpaid Amount]
FROM [featherman].sales as s
INNER JOIN [featherman].[Customers] as c
ON c.CustomerID = s.CustomerID
WHERE [Paid] = 0 AND (GETDATE() - [Invoice_Date]) < 500
GROUP BY c.CustomerID, CustomerName, [Sale_ID], [Invoice_Date]
ORDER  BY c.[CustomerID]