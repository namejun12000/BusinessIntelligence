USE [AdventureWorksDW2014];
-- intro to sub queries!! which prices are 50% more than average?
-- you dont always need a sub-query -can use varib;es

DECLARE @Avg as decimal(6,2) = (SELECT avg([DealerPrice]) FROM [dbo].[DimProduct])

SELECT [ProductKey], [ModelName], [ProductAlternateKey]
,[DealerPrice]
FROM [dbo].[DimProduct]
WHERE [DealerPrice] > @Avg * 1.5
ORDER BY [DealerPrice]