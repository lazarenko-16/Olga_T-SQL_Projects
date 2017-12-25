-- Aggregations
USE AdventureWorks2012 ;

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