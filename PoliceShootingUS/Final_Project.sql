USE [MF31namjun.lee];

--Police Killing
DECLARE @PoliceKilling TABLE([ID] INT, [Date] DATE, [Manner Death] NVARCHAR(50), [Armed] NVARCHAR(50)
, [Age] INT, [Gender] NVARCHAR(50), [Race] NVARCHAR(50), [City] NVARCHAR(50), [State] NVARCHAR(2), [Mental Illness] NVARCHAR(20)
, [Threat Level] NVARCHAR(50),[Flee] NVARCHAR(50), [Body Camera] NVARCHAR(20)
, [Year] INT, [Age Group] NVARCHAR(50))

INSERT INTO @PoliceKilling ([ID], [Date], [Manner Death], [Armed], [Age], [Gender], [Race], [City], [State], [Mental Illness]
, [Threat Level], [Flee], [Body Camera])
SELECT CONVERT(INT,[id]), [date]
, [manner_of_death]
, ISNULL([armed], 'undetermined')
, CONVERT(INT,[age])
, [gender]
, ISNULL([race], 'Other')
, [city], [state], [signs_of_mental_illness], [threat_level]
, ISNULL([flee], 'Unknown'), [body_camera]
FROM 
(
SELECT *
FROM [dbo].[Final_UsPoliceShooting]
WHERE Age IS NOT NULL AND  Gender IS NOT NULL
) as result1

--Median Income
DECLARE @MedianIncome TABLE ([State] NVARCHAR(50), [Median Income] DECIMAL(8,2))

INSERT INTO @MedianIncome ([State], [Median Income])
SELECT CONVERT(NVARCHAR(50),[Geographic_Area])
, AVG(CONVERT(DECIMAL(8,2),[Median_Income]))
FROM [dbo].[Final_MedianHouseholdIncome]
WHERE [Median_Income] IS NOT NULL
GROUP BY CONVERT(NVARCHAR(50), [Geographic_Area])

--Completed High School
DECLARE @CompletedHighSchool TABLE ([State] NVARCHAR(50), [Completed HS] DECIMAL(8,2))

INSERT INTO @CompletedHighSchool ([State], [Completed HS])
SELECT CONVERT(NVARCHAR(50),[Geographic_Area])
, AVG(CONVERT(DECIMAL(8,2),[percent_completed_hs]))
FROM [dbo].[Final_CompletedHighSchool]
WHERE [percent_completed_hs] IS NOT NULL
GROUP BY CONVERT(NVARCHAR(50), [Geographic_Area])

--Poverty Level
DECLARE @PovertyLevel TABLE ([State] NVARCHAR(50), [Poverty Rate] DECIMAL(8,2))

INSERT INTO @PovertyLevel ([State], [Poverty Rate])
SELECT CONVERT(NVARCHAR(50), [Geographic_Area])
, AVG(CONVERT(DECIMAL(8,2),[poverty_rate]))
FROM [dbo].[Final_PovertyLevel]
WHERE [poverty_rate] IS NOT NULL
GROUP BY CONVERT(NVARCHAR(50),[Geographic_Area])

--Share Race 
DECLARE @Race TABLE ([State] NVARCHAR(50), [% White] DECIMAL(8,2), [% Black] DECIMAL(8,2), [% Native] DECIMAL(8,2)
, [% Asian] DECIMAL(8,2), [% Hispanic] DECIMAL(8,2))

INSERT INTO @Race ([State], [% White], [% Black], [% Native], [% Asian], [% Hispanic])
SELECT CONVERT(NVARCHAR(50), [Geographic_Area])
, AVG(CONVERT(DECIMAL(8,2),[share_white]))
, AVG(CONVERT(DECIMAL(8,2),[share_black]))
, AVG(CONVERT(DECIMAL(8,2),[share_native_american]))
, AVG(CONVERT(DECIMAL(8,2),[share_asian]))
, AVG(CONVERT(DECIMAL(8,2),[share_hispanic]))
FROM [dbo].[Final_ShareRaceByCity]
WHERE [share_white] IS NOT NULL AND [share_hispanic] IS NOT NULL
AND [share_black] IS NOT NULL AND [share_native_american] IS NOT NULL
AND [share_asian] IS NOT NULL 
GROUP BY CONVERT(NVARCHAR(50),[Geographic_Area])

-- Main Table
DECLARE @MainTable TABLE([ID] INT, [Date] DATE, [Manner Death] NVARCHAR(50), [Armed] NVARCHAR(50), [Age] INT, [Gender] NVARCHAR(50), [Race] NVARCHAR(50), [City] NVARCHAR(50), [State] NVARCHAR(2)
, [Mental Illness] NVARCHAR(20), [Threat Level] NVARCHAR(50),[Flee] NVARCHAR(50), [Body Camera] NVARCHAR(20)
, [Median Income] DECIMAL(8,2), [Completed HS] DECIMAL(8,2), [Poverty Rate] DECIMAL(8,2)
, [% White] DECIMAL(8,2), [% Black] DECIMAL(8,2), [% Native] DECIMAL(8,2), [% Asian] DECIMAL(8,2), [% Hispanic] DECIMAL(8,2)
, [Age Group] NVARCHAR(50), [Median Income Label] NVARCHAR(50), [Completed HS Label] NVARCHAR(50)
, [Poverty Label] NVARCHAR(50), [Race Distribution Label] NVARCHAR(50), [Day Name] NVARCHAR(50))

INSERT INTO @MainTable ([ID], [Date], [Manner Death], [Armed], [Age], [Gender], [Race]
, [City], [State], [Mental Illness], [Threat Level], [Flee], [Body Camera]
, [Median Income], [Completed HS], [Poverty Rate]
, [% White], [% Black], [% Native], [% Asian], [% Hispanic])
SELECT [ID], [Date], [Manner Death], [Armed], [Age], [Gender], [Race], [City], pk.[State]
, [Mental Illness], [Threat Level], [Flee], [Body Camera]
, [Median Income], [Completed HS], [Poverty Rate]
, [% White], [% Black], [% Native], [% Asian], [% Hispanic]
FROM @PoliceKilling as pk
INNER JOIN @MedianIncome as mi ON pk.State = mi.State
INNER JOIN @CompletedHighSchool as chs ON pk.State = chs.State
INNER JOIN @PovertyLevel as pl ON pk.State = pl.State
INNER JOIN @Race as race ON pk.State = race.State

UPDATE @MainTable SET [Gender]
= (CASE 
	WHEN [Gender] = 'M' THEN 'Male'
	WHEN [Gender] = 'F' THEN 'Female'
	END)

UPDATE @MainTable SET [Threat Level]
= (CASE
	WHEN [Threat Level] = 'attack' THEN 'Attack'
	WHEN [Threat Level] = 'other' THEN 'Not Attack'
	WHEN [Threat Level] = 'undetermined' THEN 'Unknown'
	END)

UPDATE @MainTable SET [Day Name]
= (DATENAME(WEEKDAY, [Date]))

UPDATE @MainTable SET [Race]
= (CASE
	WHEN [Race] = 'W' THEN 'White'
	WHEN [Race] = 'B' THEN 'Black'
	WHEN [Race] = 'H' THEN 'Hispanic'
	WHEN [Race] = 'A' THEN 'Asian'
	WHEN [Race] = 'N' THEN 'Native'
	ELSE 'Other'
	END)

UPDATE @MainTable SET [Mental Illness]
= (CASE
	WHEN [Mental Illness] = 0 THEN 'Normal'
	WHEN [Mental Illness] = 1 THEN 'Abnormal'
	END)

UPDATE @MainTable SET [Body Camera]
= (CASE
	WHEN [Body Camera] = 0 THEN 'Absence'
	WHEN [Body Camera] = 1 THEN 'Presence'
	END)

UPDATE @MainTable SET [Manner Death]
= (CASE
	WHEN [Manner Death] = 'shot' THEN 'Shot'
	WHEN [Manner Death] = 'shot and Tasered' THEN 'Shot & Tasered'
	END)

UPDATE @MainTable SET [Armed]
= UPPER(LEFT(Armed, 1)) + SUBSTRING(Armed, 2, LEN(Armed))

UPDATE @MainTable SET [Age Group]
= (CASE 
	WHEN [Age] < 20 THEN 'Less than 20 years'
	WHEN [Age] BETWEEN 20 AND 29 THEN '20 years'
	WHEN [Age] BETWEEN 30 AND 39 THEN '30 years'
	WHEN [Age] BETWEEN 40 AND 49 THEN '40 years'
	WHEN [Age] BETWEEN 50 AND 59 THEN '50 years'
	WHEN [Age] BETWEEN 60 AND 69 THEN '60 years'
	WHEN [Age] >= 70 THEN 'More than 70 years'
	END)

UPDATE @MainTable SET [Median Income Label] 
= (SELECT CASE
	WHEN [Median Income] >= 70000 THEN 'High'
	WHEN [Median Income] BETWEEN 50000 AND 69999 THEN 'Medium' 
	WHEN [Median Income] < 50000 THEN 'Low'
	END)

UPDATE @MainTable SET [Completed HS Label] 
= (SELECT CASE
	WHEN [Completed HS] BETWEEN 90.00 AND 100 THEN 'High' 
	WHEN [Completed HS] BETWEEN 80.00 AND 89.99 THEN 'Average' 
	WHEN [Completed HS] BETWEEN 70.00 AND 79.99 THEN 'Low' 
	END)

UPDATE @MainTable SET [Poverty Label] 
= (SELECT CASE
	WHEN [Poverty Rate] >= 20.00 THEN 'Level 4'
	WHEN [Poverty Rate] BETWEEN 15.00 AND 19.99 THEN 'Level 3'
	WHEN [Poverty Rate] BETWEEN 10.00 AND 14.99 THEN 'Level 2' 
	WHEN [Poverty Rate] < 10.00 THEN 'Level 1'
	END)

UPDATE @MainTable SET [Race Distribution Label]
= (SELECT CASE
	WHEN [% Black] > 30.00 THEN 'Black more than 30 %'
	WHEN [% Hispanic] > 30.00 THEN 'Hispanic more than 30 %'
	WHEN [% Native] > 30.00 THEN 'Native American more than 30%'
	WHEN [% Asian] > 30.00 THEN 'Asian More than 30%'
	ELSE 'Overwhelmingly White'
	END)

-- save the array to my database
--SELECT * INTO [MF31namjun.lee].[dbo].[Final_Project] FROM @MainTable

