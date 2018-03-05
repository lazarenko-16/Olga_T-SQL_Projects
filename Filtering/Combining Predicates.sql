-- Date Started: Dec 29,2017
-- Project Name: Combining Predicates (at Filtering)
-- Author: Olga Lazarenko
-- Description: create queries with multiple predicates to filter data

USE AdventureWorks2012 ; -- call AdventureWorks2012 DB
GO


SELECT SalesOrderID
	, CarrierTrackingNumber --nvarchar, null
	, OrderQty
	, UnitPrice --money
	, LineTotal -- numeric
	, ModifiedDate --datetime
FROM Sales.SalesOrderDetail ;

SELECT SalesOrderID
	, CarrierTrackingNumber --nvarchar, null
	, OrderQty
	, UnitPrice --money
	, LineTotal -- numeric
	, CAST((ModifiedDate) AS date) As Modified_Date -- cast to date data type YYYY-MM-DD 2005-2008
FROM Sales.SalesOrderDetail ;


SELECT MIN(OrderQty) AS MinOrder
	, MAX(OrderQty) AS MaxOrder
	, MIN(UnitPrice) AS MinPrice
	, MAX(UnitPrice) AS MaxPrice
	, MIN(LineTotal) AS MinTotal
	, MAX(LineTotal) As MaxTotal
FROM Sales.SalesOrderDetail ;


SELECT SalesOrderID
	, CarrierTrackingNumber --nvarchar, null
	, OrderQty
	, UnitPrice --money
	, LineTotal -- numeric
	, CAST((ModifiedDate) AS date) As Modified_Date -- cast to date data type YYYY-MM-DD 2005-2008
FROM Sales.SalesOrderDetail
WHERE  OrderQty > 20 AND YEAR(CAST((ModifiedDate) AS date)) = 2005 
	OR  YEAR(CAST((ModifiedDate) AS date)) = 2006  ; 
/* 19357 rows are returned
 First will be evaluated AND, 
 after this OR , for Year = 2006 any OrderQty is retrieved,
  OrderQty > 20 doesn't apply for YEAR = 2006
  */

  SELECT SalesOrderID
	, CarrierTrackingNumber --nvarchar, null
	, OrderQty
	, UnitPrice --money
	, LineTotal -- numeric
	, CAST((ModifiedDate) AS date) As Modified_Date -- cast to date data type YYYY-MM-DD 2005-2008
FROM Sales.SalesOrderDetail
WHERE  OrderQty > 20 AND (YEAR(CAST((ModifiedDate) AS date)) = 2005 
	OR  YEAR(CAST((ModifiedDate) AS date)) = 2006 ) ; 

/* 38 rows are retrieved
The parenthesis have the highest precedence
rows with OrderQty > 20 for both years 2005 and 2006 will be selected 
*/

--***************************************************************
/* the query is supposed to return the names of the customers with 
last name starts with A or K or P ; the records ordered by LastName in descending order 
*/
SELECT 
	DISTINCT( LastName + ' ' + FirstName) AS FullName
FROM AdventureWorks2012.Person.Person 
WHERE LastName LIKE 'A%' OR LastName LIKE 'K%' OR LastName Like 'P%' 
ORDER BY FullName DESC ; 


/*the query returns the names of the customers with 
last name starts with A or K or P  and these customers should 
have the first name starts with M or J; 
To retrieve the correct records the parentheses are used 
to separate multiple predicates/conditions to obtain the desired result.
The records are organized by the last name.
*/
SELECT 
	DISTINCT( LastName + ' ' + FirstName) AS FullName
FROM AdventureWorks2012.Person.Person 
WHERE (LastName LIKE 'A%' OR LastName LIKE 'K%' OR LastName Like 'P%')
	  AND 
	  ( FirstName LIKE 'M%' OR FirstName LIKE 'J%')
ORDER BY FullName  ; 

