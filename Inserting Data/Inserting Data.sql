/* Date: March 28, 2018
   Project Name: Inserting Data
   Author: Olga Lazarenko
   Description: the project will demonstrate how to use different methods to insert data into tables;
				statements like INSERT INTO, INSERT SELECT, INSERT EXEC, SELECT INTO
*/

USE AdventureWorks2012 ;

IF OBJECT_ID(N'Sales.MyOrders', N'U') IS NOT NULL
	DROP TABLE Sales.MyOrders ; 

GO ;

CREATE TABLE AdventureWorks2012.Sales.MyOrders
(
	SalesOrderID INT NOT NULL IDENTITY(1,1) -- the column has IDENTITY property with seed 1 and an increment 1
	--this property will generate values in this column automatically when rows are inserted 
		CONSTRAINT PK_MyOrders_SalesOrderID PRIMARY KEY
	, OrderDate DATE NOT NULL
		CONSTRAINT DFT_MyOrders_OrderDate DEFAULT (CAST(SYSDATETIME() AS DATE))
	, CustomerID INT NOT NULL
	, SalesPersonID INT NOT NULL
	, TerritoryID INT NULL
	, SubTotal MONEY NOT NULL
) ; 

--INSERT VALUES statement  ( insert one or more rows)
INSERT INTO AdventureWorks2012.Sales.MyOrders
( OrderDate, CustomerID, SalesPersonID, TerritoryID, SubTotal
) 
VALUES 
('20120315', 110, 282, 6, 235.14 ) ; 

SELECT * FROM AdventureWorks2012.Sales.MyOrders ; 

INSERT INTO AdventureWorks2012.Sales.MyOrders
( OrderDate, CustomerID, SalesPersonID, TerritoryID, SubTotal) 
VALUES 
('20150620',124, 276,4, 178.90), 
(DEFAULT, 202, 282, 6, 307.38), --DEFAULT will generate today's date 2018-03-28
(DEFAULT, 110, 280, 1, 55.0), 
('20110917',155, 280, 1, 134.55); 
 

 INSERT INTO AdventureWorks2012.Sales.MyOrders
( OrderDate, CustomerID, SalesPersonID, TerritoryID, SubTotal) 
VALUES 
 (DEFAULT, 202, 282, NULL, 200.00) ; 

 GO 

SELECT * FROM AdventureWorks2012.Sales.MyOrders ;
/* using SELECT * is not a good practice, but here I use it only for ad hoc query to examine 
the content of the table after the applying changes 

SalesOrderID column contains the generated values (started with 1 and incremented by 1)
NULL OrderDate is substuted with the DEFAULT values (today's date using SYSDATETIME() function 
and converted from datetime data type to the date type using CAST() function

6 rows are returned
*/

--*************************************************************************************************

/* INSERT SELECT to be used to insert the result set obtained by quering the table Sales.SalesOrderHeader
Because the mentioned table contains SalelsOrderID values wich will be provided for the table Sales.MyOrders
instead of letting the IDENTITY property generated them,  
we need to set IDENTITY_INSERT property ON 
and  when everything is done , IDENTITY_INSERT will be set OFF
*/

SET IDENTITY_INSERT AdventureWorks2012.Sales.MyOrders ON ; 

INSERT INTO AdventureWorks2012.Sales.MyOrders
(SalesOrderID, OrderDate, CustomerID, SalesPersonID, TerritoryID, SubTotal) 
	SELECT  
	SalesOrderID, OrderDate, CustomerID, SalesPersonID, TerritoryID, SubTotal
	FROM  AdventureWorks2012.Sales.SalesOrderHeader
	WHERE TerritoryID IN (7,8,9) 
		AND	SalesPersonID IS NOT NULL ; --452 rows affected 

SET IDENTITY_INSERT AdventureWorks2012.Sales.MyOrders OFF ; 

SELECT * FROM AdventureWorks2012.Sales.MyOrders ; -- 458 rows are returned (6 + 452)


--*****************************************************************************************

/* INSERT EXEC statement will insert the result set returned by a stored procedure
The procedure called sp_Sales.OrderYear wich accepts an order year and return the orders for this year
*/

-- check if the procedure is already exists
IF OBJECT_ID(N'sp_SalesOrderYear', N'P') IS NOT NULL
	DROP PROCEDURE sp_SalesOrderYear ; 
GO ;
--create the procedure
CREATE PROCEDURE sp_SalesOrderYear
	@TerritoryID INT
AS
BEGIN 
SELECT SalesOrderID, OrderDate, CustomerID, SalesPersonID, TerritoryID, SubTotal
FROM AdventureWorks2012.Sales.SalesOrderHeader 
WHERE TerritoryID = @TerritoryID 
	AND SalesPersonID IS NOT NULL 
END ; 
GO ;

EXECUTE  sp_SalesOrderYear  -- run the procedure sp_SalesOrderYear
	@TerritoryID = 2
	  -- set the parameter 
--342 rows are returned 

--invoke the stored procedure with @SubTotal = 70
SET IDENTITY_INSERT AdventureWorks2012.Sales.MyOrders ON ; 

INSERT INTO AdventureWorks2012.Sales.MyOrders
(SalesOrderID, OrderDate, CustomerID, SalesPersonID, TerritoryID, SubTotal) 
	EXECUTE  sp_SalesOrderYear  -- run the procedure sp_SalesOrderYear
	@TerritoryID = 2; --342 rows affected 

SET IDENTITY_INSERT AdventureWorks2012.Sales.MyOrders OFF; 

SELECT * FROM AdventureWorks2012.Sales.MyOrders ; --800 rows returned (458 + 342)

GO 


--****************************************************************************************
-- SELECT INTO statement at queries
/* this statement creates the target table based on the definition of the source 
	and inserts the result rows from the query into the table. 
	Column names, types, nullability and IDENTITY property will be kept, 
	but indexes, constraints, triggers, permissions are not copied. 

	Because I was not able to find a table with IDENTITY property 
	in AdventureWorks2012 database, I will create the table Sales.MyOrders2

*/

USE AdventureWorks2012 ; 
GO 

-- check if the table Sales.MyOrders2 already exists
IF OBJECT_ID(N'Sales.MyOrders2', N'U') IS NOT NULL
	DROP TABLE Sales.MyOrders2 ;  
 
 CREATE TABLE AdventureWorks2012.Sales.MyOrders2
(
	SalesOrderID INT NOT NULL IDENTITY(1,1) -- the column has IDENTITY property with seed 1 and an increment 1
	--this property will generate values in this column automatically when rows are inserted 
		CONSTRAINT PK_MyOrders2_SalesOrderID PRIMARY KEY
	, OrderDate DATE NOT NULL
		CONSTRAINT DFT_MyOrders2_OrderDate DEFAULT (CAST(SYSDATETIME() AS DATE))
	, CustomerID INT NOT NULL
	, SalesPersonID INT NOT NULL
	, TerritoryID INT NOT NULL
	, SubTotal MONEY  NULL
) ; 

SELECT * FROM Sales.MyOrders2 ; 

--populate the table with some data
INSERT INTO AdventureWorks2012.Sales.MyOrders2
( OrderDate, CustomerID, SalesPersonID, TerritoryID, SubTotal) 
VALUES 
('20150620',124, 276,4, 178.90), 
(DEFAULT, 202, 282, 6, 307.38), --DEFAULT will generate today's date 2018-03-28
(DEFAULT, 110, 280, 1, 55.0), 
('20110917',155, 280, 1, 134.55); --4 rows 


/* to check, if a column has IDENTITY property:
	 SELECT COLUMNPROPERTY(OBJECT_ID('tbl_name'), 'column_name', 'IsIdentity')
    if returens 1 the column has IDENTITY property
*/
SELECT COLUMNPROPERTY(OBJECT_ID('Sales.MyOrders2'), 'SalesOrderID', 'IsIdentity')
-- returns 1, thus the column SalesOrderID had IDENTITY property

SELECT COLUMNPROPERTY(OBJECT_ID('Sales.MyOrders2'), 'TerritoryID', 'IsIdentity')
--returns 0, thus the column TerritoryID doesn't have IDENTITY property




