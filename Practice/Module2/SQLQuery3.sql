USE [AdventureWorksDW2014];

SELECT [SalesOrderNumber],[SalesOrderLineNumber],[ProductKey]
,FORMAT([OrderDate], 'd', 'en-US') as [Order Date]
,[OrderQuantity]
,FORMAT([UnitPrice], 'N0') as [Unit Price]
, FORMAT(([OrderQuantity] *  [UnitPrice]), 'N0') as [Line Total]
FROM [dbo].[FactResellerSales]

