-- Date: Dec 28,2017
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

