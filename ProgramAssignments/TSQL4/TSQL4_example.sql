USE [Featherman_Analytics];
-- Start with your query from the prior related assignment and using the data in the table shown above load an array. 
-- create the HealthHeartExperimental table 
DECLARE @HealthHeartExperimental TABLE ([ID] INT, [Age] INT, [SexNum] INT, [SysBP] DECIMAL(8,2), [DiaBP] DECIMAL(8,2), [HRTreadmillTest] DECIMAL(8,2)
, [WeightLbs] DECIMAL(8,2), [HeightInches] DECIMAL(8,2), [BMI] DECIMAL, [Age Group] NVARCHAR(50), [BMI Group] NVARCHAR(50)
, [AvgMaxHeartRate] DECIMAL(8,2), [HR Zone 50] DECIMAL(8,2), [HR Zone 60] DECIMAL(8,2), [Heart Health] NVARCHAR(50)
,[Blood Pressure] NVARCHAR(50), [Gender] NVARCHAR(50))
-- insert data into the table (copy query from assignment 3)
INSERT INTO @HealthHeartExperimental ([ID], [Age], [SexNum], [SysBP], [DiaBP], [HRTreadmillTest]
, [WeightLbs], [HeightInches], [BMI], [Age Group], [BMI GROUP] 
, [AvgMaxHeartRate], [HR Zone 50], [HR Zone 60], [Heart Health], [Blood Pressure], [Gender])
(SELECT *
, CASE -- results of treadmill test
	WHEN [HRTreadmillTest] >= [AvgMaxHeartRate] THEN 'At risk' 
	WHEN [HRTreadmillTest] < [AvgMaxHeartRate] AND
	[HRTreadmillTest] > [HR Zone 60] 
	THEN 'Healthy'
	WHEN [HRTreadmillTest] <= [HR Zone 50] OR [HRTreadmillTest] <= [HR Zone 60]
	THEN 'Extremely Healthy'
	END AS [Heart Health]
, CASE -- Blood Pressure
	WHEN [SysBP] < 120 AND [DiaBP] < 80 THEN 'Normal'
	WHEN ([SysBP] BETWEEN 120 AND 129) AND [DiaBP] < 80 THEN 'Elevated'
	WHEN ([SysBP] BETWEEN 130 AND 139) OR ([DiaBP]BETWEEN 80 AND 89) THEN 'Stage 1 Hypertension'
	WHEN ([SysBP] >= 140 AND [SysBP] < 180) OR ([DiaBP] >= 90 AND [DiaBP] < 120) THEN 'Stage 2 Hypertension'
	WHEN [SysBP] >= 180 OR [DiaBP] >= 120 THEN 'Hypertensive crisis'
	END AS [Blood Pressure]
, CASE -- Gender
	WHEN sex = 1 THEN 'Male'
	ELSE  'Female'
	END AS [Gender]
FROM
(SELECT *
, CASE -- BMI groups
	WHEN [BMI] < 18.5 THEN 'Underweight'
	WHEN [BMI] BETWEEN 18.5 AND 24.9 THEN 'Healthy Weight'
	WHEN [BMI] BETWEEN 25.0 AND 29.9 THEN 'Overweight'
	WHEN [BMI] >= 30.0 THEN 'Obesity'
	END AS [BMI Group]
, CASE -- Avg Max Heart Rate (85%)
	WHEN [Age Group] = '20 years' THEN 170
	WHEN [Age Group] = '30 years' THEN 162
	WHEN [Age Group] = '35 years' THEN 157
	WHEN [Age Group] = '40 years' THEN 153
	WHEN [Age Group] = '45 years' THEN 149
	WHEN [Age Group] = '50 years' THEN 145
	WHEN [Age Group] = '55 years' THEN 140
	WHEN [Age Group] = '60 years' THEN 136
	WHEN [Age Group] = '65 years' THEN 132
	WHEN [Age Group] = '70 years' THEN 128
	END AS [AvgMaxHeartRate]
, CASE -- HR Zone 50%
	WHEN [Age Group] = '20 years' THEN 100
	WHEN [Age Group] = '30 years' THEN 95
	WHEN [Age Group] = '35 years' THEN 93
	WHEN [Age Group] = '40 years' THEN 90
	WHEN [Age Group] = '45 years' THEN 88
	WHEN [Age Group] = '50 years' THEN 85
	WHEN [Age Group] = '55 years' THEN 83
	WHEN [Age Group] = '60 years' THEN 80
	WHEN [Age Group] = '65 years' THEN 78
	WHEN [Age Group] = '70 years' THEN 75
	END AS [HR Zone 50]
, CASE -- HR Zone 60%
	WHEN [Age Group] = '20 years' THEN 120
	WHEN [Age Group] = '30 years' THEN 114
	WHEN [Age Group] = '35 years' THEN 111
	WHEN [Age Group] = '40 years' THEN 108
	WHEN [Age Group] = '45 years' THEN 105
	WHEN [Age Group] = '50 years' THEN 102
	WHEN [Age Group] = '55 years' THEN 99
	WHEN [Age Group] = '60 years' THEN 96
	WHEN [Age Group] = '65 years' THEN 93
	WHEN [Age Group] = '70 years' THEN 90
	END AS [HR Zone 60]
FROM 
(SELECT [ID],[age],[sex],[SysBP],[DiaBP],[HRTreadmillTest],[weightLbs]
,[heightInches],[BMI]
, CASE -- age groups
	WHEN age BETWEEN 20 AND 29 THEN '20 years'
	WHEN age BETWEEN 30 AND 34 THEN '30 years'
	WHEN age BETWEEN 35 AND 39 THEN '35 years'
	WHEN age BETWEEN 40 AND 44 THEN '40 years'
	WHEN age BETWEEN 45 AND 49 THEN '45 years'
	WHEN age BETWEEN 50 AND 54 THEN '50 years'
	WHEN age BETWEEN 55 AND 59 THEN '55 years'
	WHEN age BETWEEN 60 AND 64 THEN '60 years'
	WHEN age BETWEEN 65 AND 69 THEN '65 years'
	WHEN age BETWEEN 70 AND 79 THEN '70 years'
	END AS [Age Group]
FROM [featherman].[Health_heart_experimental]
) AS data
) AS data2
)
-- 1. create the table (ReachedMaxHeartRate)
-- this table based on their actual max heart rate on the treadmill test as compared to the max their age group.
DECLARE @ReachedMaxHeartRate TABLE ([ID] INT, [Heart Health Specific] NVARCHAR(50))
-- insert the data into the table 
INSERT INTO @ReachedMaxHeartRate ([ID], [Heart Health Specific])
SELECT [ID]
, CASE 
	WHEN [HRTreadmillTest] >= [AvgMaxHeartRate] THEN 'At risk'
	WHEN [HRTreadmillTest] >= ([AvgMaxHeartRate] * 0.9) THEN 'Warning'
	WHEN [HRTreadmillTest] >= ([AvgMaxHeartRate] * 0.7) THEN 'Normal'
	WHEN [HRTreadmillTest] >= ([AvgMaxHeartRate] * 0.5) THEN 'Healthy'
	ELSE 'Extremely Healthy'
	END
FROM @HealthHeartExperimental
-- 2.create the table (WeightHeight)
-- this table based on weight pounds divided by height inches
DECLARE @WeightHeight TABLE ([ID] INT, [Weight/Height] DECIMAL(8,2)
, [Weight/Height Group] NVARCHAR(50)
, [Weight/Height Quantile #] DECIMAL, [Weight/Height Quantile Group] NVARCHAR(50))
-- insert the data into the table
INSERT INTO @WeightHeight ([ID], [Weight/Height], [Weight/Height Quantile #], [Weight/Height Quantile Group])
SELECT [ID], [WeightLbs]/[HeightInches]
, NTILE(4) OVER(ORDER BY ([WeightLbs]/[HeightInches])) -- quartiles based on weight divided by height
, CASE NTILE(4) OVER(ORDER BY ([WeightLbs]/[HeightInches])) --quartiles lables
	WHEN 1 THEN 'Group 1'
	WHEN 2 THEN 'Group 2'
	WHEN 3 THEN 'Group 3'
	WHEN 4 THEN 'Group 4'
	END
FROM @HealthHeartExperimental
--Updata categories based on the weight/height
UPDATE @WeightHeight SET [Weight/Height Group] =
(
CASE
	WHEN [Weight/Height] < 2.0 THEN 'Group 1'
	WHEN [Weight/Height] BETWEEN 2.0 AND 2.49 THEN 'Group 2'
	WHEN [Weight/Height] BETWEEN 2.50 AND 2.99 THEN 'Group 3'
	WHEN [Weight/Height] >= 3.0 THEN 'Group 4'
	END
)
-- 3.create the table (Blockage)
-- this table based on treadmill results
DECLARE @Blockage TABLE ([ID] INT
, [Occurrence of Blockage] NVARCHAR(50)
, [Treadmill Quantile #] DECIMAL, [Treadmill Quantile Group] NVARCHAR(50))
-- insert the data into the table
INSERT INTO @Blockage ([ID], [Occurrence of Blockage], [Treadmill Quantile #], [Treadmill Quantile Group])
SELECT [ID]
, CASE -- categories about occurrence of blockage
	WHEN [HRTreadmillTest] > [AvgMaxHeartRate] THEN 'High likelihood of occurrence'
	WHEN [HRTreadmillTest] <= [AvgMaxHeartRate] THEN 'Less likelihood of occurrence'
	END
, NTILE(4) OVER(ORDER BY ([HRTreadmillTest])) -- quartiles based on treadmill test
, CASE NTILE(4) OVER(ORDER BY ([HRTreadmillTest])) -- quartiles labels
	WHEN 1 THEN 'Group 1'
	WHEN 2 THEN 'Group 2'
	WHEN 3 THEN 'Group 3'
	WHEN 4 THEN 'Group 4'
	END
FROM @HealthHeartExperimental
--merge all arrays by ID key and show the results
SELECT hhe.[ID], [Age], [SysBP], [DiaBP], [HRTreadmillTest], [WeightLbs], [HeightInches], [BMI], [Age Group], [BMI Group]
, [AvgMaxHeartRate], [Blood Pressure], [Gender], [Heart Health Specific], [Weight/Height]
, [Weight/Height Group], [Weight/Height Quantile #],[Weight/Height Quantile Group]
, [Occurrence of Blockage], [Treadmill Quantile #], [Treadmill Quantile Group]
FROM @HealthHeartExperimental as hhe
INNER JOIN @ReachedMaxHeartRate as rmr
ON hhe.ID = rmr.ID
INNER JOIN @WeightHeight as wh
ON hhe.ID = wh.ID
INNER JOIN @Blockage as bk
ON hhe.ID = bk.ID

