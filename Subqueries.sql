--Date: Jan 16,2018
--Project Name: Subqueries
--Author: Olga Lazarenko
--Description: the purpose of the project is to create create nested queries,
			--( the outer query and the subquery); 
			-- create differenct type of the subqueries: seft-contained and correlated, 
			--scalar or multi-valued

USE AdventureWorks2012 ; 
GO 

-- Self-contained subqueries (can be run independently from the outer query)

--#1
-- Get first and last name of employees with the pay rate > 20 
SELECT BusinessEntityID AS EmplyeeID
	, FirstName
	, LastName
FROM AdventureWorks2012.Person.Person 
WHERE BusinessEntityID IN
	(
	SELECT BusinessEntityID AS EmployeeID --this subquery/inner query has no dependency on the outer query
	FROM AdventureWorks2012.HumanResources.EmployeePayHistory 
	WHERE Rate > 20  -- this subquery is multi-valued, it returns multiple values
	) ; 
-- returned 79 rows


-- ****************************************************************************************************************
-- Subquery can be placed in the lines of the following causes: SELECT, FROM, WHERE
--#2. Subquery at  SELECT line

 SELECT ProductID	
	, Name AS 'ProductName'
	, ProductNumber
	, ListPrice
	, ( StandardCost -
	  (SELECT AVG(StandardCost)
	  FROM AdventureWorks2012.Production.Product ) ) -- the inner query is the subquery for the outer quiery
		AS StandardCostDifference                    -- it is a self-contained query that returns a scalar value
FROM AdventureWorks2012.Production.Product ;


--#3. Subquery at SELECT clause line

SELECT TerritoryID
	, Name AS 'TerritoryName'
	, CountryRegionCode AS 'CountryCode'
	, (SalesYTD - 
				( SELECT AVG(SalesYTD) -- this is the inner self-contained subquery, returns the single value
					FROM AdventureWorks2012.Sales.SalesTerritory)) AS 'SalesDiffernce'
FROM AdventureWorks2012.Sales.SalesTerritory ; 



--************************************************************************************************************
-

 