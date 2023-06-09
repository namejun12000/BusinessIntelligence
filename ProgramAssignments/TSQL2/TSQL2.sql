USE [Featherman_Analytics];
-- PIVOT statements to analyze the avg. 205lb caloric burn for each combination of category and pace
SELECT * FROM
(SELECT [Category],[CaloricBurn-205lber] as [205lb],[Pace]
FROM [featherman].[Exercise]
WHERE [Exercise?] = 1) AS Base205lbTable
PIVOT
(AVG([205lb]) 
FOR [Pace] IN ([Easy], [Steady], [Vigorous], [High Intensity])) AS Pivottable
-- Easy Rec Center
SELECT TOP 3 [Category],[Pace],[Activity-1hr],[CaloricBurn-205lber] as [CalBurn]
FROM [featherman].[Exercise]
WHERE [Exercise?] = 1 AND ([Category] = 'Rec Center' AND [Pace] = 'Easy') ORDER BY newid()
-- Steady Sport
SELECT TOP 3 [Category],[Pace],[Activity-1hr],[CaloricBurn-205lber] as [CalBurn]
FROM [featherman].[Exercise]
WHERE [Exercise?] = 1 AND ([Category] = 'Activity' AND [Pace] = 'Easy') ORDER BY newid()
-- Easy Sport
SELECT TOP 3 [Category],[Pace],[Activity-1hr],[CaloricBurn-205lber] as [CalBurn]
FROM [featherman].[Exercise]
WHERE [Exercise?] = 1 AND ([Category] = 'Activity' AND [Pace] = 'Steady') ORDER BY newid()
-- Steady Activity
SELECT TOP 3 [Category],[Pace],[Activity-1hr],[CaloricBurn-205lber] as [CalBurn]
FROM [featherman].[Exercise]
WHERE [Exercise?] = 1 AND ([Category] = 'Sport' AND [Pace] = 'Steady') ORDER BY newid()
-- Easy Activity
SELECT TOP 3 [Category],[Pace],[Activity-1hr],[CaloricBurn-205lber] as [CalBurn]
FROM [featherman].[Exercise]
WHERE [Exercise?] = 1 AND ([Category] = 'Sport' AND [Pace] = 'Easy') ORDER BY newid()
