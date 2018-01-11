-- Date: Dec 24, 2017
-- Project Name: Inner joins at T-SQL
-- Author: Olga Lazarenko
-- Description: at this home lab project I create inner joins to retriev data from AdventureWorks2012 DB

USE AdventureWorks2012 ; -- call the database
GO


SELECT ProductCategoryID
	, Name
FROM Production.ProductCategory ; 

SELECT ProductSubcategoryID
	, ProductCategoryID
	, Name as SubcategoryName 
FROM Production.ProductSubcategory ; 

SELECT Name As CategoryName
	, ProductCategoryID
FROM AdventureWorks2012.Production.ProductCategory ; 

SELECT Name as SubcategoryName 
	, ProductSubcategoryID 
	, ProductCategoryID
FROM Production.ProductSubcategory ;


-- #1 Retrieve datambine data from tbl Productioin.ProductCategory and ProductionSubcategory using join
SELECT Table1.ProductCategoryID AS CategoryID
	, Table1.Name AS Category
	, Table2.Name AS SubCategory
	,Table2.ProductSubcategoryID AS SubCategoryID
FROM AdventureWorks2012.Production.ProductCategory AS Table1
	INNER JOIN
	AdventureWorks2012.Production.ProductSubcategory AS Table2
	ON Table1.ProductCategoryID = Table2.ProductCategoryID ; 

-- #4
--SELECT CustomerID 
--	, PersonID
--	, StoreID
--FROM AdventureWorks2012.Sales.Customer ; 
-- Retrieved 19820 rows

SELECT BusinessEntityID
	--, PersonType
	--, Title
	--, FirstName
	--, LastName
	--, Demographics
	, (FirstName +' '+ LastName) AS PersonName
FROM AdventureWorks2012.Person.Person 
ORDER BY BusinessEntityID ; -- returned 19972 rows

-- Inner join between two tables Sales.Customer and Person.Person.
SELECT C.PersonID AS CustomerID
	, P.FirstName 
	, P.LastName
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID ; -- to have the matching rows between these two tables
-- 19119 rows are returned


--Left Join between table Sales.Customer and Person.Person
-- to have the all rows from Sales.Customers and the corresponding rows from Person.Person
-- the final table can contain null values in case there is/are not matching row/s at Person.Person.
SELECT C.PersonID AS CustomerID
	, P.FirstName 
	, P.LastName
FROM AdventureWorks2012.Sales.Customer AS C
	LEFT JOIN  AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
ORDER BY CustomerID ; -- non-matching rows will be displayed before the matching ones
--19820 rows are returned


-- Right join: to have all rows from Person.Person and matching and non-matching rows from Sales.Customer
SELECT C.PersonID AS CustomerID
	, P.FirstName 
	, P.LastName
FROM AdventureWorks2012.Sales.Customer AS C
	RIGHT JOIN  AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
ORDER BY CustomerID ; 
-- returned 19972 rows


-- Full Outer join: display all rows from Sales.Customer and Person.Person
SELECT C.PersonID AS CustomerID
	, P.FirstName 
	, P.LastName
FROM AdventureWorks2012.Sales.Customer AS C
	FULL OUTER JOIN  AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
ORDER BY CustomerID ; 
--returned 20673 rows



--#5
SELECT Distinct CustomerID
FROM Sales.SalesOrderHeader ; 
/* 19119 rows are returned, it means that 19119 customers made orders 
but we have 19820 customers (Sales.Customer table) and 
19119 customers first and last names (Person.Person)
It means that not all customers from Sales.Customer placed their orders 
and we don't have the names for all of them.

We want to retrieve data to have the  table containing :
CustomerID/FirstName/LastName/SalesOrderNumber/SubTotal

As well we want to have data for the  table:
CustomerID/FirstName/LastName/NumberOfOrders/OrdersTotal 
where NumberOfOrders is COUNT(SalesOrderNumber)
and OrdersTotal is SUM(SubTotal) 
the following aggregates are grouped by CustomerID
*/



	--#2 combine data from tables Production.ProductInventory and Production.Location
	SELECT ProductID
		, LocationID
		, Quantity
	FROM Production.ProductInventory ; 

	SELECT LocationID
		, Name As LocationName
	FROM Production.Location ; 

	SELECT t2.Name AS LocationName
		, t1.Shelf
		, t1.Bin
		, t1.ProductID 
		, t1.Quantity AS Qty
	FROM AdventureWorks2012.Production.ProductInventory AS t1
		INNER JOIN AdventureWorks2012.Production.Location AS t2
		ON t1.LocationID = t1.LocationID ; 


	SELECT ProductModelID
		, Name AS ModelName
	FROM Production.ProductModel ; 

	SELECT ProductDescriptionID
		, Description
	FROM Production.ProductDescription ; 



-- #3 Join three tables to retrieve data 
	/*  to have ProductModelsID, ModelName and Description as the result table
    talbes:
	Production.ProductModel
	ProductModelProductDescriptionCulture
	Production.ProductDescription
	*/
	SELECT M.ProductModelID
		, M.Name AS ModelName
		, D.Description
	FROM AdventureWorks2012.Production.ProductModel AS M
		INNER JOIN 
		AdventureWorks2012.Production.ProductModelProductDescriptionCulture AS C
		ON M.ProductModelID = C.ProductDescriptionID
		INNER JOIN 
		AdventureWorks2012.Production.ProductDescription AS D
		ON C.ProductDescriptionID = D.ProductDescriptionID ;

-- modify the above query to have ModelName with 'Frame'

	SELECT M.ProductModelID
		, M.Name AS ModelName
		, D.Description
	FROM AdventureWorks2012.Production.ProductModel AS M
		INNER JOIN 
		AdventureWorks2012.Production.ProductModelProductDescriptionCulture AS C
		ON M.ProductModelID = C.ProductDescriptionID
		INNER JOIN 
		AdventureWorks2012.Production.ProductDescription AS D
		ON C.ProductDescriptionID = D.ProductDescriptionID 
	WHERE M.Name Like '%Frame%';

-- #4
--SELECT CustomerID 
--	, PersonID
--	, StoreID
--FROM AdventureWorks2012.Sales.Customer ; 
-- Retrieved 19820 rows

SELECT BusinessEntityID
	--, PersonType
	--, Title
	--, FirstName
	--, LastName
	--, Demographics
	, (FirstName +' '+ LastName) AS PersonName
FROM AdventureWorks2012.Person.Person 
ORDER BY BusinessEntityID ; -- returned 19972 rows

-- Inner join between two tables Sales.Customer and Person.Person.
SELECT C.PersonID AS CustomerID
	, P.FirstName 
	, P.LastName
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID ; -- to have the matching rows between these two tables
-- 19119 rows are returned


--Left Join between table Sales.Customer and Person.Person
-- to have the all rows from Sales.Customers and the corresponding rows from Person.Person
-- the final table can contain null values in case there is/are not matching row/s at Person.Person.
SELECT C.PersonID AS CustomerID
	, P.FirstName 
	, P.LastName
FROM AdventureWorks2012.Sales.Customer AS C
	LEFT JOIN  AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
ORDER BY CustomerID ; -- non-matching rows will be displayed before the matching ones
--19820 rows are returned


-- Right join: to have all rows from Person.Person and matching and non-matching rows from Sales.Customer
SELECT C.PersonID AS CustomerID
	, P.FirstName 
	, P.LastName
FROM AdventureWorks2012.Sales.Customer AS C
	RIGHT JOIN  AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
ORDER BY CustomerID ; 
-- returned 19972 rows


-- Full Outer join: display all rows from Sales.Customer and Person.Person
SELECT C.PersonID AS CustomerID
	, P.FirstName 
	, P.LastName
FROM AdventureWorks2012.Sales.Customer AS C
	FULL OUTER JOIN  AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
ORDER BY CustomerID ; 
--returned 20673 rows



--#5
SELECT Distinct CustomerID
FROM Sales.SalesOrderHeader ; 
/* 19119 rows are returned, it means that 19119 customers made orders 
but we have 19820 customers (Sales.Customer table) and 
19119 customers first and last names (Person.Person)
It means  not all customers from Sales.Customer placed their orders 
and we don't have the names for all of them.

We want to retrieve the  data to have the  table containing :
CustomerID/FirstName/LastName/SalesOrderNumber/SubTotal

As well we want to have the data for the  table:
CustomerID/FirstName/LastName/NumberOfOrders/OrdersTotal
 
where NumberOfOrders is COUNT(SalesOrderNumber)
and OrdersTotal is SUM(SubTotal) 
the following aggregates are grouped by CustomerID
*/

SELECT SalesOrderID
	, SalesOrderNumber
	, CustomerID
	, SubTotal
FROM Sales.SalesOrderHeader ; 
--returned 31465 rows

SELECT 
	 CustomerID
	, SUM(SubTotal) AS OrdersTotal
FROM Sales.SalesOrderHeader 
GROUP BY CustomerID 
ORDER BY CustomerID ; 
-- returned 19119 rows, it means 19119 customers made orders

--create inner join between tables Person.Person  and Sales.Customer;
-- after this create inner join with this derived table and table Sales.SalesOrderHeader

SELECT C.CustomerID
	--, P.FirstName
	--, P.LastName
	, SUM(SubTotal) AS OrdersTotal
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
	INNER JOIN AdventureWorks2012.Sales.SalesOrderHeader AS O
		ON C.CustomerID = O.CustomerID 
GROUP BY C.CustomerID ; 
-- retured 19119 rows
 

SELECT C.CustomerID
	, (P.LastName + ' ' + P.FirstName) AS CustomerName
	, COUNT(SalesOrderNumber) As Orders
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN AdventureWorks2012.Sales.SalesOrderHeader AS O
		ON C.CustomerID = O.CustomerID 
	INNER JOIN AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
GROUP BY C.CustomerID ,(P.LastName + ' ' + P.FirstName)
ORDER BY CustomerName ; 
-- returned 19119 rows


-- we can find 10 top customers with max spendings(Total)
SELECT TOP 10
	C.CustomerID
	, SUM(SubTotal) AS OrdersTotal
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
	INNER JOIN AdventureWorks2012.Sales.SalesOrderHeader AS O
		ON C.CustomerID = O.CustomerID 
GROUP BY C.CustomerID
ORDER BY OrdersTotal DESC ; -- returned 10 rows

-- when we create joins we also can use HAVING clause to filer the data
-- for example we retriev the data CustomerID/CustomerName/OrdersTotal with OrdersTotal>500000
SELECT C.CustomerID
	, SUM(SubTotal) AS OrdersTotal
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID 
	INNER JOIN AdventureWorks2012.Sales.SalesOrderHeader AS O
		ON C.CustomerID = O.CustomerID 
GROUP BY C.CustomerID
HAVING SUM(SubTotal) > 500000
ORDER BY OrdersTotal DESC ; 


--#6
-- we well add the territory name 
SELECT C.CustomerID
	, (P.LastName + ' ' + P.FirstName) AS CustomerName
	, SUM(SubTotal) AS OrdersTotal
	, T.Name AS TerritoryName
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN AdventureWorks2012.Sales.SalesOrderHeader AS O
		ON C.CustomerID = O.CustomerID 
	INNER JOIN AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID
	INNER JOIN AdventureWorks2012.Sales.SalesTerritory AS T
		ON C.TerritoryID = T.TerritoryID 
GROUP BY C.CustomerID ,(P.LastName + ' ' + P.FirstName),T.Name -- notice we have to group on each joined table
ORDER BY OrdersTotal DESC ; 
--returned 19119 rows


-- and if we want to filter only for a specific territory ( for example Canada)
SELECT C.CustomerID
	, (P.LastName + ' ' + P.FirstName) AS CustomerName
	, SUM(SubTotal) AS OrdersTotal
	, T.Name AS TerritoryName
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN AdventureWorks2012.Sales.SalesOrderHeader AS O
		ON C.CustomerID = O.CustomerID 
	INNER JOIN AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID
	INNER JOIN AdventureWorks2012.Sales.SalesTerritory AS T
		ON C.TerritoryID = T.TerritoryID 
GROUP BY C.CustomerID ,(P.LastName + ' ' + P.FirstName),T.Name -- notice we have to group on each joined table
HAVING T.Name = 'Canada'
ORDER BY OrdersTotal DESC ;
--got 1677 rows

-- now we use a wildcard for HAVING clause
SELECT C.CustomerID
	, (P.LastName + ' ' + P.FirstName) AS CustomerName
	, SUM(SubTotal) AS OrdersTotal
	, T.Name AS TerritoryName
FROM AdventureWorks2012.Sales.Customer AS C
	INNER JOIN AdventureWorks2012.Sales.SalesOrderHeader AS O
		ON C.CustomerID = O.CustomerID 
	INNER JOIN AdventureWorks2012.Person.Person AS P
		ON C.PersonID = P.BusinessEntityID
	INNER JOIN AdventureWorks2012.Sales.SalesTerritory AS T
		ON C.TerritoryID = T.TerritoryID 
GROUP BY C.CustomerID ,(P.LastName + ' ' + P.FirstName),T.Name -- notice we have to group on each joined table
HAVING T.Name LIKE '%west'
ORDER BY OrdersTotal DESC ;
--returned 7993 rows

