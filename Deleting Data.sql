/* Date:  March 26, 2018
   Project Name: Deleting Data
   Author: Olga Lazarenko
   Description: DELETE, 
				DELETE based on a join,
				DELETE using table expresions, 
				TRUNCATE the data 
*/

USE AdventureWorks2012 ; 
GO

IF OBJECT_ID(N'Sales.OrderDetails_Copy', N'U') IS NOT NULL
	DROP TABLE Sales.OrderDetails_Copy ;  
-- check if the object ( the table Sales.OrderDetails_Copy / U) is exists
-- if the table exists, drop it


SELECT *
INTO Sales.OrderDetails_Copy
FROM Sales.SalesOrderDetail ; 
--create a copy of the table Sales.SalesOrderDetails
-- the copy will be named OrderDetails_Copy

ALTER TABLE Sales.SalesOrderDetails_Copy
	ADD CONSTRAINT PK_SalesOrderDetails_Copy PRIMARY KEY(SalesOrderID) ; 
-- add the constraint( the primary key to the table Sales.OrderDetails_Copy

GO

--******************************************************************************************

/*Create the copy of the table Sales.SalesOrderHeader
 and name it Sales.OrderHeader_Copy/
 The first step is to check of this object( the table type)
 is already exists in the database
 */
 IF OBJECT_ID(N'Sales.OrderHeader_Copy', N'U') IS NOT NULL  
	DROP TABLE Sales.OrderHeader_Copy ; 

SELECT * 
INTO Sales.OrderHeader_Copy
FROM Sales.SalesOrderHeader ; 

--add the primery key(SalesOrderID) to the table Sales.OrderHeader_Copy
ALTER TABLE Sales.OrderHeader_Copy
	ADD CONSTRAINT PK_OrderHeader_Copy PRIMARY KEY(SalesOrderID) ; 

GO
-- *******************************************************************************************

/* create the copy of the table Sales.SalesTerritory
	and give it the name Sales.SalesTerritory_Copy
   First, check of the table Sales.SalesTerritory_Copy
   exists, if does, drop it.
*/
IF OBJECT_ID(N'Sales.SalesTerritory_Copy', N'U') IS NOT NULL 
	DROP TABLE Sales.SalesTerritory_Copy ; 

SELECT * 
INTO Sales.SalesTerritory_Copy
FROM Sales.SalesTerritory ; 

ALTER TABLE Sales.SalesTerritory_Copy
	ADD CONSTRAINT PK_SalesTerritory_Copy PRIMARY KEY(TerritoryID) ; 
-- add the constraint Primary key to the table

--**********************************************************************************************

SELECT
	T.Name
	,SalesOrderID
	, OrderDate
	, CustomerID
	, SubTotal
	, TaxAmt
FROM Sales.OrderHeader_Copy O
INNER JOIN 
	Sales.SalesTerritory_Copy T
	ON O.TerritoryID= T.TerritoryID 
ORDER BY Name ; 
--31465 rows returned

SELECT 
	T.Name
	,SalesOrderID
	, OrderDate
	, CustomerID
	, SubTotal
	, TaxAmt
FROM Sales.OrderHeader_Copy O
INNER JOIN 
	Sales.SalesTerritory_Copy T
	ON O.TerritoryID= T.TerritoryID 
WHERE T.Name = N'Australia'  ;
--6843 rows retieved 

/* delete the rows from the table Sales.OrderHeader_Copy
  where orders are in Australia.
  We should have 31465 minus 6843 rows = 24622 rows
*/

DELETE FROM O
FROM Sales.OrderHeader_Copy O
INNER JOIN 
	Sales.SalesTerritory_Copy T
	ON O.TerritoryID= T.TerritoryID 
WHERE T.Name = N'Australia'  ; 
--6843 rows affected 

-- now we will check how many rows are left at the table Sales.OrderHeader_Copy
SELECT * 
FROM Sales.OrderHeader_Copy ; 
--24622 rows are returned, thus the DELETE statement worked OK.

-- as well we can check twice
SELECT 
	T.Name
	,SalesOrderID
	, OrderDate
	, CustomerID
	, SubTotal
	, TaxAmt
FROM Sales.OrderHeader_Copy O
INNER JOIN 
	Sales.SalesTerritory_Copy T
	ON O.TerritoryID= T.TerritoryID 
WHERE T.Name = N'Australia' ; 
-- no rows are returned, we have only the table structure ( the names of the columns)

-- ******************************************************************************************
/* DELETE statement can be used to delete all rows 
or we can restrict the rows to be deleted with WHERE clause
specifying a predicate
*/

DELETE FROM Sales.OrderDetails_Copy -- the table contains 121317 rows
WHERE UnitPrice < 100 ;              --68332 rows affected


SELECT * FROM Sales.OrderDetails_Copy ; -- 52985 rows are returned 



-- to delete all rows 
DELETE FROM Sales.OrderDetails_Copy ;  --53985 rows affected
--only the records were deleted, but itself the table exists as the database object 

-- and check if the table has any data
SELECT * FROM Sales.OrderDetails_Copy ; -- 0 rows are returned, we only have the table's structure

IF OBJECT_ID(N'Sales.OrderDetails_Copy', N'U') IS NOT NULL
	PRINT('the table Sales.OrderDetails_Copy exists') ; 




