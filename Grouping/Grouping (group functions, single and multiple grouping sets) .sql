--Date: Jan 29,2018
--Project Name: Grouping (single, multiple grouping sets
--Author: Olga Lazarenko
--Description: create grouped queries using group functions, GROUP BY clause or both

USE AdventureWorks2012 ; -- call the data
GO 

-- grouped query with group function/s

-- calculate the number of customers
SELECT COUNT(CustomerID) AS Customers
FROM AdventureWorks2012.Sales.Customer ;
--returns 19820 rows
/*there is no explicit GROUP BY clause in this query, 
but all rows are arranged in one group and then the COUNT()function
counts the number of the rows in the group returning only one row in the result set */


SELECT COUNT(PersonID) AS CustomersWithPersonID
FROM AdventureWorks2012.Sales.Customer ; 
-- the column PersonID allows null values, not all customers might have PersonID
-- we will calculate the number of customers with PersonID
--19119 rows are retrieved

SELECT COUNT(CustomerID) AS CustomersWithoutPersonID
FROM AdventureWorks2012.Sales.Customer 
WHERE PersonID IS NULL ; 
--701 rows are returned



-- explicit GROUP BY clause 
-- display the total sale by CountryRetionCode in descending way 
SELECT CountryRegionCode
	, SUM(SalesYTD) AS TotalSale
FROM AdventureWorks2012.Sales.SalesTerritory 
GROUP BY CountryRegionCode -- this is a single grouping set
ORDER BY TotalSale DESC ; 


-- calculate the number of orders by the ship method and status
SELECT P.ShipMethodID
	, S.Name AS ShipMethod
	, Status
	, COUNT(PurchaseOrderID) AS Orders
	, SUM(SubTotal) AS Total 
FROM AdventureWorks2012.Purchasing.PurchaseOrderHeader AS P
	INNER JOIN
	AdventureWorks2012.Purchasing.ShipMethod AS S
	ON P.ShipMethodID = S.ShipMethodID 
GROUP BY P.ShipMethodID, S.Name, Status -- this grouping set has multiple elements 
ORDER BY P.ShipMethodID, Status 