USE [Featherman_Analytics];
DECLARE @ChannelWidth TABLE ([#SubCategories in Stores] decimal
, [#SubCategories on Web] decimal)

-- insert the data retrieved below into the specified columns of the array
INSERT INTO @ChannelWidth([#SubCategories in Stores], [#SubCategories on Web])
SELECT
-- this is the sub-query for the first column
(SELECT (COUNT(DISTINCT(p.[Sub Category])))
FROM [dbo].[FactResellerSales] as rs
INNER JOIN [dbo].[AW_Products_Flattened] as p
ON p.ProductKey =rs.ProductKey)

--this is the sub-query for the second column
,(SELECT (COUNT(DISTINCT(p.[Sub Category])))
FROM [dbo].[FactInternetSales] as fis
INNER JOIN [dbo].[AW_Products_Flattened] as p
ON p.ProductKey = fis.ProductKey)

SELECT * FROM @ChannelWidth