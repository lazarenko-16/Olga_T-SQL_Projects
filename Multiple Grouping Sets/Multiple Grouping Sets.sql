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