
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

  --*********************************************************************

   USE AdventureWorks2014; 
   GO 
  --Current date and time
  SELECT GETDATE() ; 
  --returned the current date and time in DATETIME data type (YYYY-MM-DD HH:MM:SS [.nnn]), 
  -- 2018-09-05 01:56:13.247

  SELECT GETUTCDATE() ; 
  -- 2018-09-05 01:56:13.247

  SELECT CURRENT_TIMESTAMP ; 
  --returned the current date and time in DATETIME data type (YYYY-MM-DD HH:MM:SS [.nnn]),
  -- 2018-09-05 01:56:13.247 ;  it is the standard option 
  
  SELECT SYSDATETIME() ;  
  --returned the current date and time in DATETIME data type (YYYY-MM-DD HH:MM:SS [.nnnnnnn]),
  -- with more seconds precision
  --2018-09-05 01:55:51.4948449

  SELECT SYSUTCDATETIME() ; 
  --2018-09-05 08:59:00.6983855
  --UTC returns teh current date and time in UTC terms 
  -- DATETIME data type


  SELECT SYSDATETIMEOFFSET() ;  
  -- the same as the result from SYSDATETIME but inculding the time zone offset
  --2018-09-05 01:54:44.9009682 -07:00

  --*******************************************************

  --Date and Time Parts
  SELECT DATEPART(year, '20020115') AS my_year ;
  --returned 2002
  
  SELECT DATEPART(month, '20020125') AS my_mounth ; 
   --returned 1 

   SELECT DATEPART(day, '20020125') AS my_day ; 
   --returned 25

   --the same results can be obtained with YEAR, MONTH, DAY at DATEPART 
   SELECT YEAR('20020329') AS my_year ; 
   SELECT MONTH('20020329') AS my_mounth ; 
   SELECT DAY('20020329') AS my_day ; 
   --retured numeric values for the year, the month and the day

   -- to get the name of the date part 
   SELECT DATENAME(month, '20020329'); -- the function is language-dependable
   --returned 'March'
   SELECT DATENAME(day, '20020329') ; 
   -- returned 29 ???


   --calculate how many products the company started to sell by year and mounth
   SELECT 
	YEAR(SellStartDate) AS YearStartDate
	, MONTH(SellStartDate) AS MonthStartDate
	, DATENAME(month,SellStartDate) AS MonthName 
	, COUNT(ProductID) AS NumOfProducts
   FROM AdventureWorks2014.Production.Product 
   GROUP BY YEAR(SellStartDate), MONTH(SellStartDate)
			, DATENAME(month,SellStartDate)
   ORDER BY YearStartDate , MonthStartDate 
   ; 



   --show the sales for which products are not over SellEndDate IS NULL
   -- display the date these products' sales are started 
   SELECT ProductID
	--, SellStartDate
	, CAST(SellStartDate AS DATE) SellStart
	, YEAR(SellStartDate) AS YearStart
	, MONTH(SellStartDate) AS MonthStart
	, DATENAME(month, SellStartDate) AS MonthName 
   FROM AdventureWorks2014.Production.Product 
   WHERE SellEndDate IS NULL 
   ; 
   --406 rows are returned 

   --show the sales for which products are over SellEndDate IS NOT NULL 
      SELECT ProductID
	--, SellStartDate
	, CAST(SellStartDate AS DATE) SellStart
	, YEAR(SellStartDate) AS YearStart
	, MONTH(SellStartDate) AS MonthStart
	, DATENAME(month, SellStartDate) AS MonthName 
   FROM AdventureWorks2014.Production.Product 
   WHERE SellEndDate IS NOT  NULL 
   ;
   --98 rows returned 

   SELECT ProductID
   FROM AdventureWorks2014.Production.Product ; 
   -- 504 rows returned , 406/sales + 98/sales are over = 504 

   SELECT 
	COUNT(ProductID) AS NumOfProducts_SaleEnd
	, YEAR(SellStartDate) AS YearStart
	, YEAR(SellEndDate) AS YearEnd
	, MONTH(SellStartDate) AS MonthStart
	, MONTH(SellEndDate) AS MounthEnd
	, DATENAME(month, SellStartDate) AS MonthName 
   FROM AdventureWorks2014.Production.Product 
   WHERE SellEndDate IS NOT  NULL 
   GROUP BY YEAR(SellStartDate)
			, YEAR(SellEndDate)
			, MONTH(SellStartDate)
			, MONTH(SellEndDate)  
			;
   --2 rows returned 

   SELECT 
	COUNT(ProductID) AS NumOfProducts_SaleNow
	, YEAR(SellStartDate) AS YearStart
	, MONTH(SellStartDate) AS MonthStart
	, DATENAME(month, SellStartDate) AS MonthName 
   FROM AdventureWorks2014.Production.Product 
   WHERE SellEndDate IS NULL 
   GROUP BY YEAR(SellStartDate)
			, MONTH(SellStartDate) 
			, DATENAME(month, SellStartDate) 
			; 
			--4 rows returned 

