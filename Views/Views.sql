/*
Date: Nov 13, 2018
Project Name: Views 
Author: Olga Lazarenko
Description: the purpose of this project is to create views 
*/

USE AdventureWorks2014;
GO

 CREATE VIEW v_Person 
AS 
SELECT BusinessEntityID AS PersonID
	, PersonType
	, FirstName 
	, LastName
	, EmailPromotion
	, Demographics
	, ModifiedDate
FROM Person.Person ;
GO 

SELECT 
	PersonID
	, PersonType
	, LastName
	, FirstName
	, EmailPromotion
	, Demographics
	, ModifiedDate
FROM v_Person ; 
--19972 rows returned 

DROP VIEW v_Person ;
GO 

--create the table Person.Person2 as a copy of the table Person.Person ( not all columns) 
SELECT 
	BusinessEntityID AS PersonID
	, PersonType
	, FirstName 
	, LastName
	, EmailPromotion
	, Demographics
	, ModifiedDate
INTO Person.Person_copy1
FROM Person.Person ; 
GO



CREATE VIEW v_Person_copy1
AS 
SELECT * FROM Person.Person_copy1
GO 

ALTER TABLE Person.Person_copy1
	DROP COLUMN Demographics ; 
GO
 
 SELECT *
 FROM v_Person_copy1 ; -- the view is based on the table Person.Person_copy1; 
                        -- table has been recently modified
/* error notification :
Msg 4502, Level 16, State 1, Line 61
View or function 'v_Person2' has more column names specified than columns defined.
*/

DROP VIEW v_Person_copy1 ; 
GO 
-- create the view v_Person_copy1 with schemabinding
CREATE VIEW v_Person_copy1
WITH SCHEMABINDING 
AS 
SELECT 
	PersonID
	, PersonType
	, FirstName 
	, LastName
	, EmailPromotion
	, ModifiedDate 
FROM Person.Person_copy1 ; 
GO 

ALTER TABLE Person.Person_copy1
	DROP COLUMN EmailPromotion ; 
/* notification: 
Msg 5074, Level 16, State 1, Line 85
The object 'v_Person_copy1' is dependent on column 'EmailPromotion'.
Msg 4922, Level 16, State 9, Line 85
ALTER TABLE DROP COLUMN EmailPromotion failed because one or more objects access this column.
*/

-- in order to drop the column EmailPromotion from the table I will drop the view v_Person_copy1
-- then drop the column from the table and re-create the view again

IF OBJECT_ID(N'v_Person_copy1', N'V') IS NOT NULL
DROP VIEW v_Person_copy1 ; 

ALTER TABLE Person.Person_copy1
	DROP COLUMN EmailPromotion ; 

--check the existing columns in the table 
SELECT * FROM Person.Person_copy1 ; 
GO 

-- re-create the view with schemabinding on this table
CREATE VIEW v_Person_copy1
WITH SCHEMABINDING
AS 
SELECT 
	PersonID
	, PersonType
	, FirstName 
	, LastName
	, ModifiedDate 
FROM Person.Person_copy1 ; 
GO 


SELECT * 
FROM v_Person_copy1 ; 
--the view does not contain the column EmailPromotion 

--drop the table Person.Person_copy1 and the view v_Person_copy1
IF OBJECT_ID(N'Person.Person_copy1', N'U') IS NOT NULL 
DROP TABLE Person.Person_copy1 ; 
-- notificaton:
/* Msg 3729, Level 16, State 1, Line 127
Cannot DROP TABLE 'Person.Person_copy1' because it is being referenced by object 'v_Person_copy1'.
*/

DROP VIEW v_Person_copy1 ; 
 