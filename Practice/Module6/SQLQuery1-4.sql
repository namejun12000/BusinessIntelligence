USE [Featherman_Analytics];

DECLARE @TotalBikeUnits decimal, @TotalProfitLoss decimal
, @TotalBikeProfit decimal, @TotalBikeLosses decimal
, @AvgProfitPerUnit decimal

DECLARE @BikesData TABLE (
[Channel] nvarchar(15), [Model] nvarchar(25)
, [#Units] decimal(10), [Profit] decimal(10)
, [% Total Units] decimal (8,2)
, [Profit/Loss Per Unit] decimal(8)
, [% of Total Profit] decimal(8,2)
, [% of Generated Profits] decimal(8,2)
, [% of Generated Losses] decimal(8,2)
)

INSERT INTO @BikesData ([Model], [#Units], [Profit])
SELECT [Model], SUM(rs.[OrderQuantity])
,SUM([SalesAmount] - [TotalProductCost])
FROM [dbo].[FactResellerSales] as rs
INNER JOIN [dbo].[AW_Products_Flattened] as p
ON rs.ProductKey = p.ProductKey
WHERE [Category] = 'Bikes'
GROUP BY [Model]
ORDER BY [Model]


SET @TotalBikeUnits = (SELECT SUM([#Units]) FROM @BikesData)
SET @TotalProfitLoss = (SELECT SUM([Profit]) FROM @BikesData)
SET @TotalBikeProfit = (SELECT SUM([Profit]) FROM @BikesData WHERE [Profit] > 0)
SET @TotalBikeLosses = (SELECT SUM([Profit]) FROM @BikesData WHERE [Profit] < 0)

--Update columns in the array
UPDATE @BikesData SET 
	[Channel] = 'Reseller'
	, [% Total Units] = ([#Units]/@TotalBikeUnits)
	, [% of Total Profit] = ([Profit]/@TotalProfitLoss) --formula is fubar
	, [Profit/Loss Per Unit] = ([Profit]/[#Units])

--lets try to provide some useful metrics on profit loss, let featherman know if you have a better idea
UPDATE @BikesData SET [% of Generated Profits] =
	(CASE WHEN [Profit] > 0 THEN ([Profit]/@TotalBikeProfit)
	ELSE 0
	END)

UPDATE @BikesData SET [% of Generated Losses] =
	(CASE WHEN [Profit] < 0 THEN ([Profit] / @TotalBikeLosses)
	ELSE 0
	END )

-- THIS next line of code demonstrates that you can inset a new row with only a portion of the columns
INSERT INTO @BikesData ([Channel], [Model], [#Units])
	VALUES ('Reseller', 'All Models', @TotalBikeUnits)

-- calculate a summary value and store it into one row of the array
SET @AvgProfitPerUnit = (SELECT AVG([Profit/Loss Per Unit]) FROM @BikesData)

UPDATE @BikesData SET [Profit/Loss Per Unit] = @AvgProfitPerUnit
	WHERE [Model] = 'All Models'

--Format and display the data
SELECT [Channel], [Model], FORMAT([#Units], 'N0') as [# Units]
, FORMAT([% Total Units], 'p0') as [% Total Units]
, FORMAT([Profit], 'N0') as [Profit/Loss]
, FORMAT([Profit/Loss Per Unit], 'N0') as [Profit/Loss Per Unit]
, FORMAT([% of Total Profit], 'P0') as [% of Total Profit -Don't use]
, FORMAT([% of Generated Profits], 'p0') as [% of Generated Profits]
, FORMAT([% of Generated Losses], 'p0') as [% of Generated Losses]
FROM @BikesData


-- Create a new SQL Server table and then save the data from the array into the database table. If the table already exits, then us line 50 to delete the table before recreating it. In another example we will delete all the reows from an existing SQL table then refill it with the new data

DROP TABLE [Featherman_Analytics].[dbo].[BikesData]
SELECT * INTO [Featherman_Analytics].[dbo].[BikesData]
FROM @BikesData --so this code creates the new tables for us

-- display totals for compare
PRINT 'Original Calculation Total Profit/Loss: ' + FORMAT(@TotalProfitLoss, 'N0')
PRINT 'Total Profit: ' + FORMAT(@TotalBikeProfit, 'N0')
PRINT 'Total Loss: ' + FORMAT(@TotalBikeLosses, 'N0')
PRINT 'Net profitability' + FORMAT(@TotalBikeProfit + @TotalBikeLosses, 'N0')