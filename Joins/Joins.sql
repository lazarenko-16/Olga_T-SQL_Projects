-- Date: Dec 24, 2017
-- Project Name: Inner joins at T-SQL
-- Author: Olga Lazarenko
-- Description: at this home lab project I create inner joins to retriev data from AdventureWorks2012 DB

USE AdventureWorks2012 ; -- call the database

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



