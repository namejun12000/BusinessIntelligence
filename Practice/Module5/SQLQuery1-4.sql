USE [AdventureWorksDW2014];
--Delete the table then re-create it with new data
/*DROP TABLE [Featherman_Analytics].dbo.Test
GO*/
/*DROP TABLE [Featherman_Analytics].dbo.Test2
GO*/
-- what wer the unit sales for each product in either sales channel, include [Model Name]. Notice the quer returns a set of rows based on the most granular column attribute.
SELECT [ModelName]
,[Color], ISNULL([Class], 0) as [Class]
, ISNULL([ProductLine], '') as [Product line]


, ISNULL((SELECT SUM([OrderQuantity]) FROM [dbo].[FactResellerSales] as rs
WHERE rs.ProductKey = p.ProductKey), '') as [Reseller Units]
, ISNULL((SELECT SUM([OrderQuantity]) FROM [dbo].[FactInternetSales] as i
WHERE i.ProductKey = p.ProductKey), 0) as [Web Units]

-- create the following table
/*INTO [Featherman_Analytics].dbo.Test*/

FROM [dbo].[DimProduct] as p
WHERE [FinishedGoodsFlag] = 1
ORDER BY [ModelName];
-- what one query can run differnt sets of code? yes and together they are as very powerful!!
-- your job as an analyst/DBA is often to complie, and condense data for further reporting...

/*SELECT [ModelName]
,SUM([Reseller Units]) as [Reseller Units]
,SUM([Web Units]) as [Web Units]
INTO [Featherman_Analytics].dbo.Test2
FROM [Featherman_Analytics].dbo.Test
GROUP BY [ModelName]
ORDER BY [ModelName]*/