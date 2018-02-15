/*	Date: Feb 14,2018
	Project Name: Common Table Expressions (CTEs)
	Author: Olga Lazarenko
	Descriprion: practice in creating CTEs
				The benefits of using CTEs:
				-> breakdown complex queries
				-> avoid subqueries
				-> simplify syntax
*/

USE AdventureWorks2012 ; -- call the database
GO 


--Ex.1
-- calculate the total sales  and number of customers by territories and order it in desc way
SELECT 
	T.TerritoryID AS TerritoryID
	, T.Name AS TerritoryName
	, SUM(SalesYTD) AS TotalSales
	, COUNT(C.CustomerID) AS NumCustomers
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN 
	AdventureWorks2012.Sales.SalesTerritory AS T
	ON C.TerritoryID = T.TerritoryID 
GROUP BY 
	T.TerritoryID
	, T.Name
ORDER BY 
	TotalSales DESC ; 
-- returned 10 rows


--the above query can we writen as CTE  ***************************************************

WITH SalesTerritory 
	(TerritoryID, TerritoryName, TotalSales, NumCustomers )
AS 
(
 
	SELECT 
	T.TerritoryID AS TerritoryID
	, T.Name AS TerritoryName
	, SUM(SalesYTD) AS TotalSales
	, COUNT(C.CustomerID) AS NumCustomers
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN 
	AdventureWorks2012.Sales.SalesTerritory AS T
	ON C.TerritoryID = T.TerritoryID 
GROUP BY 
	T.TerritoryID
	, T.Name
)
SELECT --* 
TerritoryName
, TotalSales
FROM SalesTerritory 
WHERE TotalSales > 3000000000
 --at CTE we can use where to filter aggregations, 
 --at the above query we have to use HAVING because of GROUP BY clause
ORDER BY TotalSales DESC ;


--**************************************************************************************************