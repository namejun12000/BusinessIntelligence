USE [Featherman_Analytics];

SELECT *
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
