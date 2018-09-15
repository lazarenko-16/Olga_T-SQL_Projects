/*
Date: Sep 14, 2018
Project Name: Subqueries
Author: Olga Lazarenko
Description : create different subqueries to retrieve data

*/

USE AdventureWorks2014 ; 
GO 

-- a subquery in the SELECT clause
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