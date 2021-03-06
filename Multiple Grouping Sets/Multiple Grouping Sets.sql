--Data: Feb 1,2018
--Project Name: Multiple Grouping Sets
--Author: Olga Lazarenko
--Description: create queries with multiple grouping sets clauses: 
--				GROUPING SETS, CUBE, ROLLUP


USE AdventureWorks2012 ; -- Call AdventureWorksw2012 database 
GO 

--GROUPING SETS  clause : the data will be grouped in more then one way using a list of grouping sets 
SELECT 
	OrganizationLevel
	, Gender
	, AVG(VacationHours) AS Average_VacationHours
FROM AdventureWorks2012.HumanResources.Employee 
GROUP BY GROUPING SETS
(
	  (OrganizationLevel, Gender)
	, (OrganizationLevel		)
	, (Gender					)
) ; 



SELECT 
	DepartmentID 
	, YEAR(StartDate) AS StartYear 
	, COUNT(BusinessEntityID) AS Employees
FROM AdventureWorks2012.HumanResources.EmployeeDepartmentHistory
WHERE DepartmentID > 0  
GROUP BY GROUPING SETS
(
	  (DepartmentID, YEAR(StartDate))

)
ORDER BY DepartmentID , YEAR(StartDate) ; 

SELECT Distinct(DepartmentID) 
FROM AdventureWorks2012.HumanResources.EmployeeDepartmentHistory ; 



-- ********************************************************************************************
--ROLLUP clause is used to have aggregations for each grouping element and the final aggregation
 SELECT DepartmentName AS Department
	, Gender
	, MaritalStatus
	, AVG(BaseRate) AS AvgRate
	, AVG(VacationHours) AS AvgVacationHours
	, MAX(SickLeaveHours) AS MaxSickLeaveHours
FROM AdventureWorksDW2012.Employee 
GROUP BY  DepartmentName, Gender, MaritalStatus;
  --returns 51 rows

SELECT DepartmentName AS Department
	, Gender
	, MaritalStatus
	, AVG(BaseRate) AS AvgRate
	, AVG(VacationHours) AS AvgVacationHours
	, MAX(SickLeaveHours) AS MaxSickLeaveHours
FROM AdventureWorks2012.Employee 
GROUP BY ROLLUP ( DepartmentName, Gender, MaritalStatus);
  /* returns 98 rows
   with a hierarchy formed by the input elements ( DepartmentName, Gender, MaritalStatus)
   and NUlls at the result are used as placeholders when the element is not  part of the grouping set.
   ROLLUP provides totals using the elements in ( DepartmentName, Gender, MaritalStatus)

   There are aggregations:
		for each department
			for each gender group in this department
				for each marital status in each group
		grand total (at the end of the result set)
 */

SELECT DepartmentName AS Department
	, Gender
	, MaritalStatus
	, AVG(BaseRate) AS AvgRate
	, AVG(VacationHours) AS AvgVacationHours
	, MAX(SickLeaveHours) AS MaxSickLeaveHours
FROM AdventureWorks2012.DimEmployee 
GROUP BY 
	DepartmentName
	, Gender
	, MaritalStatus
WITH ROLLUP ;
  -- returns with 98 rows, the result is the same as from the above query

USE SQLClass ; -- use SQLClass database
GO

SELECT Region
	, CountryCode
	, CardType
	, SUM(TotalDue)
FROM SQLClass.Sales_CreditCard 
GROUP BY 
	Region
	, CountryCode
	, CardType 
ORDER BY 
	Region
	, CountryCode
	, CardType ; -- returns 24 rows


 SELECT 
	Region
	, CountryCode
	, CardType
	, SUM(TotalDue)
FROM SQLClass.Sales_CreditCard 
GROUP BY 
	Region
	, CountryCode
	, CardType 
WITH ROLLUP
ORDER BY 
	Region
	, CountryCode
	, CardType ; -- returns 34 rows

	-- or
SELECT Region
	, CountryCode
	, CardType
	, SUM(TotalDue)
FROM  SQLClass.Sales_CreditCard
GROUP BY ROLLUP 
  (
	Region
	, CountryCode
	, CardType 
	)
ORDER BY 
	Region
	, CountryCode
	, CardType ; -- returns 34 rows 

	--**************************************************************
USE AdventureWorks2012 ; 
GO

SELECT 
	D.DepartmentID
	, D.ShiftID
	, S.Name AS ShiftName
	, COUNT(BusinessEntityID) AS Employees
FROM AdventureWorks2012.HumanResources.EmployeeDepartmentHistory AS D
	INNER JOIN
	AdventureWorks2012.HumanResources.Shift AS S
	ON D.ShiftID = S.ShiftID 
GROUP BY
	 D.DepartmentID
	 , D.ShiftID
	 , S.Name 
ORDER BY 
	D.DepartmentID
	, D.SHiftID ; 


SELECT 
	--DH.DepartmentID
	 D.Name AS Department
	, S.Name AS ShiftName
	, COUNT(BusinessEntityID) AS Employees
FROM AdventureWorks2012.HumanResources.EmployeeDepartmentHistory AS DH
	INNER JOIN
	AdventureWorks2012.HumanResources.Shift AS S
	ON DH.ShiftID = S.ShiftID 
	INNER JOIN
	AdventureWorks2012.HumanResources.Department AS D
	ON D.DepartmentID = DH.DepartmentID 
WHERE DH.DepartmentID BETWEEN 7 AND 9
GROUP BY
	 --DH.DepartmentID
	  D.Name 
	 , S.Name
WITH ROLLUP
ORDER BY 
	D.Name DESC 
	 ; 

-- more queries with ROLLUP grouping clause
SELECT  -- this is usuall groupoing query
	YEAR(SellStartDate) AS SellYear
	, Color
	, AVG(ListPrice) AS Avg_ListPrice
FROM AdventureWorks2012.Production.Product 
GROUP BY 
	YEAR(SellStartDate)
	, Color
ORDER BY 
	SellYear
	, Color ; --24 rows returned
	/* at the column color there are null values, because this colunm Color allows them,
	and there are Average List Price corresponding to the null values for Color, grouped by SellYear

	The column SellStartDate doesn't allow to use null values, 
	so we don't have any problem with the totals of aggretations here
	*/


 SELECT 
	YEAR(SellStartDate) AS SellYear
	, Color
	, AVG(ListPrice) AS Avg_ListPrice
FROM AdventureWorks2012.Production.Product 
GROUP BY 
	YEAR(SellStartDate)
	, Color
WITH ROLLUP
ORDER BY 
	SellYear
	, Color ; --29 rows returned 
	/* in case using ROLLUP clause and if the grouping column Color allows nulls,
	at the result we cannot distinguis the total for the null values and the total for a specific color
	in this case we can use GROUPING or GROUPING_ID

	GROUPING will identify a column/row being used for a total (or any other aggregation) : 
	1 will be for identify the aggration for null values 
	in our case 1 will be for the average for  a group, other flag for an individual values

	so, if NULL color has a flag of 1,  it means the aggregation is  for the whole group of a year
	if NULL color has zero as a flag, it means the aggregation is for individual value of color grou8p
	*/

	-- we use GROUPING  
SELECT 
	YEAR(SellStartDate) AS SellYear -- we don't use GROUPING here, because SellStartDate colomn doesn't allow null values 
	, Color -- this column allow to use null values, so we will use GROUPING 
	, GROUPING(Color) AS flag_color_null
	/* if Color_Total is 1, the corresponding Avg_ListPrice is for the aggregation for the whole group
	, if Color_Total is 0, the aggregation is for null values for an individual item in the group

	but using GROUPING will will have additional columns, and this can be considered as a disadvantage
	in our case it is only one additional column, but in other  queries  we can have more of them 
	*/
	, AVG(ListPrice) AS Avg_ListPrice
FROM AdventureWorks2012.Production.Product 
GROUP BY 
	YEAR(SellStartDate)
	, Color
WITH ROLLUP
ORDER BY 
	SellYear
	, Color ; 

  /* we can use:
  . . . . . . . . 
  GROUP BY 
	YEAR(SellStartDate)
	, Color
WITH ROLLUP
ORDER BY 
	SellYear
	, Color 

or
. . . . . . . . . . 
GROUP BY ROLLUP
	(
	YEAR(SellStartDate)
	, Color
	)
ORDER BY 
	SellYear
	, Color ;

*/

 SELECT 
	YEAR(SellStartDate) AS SellYear
	, Color
	, GROUPING(Color) AS flag_color_null
	, AVG(ListPrice) AS Avg_ListPrice
FROM AdventureWorks2012.Production.Product 
GROUP BY ROLLUP
	(
	YEAR(SellStartDate)
	, Color
	)
ORDER BY 
	SellYear
	, Color ;


--***************************************************************************
-- modify the previous query by adding additional grouping by Class, Style ( both columns allow null values)

SELECT DISTINCT Class -- NULL, H, L, M
FROM AdventureWorks2012.Production.Product ;

SELECT DISTINCT Style -- NULL, M, U, W
FROM AdventureWorks2012.Production.Product ;


 SELECT 
	YEAR(SellStartDate) AS SellYear
	, Style
	, GROUPING(Style) AS flag_style
	, Color
	, GROUPING(Color) AS flag_color
	, AVG(ListPrice) AS Avg_ListPrice
FROM AdventureWorks2012.Production.Product 
GROUP BY ROLLUP
	(
	YEAR(SellStartDate)
	, Style
	, Color
	)
ORDER BY 
	SellYear
	, Style
	, Color ; 
	--51 rows returned

/* use GROUPING_ID to accept multiple grouping parameters and avoid overwelming the result table with additional columns
a bitmat is used to identify which columns are being used for the aggreations
*/

 SELECT GROUPING_ID(YEAR(SellStartDate),Style,Color) AS BitMap
	, YEAR(SellStartDate) AS SellYear
	, Style
	, Color
	, AVG(ListPrice) AS Avg_ListPrice
FROM AdventureWorks2012.Production.Product 
GROUP BY ROLLUP
	(
	YEAR(SellStartDate)
	, Style
	, Color
	)
ORDER BY 
	SellYear
	, Style
	, Color ; 
	-- 51 rows returned


	--*****************************************************************************************************
	-- CUBE grouping clause
	/* provides totals/other aggregations for all combinations of columns on GROUP BY 
	with keeping the hierarchy
	*/

SELECT
	 YEAR(SellStartDate) AS SellYear
	, Style
	, Color
	, AVG(ListPrice) AS Avg_ListPrice
FROM AdventureWorks2012.Production.Product 
GROUP BY CUBE
	(
	YEAR(SellStartDate)
	, Style
	, Color
	)
ORDER BY 
	SellYear
	, Style
	, Color ; 
--OR
SELECT
	 YEAR(SellStartDate) AS SellYear
	, Style
	, Color
	, AVG(ListPrice) AS Avg_ListPrice
FROM AdventureWorks2012.Production.Product 
GROUP BY 
	YEAR(SellStartDate)
	, Style
	, Color
WITH CUBE
ORDER BY 
	SellYear
	, Style
	, Color ; 
/*  108 rows returned, compare with ROLLUP 51 rows returned (the previous query)
all the possible combinations of SellYear,Style,Color with the hierarchy:
1) SellYear,Style,Color
2) SellYear,Style
3) SellYear,Color
4) Style,Color
5) Color
6) SellYear
7) Style 
*/

	 SELECT GROUPING_ID(YEAR(SellStartDate),Style,Color) AS BitMap
	 , YEAR(SellStartDate) AS SellYear
	, Style
	, Color
	, AVG(ListPrice) AS Avg_ListPrice
FROM AdventureWorks2012.Production.Product 
GROUP BY CUBE
	(
	YEAR(SellStartDate)
	, Style
	, Color
	)
ORDER BY 
	SellYear
	, Style
	, Color ; 


-- with GROPING SETS we can tell the query how we want to group data, how to total up the data
-- desired totals

/****** Script for SelectTopNRows command from SSMS  ******/

USE AdventureWorks2012 ; 

SELECT DISTINCT LocationID 
FROM AdventureWorks2012.Production.ProductInventory 
ORDER BY LocationID ; 

SELECT DISTINCT Shelf 
FROM AdventureWorks2012.Production.ProductInventory 
ORDER BY Shelf ; 

SELECT DISTINCT Bin 
FROM AdventureWorks2012.Production.ProductInventory 
ORDER BY Bin ; 

-- Location, Shelf, Bincolumns don't allow null values (they are not null)
SELECT 
	LocationID
	, Shelf
	, Bin
	, SUM(Quantity) AS TotalQty 
FROM AdventureWorks2012.Production.ProductInventory
WHERE LocationID IN (10,20) 
	AND Shelf IN ('A','B','C')
	AND Bin IN (1,2,3)
GROUP BY 
	LocationID
	, Shelf
	, Bin 
ORDER BY 
	LocationID 
	, Shelf DESC
	, Bin ; 
	-- 8 rows returned

--GROUPING SETS
SELECT 
	LocationID
	, Shelf
	, Bin
	, SUM(Quantity) AS TotalQty 
FROM AdventureWorks2012.Production.ProductInventory
WHERE LocationID IN (10,20) 
	AND Shelf IN ('A','B','C')
	AND Bin IN (1,2,3)
GROUP BY GROUPING SETS
	(
		(LocationID,Shelf,Bin)
		, (LocationID,Shelf)
		, (Bin)
	)
ORDER BY 
	LocationID 
	, Shelf DESC
	, Bin ; 
	--14 rows returned

SELECT 
	LocationID
	, Shelf
	, Bin
	, SUM(Quantity) AS TotalQty 
FROM AdventureWorks2012.Production.ProductInventory
WHERE LocationID IN (10,20) 
	AND Shelf IN ('A','B','C')
	AND Bin IN (1,2,3)
GROUP BY GROUPING SETS
	(
		(LocationID,Shelf,Bin)-- first grouped by LocationID, after this by Shelf and finally by Bin
		, (LocationID,Shelf)-- Bin is NULL, grouped by LocationID and Shelf
		, (Bin) -- grouping by Bin IN (1,2,3) and Shelf and LocationID are NULLs
		, () -- gives the grand total 
	)
ORDER BY 
	LocationID 
	, Shelf DESC
	, Bin ; 
	--14 rows returned

-- ROLLUP
SELECT 
	LocationID
	, Shelf
	, Bin
	, SUM(Quantity) AS TotalQty 
FROM AdventureWorks2012.Production.ProductInventory
WHERE LocationID IN (10,20) 
	AND Shelf IN ('A','B','C')
	AND Bin IN (1,2,3)
GROUP BY ROLLUP 
	(
		LocationID
		, Shelf
		, Bin
	)
ORDER BY 
	LocationID 
	, Shelf DESC
	, Bin ; 
	--14 rows returned

--CUBE
SELECT 
	LocationID
	, Shelf
	, Bin
	, SUM(Quantity) AS TotalQty 
FROM AdventureWorks2012.Production.ProductInventory
WHERE LocationID IN (10,20) 
	AND Shelf IN ('A','B','C')
	AND Bin IN (1,2,3)
GROUP BY CUBE
	(
		LocationID
		, Shelf
		, Bin
	)
ORDER BY 
	LocationID 
	, Shelf DESC
	, Bin ; 
	--34 rows returned, some rows can be duplicated

--*************************************************************************

USE AdventureWorks2014 ; 
GO 

CREATE VIEW v_EmpDept -- I will work with this view ( joins three tables) and Window functions
AS
(
SELECT  DH.DepartmentID AS DeptID
	, D.[Name] AS DeptName
	--, D.GroupName AS GroupName
	, E.BusinessEntityID AS EmpID
	, E.Gender AS Gender
	, E.MaritalStatus AS MaritalStatus
	--, E.HireDate
	, E.VacationHours
	, E.SickLeaveHours
FROM HumanResources.Employee AS E
INNER JOIN 
	HumanResources.EmployeeDepartmentHistory AS DH
	ON E.BusinessEntityID = DH.BusinessEntityID 
INNER JOIN 
	HumanResources.Department AS D
	ON DH.DepartmentID = D.DepartmentID
)
; 
GO 

ALTER VIEW dbo.v_EmpDept
AS
(
SELECT  DH.DepartmentID AS DeptID
	, D.[Name] AS DeptName
	, S.[Name] AS [Shift]
	--, D.GroupName AS GroupName
	, E.BusinessEntityID AS EmpID
	, E.JobTitle
	, E.Gender AS Gender
	, E.MaritalStatus AS MaritalStatus
	--, E.HireDate
	, E.VacationHours
	, E.SickLeaveHours
	, PH.Rate
	, PH.PayFrequency
FROM HumanResources.Employee AS E
INNER JOIN 
	HumanResources.EmployeeDepartmentHistory AS DH
	ON E.BusinessEntityID = DH.BusinessEntityID 
INNER JOIN 
	HumanResources.Department AS D
	ON DH.DepartmentID = D.DepartmentID
INNER JOIN 
	HumanResources.[Shift] AS S
	ON DH.ShiftID = S.ShiftID
INNER JOIN 
	HumanResources.EmployeePayHistory AS PH
	ON E.BusinessEntityID = PH.BusinessEntityID
WHERE DH.DepartmentID IN (7,8,15)
)
; 
GO

SELECT * FROM dbo.v_EmpDept 
ORDER BY DeptID 
; 


SELECT DeptID
	, DeptName 
	, Gender
	, COUNT(EmpID) AS NumOfEmp
FROM dbo.v_EmpDept
 
GROUP BY GROUPING SETS 
	(
		( DeptID,DeptName,  Gender)
		, ()
	)
;

--********************************************************************

USE AdventureWorksDW2014 ; 
GO 

-- count the sales persons by TerritoryGroup, TerritoryName from Sales.vSalesPerson

SELECT TerritoryGroup
	, TerritoryName
	, COUNT(BusinessEntityID) AS NumberOfSalesPerson
FROM [AdventureWorks2014].[Sales].[vSalesPerson] 
GROUP BY GROUPING SETS 
	(
		(TerritoryGroup, TerritoryName)
		--, (TerritoryGroup)
		--, (TerritoryName)
		--, ()
		)
HAVING TerritoryGroup NOT LIKE 'Pacific'
ORDER BY TerritoryGroup DESC , TerritoryName 
;
--9 rows returned for TerritoryGroup NorthAmerica and Europe
/* the columns TerritoryGroup and TerritoryName allow NULL values, 
but there the query result doesn't include number of sales persons 
for NULL values for these columns */

-- to check if the data have NULLs in TerritoryGroup and TerritoryName
SELECT BusinessEntityID
	, TerritoryGroup
	, TerritoryName
FROM [AdventureWorks2014].[Sales].[vSalesPerson]
WHERE  (TerritoryGroup IS NULL 
	OR TerritoryName IS NULL )
; -- 3 rows returned 

SELECT TerritoryGroup
	, TerritoryName
	, COUNT(BusinessEntityID) AS NumberOfSalesPerson
FROM [AdventureWorks2014].[Sales].[vSalesPerson] 
GROUP BY GROUPING SETS 
	(
		(TerritoryGroup, TerritoryName)
		--, (TerritoryGroup)
		--, (TerritoryName)
		--, ()
		)
--HAVING TerritoryGroup NOT LIKE 'Pacific'     the filtering confition is not applyed 
ORDER BY TerritoryGroup DESC , TerritoryName 
; -- 11 rows returned including the number of sales persons for NULLs in TerritoryGroup and TerritoryName





SELECT TerritoryGroup
	, TerritoryName
	, COUNT(BusinessEntityID) AS NumberOfSalesPerson
FROM [AdventureWorks2014].[Sales].[vSalesPerson]
--WHERE TerritoryGroup NOT LIKE 'Pacific' -- the filtering condition 
GROUP BY GROUPING SETS 
	(
		(TerritoryGroup, TerritoryName)
		, (TerritoryGroup)
		, (TerritoryName)
		, ()
		)
ORDER BY TerritoryGroup DESC , TerritoryName DESC
;



SELECT TerritoryGroup -- allows NULLs
	, TerritoryName -- allows NULLS 
	, COUNT(BusinessEntityID) AS NumberOfSalesPerson
FROM [AdventureWorks2014].[Sales].[vSalesPerson]
GROUP BY GROUPING SETS 
	(
		(TerritoryGroup, TerritoryName)
		--, (TerritoryGroup)
		--, (TerritoryName)
		, ()
		)
ORDER BY TerritoryGroup DESC , TerritoryName DESC ;
 -- 12 rows returned
/* in this case we cannot distinguish aggregations for the columns allowing NULLs and 
the grand total ()
*/


-- use GROUPING and GROUPING_ID to distinguish aggregatios for the grouping sets and for the NULLs
SELECT TerritoryGroup -- allows NULLs
	, TerritoryName -- allows NULLS 
	, COUNT(BusinessEntityID) AS NumberOfSalesPerson
	, GROUPING(TerritoryGroup) AS gr_TerGroup -- if 1 it is for NULLs, 0 for grouping sets
	, GROUPING(TerritoryName) AS gr_TerName
FROM [AdventureWorks2014].[Sales].[vSalesPerson]
GROUP BY GROUPING SETS 
	(
		(TerritoryGroup, TerritoryName)
		--, (TerritoryGroup)
		--, (TerritoryName)
		, ()
		) 
ORDER BY TerritoryGroup DESC , TerritoryName DESC ; 
 -- from the result we see that the row 11 represents aggregation for the Null values
-- and the row 12 is the grand total 



--I want to put 'Grand Total' at the corresponding cell of the column TerritoryGroup
SELECT 
	CASE
		WHEN GROUPING(TerritoryGroup)=1 THEN 'Grand Total'
		ELSE ISNULL(TerritoryGroup, 'n/a ')-- if TerritoryGroup is NULL, 'Unknown' will be returned 
	END AS TerritoryGroup
	
	, 
	CASE 
		WHEN GROUPING(TerritoryName) = 1 THEN 'Grand Total'
		ELSE ISNULL(TerritoryName, 'n/a')
	END AS TerritoryName

	, COUNT(BusinessEntityID) AS NumberOfSalesPerson
	, GROUPING(TerritoryGroup) AS gr_TerGroup -- if 1 it is for NULLs, 0 for grouping sets
	, GROUPING(TerritoryName) AS gr_TerName
FROM [AdventureWorks2014].[Sales].[vSalesPerson]
GROUP BY GROUPING SETS 
	(
		(TerritoryGroup, TerritoryName)
		--, (TerritoryGroup)
		--, (TerritoryName)
		, ()
		)
;
GO
--*************************************************************************************
USE AdventureWorks2014 ; 
GO

/*calculate the subtotal and the grand total of all sales grouped by the countries and their provinces
ROLLUP() function will be used */

SELECT CountryRegionName AS Country
	, StateProvinceName AS Province
	, SUM(SalesYTD) AS Sales
FROM AdventureWorks2014.Sales.vSalesPerson
GROUP BY ROLLUP(CountryRegionName, StateProvinceName)
--ORDER BY Country, Province   
-- if we use ORDER BY clause, it will be not very useful, 
-- without ORDER BY we have the grand total as the last row of retrieved data
;

/* if substitute NULLs 
(in these example the columns Country and Provice don't allow NULLs, 
thus the NULLs in the result set represent the subtotals and the grand total)
I will use GROUPING/ GROUPING_ID also can be used */
SELECT CountryRegionName AS Country
	, StateProvinceName AS Province
	, SUM(SalesYTD) AS Sales
	, GROUPING(CountryRegionName) AS gr_Country
	, GROUPING(StateProvinceName) AS gr_Province
FROM AdventureWorks2014.Sales.vSalesPerson
GROUP BY ROLLUP(CountryRegionName, StateProvinceName)
;

SELECT 
	CASE
		WHEN GROUPING(CountryRegionName) = 1 THEN 'Total for all counties'
		ELSE CountryRegionName
	END AS CountryRegionName
	, 
	CASE 
		WHEN GROUPING(StateProvinceName) = 1 AND GROUPING(CountryRegionName) = 1 THEN 'Total for all provinves'
		WHEN GROUPING(StateProvinceName) = 1 THEN 'Total for ' + CountryRegionName
		ELSE StateProvinceName
	END AS StateProvinceName
	, SUM(SalesYTD) AS Sales
	, GROUPING(CountryRegionName) AS gr_Country
	, GROUPING(StateProvinceName) AS gr_Province
FROM AdventureWorks2014.Sales.vSalesPerson
GROUP BY ROLLUP(CountryRegionName, StateProvinceName)
;

-- we the final view of the result set, 
SELECT 
	CASE
		WHEN GROUPING(CountryRegionName) = 1 THEN 'Total for all countries'
		WHEN GROUPING(CountryRegionName) = 0 AND GROUPING(StateProvinceName) = 1 THEN ' ' 
		ELSE CountryRegionName
	END AS Country
	, 
	CASE 
		WHEN GROUPING(StateProvinceName) = 1 AND GROUPING(CountryRegionName) = 1 THEN 'Total for all provinves'
		WHEN GROUPING(StateProvinceName) = 1 THEN 'Total for ' + CountryRegionName
		ELSE StateProvinceName
	END AS Province
	, SUM(SalesYTD) AS Sales
	--, GROUPING(CountryRegionName) AS gr_Country
	--, GROUPING(StateProvinceName) AS gr_Province
FROM AdventureWorks2014.Sales.vSalesPerson
GROUP BY ROLLUP(CountryRegionName, StateProvinceName)
; -- 21 rows returned 


SELECT CountryRegionName AS Country
	, StateProvinceName AS Province
	, SUM(SalesYTD) AS Sales
	, GROUPING_ID(CountryRegionName, StateProvinceName) AS gr_ID
FROM AdventureWorks2014.Sales.vSalesPerson
GROUP BY ROLLUP(CountryRegionName, StateProvinceName)
;
/* at this example gr_ID = 1 for the subtotals and gr_ID = 3 for the grand total */

SELECT 
	CASE 
		WHEN GROUPING_ID(CountryRegionName,StateProvinceName) = 3 THEN ' Grand Total ' 
		WHEN GROUPING_ID(CountryRegionName) = 0 AND GROUPING_ID(StateProvinceName) = 1 THEN 'Total for ' + CountryRegionName
		ELSE CountryRegionName
	END AS Country 
	,
	CASE 
		WHEN GROUPING_ID(StateProvinceName) = 1 AND GROUPING_ID(CountryRegionName) = 2 THEN 'Total for '+ CountryRegionName
		WHEN GROUPING_ID(StateProvinceName) =1 THEN ' '
		ELSE StateProvinceName
	END AS Province 
	, SUM(SalesYTD) AS Sales
	, GROUPING_ID(CountryRegionName, StateProvinceName) AS gr_ID
FROM AdventureWorks2014.Sales.vSalesPerson
GROUP BY ROLLUP(CountryRegionName, StateProvinceName)
; -- 21 rows returned 
GO
--***********************************************************************************************

SELECT CountryRegionName AS Country -- the column doesn't allow NULL values
	, StateProvinceName AS Province -- the column doesn't allow NULL values
	, City -- the column doesn't allow NULL values
	, SUM(SalesYTD) AS Sales
FROM AdventureWorks2014.Sales.vSalesPerson 
GROUP BY ROLLUP(CountryRegionName, StateProvinceName) 
; 

-- the grouping columns don't allow NULLs
SELECT 
	CASE
		WHEN GROUPING_ID(CountryRegionName, StateProvinceName, City) = 7 THEN 'Grand Total '
		WHEN GROUPING_ID(CountryRegionName, StateProvinceName, City) = 3 THEN 'Total for ' + CountryRegionName
		
		
		ELSE CountryRegionName
	END AS CountryRegionName 
	, 
	CASE	
		WHEN GROUPING_ID(CountryRegionName, StateProvinceName, City) = 3 THEN 'Total for all provinces of ' + CountryRegionName
		WHEN GROUPING_ID(CountryRegionName, StateProvinceName, City) = 7 THEN ' ' 
		WHEN GROUPING_ID(CountryRegionName, StateProvinceName, City) = 1 THEN ' ' 
		ELSE StateProvinceName
	END AS StateProvinceName
	,
	CASE 
		WHEN GROUPING_ID(CountryRegionName, StateProvinceName, City) = 1 THEN 'All cities of ' + StateProvinceName  
		WHEN GROUPING_ID(CountryRegionName, StateProvinceName, City) = 3 THEN 'All cities of ' + CountryRegionName
		WHEN GROUPING_ID(CountryRegionName, StateProvinceName, City) = 7 THEN ' '  
		 
		ELSE City
	END AS City
		
	, SUM(SalesYTD) AS Sales
    , GROUPING_ID(CountryRegionName, StateProvinceName, City) AS gr_ID
FROM AdventureWorks2014.Sales.vSalesPerson 
GROUP BY ROLLUP(CountryRegionName, StateProvinceName, City) 
;
 

 -- use CUBE () for grouping 
 SELECT CountryRegionName AS Country
	, PhoneNumberType AS State
	--, City
	, COUNT(BusinessEntityID) AS CountCustomers
 FROM AdventureWorks2014.Sales.vIndividualCustomer
 GROUP BY CUBE(CountryRegionName,PhoneNumberType)
 ; /*grouping will be done by all possible compinations of (CountryRegionName, PhoneNumberType):
    by CountryRegionName and PhoneNumberType, 
	by CountryRegionName,
	by PhoneNumberType, 
	by () grand total, all countries, all phone types
	*/

 SELECT CountryRegionName AS Country
	, PhoneNumberType AS State
	--, City
	, COUNT(BusinessEntityID) AS CountCustomers
	, GROUPING(CountryRegionName) AS gr_Country
	, GROUPING(PhoneNumberType) AS gr_Phone
	, GROUPING_ID(CountryRegionName, PhoneNumberType) AS gr_ID
 FROM AdventureWorks2014.Sales.vIndividualCustomer
 GROUP BY CUBE(CountryRegionName,PhoneNumberType)
 ; 


-- the grouping columns don't allow NULLs
 SELECT 
	CASE
		WHEN GROUPING(CountryRegionName)=1
			AND GROUPING(PhoneNumberType) = 0 THEN 'Total'
		WHEN GROUPING(CountryRegionName)= 1
			AND GROUPING(PhoneNumberType) = 1 THEN 'Grand Total'
		ELSE CountryRegionName
	END AS Country
	
	, 
	CASE
		WHEN GROUPING(PhoneNumberType) = 1 
			AND GROUPING(CountryRegionName) = 1 THEN ' ' 
		WHEN GROUPING(PhoneNumberType) = 1 
			AND GROUPING(CountryRegionName) = 0 THEN ' ' 
		ELSE PhoneNumberType
	END AS PhoneType
	, COUNT(BusinessEntityID) AS CountCustomers
	--, GROUPING(CountryRegionName) AS gr_Country
	--, GROUPING(PhoneNumberType) AS gr_Phone
	--, GROUPING_ID(CountryRegionName, PhoneNumberType) AS gr_ID
 FROM AdventureWorks2014.Sales.vIndividualCustomer
 GROUP BY CUBE(CountryRegionName,PhoneNumberType)
 ; 
 GO

 --**************************************************************************
 SELECT [Group] AS CountryGroup
	, CountryRegionCode AS CountryName
	, [Name] AS Region 
	-- all these columns dont't allow NULLs 
	, SUM(SalesYTD ) AS Sales
	, GROUPING_ID([Group], CountryRegionCode, [Name]) AS gr_ID
	-- for all rows, exsept the row with the Grand Total, gr_ID = 0
	-- for the grand total row gr_ID = 7 , 1*(2^2)+1*(2^1)+1*(2^0) = 4+2+1= 7
 FROM AdventureWorks2014.Sales.SalesTerritory 
 GROUP BY GROUPING SETS
	(
		([Group], CountryRegionCode, [Name])
		, () -- grand total
	)
	;
 
 -- the final version 
  SELECT 
	CASE
		WHEN GROUPING_ID([Group], CountryRegionCode, [Name]) = 7 THEN 'Grand Total '
		ELSE [Group]
	END AS CountryGrouip
	, 
	CASE 
		WHEN  GROUPING_ID([Group], CountryRegionCode, [Name]) = 7 THEN ' ' 
		ELSE CountryRegionCode
	END AS CountryCode
	, 
	CASE 
		WHEN  GROUPING_ID([Group], CountryRegionCode, [Name]) = 7 THEN ' ' 
		ELSE [Name]
	END AS Region 
	-- all these columns dont't allow NULLs 
	, SUM(SalesYTD ) AS Sales
	, GROUPING_ID([Group], CountryRegionCode, [Name]) AS gr_ID
	-- for all rows, exsept the row with the Grand Total, gr_ID = 0
	-- for the grand total row gr_ID = 7 , 1*(2^2)+1*(2^1)+1*(2^0) = 4+2+1= 7
 FROM AdventureWorks2014.Sales.SalesTerritory 
 GROUP BY GROUPING SETS
	(
		([Group], CountryRegionCode, [Name])
		, () -- grand total
	)
	;

