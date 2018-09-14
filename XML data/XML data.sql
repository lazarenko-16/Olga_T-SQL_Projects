/* 
Date: Sep 10, 2018
Project Name: Quering and Manipulating XML Data
Author: Olga Lazarenko
Description: the purpose of this project is to gain experience 
			and practical skills working with XML using SQL Server.
*/

USE AdventureWorks2014 
; 
GO 

--create XML from relational data with query

-- select female employees, inner join tables HumanResources.Employee and Person.Person 
SELECT 
	E.BusinessEntityID AS EmpID
	, P.FirstName
	, P.LastName
	, E.BirthDate
	, E.JobTitle
	--, P.Title 
FROM AdventureWorks2014.HumanResources.Employee AS E
	INNER JOIN
	AdventureWorks2014.Person.Person AS P 
	ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.Gender = 'F'
FOR XML RAW	-- the RAW mode of XML, each row will be a single XML element, each column will be an attribute of the element
; 
/* the part of the result:
<row EmpID="2" FirstName="Terri" LastName="Duffy" BirthDate="1971-08-01" JobTitle="Vice President of Engineering" />
<row EmpID="5" FirstName="Gail" LastName="Erickson" BirthDate="1952-09-27" JobTitle="Design Engineer" />
*/

-- it is possible to override the query 
SELECT 
	E.BusinessEntityID AS EmpID
	, P.FirstName
	, P.LastName
	, E.BirthDate
	, E.JobTitle
	--, P.Title 
FROM AdventureWorks2014.HumanResources.Employee AS E
	INNER JOIN
	AdventureWorks2014.Person.Person AS P 
	ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.Gender = 'F'
FOR XML RAW ('Employee') 
; 
/* the part of the result:
<Employee EmpID="2" FirstName="Terri" LastName="Duffy" BirthDate="1971-08-01" JobTitle="Vice President of Engineering" />
<Employee EmpID="5" FirstName="Gail" LastName="Erickson" BirthDate="1952-09-27" JobTitle="Design Engineer" />
*/

-- adding the root element 
SELECT 
	E.BusinessEntityID AS EmpID
	, P.FirstName
	, P.LastName
	, E.BirthDate
	, E.JobTitle
	--, P.Title 
FROM AdventureWorks2014.HumanResources.Employee AS E
	INNER JOIN
	AdventureWorks2014.Person.Person AS P 
	ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.Gender = 'F'
FOR XML RAW('Employee')
		, ROOT 
; 

/*
<root>
  <Employee EmpID="2" FirstName="Terri" LastName="Duffy" BirthDate="1971-08-01" JobTitle="Vice President of Engineering" />
  <Employee EmpID="5" FirstName="Gail" LastName="Erickson" BirthDate="1952-09-27" JobTitle="Design Engineer" />
   .................................
   ..................................
 </root> 
 */

 -- providing a name for the root element
SELECT 
	E.BusinessEntityID AS EmpID
	, P.FirstName
	, P.LastName
	, E.BirthDate
	, E.JobTitle
	--, P.Title 
FROM AdventureWorks2014.HumanResources.Employee AS E
	INNER JOIN
	AdventureWorks2014.Person.Person AS P 
	ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.Gender = 'F' and E.BusinessEntityID IN (2,5,8)
-- additional filter is added to make the output less bulky
FOR XML RAW('Employee')
		, ROOT('Employee')
; 
/* the result 
<Employee>
  <Employee EmpID="2" FirstName="Terri" LastName="Duffy" BirthDate="1971-08-01" JobTitle="Vice President of Engineering" />
  <Employee EmpID="5" FirstName="Gail" LastName="Erickson" BirthDate="1952-09-27" JobTitle="Design Engineer" />
  <Employee EmpID="8" FirstName="Diane" LastName="Margheim" BirthDate="1986-06-05" JobTitle="Research and Development Engineer" />
</Employee>
*/


-- adding a child element to the row element by using ELEMENTS option
SELECT 
	E.BusinessEntityID AS EmpID
	, P.FirstName
	, P.LastName
	, E.BirthDate
	, E.JobTitle
	--, P.Title 
FROM AdventureWorks2014.HumanResources.Employee AS E
	INNER JOIN
	AdventureWorks2014.Person.Person AS P 
	ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.Gender = 'F' and E.BusinessEntityID IN (2,5,8)
FOR XML RAW('Employee')
		, ROOT('Employee')
		, ELEMENTS
; 
--********************************************************

-- the column Title from the table Person.Person can contain NULLs
SELECT 
	E.BusinessEntityID AS EmpID
	, P.FirstName
	, P.LastName
	, E.BirthDate
	, E.JobTitle
	, P.Title -- allows NULLs
FROM AdventureWorks2014.HumanResources.Employee AS E
	INNER JOIN
	AdventureWorks2014.Person.Person AS P 
	ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.Gender = 'F' 
FOR XML RAW('Employee')
		, ROOT('Employee')
		, ELEMENTS
; -- in case Title is NULL, we will not have this column in the XML result
/*a subset  of the result:
  <Employee>
    <EmpID>5</EmpID>
    <FirstName>Gail</FirstName>
    <LastName>Erickson</LastName>
    <BirthDate>1952-09-27</BirthDate>
    <JobTitle>Design Engineer</JobTitle>
    <Title>Ms.</Title>
  </Employee>
  <Employee>
    <EmpID>8</EmpID>
    <FirstName>Diane</FirstName>
    <LastName>Margheim</LastName>
    <BirthDate>1986-06-05</BirthDate>
    <JobTitle>Research and Development Engineer</JobTitle>
  </Employee>
  */


  -- to have NULLs being included into XML, we can use XSINIL key word after the ELEMENT option
  SELECT 
	E.BusinessEntityID AS EmpID
	, P.FirstName
	, P.LastName
	, E.BirthDate
	, E.JobTitle
	, P.Title 
FROM AdventureWorks2014.HumanResources.Employee AS E
	INNER JOIN
	AdventureWorks2014.Person.Person AS P 
	ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.Gender = 'F' 
FOR XML RAW('Employee')
		, ROOT('Employee')
		, ELEMENTS XSINIL 
;
/* the output contains xsi:nil attribite with a value of true 
when Title is NULL(<Title xsi:nil="true" />);

xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
this attribute is added and provides the name of the default schema instance


the subset of the output: 

<Employee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
  <Employee>
    <EmpID>2</EmpID>
    <FirstName>Terri</FirstName>
    <LastName>Duffy</LastName>
    <BirthDate>1971-08-01</BirthDate>
    <JobTitle>Vice President of Engineering</JobTitle>
    <Title xsi:nil="true" />
  </Employee>
  <Employee>
    <EmpID>5</EmpID>
    <FirstName>Gail</FirstName>
    <LastName>Erickson</LastName>
    <BirthDate>1952-09-27</BirthDate>
    <JobTitle>Design Engineer</JobTitle>
    <Title>Ms.</Title>
  </Employee>

  */



  -- to specify an inline W3C XML Schema(XSD) 
  --and have in inculded into the XML (using the option XMLSHEMA):
  SELECT 
	E.BusinessEntityID AS EmpID
	, P.FirstName
	, P.LastName
	, E.BirthDate
	, E.JobTitle
	, P.Title 
FROM AdventureWorks2014.HumanResources.Employee AS E
	INNER JOIN
	AdventureWorks2014.Person.Person AS P 
	ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.Gender = 'F' 
FOR XML RAW('Employee')
		, ROOT('Employee')
		, ELEMENTS XSINIL 
		, XMLSCHEMA
;--the schema is fully defined and included into the XML result