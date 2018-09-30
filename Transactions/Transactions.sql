/*
Date: Sep 29, 2018
Project Name: Transactions
Author: Olga Lazarenko
Description: create code with transactions
			- automatic 
			- implicit
			- explicit
			- @@TRANCOUNT
			- XACT_STATE
*/

USE AdventureWorks2014 ; 
GO

SELECT * FROM Person.NewSalesPerson ; 
SELECT @@TRANCOUNT AS transaction_level,  -- @@TRANCOUNT function display the level of the transaction
		 XACT_STATE() AS transaction_state ; -- the transaction state 
--level =  0 returned: no active transaction 
-- state = 0 : no active transaction


BEGIN TRANSACTION ; -- execute this 
SELECT @@TRANCOUNT AS transaction_level,  -- @@TRANCOUNT function display the level of the transaction
		 XACT_STATE() AS transaction_state ; -- the transaction state 
/* level = 1, there is an active transaction, the transaction is not nested
	state = 1, the transaction is not committed yet, but can be committed, the nesting level is not reported here
*/
SELECT * FROM Person.NewSalesPerson ; 

SELECT @@TRANCOUNT AS transaction_level,  -- @@TRANCOUNT function display the level of the transaction
		 XACT_STATE() AS transaction_state ; -- the transaction state
-- level = 1, state = 1

COMMIT TRANSACTION ; 

SELECT @@TRANCOUNT AS transaction_level,  -- @@TRANCOUNT function display the level of the transaction
		 XACT_STATE() AS transaction_state ; -- the transaction state
-- level = 0, state = 0

GO

-- example with a nested transaction ***********************************************************
BEGIN TRANSACTION ; 
SELECT @@TRANCOUNT AS transaction_level,  -- @@TRANCOUNT function display the level of the transaction
		 XACT_STATE() AS transaction_state ; -- the transaction state
-- returned: the transaction level = 1 ( there is an active tran-n , 
-- the transaction state = 1 (not commited yet, but can be committed)
	BEGIN TRANSACTION ; 
	SELECT @@TRANCOUNT AS transaction_level,  --  the level of the transaction
		 XACT_STATE() AS transaction_state ; -- the transaction state
	/* the transaction level = 2, it is > 1, the transaction  is nested
		the transaction state = 1 , not committed yet, but can be committed
	*/
	SELECT * FROM Person.NewSalesPerson ; 
	SELECT @@TRANCOUNT AS transaction_level,  --  the level of the transaction
		 XACT_STATE() AS transaction_state ; -- the transaction state
	/* the transaction level = 2, it is > 1, the transaction  is nested, the nesting level = 2
		the transaction state = 1 , not committed yet, but can be committed
	*/
	COMMIT TRANSACTION ; -- this will commit the inner transaction
	SELECT @@TRANCOUNT AS transaction_level,  --  the level of the transaction
		 XACT_STATE() AS transaction_state ; -- the transaction state
	/* the transaction level = 1, it is > 0, the transaction  is active, but not nested  
		the transaction state = 1 , not committed yet, but can be committed
	*/
COMMIT TRANSACTION ; -- this will commit the outer transaction 
SELECT @@TRANCOUNT AS transaction_level,  --  the level of the transaction
		 XACT_STATE() AS transaction_state ; -- the transaction state
	/* the transaction level = 0, there is no active transaction 
		the transaction state = 0 ,there is no active transaction
    */

ROLLBACK TRANSACTION ; 

USE AdventureWorks2014 ; 
GO
SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ; 
-- tr_level = 0 , tr_state = 0   => there is no active transaction 

-- create a transaction with the nesting level = 3 
BEGIN TRANSACTION ; 
SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ; 
-- tr_level = 1 (active transaction) , tr_state = 1 ( not committed but can be committed)
	BEGIN TRANSACTION ; 
	SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
	-- tr_level = 2>1 ( active transaction with the  nesting level = 2)
	-- tr-state = 1 ( uncommitted, but can be committed)
		BEGIN TRANSACTION ; 
		SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
		-- tr_level = 3 ( active transaction with the nesting level = 3)
		-- tr_state = 1 ( uncommitted, but can be committed)

		SELECT * FROM Person.NewSalesPerson ; 
		SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
		-- tr_level = 3 ( active transaction with the nesting level = 3)
		-- tr_state = 1 ( uncommitted, but can be committed)
		COMMIT TRANSACTION ; -- commit the most inner transaction
		SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
		-- tr_level = 2 , the nesting level 
		-- tr_state = 1
	COMMIT TRANSACTION ; 
	SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
		-- tr_level = 1 , the transaction is not nested , but active 
		-- tr_state = 1
COMMIT TRANSACTION ; -- will commit the outer transaction 
SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
-- tr_level = 0 , there is no active transaction 
-- tr_state = 0 , there is no active transaction 
ROLLBACK ; 
GO 

-- *****************************************************************************************************************************

USE AdventureWorks2014 ; 
GO 

SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
-- tr_level = 0 , there is no active transaction 
-- tr_state = 0 , there is no active transaction 


-- implicit transaction (doesn't have BEGIN statement, but must have COMMIT or ROLLBACK )
SET IMPLICIT_TRANSACTIONS ON ; 
SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
-- tr_level = 0 , there is no active transaction 
-- tr_state = 0 , there is no active transaction

UPDATE Person.NewSalesPerson
	SET FirstName = 'Rosetta'
	WHERE PersonID = 1 ; 
SELECT * FROM Person.NewSalesPerson ; -- the update is applyed 
SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
-- tr_level = 1 , there is  active transaction 
-- tr_state = 1 , there is uncommitted transaction 

ROLLBACK TRANSACTION ; 
SELECT * FROM Person.NewSalesPerson ; -- the change has been rolled back
SELECT @@TRANCOUNT AS tr_level, XACT_STATE() AS tr_state ;
-- tr_level = 0 , there is  active transaction 
-- tr_state = 0 , there is uncommitted transaction 

SET IMPLICIT_TRANSACTIONS OFF ; 