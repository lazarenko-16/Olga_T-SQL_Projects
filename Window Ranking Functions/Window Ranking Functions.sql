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


