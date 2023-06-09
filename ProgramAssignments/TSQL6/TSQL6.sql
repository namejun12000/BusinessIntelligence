USE [Featherman_Analytics];

DROP TABLE [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria1]
DROP TABLE [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria2]
DROP TABLE [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria3]
DROP TABLE [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria4]
DROP TABLE [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria5]
DROP TABLE [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria6]
DROP TABLE [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria7]

-- Create main array
DECLARE @MainTable TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [# Small Biz] DECIMAL
, [% Emp by Small Biz] DECIMAL(20,2), [Med Income Emp Incorporated] DECIMAL (20,2), [Med Income Emp UNIcorporated] DECIMAL(20,2)
, [# New Biz] DECIMAL, [# New Job for Biz] DECIMAL, [% Exporters Small Biz] DECIMAL (20,2)
, [GDP Growth] DECIMAL(20,2), [Unemployment Rate] DECIMAL(20,2), [% Manufacturing Emp Small Biz] DECIMAL(20,2)
, [% Prof Service Emp Small Biz] DECIMAL(20,2), [% Mining Emp Small Biz] DECIMAL(20,2)
, [Med Income] DECIMAL(20,2), [% Pop Poverty] DECIMAL(20,2)
, [# Breweries] DECIMAL, [# Wineries] DECIMAL
, [% Completed HS] DECIMAL(20,2)
, [# Poverty] DECIMAL(20,2), [% Poverty] DECIMAL(20,2), [Med Household Income] DECIMAL(20,2)
, [Pop 1990] DECIMAL(20,2), [Pop 2000] DECIMAL(20,2), [Pop 2010] DECIMAL(20,2), [Pop 2018] DECIMAL(20,2), [PopChange] DECIMAL(20,2)
, [% White] DECIMAL(5,2), [% Black] DECIMAL(5,2), [% Native American] DECIMAL(5,2), [% Asian] DECIMAL(5,2), [% Hispanic] DECIMAL(5,2)
, [State Population] DECIMAL(20,2), [# Retirees] DECIMAL, [# Disabled Workers] DECIMAL
, [# Over 65 Female] DECIMAL, [# Over 65 Male] DECIMAL)

-- Create each array for 8 tables
DECLARE @SimBusiness TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [# Small Biz] DECIMAL(20,2)
, [% Emp by Small Biz] DECIMAL(20,2), [Med Income Emp Incorporated] DECIMAL (20,2), [Med Income Emp UNIcorporated] DECIMAL(20,2)
, [# New Biz] DECIMAL(20,2), [# New Job for Biz] DECIMAL(20,2), [% Exporters Small Biz] DECIMAL (20,2)
, [GDP Growth] DECIMAL(20,2), [Unemployment Rate] DECIMAL(20,2), [% Manufacturing Emp Small Biz] DECIMAL(20,2)
, [% Prof Service Emp Small Biz] DECIMAL(20,2), [% Mining Emp Small Biz] DECIMAL(20,2))

DECLARE @IncomeDeomographics TABLE ([State] NVARCHAR(2), [Med Income] DECIMAL(20,2), [% Pop Poverty] DECIMAL(20,2))

DECLARE @BreweriesWineries TABLE ([State] NVARCHAR(2), [# Breweries] DECIMAL(20,2), [# Wineries] DECIMAL(20,2))

DECLARE @CompletedHighSchool TABLE ([State] NVARCHAR(2), [% Completed HS] DECIMAL(20,2))

DECLARE @PovertyMedIncome TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [# Poverty] DECIMAL(20,2)
, [% Poverty] DECIMAL(20,2), [Med Household Income] DECIMAL(20,2))

DECLARE @PopulationChange TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [Pop 1990] DECIMAL(20,2), [Pop 2000] DECIMAL(20,2)
, [Pop 2010] DECIMAL(20,2), [Pop 2018] DECIMAL(20,2), [PopChange] DECIMAL(20,2))

DECLARE @Race TABLE ([State] NVARCHAR(2), [% White] DECIMAL(5,2), [% Black] DECIMAL(5,2), [% Native American] DECIMAL(5,2)
, [% Asian] DECIMAL(5,2), [% Hispanic] DECIMAL(5,2))

DECLARE @PopRetirees TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [State Pop] DECIMAL(20,2), [# Retirees] DECIMAL(20,2)
, [# Disabled Workers] DECIMAL(20,2), [# Over 65 Female] DECIMAL(20,2), [# Over 65 Male] DECIMAL(20,2))

-- Insert the data into each array
INSERT INTO @SimBusiness ([State], [State Name], [# Small Biz]
, [% Emp by Small Biz], [Med Income Emp Incorporated], [Med Income Emp UNIcorporated]
, [# New Biz], [# New Job for Biz], [% Exporters Small Biz]
, [GDP Growth], [Unemployment Rate], [% Manufacturing Emp Small Biz]
, [% Prof Service Emp Small Biz], [% Mining Emp Small Biz])
SELECT
[State], [StateName], [NumSmallBiz], [PercentEmpbySmBiz], [MedIncomeSelfEmplINcorBiz], [MedIncomeSelfEmplUnIncorpBiz]
,[NumNewBiz2018], [NumNewJobsFromNewBiz2018], [PctOfExportersThatAreSmBiz], [StateGDPGrowth], [StateUnemploymentRate]
, [PctMfrEmpFromSmBiz], ISNULL([PctProfessionalSvcEmpfromSMBiz],0), ISNULL([PctMiningEmpfromSMBiz],0)
FROM [featherman].[ArraysHW_SmBizData2018]

INSERT INTO @IncomeDeomographics ([State],[Med Income],[% Pop Poverty])
SELECT [State], [MedianIncome], [%PopInPoverty]
FROM [featherman].[ArraysHW_IncomeDemographics]

INSERT INTO @BreweriesWineries ([State], [# Breweries], [# Wineries])
SELECT [State], [NumBreweries], [NumWineries]
FROM [featherman].[ArraysHW_NumBreweriesWineriesByState]

INSERT INTO @CompletedHighSchool ([State], [% Completed HS])
SELECT [State], FORMAT(AVG(ISNULL(PercentCompletedHS,0)), 'N2') --condense the data down to state level
FROM [featherman].[ArraysHW_PctOver25GradHS]
GROUP BY State

INSERT INTO @PovertyMedIncome ([State], [State Name], [# Poverty], [% Poverty], [Med Household Income])
SELECT [State], [StateName], [Poverty#], [Poverty%], [MedHHIncome]
FROM [featherman].[ArraysHW_PovertyData_AndMedianIncome2016]

INSERT INTO @PopulationChange ([State],[State Name],[Pop 1990],[Pop 2000],[Pop 2010],[Pop 2018],[PopChange])
SELECT [State],[StateName], [Pop1990], [Pop2000], [Pop2010], [Pop2018], [PopChange2010-18]
FROM [featherman].[ArraysHW_PopulationChange]

INSERT INTO @Race ([State],[% White],[% Black],[% Native American],[% Asian],[% Hispanic])
SELECT [State] --condense the data down to state level
, AVG(ISNULL([%white],0)), AVG(ISNULL([%black],0)), AVG(ISNULL([%native_american],0))
, AVG(ISNULL([%asian],0)), AVG(ISNULL([%hispanic],0))
FROM [featherman].[ArraysHW_ShareRaceByCity]
GROUP BY [State]

INSERT INTO @PopRetirees ([State], [State Name],[State Pop],[# Retirees],[# Disabled Workers],[# Over 65 Female],[# Over 65 Male])
SELECT [State], [StateName], [Population], [#Retirees], [#DisabledWorkers], [Over65Fem], [Over65Men]
FROM [featherman].[ArraysHW_StatePopandRetirees]

-- insert into all data (8 arrays) into main array
INSERT INTO @MainTable ([State], [State Name], [# Small Biz]
, [% Emp by Small Biz], [Med Income Emp Incorporated], [Med Income Emp UNIcorporated]
, [# New Biz], [# New Job for Biz], [% Exporters Small Biz]
, [GDP Growth], [Unemployment Rate], [% Manufacturing Emp Small Biz]
, [% Prof Service Emp Small Biz], [% Mining Emp Small Biz]
, [Med Income],[% Pop Poverty]
, [# Breweries], [# Wineries]
, [% Completed HS]
, [# Poverty], [% Poverty], [Med Household Income]
, [Pop 1990], [Pop 2000], [Pop 2010], [Pop 2018], [PopChange]
, [% White], [% Black], [% Native American], [% Asian], [% Hispanic]
, [State Population], [# Retirees], [# Disabled Workers], [# Over 65 Female], [# Over 65 Male])
SELECT sb.[State], sb.[State Name], [# Small Biz]
, [% Emp by Small Biz], [Med Income Emp Incorporated], [Med Income Emp UNIcorporated]
, [# New Biz], [# New Job for Biz], [% Exporters Small Biz]
, [GDP Growth], [Unemployment Rate], [% Manufacturing Emp Small Biz]
, [% Prof Service Emp Small Biz], [% Mining Emp Small Biz]
, [Med Income],[% Pop Poverty]
, [# Breweries], [# Wineries]
, [% Completed HS]
, [# Poverty], [% Poverty], [Med Household Income]
, [Pop 1990], [Pop 2000], [Pop 2010], [Pop 2018], [PopChange]
, [% White], [% Black], [% Native American], [% Asian], [% Hispanic]
, [State Pop], [# Retirees], [# Disabled Workers], [# Over 65 Female], [# Over 65 Male]
FROM @SimBusiness as sb 
INNER JOIN @IncomeDeomographics as idg ON sb.[State] = idg.[State]
INNER JOIN @BreweriesWineries as bw ON sb.[State] = bw.[State]
INNER JOIN @CompletedHighSchool as chs ON sb.[State] = chs.[State]
INNER JOIN @PovertyMedIncome as pmi ON sb.[State] = pmi.[State]
INNER JOIN @PopulationChange as pc ON sb.[State] = pc.[State]
INNER JOIN @Race as race ON sb.[State] = race.[State]
INNER JOIN @PopRetirees as pr ON sb.[State] = pr.[State]

-- Decision Criteria 1

-- create array
DECLARE @DecisionCriteria1 TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [Pop 1990] DECIMAL, [Pop 2000] DECIMAL, [Pop 2010] DECIMAL, [Pop 2018] DECIMAL, [Pop Change] DECIMAL(5,2), [Median Income] DECIMAL, [Pop Change Group] NVARCHAR(50), [Median Income Label] NVARCHAR(50))

-- insert the data
INSERT INTO @DecisionCriteria1 ([State], [State Name], [Pop 1990], [Pop 2000], [Pop 2010], [Pop 2018], [Pop Change],[Median Income])
SELECT [State], [State Name], [Pop 1990], [Pop 2000], [Pop 2010], [Pop 2018], [PopChange], [Med Income]
FROM @MainTable

-- build new column
UPDATE @DecisionCriteria1 SET [Pop Change Group]
= (SELECT CASE 
	WHEN [Pop Change] >= 0.10 THEN 'Fast Increase'
	WHEN [Pop Change] BETWEEN 0.05 AND 0.099 THEN 'Moderate Increase'
	WHEN [Pop Change] BETWEEN 0.01 AND 0.049 THEN 'Slow Increase'
	WHEN [Pop Change] = 0.00 THEN 'Stagnant'
	WHEN [Pop Change] < 0.00 THEN 'Decrease'
	END)

UPDATE @DecisionCriteria1 SET [Median Income Label]
= (SELECT CASE
	WHEN [Median Income] >= 70000 THEN 'High'
	WHEN [Median Income] BETWEEN 50000 AND 69999 THEN 'Medium'
	WHEN [Median Income] < 50000 THEN 'Low'
	END)

-- save the array to my database
SELECT * INTO [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria1] 
FROM @DecisionCriteria1

-- Decision Criteria2

-- create array
DECLARE @DecisionCriteria2 TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [# Poverty] DECIMAL, [% Poverty] DECIMAL(5,2), [Med Household Income] DECIMAL(20,2), [% High School Graduate] DECIMAL (5,2), [Unemployment Rate] DECIMAL (5,2), [% Not Poverty] DECIMAL (5,2), [Poverty Level] NVARCHAR(50)
, [Unemployment Label] NVARCHAR(50), [Graduated High School Label] NVARCHAR(50))

-- insert the data
INSERT INTO @DecisionCriteria2 ([State], [State Name], [# Poverty], [% Poverty], [Med Household Income], [% High School Graduate], [Unemployment Rate])
SELECT [State], [State Name], [# Poverty], [% Poverty], [Med Household Income], [% Completed HS], [Unemployment Rate]
FROM @MainTable

DECLARE @TotalPercent as DECIMAL = 100 -- set total percent into array

-- build new columns
UPDATE @DecisionCriteria2 SET [% Not Poverty]
= (SELECT (@TotalPercent - [% Poverty]))

UPDATE @DecisionCriteria2 SET [Poverty Level]
= (SELECT CASE
	WHEN [% Poverty] >= 20.00 THEN 'Level 4'
	WHEN [% Poverty] BETWEEN 15.00 AND 19.99 THEN 'Level 3'
	WHEN [% Poverty] BETWEEN 10.00 AND 14.99 THEN 'Level 2'
	WHEN [% Poverty] < 10.00 THEN 'Level 1'
	END)

UPDATE @DecisionCriteria2 SET [Unemployment Label]
= (SELECT CASE
	WHEN [Unemployment Rate] >= 0.05 THEN 'High'
	WHEN [Unemployment Rate] BETWEEN 0.03 AND 0.049 THEN 'Medium'
	WHEN [Unemployment Rate] < 0.03 THEN 'Low'
	END )

UPDATE @DecisionCriteria2 SET [Graduated High School Label]
= (SELECT CASE 
	WHEN [% High School Graduate] BETWEEN 90.00 AND 100 THEN 'High'
	WHEN [% High School Graduate] BETWEEN 80.00 AND 89.99 THEN 'Average'
	WHEN [% High School Graduate] BETWEEN 70.00 AND 79.99 THEN 'Low'
	END )

-- save the array to my database
SELECT * INTO [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria2] 
FROM @DecisionCriteria2

-- Decision Criteria3

-- create array
DECLARE @DecisionCriteria3 TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [State Population] DECIMAL, [# Retirees] DECIMAL, [# Over 65 Female] DECIMAL, [# Over 65 Male] DECIMAL, [# Total Over 65] DECIMAL, [% Total Over 65] DECIMAL(5,2), [% Retirees] DECIMAL(5,2), [Retirees Label] NVARCHAR(50), [Over 65 Label] NVARCHAR(50))

-- insert the data
INSERT INTO @DecisionCriteria3 ([State], [State Name], [State Population], [# Retirees], [# Over 65 Female], [# Over 65 Male])
SELECT [State], [State Name], [State Population], [# Retirees],  [# Over 65 Female], [# Over 65 Male]
FROM @MainTable

-- build new columns
UPDATE @DecisionCriteria3 SET [# Total Over 65]
= (SELECT [# Over 65 Female] + [# Over 65 Male]) 

UPDATE @DecisionCriteria3 SET [% Total Over 65]
= (SELECT [# Total Over 65] / [State Population])

UPDATE @DecisionCriteria3 SET [% Retirees]
= (SELECT [# Retirees] / [State Population])

UPDATE @DecisionCriteria3 SET [Retirees Label]
= (SELECT CASE
	WHEN [% Retirees] >= 0.70 THEN 'Very large distribution'
	WHEN [% Retirees] BETWEEN 0.65 AND 0.69 THEN 'Large distribution'
	WHEN [% Retirees] BETWEEN 0.60 AND 0.64 THEN 'Normal distribution'
	WHEN [% Retirees] < 0.60 THEN 'Less distribution'
	END)

UPDATE @DecisionCriteria3 SET [Over 65 Label]
= (SELECT CASE
	WHEN [% Total Over 65] >= 0.70 THEN 'Over 70 %'
	WHEN [% Total Over 65] BETWEEN 0.65 AND 0.69 THEN '65 ~ 69.9 %'
	WHEN [% Total Over 65] < 0.65 THEN 'Less 65 %'
	END)

-- save the array to my database
SELECT * INTO [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria3] 
FROM @DecisionCriteria3

-- Decision Criteria4

-- create array
DECLARE @DecisionCriteria4 TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [# New Biz] DECIMAL, [# New Job Biz] DECIMAL, [GDP Growth] DECIMAL(20,2), [GDP Group] NVARCHAR(50), [New Job Level] NVARCHAR(50))

-- insert the data
INSERT INTO @DecisionCriteria4 ([State], [State Name], [# New Biz], [# New Job Biz], [GDP Growth])
SELECT [State], [State Name], [# New Biz], [# New Job for Biz], [GDP Growth]
FROM @MainTable

-- build new columns
UPDATE @DecisionCriteria4 SET [GDP Group]
= (SELECT CASE
	WHEN [GDP Growth] >= 0.05 THEN 'Fast'
	WHEN [GDP Growth] BETWEEN 0.03 AND 0.049 THEN 'Moderate'
	WHEN [GDP Growth] BETWEEN 0.01 AND 0.029 THEN 'Slow'
	WHEN [GDP Growth] < 0.01 THEN 'Stagnant'
	END)

UPDATE @DecisionCriteria4 SET [New Job Level]
= (SELECT CASE 
	WHEN [# New Job Biz] >= 50000 THEN 'Excellent'
	WHEN [# New Job Biz] BETWEEN 30000 AND 49999 THEN 'Great'
	WHEN [# New Job Biz] BETWEEN 10000 AND 29999 THEN 'Normal'
	WHEN [# New Job Biz] < 10000 THEN 'Poor'
	END) 

-- save the array to my database
SELECT * INTO [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria4] 
FROM @DecisionCriteria4

-- Decision Criteria 5

-- create array
DECLARE @DecisionCriteria5 TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [# Small Biz] DECIMAL, [% Emp by Small Biz] DECIMAL(5,2), [% Manufacturing Emp] DECIMAL(5,2) , [% Prof Service Emp] DECIMAL(5,2), [% Mining Emp] DECIMAL(5,2), [GDP Growth] DECIMAL(5,2), [# Business Level] NVARCHAR(50), [GDP Group] NVARCHAR(50))

-- insert the data
INSERT INTO @DecisionCriteria5 ([State], [State Name], [# Small Biz], [% Emp by Small Biz], [% Manufacturing Emp], [% Prof Service Emp], [% Mining Emp], [GDP Growth])
SELECT [State], [State Name], [# Small Biz], [% Emp by Small Biz], [% Manufacturing Emp Small Biz], [% Prof Service Emp Small Biz], [% Mining Emp Small Biz], [GDP Growth]
FROM @MainTable

-- build new columns
UPDATE @DecisionCriteria5 SET [GDP Group]
= (SELECT CASE
	WHEN [GDP Growth] >= 0.05 THEN 'Fast'
	WHEN [GDP Growth] BETWEEN 0.03 AND 0.049 THEN 'Moderate'
	WHEN [GDP Growth] BETWEEN 0.01 AND 0.029 THEN 'Slow'
	WHEN [GDP Growth] < 0.01 THEN 'Stagnant'
	END)

UPDATE @DecisionCriteria5 SET [# Business Level]
= (SELECT CASE
	WHEN [# Small Biz] >= 1000000 THEN 'More or equal than 1000K'
	WHEN [# Small Biz] BETWEEN 500000 AND 999999 THEN 'Between 500K and 999K'
	WHEN [# Small Biz] BETWEEN 100000 AND 499999 THEN 'Between 100K and 499K'
	WHEN [# Small Biz] BETWEEN 50000 AND 99999 THEN 'Between 50K and 99K'
	WHEN [# Small Biz] < 50000 THEN 'Less than 50K'
	END)

-- save the array to my database
SELECT * INTO [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria5] 
FROM @DecisionCriteria5

-- Decision Criteria 6

-- create array
DECLARE @DecisionCriteria6 TABLE ([State] NVARCHAR(2), [State Name] NVARCHAR(50), [# Breweries] DECIMAL, [# Wineries] DECIMAL, [Med Income] DECIMAL, [Total BrewWine] DECIMAL, [BrewWine Group] NVARCHAR(50), [Med Income Group] NVARCHAR(50))

-- insert the data
INSERT INTO @DecisionCriteria6 ([State], [State Name], [# Breweries], [# Wineries], [Med Income])
SELECT [State], [State Name], [# Breweries], [# Wineries], [Med Income]
FROM @MainTable

-- build new columns
UPDATE @DecisionCriteria6 SET [Total BrewWine]
= (SELECT [# Breweries] + [# Wineries])

UPDATE @DecisionCriteria6 SET [BrewWine Group]
= (SELECT CASE
	WHEN [Total BrewWine] >= 1000 THEN 'More or equal than 1000'
	WHEN [Total BrewWine] BETWEEN 500 AND 999 THEN 'Between 500 and 999'
	WHEN [Total BrewWine] BETWEEN 100 AND 499 THEN 'Between 100 and 499'
	WHEN [Total BrewWine] < 100 Then 'Less than 100'
	END)

UPDATE @DecisionCriteria6 SET [Med Income Group]
= (SELECT CASE
	WHEN [Med Income] > 60000 THEN 'High'
	WHEN [Med Income] BETWEEN 40000 AND 60000 THEN 'Medium'
	WHEN [Med Income] < 40000 THEN 'Low'
	END)

-- save the array to my database
SELECT * INTO [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria6] 
FROM @DecisionCriteria6

-- Decision Criteria 7

-- create array
DECLARE @DecisionCriteria7 TABLE([State] NVARCHAR(2), [State Name] NVARCHAR(50), [# New Job Biz] DECIMAL, [% White] DECIMAL(5,2), [% Black] DECIMAL(5,2), [% Native American] DECIMAL(5,2), [% Asian] DECIMAL(5,2), [% Hispanic] DECIMAL(5,2), [Asian Group] NVARCHAR(50), [New Job Group] NVARCHAR(50))

-- insert the data
INSERT INTO @DecisionCriteria7 ([State], [State Name], [# New Job Biz], [% White], [% Black], [% Native American], [% Asian], [% Hispanic])
SELECT [State], [State Name], [# New Job for Biz], [% White], [% Black], [% Native American], [% Asian], [% Hispanic]
FROM @MainTable

-- build new columns
UPDATE @DecisionCriteria7 SET [New Job Group]
= (SELECT CASE 
	WHEN [# New Job Biz] >= 50000 THEN 'More or equal than 50000'
	WHEN [# New Job Biz] BETWEEN 30000 AND 49999 THEN 'Between 30000 and 49999'
	WHEN [# New Job Biz] BETWEEN 10000 AND 29999 THEN 'Between 10000 and 29999'
	WHEN [# New Job Biz] < 10000 THEN 'Less than 10000'
	END) 

UPDATE @DecisionCriteria7 SET [Asian Group]
= (SELECT CASE
	WHEN [% Asian] >= 10.00 THEN 'More or equal than 10 %'
	WHEN [% Asian] BETWEEN 5.00 AND 9.99 THEN '5 % ~ 9.9 %'
	WHEN [% Asian] BETWEEN 1.00 AND 4.99 THEN '1 % ~ 4.9 %'
	WHEN [% Asian] < 1.00 THEN 'Less than 1 %'
	END)

-- save the array to my database
SELECT * INTO [MF31namjun.lee].[dbo].[TSQL6_DecisionCriteria7] 
FROM @DecisionCriteria7

SELECT * FROM @DecisionCriteria3
