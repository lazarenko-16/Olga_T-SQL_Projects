--Date: March 05,2018
--Project Name: Stored Prosedurs
--Author: Olga Lazarenko
--Description: stored prosedures will be created 



USE AdventureWorks2012; -- call AdventureWorks2012 database 


--SELECT 
--	DISTINCT JobTitle
--FROM AdventureWorks2012.HumanResources.Employee ; 

--SELECT 
--	P.FirstName
--	, P.LastName
--	, E.JobTitle
--	, E.BirthDate
--	, HireDate
--FROM AdventureWorks2012.HumanResources.Employee AS E
--	INNER JOIN 
--	AdventureWorks2012.Person.Person AS P
--	ON E.BusinessEntityID  = P.BusinessEntityID ; 





CREATE PROCEDURE Employee_JobTitle
	@JobTitle nvarchar(50)
AS
BEGIN  
SELECT 
	P.FirstName
	, P.LastName
	, E.JobTitle
	, E.BirthDate
	, HireDate
FROM AdventureWorks2012.HumanResources.Employee AS E
	INNER JOIN 
	AdventureWorks2012.Person.Person AS P
	ON E.BusinessEntityID  = P.BusinessEntityID 
WHERE JobTitle = @JobTitle   
END ; 
GO  	

--DROP PROCEDURE Employee_JobTitle ; 

-- JobTitle can be in ( Accountant, Janitor, Recruiter) 

EXECUTE Employee_JobTitle Janitor ; 

--*********************************************************************
USE AdventureWorks2014 ;
GO

-- count the number of the employees with a specific marital status 
CREATE PROC spCountEmpMaritalStatus
@MaritalStatus AS nchar(1)
AS 
BEGIN
	SELECT COUNT(BusinessEntityID) AS NumEmp
		, MaritalStatus
	FROM HumanResources.Employee
	WHERE MaritalStatus = @MaritalStatus
	GROUP BY MaritalStatus
END
;

--call the procedure spCountEmpMaritalStatus
EXEC spCountEmpMaritalStatus 'M' ; -- count the employees wth marital status married 

EXEC spCountEmpMaritalStatus 'S' ; -- count the number of single employees

-- to the the text of spCountEmpMaritalStatus
EXEC sp_helptext spCountEmpMaritalStatus ; 
GO


--modify the stored procedure, add the emplouee gender
ALTER PROC spCountEmpMaritalStatus
@MaritalStatus nvarchar(1)
, @Gender nvarchar(1)
AS 
BEGIN
	SELECT COUNT(BusinessEntityID) AS NumEmp
		, MaritalStatus, Gender 
	FROM HumanResources.Employee
	WHERE MaritalStatus = @MaritalStatus
		AND Gender = @Gender 
	GROUP BY MaritalStatus, Gender
END
;  

-- execute the stored procedure
EXEC spCountEmpMaritalStatus 'M', 'M' ; -- number of married man employees
EXEC spCountEmpMaritalStatus 'M', 'F' ; -- number of married female employees
EXEC spCountEmpMaritalStatus 'S', 'M' ; -- number of single man employees
EXEC spCountEmpMaritalStatus 'S', 'F' ; -- number of single female employees

-- to see the stored procedure text
EXEC sp_helptext spCountEmpMaritalStatus ;
GO 

-- modify the stored procedure, add DeptartmentID, Shift
ALTER PROC spCountEmpMaritalStatus
@MaritalStatus nchar(1)
, @Gender nchar(1)
, @DeptID nchar(1)
, @ShiftID nchar(1)
AS 
BEGIN
	SELECT
		D.DepartmentID AS DeptID 
		,D.Name AS DeptName
		,S.Name AS [Shift]
		,COUNT(E.BusinessEntityID) AS NumEmp
		, E.MaritalStatus AS MaritalStatus
		, E.Gender AS Gender

	FROM HumanResources.Employee AS E
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS DH
		ON E.BusinessEntityID = DH.BusinessEntityID
	INNER JOIN HumanResources.Department AS D
		ON DH.DepartmentID = D.DepartmentID
	INNER JOIN HumanResources.[Shift] AS S
		ON DH.ShiftID = S.ShiftID -- shiftID from 1 to 3
	WHERE E.MaritalStatus = @MaritalStatus
		AND E.Gender = @Gender 
		AND DH.DepartmentID = @DeptID -- deptIf from 1 to 16
		AND S.ShiftID = @ShiftID
	GROUP BY D.DepartmentID, D.Name,S.Name,MaritalStatus, Gender
END
;

--to see the procedure text
EXEC sp_helptext spCountEmpMaritalStatus ; 

-- to call the procedure
EXEC spCountEmpMaritalStatus 'M','M', 3, 1 ; 

-- to drop the procedure
DROP PROC spCountEmpMaritalStatus ; 
-- to check if the procedure exists 
IF OBJECT_ID(N'spCountEmpMaritalStatus', N'P') IS NOT NULL
PRINT 'Procedure exists'
ELSE PRINT 'Procedure does not  exists' ; 
GO

--****************************************************************************************