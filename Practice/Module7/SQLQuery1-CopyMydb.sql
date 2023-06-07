-- this query copies one of Featherman's tables into my db so I can wirte a stored prodcedure agiainst it

USE [MF31namjun.lee];
--copy the table schema and data rows into a new table in myDB
SELECT * INTO [MF31namjun.lee].[dbo].[SalesRepPerformancetoQuota]

-- thisi s the table you are copying
FROM [Featherman_Analytics].[dbo].[SalesRepPerformancetoQuota]

-- if you only watned the table schema

DELETE FROM [MF31namjun.lee].[dbo].[SalesRepPerformancetoQuota]

-- remmove table

DROP TABLE [MF31namjun.lee].[dbo].[SalesRepPerformancetoQuota]
