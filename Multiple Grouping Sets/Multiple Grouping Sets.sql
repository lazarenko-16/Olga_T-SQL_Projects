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
  FROM AdventureWorks2012.Employee 
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
  GROUP BY  DepartmentName, Gender, MaritalStatus
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



	  SELECT Region
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
 From SQLClass.Sales_CreditCard
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