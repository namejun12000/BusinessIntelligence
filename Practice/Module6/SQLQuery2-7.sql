USE [AdventureWorksDW2012];

--UPDATE Tablename SET column1 = (12 * column2) WHERE Dim = ?

-- Set up your array
DECLARE @Sales TABLE ([Product] int
, [Reseller Units] decimal, [Inet Units] decimal)

-- Declare which colums will be added to
INSERT INTO @Sales ([Product], [Reseller Units])

--load the first two columns
SELECT [ProductKey], SUM([OrderQuantity])
FROM [dbo].[FactResellerSales]
GROUP BY [ProductKey]

-- choose a column to change the values - here valurs are changed from NULL to a total
UPDATE @Sales SET [Inet Units]
= (SELECT SUM([OrderQuantity])
FROM [dbo].[FactInternetSales]
WHERE [ProductKey] = [Product])

-- Notice the WHERRE statement is a JOIN from the database table to the array

-- Now choose what columns to display
SELECT Product, [Reseller Units]
, ISNULL([Inet Units], 0) as [INET Units]
FROM @Sales
ORDER BY [Product]
