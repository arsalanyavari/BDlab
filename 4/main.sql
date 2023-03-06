-- Amir Arsalan Yavari
-- 9830253

-- part 1
USE AdventureWorks2012
GO
SELECT Sales.SalesOrderHeader.OrderDate, Sales.SalesOrderDetail.LineTotal,
AVG(Sales.SalesOrderDetail.LineTotal)OVER (PARTITION BY Sales.SalesOrderHeader.CustomerID
ORDER BY Sales.SalesOrderHeader.OrderDate, Sales.SalesOrderHeader.SalesOrderID
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM Sales.SalesOrderHeader JOIN Sales.SalesOrderDetail ON
(SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)

-- Explain:
-- The result set of this query will contain three columns: OrderDate, LineTotal, and 
-- the calculated average LineTotal for each customer's previous two orders and the current order.

-- part 2
SELECT  
(
	CASE GROUPING (Sales.SalesTerritory.Name)
	WHEN '0' THEN Sales.SalesTerritory.Name
	WHEN '1' THEN 'All Territories'
	END
) AS TerritoryName,
(
	CASE GROUPING (Sales.SalesTerritory.[Group])
	WHEN '0' THEN (Sales.SalesTerritory.[Group])
	WHEN '1' THEN 'All Regions'
	END
) AS Region,
	SUM(Sales.SalesOrderHeader.SubTotal) AS SalesTotal,
	COUNT(Sales.SalesOrderHeader.SalesOrderID) AS SalesCount        
FROM Sales.SalesOrderHeader INNER JOIN Sales.SalesTerritory 
ON (Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID)
GROUP BY ROLLUP (Sales.SalesTerritory.[Group], Sales.SalesTerritory.Name)
--GROUP BY ROLLUP (Sales.SalesTerritory.Name, Sales.SalesTerritory.[Group])

-- Explain:
-- If we change the place of the roll-up fields, it will calculate the territory once for each territory
-- and once with its region, that's why the number of output lines will be doubled except for the total.
-- For example, in the desired state of the issue, there are 14 lines, 4 of which will be All Territories,
-- so we will have 20 lines and one line for All Territories, which will be 21 output lines in total.

-- part 3
SELECT
(
	CASE GROUPING (Production.ProductSubcategory.Name)
	WHEN '0' THEN Production.ProductSubcategory.Name
	WHEN '1' THEN 
	(
		CASE GROUPING (Production.ProductCategory.Name)
		WHEN '0' THEN Production.ProductCategory.Name
		WHEN '1' THEN 'All Categories'
		END
	)
	END
),
(
	CASE GROUPING (Production.ProductCategory.Name)
	WHEN '0' THEN Production.ProductCategory.Name
	WHEN '1' THEN 'All Categories'
	END
),
	SUM (Sales.SalesOrderDetail.OrderQty),
    SUM (Sales.SalesOrderDetail.LineTotal)
FROM Production.Product INNER JOIN Production.ProductSubcategory
  ON (Production.Product.ProductSubcategoryID = Production.ProductSubcategory.ProductSubcategoryID) INNER JOIN Production.ProductCategory 
  ON (Production.ProductSubcategory.ProductCategoryID = Production.ProductCategory .ProductCategoryID) INNER JOIN Sales.SalesOrderDetail 
  ON (Production.Product.ProductID = Sales.SalesOrderDetail.ProductID)
GROUP BY ROLLUP(Production.ProductCategory.Name, Production.ProductSubcategory.Name)

-- part 4
WITH temp (businessId,NationalId,Gender,MaritalStatus,JobTitle,HowManyOfficerInThere) 
AS
(
	SELECT Employee.BusinessEntityID,HumanResources.Employee.NationalIDNumber, HumanResources.Employee.Gender,
	CASE WHEN HumanResources.Employee.MaritalStatus LIKE 'S' THEN 'Single'
	ELSE 'Married'
	END AS MaritalStatus, Employee.JobTitle, count(Employee.JobTitle) OVER (PARTITION BY Employee.JobTitle) AS HowManyOfficer
	FROM HumanResources.Employee
)
SELECT Person.FirstName + ' ' + Person.MiddleName + ' ' + Person.LastName AS Name, NationalId, Gender, MaritalStatus, JobTitle, HowManyOfficerInThere 
FROM temp JOIN Person.Person 
ON (Person.BusinessEntityID =  temp.businessId)
WHERE HowManyOfficerInThere > 3

--SELECT Employee.BusinessEntityID,HumanResources.Employee.NationalIDNumber, HumanResources.Employee.Gender
--FROM HumanResources.Employee