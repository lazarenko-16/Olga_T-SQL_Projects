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
INTO EmployeeTable
FROM Employee_PivotTable
	PIVOT (AVG(VacationHours) FOR OrganizationLevel IN ([1],[2],[3],[4])) AS P ;

SELECT * 
FROM EmployeeTable ;


SELECT Gender
	, OrganizationLevel
	, VacationHours
FROM EmployeeTable 
	UNPIVOT(VacationHours FOR OrganizationLevel IN ([1],[2],[3],[4]) ) AS U ;  


--*************************************************************************************************
/* Pivot data from the table HumanResources.Employee in the form : Gender|OrganizationLevel|Max(SickLeaveHours) */

SELECT DISTINCT(OrganizationLevel) 
FROM HumanResources.Employee ; 
-- OrgaizationLevel : 0,1,2,3

WITH Employee_PivotTable2 AS 
(
SELECT 
	 Gender			-- grouping column 
	, OrganizationLevel -- spreading column
	, SickLeaveHours -- aggregation column
FROM AdventureWorks2012.HumanResources.Employee
)
SELECT 
	 Gender
	 ,[0],[1],[2],[3],[4]
FROM Employee_PivotTable2
	PIVOT ( MAX(SickLeaveHours) FOR OrganizationLevel IN ([0],[1],[2],[3],[4] )) AS P2 ;

-- To unpivot the table Employee_PivotTable2:
USE AdventureWorks2012 ; 

IF OBJECT_ID(N'EmployeeTable2', N'U') IS NOT NULL 
DROP TABLE EmployeeTable2 ; 

WITH Emp_PivotTable AS
(
SELECT
	Gender -- groupoing column
	, OrganizationLevel --spreading column
	, SickLeaveHours -- aggregation column
FROM HumanResources.Employee 
)

Select * 
INTO EmployeeTable2
FROM Emp_PivotTable
	PIVOT ( MAX(SickLeaveHours) FOR OrganizationLevel IN ([0],[1],[2],[3],[4])) AS P2; 

SELECT *
FROM EmployeeTable2 ; 

--now we unpivot the table EmployeeTable2
SELECT Gender
	, OrganizationLevel
	, SickLeaveHours
FROM EmployeeTable2 
	UNPIVOT( SickLeaveHours FOR OrganizationLevel IN ([0],[1],[2],[3],[4])) AS Unpivot2 ; 


--**************************************************************************************************

-- create the pivot table Gender|MaritalStatus|Count(BusinessEntityID)

USE AdventureWorks2012 ; 
GO

SELECT DISTINCT(Gender) AS Genders
FROM HumanResources.Employee ; -- Genders: F, M

SELECT DISTINCT(MaritalStatus) AS Status 
FROM HumanResources.Employee ; -- Status: S, M


WITH PivotTable3 AS
(
SELECT 
	Gender -- grouping column
	, MaritalStatus -- spreasing column
	, BusinessEntityID -- aggregation column 
	FROM HumanResources.Employee 
)
SELECT   
	Gender, [S],[M]
FROM PivotTable3
	PIVOT( COUNT(BusinessEntityID) FOR MaritalStatus IN ( [S],[M])) AS P3 ; 
-- we retrieved data about single and married females and single and married  males 


-- now we will unpivot the table 
WITH PivotTable3 AS
(
SELECT 
	Gender -- grouping column
	, MaritalStatus -- spreasing column
	, BusinessEntityID -- aggregation column 
	FROM HumanResources.Employee 
)
SELECT * 
INTO Gender_MaritalStatus
FROM PivotTable3 
	PIVOT ( COUNT(BusinessEntityID) FOR MaritalStatus IN ( [S],[M])) AS P3 ; 


 
SELECT * 
FROM Gender_MaritalStatus ; 

SELECT 
	Gender
	, MaritalStatus
	, BusinessEntityID AS NumEmployees
FROM Gender_MaritalStatus
	UNPIVOT(BusinessEntityID FOR MaritalStatus IN ([S],[M])) AS U3 ; 


--*************************************************************************
WITH PvTable
AS
(
SELECT
	ProductID
	, Style
	, Color
FROM AdventureWorks2012.Production.Product 
) 
SELECT 
	Style
	, [Black],[Blue],[Grey],[Red],[Silver],[White],[Yellow]
FROM PvTable	
	PIVOT( COUNT(ProductID) 
			FOR Color IN ([Black],[Blue],[Grey],[Red],[Silver],[White],[Yellow])
		 ) AS P ; 