-- Part1
USE AdventureWorks2012
GO

BEGIN TRAN
UPDATE Production.Product
SET Name='new_Blade'
WHERE Name = 'Blade'
WAITFOR DELAY '0:0:08'
ROLLBACK

-- Part 2

-- Dirty Read
USE AdventureWorks2012
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Begin TRAN
UPDATE Production.Product
SET Name ='new_Blade'
WHERE Name = 'Blade'
WAITFOR DELAY '0:0:08'
ROLLBACK

-- Non Repeatable
USE AdventureWorks2012
GO
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN
SELECT * 
FROM Production.Product 
WHERE Name = 'Blade'
WAITFOR DELAY '0:0:08'

SELECT *
FROM Production.Product 
WHERE Name = 'Blade'
ROLLBACK;
