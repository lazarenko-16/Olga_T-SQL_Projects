
-- Date: Dec 24, 2017
-- Project Name: Aggregations at T-SQL
-- Author: Olga Lazarenko
-- Description: at this home lab project I create queries with aggrgation functions at T-SQL
--              with MIN, MAX, COUNT, COUNT(*), AVG functions

USE AdventureWorks2012 ; -- call AdventureWorks2012
GO


SELECT TerritoryID
	, Bonus
	, SalesYTD as CurrentYearSales
	, SalesLastYear
FROM Sales.SalesPerson 
WHERE TerritoryID NOT LIKE 'NULL';


-- find the average bonuses by territory
SELECT TerritoryID
	, AVG(Bonus) AS AverageBonus
FROM Sales.SalesPerson 
GROUP BY TerritoryID
HAVING  TerritoryID NOT LIKE 'NULL';

SELECT TerritoryID
	, AVG(Bonus) AS AverageBonus
	, MAX(SalesYTD) AS  MaxSales
	--, SalesLastYear
FROM Sales.SalesPerson 
GROUP BY TerritoryID
HAVING TerritoryID NOT LIKE 'NULL' ;

 -- Aggregations about sales (TotalSales) at the territories
SELECT 
	 Name AS TerritoryName
	, SUM(SalesYTD) AS TotalSales
	, SUM(SalesLastYear) AS TotalSalesLastYear
	,( SUM(SalesYTD) -SUM( SalesLastYear))*100/SUM(SalesLastYear) AS PercentChange
	--, SUM(CostYTD) AS TotalCost
	--, SUM(CostLastYear) AS TotalCostLastYear
FROM Sales.SalesTerritory
GROUP BY Name 
ORDER BY TerritoryName ; 

SELECT 
	 Name AS TerritoryName
	, SUM(SalesYTD) AS TotalSales
	, SUM(SalesLastYear) AS TotalSalesLastYear
	,( SUM(SalesYTD) -SUM( SalesLastYear))*100/SUM(SalesLastYear) AS PercentChange
	--, SUM(CostYTD) AS TotalCost
	--, SUM(CostLastYear) AS TotalCostLastYear
FROM Sales.SalesTerritory
WHERE
	CASE
		WHEN ( SUM(SalesYTD) -SUM( SalesLastYear))> 0 THEN 'Gain'
		WHEN ( SUM(SalesYTD) -SUM( SalesLastYear)) < 0 THEN 'Loss'
		ELSE 'no changes'
	END = 'Changes'		
GROUP BY Name 
ORDER BY TerritoryName ; 


--************************************************************************************

SELECT COUNT(S.CountryRegionCode) AS Persons
	, S.CountryRegionCode AS 'CountryCode'
	, C.Name AS CountryName
FROM AdventureWorks2012.Person.StateProvince AS S
	INNER JOIN
	AdventureWorks2012.Person.CountryRegion AS C
	ON S.CountryRegionCode = C.CountryRegionCode
GROUP BY S.CountryRegionCode
	, C.Name
ORDER BY S.CountryRegionCode ; 
/*
the query gives us the number of persons/employees from each country
inner join is used to return the country's name, 
the data is groped by the country's code and name
we needed to group by C.Name , because it is mentioned at SELECT clause 
*/


SELECT TerritoryID -- retrieve the territory ID and name with the max sales
	, Name AS TerritoryName
	, SalesYTD AS Sales
	, 'MAX' AS Estimation
FROM AdventureWorks2012.Sales.SalesTerritory 
WHERE SalesYTD = (SELECT MAX(SalesYTD) 
		FROM AdventureWorks2012.Sales.SalesTerritory ) ; 

/* 
Now we will make the query more complicated, 
we want to have the territory with min sale
*/
SELECT TerritoryID -- retrieve the territory ID and name with the min sales
	, Name AS TerritoryName
	, SalesYTD AS Sales
	, 'MIN' AS Estimation
FROM AdventureWorks2012.Sales.SalesTerritory 
WHERE SalesYTD = (SELECT MIN(SalesYTD) 
		FROM AdventureWorks2012.Sales.SalesTerritory )  ;

-- and combine the results with UNION
SELECT TerritoryID -- retrieve the territory ID and name with the max sales
	, Name AS TerritoryName
	, SalesYTD AS Sales
	, 'MAX' AS Estimation
FROM AdventureWorks2012.Sales.SalesTerritory 
WHERE SalesYTD = (SELECT MAX(SalesYTD) 
		FROM AdventureWorks2012.Sales.SalesTerritory )
UNION
SELECT TerritoryID -- retrieve the territory ID and name with the max sales
	, Name AS TerritoryName
	, SalesYTD AS Sales
	, 'MIN' AS Estimation
FROM AdventureWorks2012.Sales.SalesTerritory 
WHERE SalesYTD = (SELECT MIN(SalesYTD) 
		FROM AdventureWorks2012.Sales.SalesTerritory ) 
ORDER BY Sales ; 

--*****************************************************************************
/* the query will use the aggregation functions MIN(), MAX(), AVG() to retrieve 
min, max and average vacation hours according job title/position */
SELECT 
	JobTitle
	, MIN(VacationHours) AS Min_Vacation
	, MAX(VacationHours) AS Max_Vacation
	--, AVG(VacationHours) AS Avg_Vacation 
FROM AdventureWorks2012.HumanResources.Employee 
GROUP BY JobTitle ; 


/* the query will use the aggregation function MAX() to get top 10 records with max SickLeaveHours */
SELECT TOP(10)
	JobTitle
	, MAX(SickLeaveHours) AS Max_SickHours -- aggregation function MAX() is used 
FROM AdventureWorks2012.HumanResources.Employee 
GROUP BY JobTitle 
ORDER BY Max_SickHours DESC ; --records will be ordered in descending way


-- we want to have the information how many stores each sales person works with
-- organized in descending way 
SELECT
	SalesPersonID	
	, COUNT(BusinessEntityID) AS Stores 
	-- cound the stores ID to find the number of the stores
FROM Sales.Store 
GROUP BY SalesPersonID -- grouping by the sales person ID
ORDER BY Stores DESC  ; 

