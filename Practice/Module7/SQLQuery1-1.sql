USE [MF31namjun.lee]; --use my db if you copied the table in, so you can create the stored proc
GO
CREATE PROCEDURE spSalesRepPerformanceQuota
AS
BEGIN
SELECT [EmpID],[Name],[Year],[Qtr],[Time Period], [Recorded Sales]
,[Sales Quota], [SalesKPI], [Delta]
, CASE
	WHEN [SalesKPI] >= 100.00 THEN 5
	WHEN [SalesKPI] > 90.00 THEN 4
	WHEN [SalesKPI] > 80.00 THEN 3
	WHEN [SalesKPI] >= 70.00 THEN 2
	WHEN [SalesKPI] < 70.00 THEN 1
	END AS [PerfToGoalBin] -- can be used as a dimension to categorize employee performance, but we use it as a measure akin to quantiles

, CASE
	WHEN [SalesKPI] >= 100.00 THEN 'Exceeded goal'
	WHEN [SalesKPI] > 90.00 THEN '90% of goal'
	WHEN [SalesKPI] > 80.00 THEN '80% of goal'
	WHEN [SalesKPI] >= 70.00 THEN '70% of goal'
	WHEN [SalesKPI] < 70.00 THEN 'Reassignment candidate'
	END AS [PerfToGoal] 

FROM [dbo].[SalesRepPerformancetoQuota]
END