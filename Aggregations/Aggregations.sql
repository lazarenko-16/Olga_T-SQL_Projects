
-- Date: Dec 24, 2017
-- Project Name: Aggregations at T-SQL
-- Author: Olga Lazarenko
-- Description: at this home lab project I create queries with aggrgation functions at T-SQL

USE AdventureWorks2012 ; -- call AdventureWorks2012

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