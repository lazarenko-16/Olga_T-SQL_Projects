
/* Date: August 29, 2018
Project Name: Temporary tables  
Author: Olga Lazarenko
Description: create local and global temporary tables 
			
*/

USE AdventureWorks2014 ; 
GO 


-- create local temporary table 
CREATE TABLE #Employees
(EmpID INT IDENTITY(1,1) NOT NULL
,FirstName varchar(20) NOT NULL
, LastName varchar(50) NOT NULL
, SSN varchar(15) NOT NULL
, PhoneNumber varchar(15) NULL
)
; 

INSERT INTO #Employees (FirstName, LastName, SSN, PhoneNumber)
VALUES
('Olga', 'Lazarenko', '1112223333','317-122-5408')
, ('Mary', 'Smith', '2221013170', '317-299-4485')
; 

SELECT * FROM #Employees ; 
GO

EXEC('SELECT * FROM #Employees;');
GO 

INSERT INTO #Employees (FirstName, LastName, SSN, PhoneNumber)
VALUES
('Joe', 'Labert', '3049523467', '5552040858')
; 
DROP TABLE #Employees ; 

-- check the indexes on the temporary table #Employee
SELECT * 
FROM sys.index_columns
WHERE object_id =
	(SELECT object_id
	FROM sys.indexes
	WHERE name LIKE '#Employees')
; -- no indexes exists at the table now

--create a primary key on the column EmpID
ALTER TABLE #Employees
	ADD PRIMARY KEY (EmpID)
; 