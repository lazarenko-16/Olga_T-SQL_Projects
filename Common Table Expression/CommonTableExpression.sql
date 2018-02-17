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
 --at CTE we can use WHERE clause at the above query we have to use HAVING because of GROUP BY clause
ORDER BY TotalSales DESC ;


--**************************************************************************************************
-- retrieve phone numbers ( work, home, cell) of the employees 
WITH EmployeePhoneNum	
AS
(
	SELECT
		P.BusinessEntityID AS EmpID
		,( P.FirstName + ' ' + P.LastName ) AS EmpName
		, Ph.PhoneNumber AS PhoneNumber
		, PhT.Name AS PhoneNumType
	FROM AdventureWorks2012.Person.Person AS P
		LEFT JOIN 
		AdventureWorks2012.Person.PersonPhone AS Ph
		ON P.BusinessEntityID = Ph.BusinessEntityID
		INNER JOIN 
		AdventureWorks2012.Person.PhoneNumberType AS PhT
		ON Ph.PhoneNumberTypeID = PhT.PhoneNumberTypeID
)
SELECT 
	EmpName
	, EmpID
	, PhoneNumber
FROM EmployeePhoneNum
WHERE PhoneNumType LIKE 'Work' -- or it can be 'Cell', or 'Home' or any combination of them 
ORDER BY EmpName ; 