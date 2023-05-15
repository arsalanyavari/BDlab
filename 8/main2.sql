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
UPDATE Production.Product
SET SafetyStockLevel = SafetyStockLevel - 480
WHERE Name = 'Blade'
COMMIT;