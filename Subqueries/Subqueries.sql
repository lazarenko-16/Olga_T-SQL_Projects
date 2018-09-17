/*
Date: Sep 14, 2018
Project Name: Subqueries
Author: Olga Lazarenko
Description : create different subqueries to retrieve data
			1) subquery in the SELECT clause
			2) subquery in the FROM clause
			3) subquery in the WHERE clause

*/

USE AdventureWorks2014 ; 
GO 

--***************    1) subquery in the SELECT clause     **********************
-- the current query contains two subqueries in the SELECT clause 
SELECT 
	SP.TerritoryID
	, SP.BusinessEntityID AS EmpID
	, (SELECT HR.JobTitle
		FROM AdventureWorks2014.HumanResources.Employee AS HR
		WHERE HR.BusinessEntityID = SP.BusinessEntityID
		) AS JobTitle

	, (SELECT P.FirstName + ' ' + P.LastName
		FROM AdventureWorks2014.Person.Person AS P
		WHERE P.BusinessEntityID = SP.BusinessEntityID
		) AS Name 
	, SP.Bonus
	, SP.SalesYTD 
FROM AdventureWorks2014.Sales.SalesPerson AS SP
ORDER BY SP.TerritoryID 
;

--***************    2) subquery in the FROM clause     **********************
SELECT TransactionID
	, CAST(TransactionDate AS DATE) AS TransactionDate
	, ProductName
	, ListPrice
FROM	
	(
	SELECT TransactionID
		, TransactionDate
		, Quantity
		, ActualCost
		, P.[Name] AS ProductName
		, P.ListPrice
		, TransactionType
	FROM AdventureWorks2014.Production.TransactionHistory AS TRH
		INNER JOIN 
		AdventureWorks2014.Production.Product AS P
		ON TRH.ProductID = P.ProductID 
	) AS T -- the subquery/the inner query
WHERE T.TransactionType = 'W'
	AND Quantity >= 50 
	AND ListPrice <> 0.00 ; 



--***************    3) subquery in the WHERE clause     **********************

-- retrieve the emails of the employees from the sales department 
SELECT EmailAddress
FROM AdventureWorks2014.Person.EmailAddress 
WHERE BusinessEntityID IN 
	(
	SELECT BusinessEntityID
	FROM AdventureWorks2014.HumanResources.EmployeeDepartmentHistory
	WHERE DepartmentID  IN 
		(
		SELECT DepartmentID
		FROM AdventureWorks2014.HumanResources.Department
		WHERE [Name] LIKE 'Sales%'
		)
	) ; 