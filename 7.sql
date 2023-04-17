sp_configure 'show advanced options', 1;
RECONFIGURE;
Go
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO
exec sp_configure 'Advanced', 1 RECONFIGURE
exec sp_configure 'Ad Hoc Distributed Queries', 1 
RECONFIGURE
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'AllowInProcess', 1 
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'DynamicParameters', 1 
GO


-- To enable the feature.
 EXEC sp_configure 'xp_cmdshell', 1 
 GO
 -- To update the currently configured value for this feature.
 RECONFIGURE
 GO 

--select * from AdventureWorks2012.Sales.SalesTerritory

-- Part 1
xp_cmdshell 'bcp "SELECT TerritoryID,Name FROM AdventureWorks2012.Sales.SalesTerritory" queryout "C:\Users\user\Desktop\DBlab\7\output\q1-Output.txt" -T -c -t"|"'

-- Part 2
xp_cmdshell 'bcp "SELECT * FROM AdventureWorks2012.Production.Location" queryout "C:\Users\user\Desktop\DBlab\7\output\location.dat" -T -c -t"|"'

-- Part 3

-- SELECT Name, Demographics FROM AdventureWorks2012.Sales.Store

-- SELECT Name, Demographics.query('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";for $survey in /StoreSurvey return <result> {$survey/AnnualSales} {$survey/YearOpened} {$survey/NumberEmployees} </result>') AS Details FROM AdventureWorks2012.Sales.Store

xp_cmdshell 'bcp "SELECT Name, Demographics.query(''declare default element namespace \"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $survey in /StoreSurvey return <result> {$survey/AnnualSales} {$survey/YearOpened} {$survey/NumberEmployees} </result>'') AS Details FROM AdventureWorks2012.Sales.Store" queryout "C:\Users\user\Desktop\DBlab\7\output\q3-Output.txt" -q -T -c -t"|"'

-- Part 5

-- DROP TABLE csv_data

CREATE TABLE csv_data (
  col1 VARCHAR(100),
  col2 VARCHAR(100),
  col3 VARCHAR(100)
);


--DROP PROCEDURE add_csv_files

CREATE PROCEDURE add_csv_files(
    @FilePath VARCHAR(255),
    @FileExteention VARCHAR(255) = '.csv',
    @Table VARCHAR(255))
AS
BEGIN
	DECLARE @bcp VARCHAR(100)
	SET @bcp = 'bcp' + ' ' + @Table + ' IN ' + @FilePath + @FileExteention + ' -T -c -t,'
	EXEC xp_cmdshell @bcp
END

EXEC add_csv_files 'C:\Users\user\Desktop\DBlab\7\filename', '.csv', 'master.dbo.csv_data'

SELECT * FROM csv_data
