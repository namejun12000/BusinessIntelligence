USE [Featherman_Analytics]; -- load the database

DROP TABLE [MF31namjun.lee].[dbo].[TSQL5] -- if table already exists then remove the table from my database

-- create the big array table
DECLARE @TravelAdventure TABLE([Country] NVARCHAR(50), [GDPPerCapita] DECIMAL(8,2)
, [FemaleHeight] DECIMAL(8,2), [MaleHeight] DECIMAL(8,2), [HeightDifference] DECIMAL(8,2), [CountryHeightRank] INT
, [FLifeExp] DECIMAL(8,2), [MLifeExp] DECIMAL(8,2)
, [MedianAge] DECIMAL(8,2), [PopGrowth] DECIMAL(8,2), [UrbanPct] DECIMAL(8,2)
-- add 5 new columns deriving new insights
, [GDP Group] NVARCHAR(50), [Avg Life Exp] DECIMAL(8,2), [Median Age Group] NVARCHAR(50)
, [PopGrowth Group] NVARCHAR(50), [Urban Group] NVARCHAR(50)) 

-- insert columns from HWGDPPerCapita tables into the array
INSERT INTO @TravelAdventure ([Country], [GDPPerCapita])
SELECT DISTINCT([Country]), [GDPPerCapita]
FROM [featherman].[HWGDPPerCapita] AS gdp

-- merge in columns of metrics from HWHeights table
UPDATE @TravelAdventure SET [FemaleHeight]
= (SELECT [Female_Height_in_Inches] FROM [featherman].[HWHeights] as hei WHERE hei.Country_Name = Country)
UPDATE @TravelAdventure SET [MaleHeight]
= (SELECT [Male_Height_in_Inches] FROM [featherman].[HWHeights] as hei WHERE hei.Country_Name = Country)
UPDATE @TravelAdventure SET [HeightDifference]
= (SELECT [Difference] FROM [featherman].[HWHeights] as hei WHERE hei.Country_Name = Country)
UPDATE @TravelAdventure SET [CountryHeightRank]
= (SELECT [Rank] FROM [featherman].[HWHeights] as hei WHERE hei.Country_Name = Country)

-- merge in columns of metrics from HWlifeExpectancy table
UPDATE @TravelAdventure SET [FLifeExp]
= (SELECT [FemaleLifeExp] FROM [featherman].[HWlifeExpectancy] as life WHERE life.Country_Name = Country)
UPDATE @TravelAdventure SET [MLifeExp]
= (SELECT [MaleLifeExp] FROM [featherman].[HWlifeExpectancy] as life WHERE life.Country_Name = Country)

-- merge in column of metrics from HWMedianAge table
UPDATE @TravelAdventure SET [MedianAge]
= (SELECT TOP 1 [Median_age] FROM [featherman].[HWMedianAge] as age WHERE age.Country_Name = Country)

-- merge in column of metrics from HWPopulationGrowth table
UPDATE @TravelAdventure SET [PopGrowth]
= (SELECT TOP 1 [Population_growth] FROM [featherman].[HWPopulationGrowth] as pop WHERE pop.Country_Name = Country)

-- merge in column of metrics from HWurban_percent table
UPDATE @TravelAdventure SET [UrbanPct]
= (SELECT [UrbanPercent] FROM [featherman].[HWurban_percent] as urban WHERE urban.Country_Name = Country)

-- update the gdp group using CASE statement
UPDATE @TravelAdventure SET [GDP Group]
= (CASE
	WHEN [GDPPerCapita] < 10000.00 THEN 'Less than $10,000'
	WHEN [GDPPerCapita] BETWEEN 10000.00 AND 24999.00 THEN 'Between $10,000 and $24,999'
	WHEN [GDPPerCapita] BETWEEN 25000.00 AND 39999.00 THEN 'Between $25,000 and $39,999'
	WHEN [GDPPerCapita] >= 40000.00 THEN 'More or equal than $40,000'
	END)

-- update the female and male average life expectancy
UPDATE @TravelAdventure SET [Avg Life Exp]
= ([FLifeExp] + [MLifeExp]) / 2

-- update median age group using CASE statement
UPDATE @TravelAdventure SET [Median Age Group]
= (CASE 
	WHEN [MedianAge] BETWEEN 10.00 AND 19.99 THEN '10 years'
	WHEN [MedianAge] BETWEEN 20.00 AND 29.99 THEN '20 years'
	WHEN [MedianAge] BETWEEN 30.00 AND 39.99 THEN '30 years'
	WHEN [MedianAge] >= 40 THEN '40 years'
	END)

-- update population growth group using CASE statement
UPDATE @TravelAdventure SET [PopGrowth Group]
= (CASE
	WHEN [PopGrowth] < 0 THEN 'Decrease'
	WHEN [PopGrowth] BETWEEN 0 AND 0.99 THEN 'Less 1% Increase'
	WHEN [PopGrowth] BETWEEN 1 AND 1.99 THEN 'Less 2% Increase'
	WHEN [PopGrowth] BETWEEN 2 AND 2.99 THEN 'Less 3% Increase'
	WHEN [PopGrowth] >= 3 THEN 'More 3% Increase'
	END)

-- update urban percent using CASE statement
UPDATE @TravelAdventure SET [Urban Group]
= (CASE 
	WHEN [UrbanPct] < 50.00 THEN 'Less than 50'
	WHEN [UrbanPct] BETWEEN 50.00 AND 69.99 THEN 'Reached 50'
	WHEN [UrbanPct] BETWEEN 70.00 AND 89.99 THEN 'Reached 70'
	WHEN [UrbanPct] >= 90 THEN 'Reached 90'
	END)

-- save the array to my database
-- there is a null value because other tables are joined based on the country of the GDP table. Therefore, the columns where the null exists are not displayed.
SELECT * INTO [MF31namjun.lee].[dbo].[TSQL5] 
FROM @TravelAdventure
WHERE FemaleHeight IS NOT NULL
AND FLifeExp IS NOT NULL 
AND MedianAge IS NOT NULL 
AND PopGrowth IS NOT NULL 
AND UrbanPct IS NOT NULL
