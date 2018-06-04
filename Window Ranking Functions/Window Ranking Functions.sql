/* 
Date: May 22, 2018
Project Name: Window Ranking Functions
Author: Olga Lazarenko
Project Description: the purpose if this project 
					is use the window ranking functions
					ROW_NUMBER, RANK, DENSE, NTILE 
					at the queries to retrieve data 
					from AdventureWorks2012 database
*/

USE AdventureWorks2012;
GO

SELECT 
	ROW_NUMBER() OVER(ORDER BY Name) AS RowNumber -- the column with the row numbers will be created
	-- because there is no the PARTITION BY clause, the query result is treated as a whole set of data
	, D.[Name] AS Department
	--, D.GroupName AS [Group]
	, E.JobTitle
	, P.LastName
	, P.FirstName
FROM Person.Person AS P
INNER JOIN 
	HumanResources.Employee AS E
ON P.BusinessEntityID = E.BusinessEntityID
INNER JOIN 
	HumanResources.EmployeeDepartmentHistory AS DH
ON E.BusinessEntityID = DH.BusinessEntityID 
INNER JOIN 
	HumanResources.Department AS D
ON DH.DepartmentID = D.DepartmentID 
ORDER BY Name, JobTitle, LastName ;  


--now the PARTITION BY will be used for the above query
SELECT 
	ROW_NUMBER() OVER(PARTITION BY Name ORDER BY Name) AS RowNumber 
	/* the column with the row numbers will be created
	 the PARTITION BY clause is used, 
	 the query result is partitioned/broken into the parts according Name/Department.
	 For each part/group the ROW_NUMBER()function will create consequtive row numbers
	 */
	, D.[Name] AS Department
	--, D.GroupName AS [Group]
	, E.JobTitle
	, P.LastName
	, P.FirstName
FROM Person.Person AS P
INNER JOIN 
	HumanResources.Employee AS E
ON P.BusinessEntityID = E.BusinessEntityID
INNER JOIN 
	HumanResources.EmployeeDepartmentHistory AS DH
ON E.BusinessEntityID = DH.BusinessEntityID 
INNER JOIN 
	HumanResources.Department AS D
ON DH.DepartmentID = D.DepartmentID 
ORDER BY Name, JobTitle, LastName ;  

GO

--**********************************************************************************************

SELECT
	E.JobTitle
	, LastName
	, P.FirstName
	, ROUND(EP.Rate, 0 ) AS Rate
FROM Person.Person AS P
INNER JOIN HumanResources.EmployeePayHistory AS EP
ON	P.BusinessEntityID = EP.BusinessEntityID 
INNER JOIN HumanResources.Employee AS E
ON EP.BusinessEntityID = E.BusinessEntityID ;

SELECT
	E.JobTitle
	, LastName
	, P.FirstName
	, ROUND(EP.Rate, 0 ) AS Rate
	, RANK() OVER(ORDER BY Rate DESC)
	/* ranking the employees according their pay rate in descending way
	this ranking can have gaps, it is not sequatial,
	because the query doesn't have PARTITION BY clause,
	the result set is considered as a whole set, without divining into parts
	*/
FROM Person.Person AS P
INNER JOIN HumanResources.EmployeePayHistory AS EP
ON	P.BusinessEntityID = EP.BusinessEntityID 
INNER JOIN HumanResources.Employee AS E
ON EP.BusinessEntityID = E.BusinessEntityID ; 
-- 315 rows returned 

GO

--*************************************************************************************

SELECT
	DH.DepartmentID AS DepartmentID
	, E.JobTitle
	, LastName
	, P.FirstName
	, ROUND(EP.Rate, 0 ) AS Rate
	, RANK() OVER(PARTITION BY DepartmentID ORDER BY Rate DESC) AS RateRank
	/* the employee will be assignned the ranks emplyoing data partition
	by DepartmentID);
	The ranking might have gaps, in case some employees at the same department
	have the same pay rate
	*/
FROM Person.Person AS P
INNER JOIN HumanResources.EmployeePayHistory AS EP
ON	P.BusinessEntityID = EP.BusinessEntityID 
INNER JOIN HumanResources.Employee AS E
ON EP.BusinessEntityID = E.BusinessEntityID
INNER JOIN HumanResources.EmployeeDepartmentHistory AS DH
ON E.BusinessEntityID = DH.BusinessEntityID ; 


--*******************************************************************************
SELECT
	DH.DepartmentID AS DepartmentID
	, E.JobTitle
	, LastName
	, P.FirstName
	, ROUND(EP.Rate, 0 ) AS Rate
	, RANK() OVER(PARTITION BY DepartmentID ORDER BY Rate DESC) AS RateRank
	/* RANK() function will create ranking for the pay rate,
	the ranking might have gaps
	*/
	, DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Rate DESC) AS DenseRateRank
	/* DENSE_RANK() function will create the sequential(without gaps) rating for the pay rate
	*/
FROM Person.Person AS P
INNER JOIN HumanResources.EmployeePayHistory AS EP
ON	P.BusinessEntityID = EP.BusinessEntityID 
INNER JOIN HumanResources.Employee AS E
ON EP.BusinessEntityID = E.BusinessEntityID
INNER JOIN HumanResources.EmployeeDepartmentHistory AS DH
ON E.BusinessEntityID = DH.BusinessEntityID ;



--********************************************************************

-- create the ranking of the sales territories
SELECT 
	RANK() OVER ( ORDER BY SalesYTD DESC) AS SalesRank 
	, [Name] AS Territory
	, CountryRegionCode AS CountryCode
	, ROUND(SalesYTD,2) AS Sales 
FROM Sales.SalesTerritory ; 




SELECT 
	RANK() OVER (PARTITION BY CountryRegionCode
	 -- the data will be divided/partitioned into groups by the CountryRegionCode
					ORDER BY SalesYTD DESC ) AS SalesRank
	-- the rows into a group will be ranking according to the SalesYTD at the descending way	
	, [Name] AS Territory
	, CountryRegionCode AS CountryCode
	, ROUND(SalesYTD,2) AS Sales 
FROM Sales.SalesTerritory 
ORDER BY CountryCode DESC ;
-- for US CountryRegionCode the territory Southwest has the rank 1, with the greatest sales



--RANK() function not always returns consecutive ranking integers 
SELECT
	RANK() OVER ( ORDER BY VacationHours DESC) AS VacationRate
	, JobTitle
	, VacationHours
FROM HumanResources.Employee
ORDER BY VacationRate ; 


--apply partitioning by gender(F/M) and rank by VacationHours
SELECT
	Gender
	,  RANK() OVER ( PARTITION BY Gender 
					ORDER BY VacationHours DESC) AS VacationRate 
	, JobTitle
	, VacationHours
FROM HumanResources.Employee
ORDER BY Gender, VacationRate  ; 


--************************************************************
-- for LocationID = 50, rank the shelves and bins by Quantity
  SELECT
	RANK() OVER ( ORDER BY Quantity DESC ) AS Rank
	, Shelf
	, Bin
	, Quantity
  FROM Production.ProductInventory 
  WHERE LocationID = 50 ; 
  --251 rows returned



  --for LocationID = 50, rank the shelves and bins by Quantity, using partitioning by shelves 
    SELECT
	RANK() OVER ( PARTITION BY Shelf ORDER BY Quantity DESC ) AS Rank
	, Shelf
	, Bin
	, Quantity
  FROM Production.ProductInventory 
  WHERE LocationID = 50 ; 


      SELECT
	RANK() OVER ( PARTITION BY Shelf ORDER BY Quantity DESC ) AS Rank
	--there are gaps at the ranking for RANK() function
	, DENSE_RANK() OVER (PARTITION BY Shelf ORDER BY Quantity DESC ) AS Dense_Rank
	--DENSE_RANK() function returns consecutive ranking (without gaps) 
	, Shelf
	, Bin
	, Quantity
  FROM Production.ProductInventory 
  WHERE LocationID = 50 ; 