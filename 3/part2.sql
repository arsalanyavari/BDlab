-- Amir Arsalan Yavari 
-- 9830253
-- Second File

--part 1
--continue of step 4
CREATE TABLE newtable(
	Name varchar(20) NOT NULL,
	ID char(8) primary key
);

insert into newtable values('Arsaln Yavari','88888888');

select * from newtable;

--part 2
--step 1
USE AdventureWorks2012
GO

CREATE ROLE Role2
ALTER ROLE db_securityadmin
ADD member Role2;

--step 2
GRANT SELECT ON DATABASE::AdventureWorks2012 TO Role2;