/*
Date: June 5, 2018
Project Name: Queries with the OVER clause
Author: Olga Lazarenko
Description: the purpose of this project is to create queries containing the OVER clause,
			which will determine the partitioning  and the ordering a rowset, defining 
			a window to which a window function will apply.
			The OVER clause will be used with:
			1) Ranking functions (ROW_NUMBER, RANK, DENSE_RANK, NTILE)
			2) Aggregate functions(AVG, COUNT, MIN, MAX, etc.)
			3) Analystic functions (LAG, LEAD, FIRST_VALUE, LAST_VALUE)

*/

USE AdventureWorks2012 ; 
GO

-- 1) The OVER clause with the ranking functions

-- 1.1) The OVER clause with ROW_NUMBER function

SELECT 
	[Name] AS TerritoryName
	, CountryRegionCode AS RegionCode
	, [Group] AS CountryGroup
	, SalesYTD
	, ROW_NUMBER() OVER (ORDER BY [Name]) AS RowNumber
FROM Sales.SalesTerritory ;


SELECT 
	[Name] AS TerritoryName
	, CountryRegionCode AS RegionCode
	, [Group] AS CountryGroup
	, SalesYTD
	, ROW_NUMBER() OVER (PARTITION BY CountryRegionCode  ORDER BY [Name]) AS RowNumber
FROM Sales.SalesTerritory ;

-- 1.2) the OVER clause with RANK function
/* the following query will calculate how many orders were completed at each mounth of 2006 and 2007 year
 and ranking them at the descending order 
 because the PARTITION BY clause is not used at the OVER clause, 
 the rowset result is considered as one block to which the RANK() function will apply
 */
SELECT 
	YEAR(EndDate) AS OrderYear
	, MONTH(EndDate) AS OrderMonth
	, SUM(OrderQty) AS OrderQty
	, RANK() OVER (ORDER BY SUM(OrderQty) DESC) AS OrderQtyRank
FROM Production.WorkOrder 
GROUP BY YEAR(EndDate), MONTH(EndDate)
HAVING  YEAR(EndDate) IN (2007,2006)
ORDER BY OrderQtyRank ;
 
 /* the above query is modified by using the PARTITION BY clause, 
 which partition/divide the rowset result of the query into parts/groups
 and RANK() function will apply to each of them.
 */
 SELECT 
	YEAR(EndDate) AS OrderYear
	, MONTH(EndDate) AS OrderMonth
	, SUM(OrderQty) AS OrderQty
	, RANK() OVER (PARTITION BY YEAR(EndDate) ORDER BY SUM(OrderQty) DESC) AS OrderQtyRank
FROM Production.WorkOrder 
GROUP BY YEAR(EndDate), MONTH(EndDate)
HAVING  YEAR(EndDate) IN (2007,2006)
ORDER BY OrderYear, OrderMonth ;


--********************************************************************************************************
-- 2) the OVER clause with the aggregate functions

-- 2.1) the OVER clause with COUNT() aggregate function
SELECT
	DISTINCT YEAR(TransactionDate) AS [Year]
	, COUNT(TransactionID)  OVER ( PARTITION BY YEAR(TransactionDate)) AS Transactions
	--calculate total number of the transactions for each year
FROM Production.TransactionHistory ; 