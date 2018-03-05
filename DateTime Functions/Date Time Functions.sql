
-- Date: Dec 25, 2017
-- Prjoect Name: Date & Time Functions in T-SQL
-- Author: Olga Lazarenko
-- Description: queries with date/time functions will be created 


USE AdventureWorks2012 ; 

SELECT BirthDate -- date type is date YYYY-MM-DD
	, HireDate -- date type is date YYYY-MM-DD
	, ModifiedDate -- date tipe is datetime YYYY-MM-DD hh:mm:ss [.nnn]
FROM HumanResources.Employee ; 


SELECT YEAR(BirthDate) AS BirthYear
	, YEAR(HireDate) AS HireYear
	, YEAR(ModifiedDate) As ModifiedYear
FROM HumanResources.Employee ; 


SELECT YEAR(BirthDate) AS BirthYear
	, DAY(BirthDate) AS BirthDay -- the number of a day in the week
	, MONTH(BirthDate) AS BirthMonth -- the number of the mounth
	--, EOMONTH(BirthDate) As BirthMonth
	, YEAR(HireDate) AS HireYear
	, YEAR(ModifiedDate) As ModifiedYear
FROM HumanResources.Employee ;


--the current date and time in the date type datetime2(7) YYYY-MM-DD hh:mm:ss[.nnnnnnn]
 SELECT SYSDATETIME() ; 

 SELECT YEAR(SYSDATETIME()) AS CurrentYear 
	, MONTH(SYSDATETIME()) AS CurrentMounth
	, DAY(SYSDATETIME()) AS CurrenctDay ;  


SELECT SYSDATETIMEOFFSET() ; 

SELECT CURRENT_TIMESTAMP ;

SELECT CURRENT_USER ; 

SELECT YEAR(BirthDate) AS BirthYear
	, DATENAME(Month,BirthDate) as BirthMonth -- will return the name of month
FROM HumanResources.Employee ; 

SELECT DATEFROMPARTS(2000,4,30);


--calculate the current age of employees
-- and lenght of employment
SELECT DATEDIFF(YEAR,BirthDate,CURRENT_TIMESTAMP) AS Age
	, DATEDIFF(YEAR,HireDate,CURRENT_TIMESTAMP) AS EmploymentYears
FROM HumanResources.Employee ; 

-- retrieve data of employees age and the lenght of employment
-- create inner join between tables HumanResources.Employee and Person.Person
SELECT P.FirstName
	, P.LastName
	, DATEDIFF(Year,BirthDate,CURRENT_TIMESTAMP) AS Age
	,DATEDIFF(Year,HireDate,CURRENT_TIMESTAMP) AS EmploymentYears
FROM Person.Person AS P
INNER JOIN
	HumanResources.Employee AS E
	ON P.BusinessEntityID = E.BusinessEntityID 
ORDER BY EmploymentYears desc; 

--****************************************************************
-- Calculate how many days/weeks were nessessary to deliver the orders
SELECT SalesOrderID
	, OrderDate
	, DueDate
	, ShipDate
	, DATEDIFF(dd,OrderDate, DueDate) AS TotalOrderDays
	, DATEDIFF(dd, OrderDate,ShipDate) AS ShippingDays
	, DATEDIFF(wk,OrderDate, ShipDate) AS ShippingWeeks
FROM AdventureWorks2012.Sales.SalesOrderHeader ;

  --**********************************************************************

  /* the query will return records with employee full name, employee ID , job title 
  and calculated employee's age. DATEDIFF(datepart, startdate, enddate) function is used.
  INNER JOIN is used for the tables HumanResourcse.Employee and Person.Person ; 
  The records are organized by employee's name ; */
  SELECT 
	( P.FirstName + ' ' + P.LastName) AS EmployeeName
	, E. BusinessEntityID AS EmpID
	,JobTitle
	, DATEDIFF(yy, BirthDate, GETDATE()) AS Age -- calculate the employee's age
  FROM AdventureWorks2012.HumanResources.Employee AS E
	INNER JOIN 
		AdventureWorks2012.Person.Person AS P
	ON E.BusinessEntityID = P.BusinessEntityID
  ORDER BY EmployeeName ; 


  /* the query will return records of employee older than 67 years old 
  The above query will be modified */
    SELECT 
	( P.FirstName + ' ' + P.LastName) AS EmployeeName
	, E. BusinessEntityID AS EmpID
	,JobTitle
	, DATEDIFF(yy, BirthDate, GETDATE()) AS Age -- calculate the employee's age
  FROM AdventureWorks2012.HumanResources.Employee AS E
	INNER JOIN 
		AdventureWorks2012.Person.Person AS P
	ON E.BusinessEntityID = P.BusinessEntityID
  WHERE DATEDIFF(yy, BirthDate, GETDATE()) > 67 -- select only the records with calculated age>67 
  ORDER BY EmployeeName ; 