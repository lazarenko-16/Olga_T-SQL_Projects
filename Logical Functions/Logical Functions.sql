/*
Date: June 10, 2018
Project Name: Logical Functions 
Author: Olga Lazarenko
Description: create queries with logical functions
			CASE, NULLIF, IFNULL, IIF, CHOOSE
*/

USE AdventureWorks2012 ; 
GO


-- CASE expression 

SELECT 
	ProductID
	, StartDate
	, EndDate
	, StandardCost
	, CASE 
		WHEN StandardCost <= 500.00 THEN  'LowStandardCost'
		WHEN (StandardCost > 500.00 AND StandardCost <= 1000.00) THEN 'MidStandardCost'
		WHEN StandardCost > 1000.00 THEN 'HighStandardCost'
		ELSE 'Unknown'
	 END --the searched form of CASE expression is used here 
FROM Production.ProductCostHistory;