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