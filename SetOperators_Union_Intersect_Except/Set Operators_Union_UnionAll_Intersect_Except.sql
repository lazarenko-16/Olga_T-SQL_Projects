/*Date: Jan 22, 2018
  Project Name:  Using Set Operators (UNION, UNION ALL, INTERSECT, EXCEPT)
  Author: Olga Lazarenko
  Description: the purpose of the project is to create queries
				operating with set operators */

USE AdventureWorks2012 ; -- call AdventureWorks2012 DB
GO 


-- UNION/ UNION ALL  set operators **********

/* #1. Two result sets of queries from tables Sales.Customer and Sales.SalesOrderHeader will be combined
		using set operator UNION to unify the results of the two input queries
		and return only distinct rows ( duplicate rows are not returned) 
*/
SELECT CustomerID
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.Customer  --this query if runs by itselt, returns 19820 rows
	UNION
SELECT CustomerID -- this query if runs independently, returns 31465 rows
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.SalesOrderHeader ; 
-- the whole query (with the  set operator UNION) returns 38939 rows ( eliminated duplicate rows)



-- UNION ALL set operator    **************

/* #2. Two result sets of queries from tables Sales.Customer and Sales.SalesOrderHeader will be combined
		using set operator UNION ALL  to return all rows (including duplicate rows)
*/
SELECT CustomerID
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.Customer  --this query if runs by itselt, returns 19820 rows
	UNION ALL 
SELECT CustomerID -- this query if runs independently, returns 31465 rows
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.SalesOrderHeader ; 
-- 51285 rows are retuned

--#3. ORDER BY clause is not allowed in the individual queries
SELECT CustomerID
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.Customer  --this query if runs by itselt, returns 19820 rows
ORDER BY CustomerID
	UNION
SELECT CustomerID -- this query if runs independently, returns 31465 rows
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.SalesOrderHeader ;
-- the query fails: Incorrect syntax near the keyword 'UNION'

--#4. ORDER BY clause can be used for the result of the whole query 
SELECT CustomerID
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.Customer  --this query if runs by itselt, returns 19820 rows
--ORDER BY CustomerID
	UNION
SELECT CustomerID -- this query if runs independently, returnes 31465 rows
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.SalesOrderHeader 
ORDER BY CustomerID ;
-- in this case ORDER BY clause applyes to the result of the set operator UNION and the query runs successfully 




-- INTERSECT set operator ***********

--#5.  to return only distinct rows that are common to both sets
SELECT CustomerID
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.Customer  --this query if runs by itselt, returns 19820 rows
	INTERSECT
SELECT CustomerID -- this query if runs independently, returns 31465 rows
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.SalesOrderHeader ;


--EXCEPT set operator ***************
-- to retrieve distinct rows that appear in the first quiry but not in the first
--#6.
SELECT CustomerID
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.Customer  --this query if runs by itselt, returns 19820 rows
	EXCEPT
SELECT CustomerID -- this query if runs independently, returns 31465 rows
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.SalesOrderHeader ;
--19820 rows are returned


-- EXCEPT set operator, to return only distinct rows that are common to both sets
--#7.
SELECT CustomerID -- this query if runs independently, returns 31465 rows
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.SalesOrderHeader 
	EXCEPT
SELECT CustomerID
	, TerritoryID
	, AccountNumber
FROM AdventureWorks2012.Sales.Customer  ;--this query if runs by itselt, returns 19820 rows
--19119 rows are returned


--#8.
SELECT ProductID
	, StandardCost
	, ModifiedDate 
FROM AdventureWorks2012.Production.Product -- 504 rows
	UNION 
SELECT ProductID
	, StandardCost
	, ModifiedDate
FROM AdventureWorks2012.Production.ProductCostHistory ;  -- 395 rows 
-- 899 rows returned 

--#9.
SELECT ProductID
	, StandardCost
	, ModifiedDate 
FROM AdventureWorks2012.Production.Product -- 504 rows
	INTERSECT
SELECT ProductID
	, StandardCost
	, ModifiedDate
FROM AdventureWorks2012.Production.ProductCostHistory ;  -- 395 rows
-- 0 rows are returned 


--#10
SELECT ProductID
	, StandardCost
	, ModifiedDate 
FROM AdventureWorks2012.Production.Product -- 504 rows
	EXCEPT 
SELECT ProductID
	, StandardCost
	, ModifiedDate
FROM AdventureWorks2012.Production.ProductCostHistory ;  -- 395 rows
-- 504 rows are retrieved


--#11
SELECT ProductID
	, StandardCost
	, ModifiedDate
FROM AdventureWorks2012.Production.ProductCostHistory   -- 395 rows
	EXCEPT
SELECT ProductID
	, StandardCost
	, ModifiedDate 
FROM AdventureWorks2012.Production.Product -- 504 rows
-- 395 rows are returned ( the distinct rows from the first query that don't appar in the second query)

