/* 
Date: Sep 10, 2018
Project Name: Quering and Manipulating XML Data
Author: Olga Lazarenko
Description: the purpose of this project is to gain experience 
			and practical skills working with XML using SQL Server.
			1) FOR XML RAW 
			2) FOR XML AUTO
			3) FOR XML EXPLICIT 
			4) FOR XML PATH
			5) XML data type
*/

USE AdventureWorks2014 ; 
GO 

--create XML from relational data with query

--**********************     FOR XML RAW  ***********************************
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
FOR XML RAW ('Employee') ; 
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
		, ROOT ; 

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
--1) **********************  FOR XML RAW  *********************************

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
		, ELEMENTS ; -- in case Title is NULL, we will not have this column in the XML result
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
		, ELEMENTS XSINIL ;
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
		, XMLSCHEMA ;--the schema is fully defined and included into the XML result


 -- 5) *******************  XML data type  ***********************************

 -- create a table with XML data type
 CREATE TABLE Person_xml
 (ID int PRIMARY KEY , 
 Person_Data xml not null) ; 
; 

 SELECT * FROM Person_xml ;
 INSERT INTO Person_xml
 (ID, Person_Data)
 VALUES
  (1, '<Person> PersonID="1"<Name> John </Name>
		<Country>US</Country><Location>Indiana </Location><Salary> 44000</Salary> </Person>');
 INSERT INTO Person_xml
 (ID, Person_Data)
 VALUES 
 (2, '<Person> PersonID="2"<Name> Susan </Name>
		<Country>US</Country><Location>Texas </Location><Salary>50000</Salary> </Person>'),
 (3, '<Person> PersonID="3"<Name> Linda </Name>
		<Country>Germany</Country><Location>Bavaria</Location><Salary>38000</Salary> </Person>'),
 (4, '<Person> PersonID="4"<Name> George</Name>
		<Country>US</Country><Location>Utah</Location><Salary>48000</Salary> </Person>'),
 (5, '<Person> PersonID="5"<Name> Leo</Name>
		<Country>US</Country><Location>Washington</Location><Salary>72000</Salary> </Person>') ;

exec sp_help Person_xml ; -- to see the information about the table 

SELECT * 
FROM AdventureWorks2014.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'Person_xml'; --  the information about the columns 

 SELECT * FROM Person_xml; -- 5 rows returned 
/* SQL Server provides the following five XML data type methods to extract or manipuldate data
query(),
value(),
exist(),
modify(),
nodes()
*/


--the query() method returns the XML fragment
SELECT 
	 P.Person_Data.query('/Person/Name[1]') AS PersonName
	, P.Person_Data.query('/Person/Country[1]') AS Country
	, P.Person_Data.query('/Person/Location[1]') AS [Location]
	, P.Person_Data.query('/Person/Salary[1]') AS Salary
FROM Person_xml AS P ; 

--to retrieve the data without xml format:
SELECT 
	 P.Person_Data.query('/Person/Name[1]/text()') AS PersonName
	, P.Person_Data.query('/Person/Country[1]/text()') AS Country
	, P.Person_Data.query('/Person/Location[1]/text()') AS [Location]
	, P.Person_Data.query('/Person/Salary[1]/text()') AS Salary
FROM Person_xml AS P ; 


--the value() method to retrieve a value of SQL data type from an XML instance; define the data type
SELECT 
	 P.Person_Data.value('(/Person/Name)[1]', 'nvarchar(100)') AS PersonName
	, P.Person_Data.value('(/Person/Country)[1]', 'nvarchar(100)') AS Country
	, P.Person_Data.value('(/Person/Location)[1]', 'nvarchar(100)') AS [Location]
	, P.Person_Data.value('(/Person/Salary)[1]', 'int') AS Salary 
FROM Person_xml AS P ; 

--the exist() method is used to check if the specified XPATH exists or not
-- returns 1 if exists, 0 if not
SELECT P.Person_Data.exist('/Person/Name[1]') AS Person_exists
FROM Person_xml AS P
WHERE P.ID = 2; -- returns 1 


SELECT P.Person_Data.exist('/Person/Name[2]') AS Person_exists
FROM Person_xml AS P
WHERE P.ID = 2; -- returns 0, because Name contains only a single name attribute,
-- there is no second name attribute from person with ID = 2 


--the modify() method will be used for updates
UPDATE Person_xml
SET Person_Data.modify('replace value of (/Person/Salary/text())[1] with 100000')
WHERE Person_xml.ID = 1 ;  

SELECT * FROM Person_xml ; 

UPDATE Person_xml
SET Person_Data.modify('replace value of (/Person/Location/text())[1] with "Italy"')
WHERE Person_xml.ID = 1 ;

SELECT * FROM Person_xml ;

UPDATE Person_xml
SET Person_Data.modify('insert <Person> PersonID="7"<Name> Olga </Name>
		<Country>US</Country><Location>Mexico </Location><Salary> 77000</Salary> </Person>
		after (/Person)[1]')
WHERE Person_xml.ID = 2 ; 

SELECT * FROM Person_xml ;

