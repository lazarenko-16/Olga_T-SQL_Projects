-- Date: Dec 26,2017
-- Project Name: String manipulation 
-- Author: Olga Lazarenko
-- Description: queries with sting manipulations/character functions will be created


USE AdventureWorks2012 ; -- call AventureWorks2012 DB

SELECT DepartmentID
	, Name AS DeptName
	, GroupName
FROM HumanResources.Department ; 


-- REPLACE() function
SELECT DepartmentID
	, REPLACE(Name,'and','&') AS DeptName
	--to replace 'and' with '&' sign in the column DeptName
	-- for example Research and  Development becomes Research & Development
	, GroupName
FROM HumanResources.Department ; 



SELECT AddressID
	, AddressLine1
	, AddressLine2
	, City
	, PostalCode
FROM Person.Address ; 

-- concatenation of strings 
-- concatenate  address, city and postal code
SELECT AddressID
	, AddressLine1 + N', '+ City + N', ' + PostalCode AS Address 
FROM Person.Address ; 

SELECT AddressID
	, AddressLine1 + ', '+ City + ', ' + PostalCode AS Address 
FROM Person.Address ; 


SELECT BusinessEntityID
	, PersonType
	, NameStyle
	, Title
	, MiddleName
	, LastName
	, ModifiedDate
FROM Person.Person ; 

--REPLACE(), SUBSTRING() functions ************************************
  SELECT SalesOrderID
	, SalesOrderNumber
	, PurchaseOrderNumber
	, AccountNumber
	, REPLACE(SalesOrderNumber,'SO','') AS New_OrderNumber
	, REPLACE(PurchaseOrderNumber,'PO','') AS New_PurchaseNumber
	, SUBSTRING(AccountNumber,4,LEN(AccountNumber)) AS New_AccountNumber
  FROM AdventureWorks2012.Sales.SalesOrderHeader ;

