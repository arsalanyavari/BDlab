-- Part1
USE AdventureWorks2012
GO
SELECT Name, Europe, [North America], Pacific
FROM(
	SELECT Production.Product.Name, Sales.SalesTerritory.[Group] AS Region
	FROM Production.Product INNER JOIN Sales.SalesOrderDetail 
	ON (Production.Product.ProductID = Sales.SalesOrderDetail.ProductID) INNER JOIN Sales.SalesOrderHeader 
	ON (Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID) INNER JOIN Sales.SalesTerritory 
	ON (Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID)
)AS PIVOTSOURCE
PIVOT(
	COUNT(Region)
	FOR Region in (Europe, [North America], Pacific)
)AS PIVOTED;

-- Part2
--SELECT Person.BusinessEntityID, PersonType, Gender
--FROM Person.Person JOIN HumanResources.Employee ON (Person.BusinessEntityID =
--Employee.BusinessEntityID);

SELECT PersonType, M, F
FROM(
	SELECT Person.BusinessEntityID, PersonType, Gender
	FROM Person.Person JOIN HumanResources.Employee ON (Person.BusinessEntityID =
	Employee.BusinessEntityID)
	) AS PivotSource
PIVOT(
	COUNT(BusinessEntityID)
	FOR Gender IN (M, F)
)AS PIVOTED;

-- Part3
SELECT Production.Product.Name
FROM Production.Product
WHERE LEN(Production.Product.Name) < 15 AND Production.Product.Name LIKE '%e_';

--Part4

--DROP FUNCTION dbo.GetHajriDate;
IF OBJECT_ID (N'dbo.GetHajriDate', N'FN') IS NOT NULL
 DROP FUNCTION GetHajriDate;
GO
CREATE FUNCTION dbo.GetHajriDate(@inputMonthIndex int)
RETURNS NVARCHAR(20)
AS
BEGIN
DECLARE @farsi_month NVARCHAR(20);
WITH MonthIndexToName (month_index, month_farsi)
AS (
	SELECT 1, N'فروردین'
	UNION
	SELECT 2, N'اردیبهشت'
	UNION
	SELECT 3, N'خرداد'
	UNION
	SELECT 4, N'تیر'
	UNION
	SELECT 5, N'مرداد'
	UNION
	SELECT 6, N'شهریور'
	UNION
	SELECT 7, N'مهر'
	UNION
	SELECT 8, N'آبان'
	UNION
	SELECT 9, N'آذر'
	UNION
	SELECT 10, N'دی'
	UNION
	SELECT 11, N'بهمن'
	UNION
	SELECT 12, N'اسفند'
)
	SELECT @farsi_month = month_farsi
    FROM MonthIndexToName
    WHERE  @inputMonthIndex = month_index
    RETURN @farsi_month;
END;



--DROP FUNCTION dbo.CheckDateFormat;
IF OBJECT_ID (N'dbo.CheckDateFormat', N'FN') IS NOT NULL
 DROP FUNCTION CheckDateFormat;
GO
CREATE FUNCTION dbo.CheckDateFormat(@inputDate VARCHAR(10))
RETURNS NVARCHAR(64)
AS
BEGIN
DECLARE @day NVARCHAR(2);
DECLARE @month NVARCHAR(20);
DECLARE @year NVARCHAR(5);
DECLARE @ret NVARCHAR(64);
IF(
      @inputDate LIKE '____/__/__'
      AND CONVERT(INT, RIGHT(@inputDate, 2)) BETWEEN 1 AND 30
      AND CONVERT(INT, SUBSTRING(@inputDate, 6, 2)) BETWEEN 1 AND 12
      AND CONVERT(INT, LEFT(@inputDate, 4)) > 0
    )
BEGIN
	SET @day = SUBSTRING(@inputDate, 9, 10);
	SET @year = SUBSTRING(@inputDate, 1, 4);
	SET @month = dbo.GetHajriDate(CONVERT(int, SUBSTRING(@inputDate, 6, 2)))
	RETURN @day + ' ' + @month + N' ماه ' + CONVERT(nvarchar(20), @year) + N' شمسی ';
	END;
ELSE
	SET @ret =  N'فرمت تاریخ ناصحیح است';
	RETURN @ret;
END;

SELECT dbo.CheckDateFormat('1401/01/16');
SELECT dbo.CheckDateFormat('1400/13/42');

-- Part5
IF object_id(N'Sales.ufn_FindTerritoryByDate', N'if') is not null
  DROP FUNCTION Sales.ufn_FindTerritoryByDate
GO
CREATE FUNCTION Sales.ufn_FindTerritoryByDate(@inputYear int, @inputMonth int, @productName varchar(100))
RETURNS TABLE
AS
RETURN(
	SELECT DISTINCT Sales.SalesTerritory.Name
	FROM Production.Product INNER JOIN Sales.SalesOrderDetail 
    ON(Production.Product.ProductID = Sales.SalesOrderDetail.ProductID) INNER JOIN Sales.SalesOrderHeader
	ON(Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID) INNER JOIN Sales.SalesTerritory 
	ON(Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID)
	WHERE month(Sales.SalesOrderHeader.OrderDate) = @inputMonth AND year(Sales.SalesOrderHeader.OrderDate) = @inputYear AND Production.Product.Name = @productName
);
GO
SELECT * FROM Sales.ufn_FindTerritoryByDate(2005, 7, 'AWC Logo Cap');