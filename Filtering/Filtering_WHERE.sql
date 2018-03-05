-- Date Started : Dec 28,2017
-- Project Name: Filtering using T-SQL
-- Author: Olga Lazarenko
-- Description: to practice T-SQL skills and create filtering queries



USE AdventureWorks2012 ;
GO


SELECT BusinessEntityID
	, RateChangeDate
	, Rate
	, PayFrequency
FROM HumanResources.EmployeePayHistory ;



SELECT BusinessEntityID
	, RateChangeDate
	, Rate
	, PayFrequency
FROM HumanResources.EmployeePayHistory
WHERE Rate BETWEEN 11 AND 30 ;


SELECT BusinessEntityID
	, RateChangeDate
	, Rate
	, PayFrequency
FROM HumanResources.EmployeePayHistory
WHERE (Rate >= 20 AND Rate <= 50) ;

SELECT BusinessEntityID
	, YEAR(RateChangeDate) AS YEAR
	, MONTH(RateChangeDate) AS Mounth
	, Rate
FROM HumanResources.EmployeePayHistory
WHERE PayFrequency = 2 
ORDER BY YEAR desc , Rate desc ;

SELECT BusinessEntityID
	, Rate
	,LEFT(ModifiedDate,11) AS ModifiedDate
FROM HumanResources.EmployeePayHistory
WHERE PayFrequency IN (1,2) ;




SELECT BusinessEntityID
	, Rate
	, PayFrequency
FROM HumanResources.EmployeePayHistory
WHERE YEAR(RateChangeDate) = 2007
		OR Year(RateChangeDate)= 2006 ; 


SELECT AddressID
	, AddressLine1
	--, AddressLine2
	, City
	, PostalCode
	, SpatialLocation
FROM Person.Address
;

SELECT AddressID
	, AddressLine1
	--, AddressLine2
	, City
	, StateProvinceID
	, PostalCode
	, SpatialLocation
FROM Person.Address
WHERE StateProvinceID IN (9,19,79) ; 


SELECT AddressID
	, AddressLine1
	--, AddressLine2
	, City
	, StateProvinceID
	, PostalCode
	, SpatialLocation
FROM Person.Address
WHERE StateProvinceID NOT IN( 9,79) ; 


SELECT ProductID
	, Name AS ProductName
	, Color
	, ListPrice
FROM Production.Product 
WHERE ListPrice <> 0 
	AND Color <> 'NULL' 
	AND Name LIKE '%Frame%' 
ORDER BY Color,ListPrice ; 

SELECT ProductID
	, Name AS ProductName
	, Color
	, ListPrice
FROM Production.Product 
WHERE ListPrice BETWEEN 100 AND 200 ; 

SELECT ProductID
	, Name AS ProductName
	, Color
	, ListPrice
FROM Production.Product 
WHERE ProductID IN (520,521,522,524) ;

SELECT ProductID
	, Name AS ProductName
	, Color
	, ListPrice
FROM Production.Product 
WHERE ProductID NOT IN (520,521,522,523,524,525) ; 


SELECT ProductID
	, Name AS ProductName
	, Color
	, ListPrice
	--, Class
	--, Style
FROM Production.Product 
WHERE Color IS NULL 
	AND ListPrice <> 0 ; 

SELECT ProductID
	, Name AS ProductName
	, Color
	, Class
	, Style
FROM Production.Product 
WHERE Color IS NOT NULL ; 


--****************************************************************************************
-- create a filter on the column Title (allows null values) for table Person.Person
SELECT BusinessEntityID
	, PersonType
	, NameStyle
	, Title -- nulls are allowed
	, FirstName
	, LastName
FROM Person.Person ; 
-- 19972 rows are returned 



SELECT Distinct Title
FROM Person.Person ; 

SELECT BusinessEntityID
	, PersonType
	, NameStyle
	, Title -- nulls are allowed
	, FirstName
	, LastName
FROM Person.Person
WHERE Title = N'Ms.' ; -- filter on the predicate Ms. 
-- 415 rows are retured 
-- 19972-415 = 19557 rows will have a title different from Ms., including nulls
 -- we use N because the data type for the column Title is Unicode: nvarchar



SELECT BusinessEntityID
	, PersonType
	, NameStyle
	, Title -- nulls are allowed
	, FirstName
	, LastName
FROM Person.Person
WHERE Title <> N'Ms.' ; -- we want to have all type of Title(including Null values), except Ms.
-- 594 rows are returned
  /* Null values have been discarded 
  because the filtering on the column Title (allowing nulls) 
  occurs this way: the predicate is evaluated  to True, False and Unknown (three-valued logic)
  and manipulation of the column Title is happening and Null values are discarded
  To avoid this situlation we add one more condition to WHERE clause */

SELECT BusinessEntityID
	, PersonType
	, NameStyle
	, Title -- nulls are allowed
	, FirstName
	, LastName
FROM Person.Person
WHERE Title <> N'Ms.' 
	OR Title IS NULL ; 
-- 19557 rows are returned and now Title column includes NULL values 
-- the correct number of rows are returned now and if we look at the query's result 
-- we see that NULL values are not discarded any more and we obtained what we wanted


-- Attention ! we used Title IS NULL and not Title = 'NULL'
-- because this type of filtering will produce a wrong result:
SELECT BusinessEntityID
	, PersonType
	, NameStyle
	, Title -- nulls are allowed
	, FirstName
	, LastName
FROM Person.Person
WHERE Title <> N'Ms.' 
	OR Title = N'NULL' ; 
-- 594 rows are returned, NULL values are discarded
-- the reason is that the predicate's NULL ( Title = 'NULL')
-- is not equal to nulls in the column Title , one null is not equal to another null
-- because of this we cannot use the equality sigh '=' and we should use 'IS'


--*********************************************************************************

SELECT DocumentNode
	, DocumentLevel -- allows nulls 
	, Title
	, Owner
	, Status
	, DocumentSummary -- allows nulls
FROM Production.Document ; 
-- 13 rows are retured 

-- we want to retrieve data were DocumentSummary has NULL value
-- let's try this query:
SELECT DocumentNode
	, DocumentLevel -- allows nulls 
	, Title
	, Owner
	, Status
	, DocumentSummary -- allows nulls
FROM Production.Document 
WHERE DocumentSummary = N'NULL' ; 
--the query doesn't return anything
-- the predicate's null is not equal to any null in the DocumentSummary colunm
-- is it evaluated to unknow and discarded
-- in order to obtain the correct result, we use: DocumentSummary IS NULL
SELECT DocumentNode
	, DocumentLevel -- allows nulls 
	, Title
	, Owner
	, Status
	, DocumentSummary -- allows nulls, filtering on this column will follow three-valued logic True-False-Unknow
FROM Production.Document 
WHERE DocumentSummary IS NULL ;  
-- 8 rows are returned 


SELECT DocumentNode
	, DocumentLevel -- allows nulls 
	, Title
	, Owner
	, Status
	, DocumentSummary -- allows nulls
FROM Production.Document 
WHERE DocumentSummary  IS NOT NULL  ; 
-- 5 rows are retured 

-- or we can use this query:
SELECT DocumentNode
	, DocumentLevel -- allows nulls 
	, Title
	, Owner
	, Status
	, DocumentSummary -- allows nulls
FROM Production.Document 
WHERE DocumentSummary <> N'NULL' ; 
-- 5 rows are retured 

--**************************************************************************************

--Let's do filtering (three-valued logic) on a predicate with datetime data type.
-- table Productiion.ProductCostHistory, the column EndDate (datetime, null)

SELECT ProductID
	, StartDate -- not null
	, EndDate   -- null
FROM Production.ProductCostHistory ; 
--returns 395 rows

SELECT ProductID
	, CAST((StartDate) AS date) AS Start_Date
	, CAST((EndDate) AS date) AS End_Date
FROM Production.ProductCostHistory ;   
-- returns 395 rows

SELECT ProductID
	, CAST((StartDate) AS date) AS Start_Date
	, CAST((EndDate) AS date) AS End_Date
FROM Production.ProductCostHistory 
WHERE CAST((EndDate) AS date) = 'NULL' ; 
-- failed when converting date and/or time from character string

SELECT ProductID
	, CAST((StartDate) AS date) AS Start_Date
	, CAST((EndDate) AS date) AS End_Date
FROM Production.ProductCostHistory 
WHERE CAST((EndDate) AS date)  IS NULL ; 
-- 195 rows are retured

SELECT ProductID
	, CAST((StartDate) AS date) AS Start_Date
	, CAST((EndDate) AS date) AS End_Date
FROM Production.ProductCostHistory 
WHERE CAST((EndDate) AS date) IS NOT NULL ;
-- 200 rows are retrieved

--*****************************************************************************************
-- Three-valued logic with integer predicate (null)
--table Purchasing.ProductVendor
-- OnOrderQty(int,null)

SELECT ProductID	-- PK,int, not null
	, StandardPrice -- money, not null
	, OnOrderQty	  -- int, null => sorting on this predicate will follow the three-valued logic True/False/Unkown
FROM Purchasing.ProductVendor ; 
--460 rows are returned


SELECT COUNT(ProductID) AS Products
FROM Purchasing.ProductVendor 
WHERE OnOrderQty <> NULL; 
-- returns zero Products

SELECT COUNT(ProductID) AS Products
FROM Purchasing.ProductVendor 
WHERE OnOrderQty IS NOT NULL ; 
-- returns 155 Products

SELECT COUNT(ProductID) AS Products
FROM Purchasing.ProductVendor 
WHERE OnOrderQty IS NULL; 
--returns 305 Products

--*******************************************************

SELECT 
	AddressID
	, AddressLine1
	--, City
	, PostalCode
FROM AdventureWorks2012.Person.Address 
WHERE City IN ('Santa Cruz', 'San Diego', 'Los Angeles') ; 
