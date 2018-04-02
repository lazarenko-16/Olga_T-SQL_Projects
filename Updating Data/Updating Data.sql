/* 
Date: April 1, 2018
Project Name: Updating Data
Author: Olga Lazarenko
Desciption: sample data tables Sales.MyCustomers , Sales.MyOrders, Sales.MyOrderDetails will be used.
			These tables are made as initial copies of the tables Sales.Customers, Sales.SalesOrderHeader
			Sales.SalesOrderDetail;

			1) UPDATE
			2) UPDATE ... WHERE 
			3) UPDATE based on JOIN
			4) UPDATE  (nondeterministic) 
			5) UPDATE and CTE/ or derived table 
			6) UPDATE based on a variable
			7) UPDATE all-at-once

*/

Use AdventureWorks2012 ; 
GO

--1)
-- check if the tables are already exist
IF OBJECT_ID(N'Sales.MyCustomers', N'U') IS NOT NULL
	DROP TABLE Sales.MyCustomers ; 

IF OBJECT_ID(N'Sales.MyOrders', N'U') IS NOT NULL
	DROP TABLE Sales.MyOrders ;

IF OBJECT_ID(N'Sales.MyOrderDetails',N'U') IS NOT NULL
	DROP TABLE Sales.MyOrderDetails ; 

--create the sample data tables by copying the source tables using SELECT INTO statement
--( in this case the constraints are not copied)
SELECT *
INTO AdventureWorks2012.Sales.MyCustomers
FROM AdventureWorks2012.Sales.Customer ; 

SELECT * 
INTO AdventureWorks2012.Sales.MyOrders
FROM AdventureWorks2012.Sales.SalesOrderHeader ;

SELECT * 
INTO AdventureWorks2012.Sales.MyOrderDetails
FROM AdventureWorks2012.Sales.SalesOrderDetail ;  

--to add  PRIMARY KEY to the copied tables, because SELECT INTO doesn't copy the constraints 

ALTER TABLE Sales.MyCustomers
	ADD CONSTRAINT PK_CustomerID PRIMARY KEY(CustomerID) ; 

ALTER TABLE Sales.MyOrders
	ADD CONSTRAINT PK_SalesOrderID PRIMARY KEY(SalesOrderID) ; 

ALTER TABLE Sales.MyOrderDetails
	ADD CONSTRAINT PK_OrderDetails PRIMARY KEY(SalesOrderID, SalesOrderDetailID) ; 


--************************************************************************************************************
--1)
--use UPDATE statement to update the existing rows at the sample tables
-- update  UnitPriceDiscount, increase by 5%, at the table Sales.MyOrderDetails
UPDATE AdventureWorks2012.Sales.MyOrderDetails
SET UnitPriceDiscount += 0.05 ; 

--to have the data back to their original state before the update 
UPDATE AdventureWorks2012.Sales.MyOrderDetails
SET UnitPriceDiscount -= 0.05 ;

--2)
UPDATE AdventureWorks2012.Sales.MyOrderDetails
SET UnitPriceDiscount = 0.25
WHERE OrderQty = 10 ; -- 768 rows affected

-- to see the  update
SELECT * FROM AdventureWorks2012.Sales.MyOrderDetails
WHERE UnitPriceDiscount = 0.25 ; 

-- because we set the UnitPriceDiscount = 0.25 we need to recalculate the LineTotal 
UPDATE AdventureWorks2012.Sales.MyOrderDetails
SET LineTotal = LineTotal * (1-0.25)
WHERE OrderQty = 10 and UnitPriceDiscount = 0.25 ; --768 rows affected


--update the TaxAmt at the sample table Sales.MyOrders
UPDATE Sales.MyOrders
SET TaxAmt *= 0.1
WHERE TerritoryID = 5 ; -- 486 rows affected 

SELECT * FROM Sales.MyOrders 
WHERE TerritoryID = 5 ; -- 486 rows affected

--to have the data back to their original state before the update
UPDATE Sales.MyOrders
SET TaxAmt *= 10
WHERE TerritoryID = 5 ; -- 486 rows affected 



--*****************************************************************************************

--3)
/* UPDATE based on JOIN --> to update rows in the table Sales.MyOrderDetails reffering to 
 related rows in other tables; update UnitPriceDiscount ( increase by 10%) for orders, 
 plased by the customers from Germany.
 */
 -- first, a join will be created 
 
SELECT DTL.* -- all columns from Sales.MyOrderDetails 
FROM Sales.MyOrderDetails AS DTL
	INNER JOIN 
	Sales.MyOrders AS ORD
	ON DTL.SalesOrderID = ORD.SalesOrderID 
    INNER JOIN 
	Sales.SalesTerritory AS TR
	ON ORD.TerritoryID = TR.TerritoryID
    WHERE TR.Name = N'Germany' ; -- 7528 rows affected 

/* in order to perform the desired update, we will replace the SELECT clause with the UPDATE clause, 
indicating the alias of the table that is the target for the UPDATE(DTL in this case), 
and the assignment in the SET clause, as follows
*/
UPDATE DTL
SET DTL.UnitPriceDiscount += 0.10 -- increase UnitPriceDiscount by 10%
FROM Sales.MyOrderDetails AS DTL
	INNER JOIN 
	Sales.MyOrders AS ORD
	ON DTL.SalesOrderID = ORD.SalesOrderID 
    INNER JOIN 
	Sales.SalesTerritory AS TR
	ON ORD.TerritoryID = TR.TerritoryID
    WHERE TR.Name = N'Germany' ; -- 7528 rows affected

-- to check the made changes 
SELECT DTL.* -- all columns from Sales.MyOrderDetails 
FROM Sales.MyOrderDetails AS DTL
	INNER JOIN 
	Sales.MyOrders AS ORD
	ON DTL.SalesOrderID = ORD.SalesOrderID 
    INNER JOIN 
	Sales.SalesTerritory AS TR
	ON ORD.TerritoryID = TR.TerritoryID
    WHERE TR.Name = N'Germany' ; 
	-- 7528 rows returned, the 10% UnitPriceDiscount increasement is applyed to the corresponding order lines

/* to get teh previous order lines back to their original state, run an UPDATE statement 
	that reduces the UnitPriceDiscount by 10%
*/

UPDATE DTL
SET DTL.UnitPriceDiscount -= 0.10 -- reduce UnitPriceDiscount by 10%
FROM Sales.MyOrderDetails AS DTL
	INNER JOIN 
	Sales.MyOrders AS ORD
	ON DTL.SalesOrderID = ORD.SalesOrderID 
    INNER JOIN 
	Sales.SalesTerritory AS TR
	ON ORD.TerritoryID = TR.TerritoryID
    WHERE TR.Name = N'Germany' ; -- 7528 rows affected


-- to verify the changes 
SELECT DTL.* -- all columns from Sales.MyOrderDetails 
FROM Sales.MyOrderDetails AS DTL
	INNER JOIN 
	Sales.MyOrders AS ORD
	ON DTL.SalesOrderID = ORD.SalesOrderID 
    INNER JOIN 
	Sales.SalesTerritory AS TR
	ON ORD.TerritoryID = TR.TerritoryID
    WHERE TR.Name = N'Germany' ; -- 7528 rows returned, the updating has been applyed 

GO
--*******************************************************************************************

/* to be done:
			4) UPDATE  (nondeterministic) 
			5) UPDATE and CTE/ or derived table 
			6) UPDATE based on a variable
			7) UPDATE all-at-once
*/


 