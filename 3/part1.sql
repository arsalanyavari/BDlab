-- Amir Arsalan Yavari 
-- 9830253
-- First File

--part 1
--step 1
CREATE LOGIN Arsalan WITH PASSWORD=N'password'

--step 2
CREATE SERVER ROLE Role1
ALTER SERVER ROLE Dbcreator
ADD MEMBER role1;

--step 3
ALTER SERVER ROLE Role1 ADD MEMBER Arsalan;

--step 4
--DROP USER Alaki;
USE AdventureWorks2012
GO
CREATE USER Alaki FOR LOGIN Arsalan;
ALTER ROLE db_owner ADD MEMBER Alaki;

