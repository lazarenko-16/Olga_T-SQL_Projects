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


-- OVER(  PARTITION BY ... )  *****************************************************************************
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