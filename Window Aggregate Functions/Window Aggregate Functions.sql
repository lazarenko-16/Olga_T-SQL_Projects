--Date: Feb 12, 2018
--Project Name: Window Aggregate Functions
--Author: Olga Lazarenko
/* Description: create queries with window aggredate functions
				aggregate  -> OVER(PARTITION BY ...) , 
				ranking , 
				offset 
*/
USE AdventureWorks2012 ; -- call AdventureWorks2012 database
GO


/* with window functions we can define the set of rows  per function
and then return one result value per each underlying row and function,
to define the set of rows for the function OVER clause is used

The following types of window functions: AGGREGATE, RANKING, OFFSET
will be used at this project to create queries
*/



--Window AGGREGATE functions are the same as the group aggregate functions: SUM, MIN, MAX, COUNT, AVG
-- the difference is that they are applied to a window of rows defined by the OVER clause


-- OVER(PARTITION BY ... )  *****************************************************************************
SELECT 
	DaysToManufacture
	, ProductID
	, ListPrice
	, SUM(ListPrice) 
		OVER(PARTITION BY DaysToManufacture) AS  Total_ListPrice 
		-- OVER clause defines the window of rows for the function using DaysToManufacture column distinct values
		--SUM(ListPrice) represents the total list price for each distinct value of DaysToManufacture
		-- Total_ListPrice will be teh same for all rows with the same DaysToManufacture
	, SUM(ListPrice) 
		OVER() AS Grand_Total 
		--this is the grand total of all rows, it will be the same for all rows                                                                                                                
FROM AdventureWorks2012.Production.Product
WHERE ListPrice > 100
	AND ListPrice < 300  -- select only rows with ListPrice between 100 and 300 exclusive; 
-- 43 rows are returned


SELECT
	Color
	, ProductNumber
	, Size
	, StandardCost 
	, AVG(StandardCost) OVER(Partition BY Color) AS Color_Avg_Cost
	, AVG(StandardCost) OVER () AS Avg_Cost
FROM AdventureWorks2012.Production.Product 
WHERE 
	Color IS NOT NULL
	AND Size IS NOT NULL
	AND StandardCost IS NOT NULL 
	AND ( StandardCost BETWEEN 200 AND 400 ) ; 


-- Calculate the sum of OrderQty and the average of UnitPrice for each color of the product
-- using window aggregate function with OVER(PARTITON BY .... ) 
SELECT 
	P.Color
	, O.ProductID
	, O.OrderQty
	, O.UnitPrice
	, SUM(OrderQty) 
		OVER(PARTITION BY Color) AS Color_Total_OrderQty
	, SUM(OrderQty) 
		OVER() AS Grand_Total_OrderQty-- grand total for all rows 
	, AVG(UnitPrice) 
		OVER(PARTITION BY Color) AS Color_Avg_UnitPrice
	, AVG(UnitPrice) 
		OVER() AS Avg_UnitPrice -- avg for all rows 
FROM AdventureWorks2012.Purchasing.PurchaseOrderDetail AS O
	INNER JOIN 
	AdventureWorks2012.Production.Product AS P
	ON O.ProductID = P.ProductID
WHERE Color IS NOT NULL 
ORDER BY Color ; 


--Calculate teh percent of the total sale from each sales person out of the grand total sale
/* create inner joins of tables Sales.SalesPerson, HumanResources.Employee and Person.Person
and 
use wingow aggregate function SUM and OVER(PARTITION BY ...) clause
*/
SELECT 
	 SP.BusinessEntityID AS EmpID
	, P.FirstName 
	, P.LastName
	, SUM(SalesYTD) OVER(PARTITION BY SP.BusinessEntityID) AS Sales
	, SUM(SalesYTD) OVER() AS GrandTotal
	, Round(SalesYTD *100 / (SUM(SalesYTD) OVER()),2) AS Percent_GrandTotal 
FROM AdventureWorks2012.Sales.SalesPerson AS SP
	INNER JOIN
	AdventureWorks2012.HumanResources.Employee AS E
	ON SP.BusinessEntityID = E.BusinessEntityID
	INNER JOIN
	AdventureWorks2012.Person.Person AS P
	ON E.BusinessEntityID = P.BusinessEntityID 
ORDER BY EmpID  ; 

--****************************************************************************************************************

SELECT 
	 DISTINCT OrderQty 
	 --, SalesOrderID AS OrderID
	 --, UnitPrice
	 --, UnitPrice*OrderQty AS SalesOrder
	 , SUM(UnitPrice*OrderQty) OVER(PARTITION BY OrderQty) AS QtyTotal
	 , ( SUM(UnitPrice*OrderQty) OVER(PARTITION BY OrderQty) * 100 ) 
			/ (SUM(UnitPrice*OrderQty) OVER() ) AS Percent_GrandTotal 
		-- calculate the percent of distinct OrderQty totals out of the grand total sales
	 , SUM(UnitPrice*OrderQty) OVER() AS GrandTotal
FROM AdventureWorks2012.Sales.SalesOrderDetail 
ORDER BY Percent_GrandTotal DESC  ; 
--41 rows returned
/* the result is ordered the way allowing to find out what kind of orders(we are interested in OrderQty, 
how many items were orderded) contrubuted the most to the grand total sales. 
From the result of the query we see that the orders with one ordered item contributed 33.3% ),
the top three contrubuters are orders with one item (33.3%), with two items (almost 13%) and orders with three items (12,5%)

This is an example of usage window aggregate function SUM and OVER clause.
*/

--**************************************************************************************************************
--This query will use UNBOUND PRECEDING to calculate the running total / cumulative total
SELECT 
	SP.TerritoryID
	, SP.BusinessEntityID AS EmpID
	, ( P.FirstName + ' ' + P.LastName ) AS SalesPersonName
	, SP.SalesYTD AS Sales
	, SUM(SalesYTD) 
		OVER(PARTITION BY SP.TerritoryID
			ORDER BY SalesYTD DESC
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total

FROM AdventureWorks2012.Sales.SalesPerson AS SP
	INNER JOIN
	AdventureWorks2012.HumanResources.Employee AS E
	ON SP.BusinessEntityID = E.BusinessEntityID
	INNER JOIN
	AdventureWorks2012.Person.Person AS P
	ON E.BusinessEntityID = P.BusinessEntityID  ; 
-- 17 rows returned 
/* we have the running total for each partition ( TerritoryID) wich include certain sales persons
*/

 SELECT 
	TerritoryID
	, SalesYTD AS Sales
	, SUM(SalesYTD) OVER(PARTITION BY TerritoryID
						 ORDER BY TerritoryID
						 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total
 FROM AdventureWorks2012.Sales.SalesPerson ; 
 --17 rows returned, this is simplified version of the above query


 --**********************************************************************************************
 /*if we need to filter the result of the last query and return only the rows with the Running_Total > 2000000
 it is necessary to use a common table expression (CTE) based on the previous query,
 because window functions are allowed only in the SELECT and ORDER BY clauses.
 The clauses FROM, WHERE, GROUP BY and HAVING are processed before SELECT and ORDER BY clauses.
 So, to refer to the result of any window function we need to use a table expression
 */
 WITH RunningTotals AS -- create CTE (common table expression)
 (
	 SELECT 
	TerritoryID
	, SalesYTD AS Sales
	, SUM(SalesYTD) OVER(PARTITION BY TerritoryID
						 ORDER BY TerritoryID
						 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_Total
	FROM AdventureWorks2012.Sales.SalesPerson 
	)
SELECT *
FROM RunningTotals
WHERE Running_Total > 2000000 ; 
--11 rows are retrieved



--******************************************************************************************************
