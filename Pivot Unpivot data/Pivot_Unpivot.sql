/****** Script for SelectTopNRows command from SSMS  ******/
--Start Date: Jan 28, 2018
--Project Name: Pivoting/Unpivoting Data
--Author: Olga Lazarenko
--Desctiption: the purpose of the project is to create queries and  pivot/unpivot data
--				from AdventureWorks2012


USE AdventureWorks2012 ;-- call DB
GO

--********************************************************************************************
-- Pivot data from the table HumanResources.Employee
WITH Employee_PivotTable AS 
(
SELECT 
	 Gender			-- grouping column 
	, OrganizationLevel -- spreading column
	, VacationHours -- aggregation column
FROM AdventureWorks2012.HumanResources.Employee
)
SELECT 
	 Gender
	 , [1],[2],[3],[4]
FROM Employee_PivotTable
	PIVOT ( AVG(VacationHours) FOR OrganizationLevel IN ([1],[2],[3],[4] )) AS P ; 
	
-- Unpivot data
USE AdventureWorks2012 ; 
IF OBJECT_ID(N'EmployeeDemo', N'U') IS NOT NULL DROP TABLE Employee_PivotTable ; 
GO 

WITH Employee_PivotTable AS 
(
SELECT 
	 Gender			-- grouping column 
	, OrganizationLevel -- spreading column
	, VacationHours -- aggregation column
FROM AdventureWorks2012.HumanResources.Employee
)
SELECT *
INTO EmployeeDemo
FROM Employee_PivotTable
	PIVOT (AVG(VacationHours) FOR OrganizationLevel IN ([1],[2],[3],[4])) AS P ;

SELECT * 
FROM EmployeeDemo ;


SELECT Gender
	, OrganizationLevel
	, VacationHours
FROM EmployeeDemo 
	UNPIVOT(VacationHours FOR OrganizationLevel IN ([1],[2],[3],[4]) ) AS U ;  