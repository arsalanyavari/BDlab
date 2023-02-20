
-- exercise 1

SELECT * FROM Sales.SalesOrderHeader INNER JOIN Sales.SalesTerritory ON
(Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID)
WHERE Sales.SalesOrderHeader.TotalDue >= 100000 AND Sales.SalesOrderHeader.TotalDue <= 500000 AND
	  (Sales.SalesTerritory.Name = 'France' OR Sales.SalesTerritory.[Group] = 'North America');


-- exercise 2

SELECT Sales.SalesOrderHeader.SalesOrderID, Sales.SalesOrderHeader.CustomerID, Sales.SalesOrderHeader.SubTotal, Sales.SalesOrderHeader.OrderDate, Sales.SalesTerritory.Name 
FROM Sales.SalesOrderHeader INNER JOIN Sales.SalesTerritory 
ON (Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID)


-- exercise 3

-- part1
WITH temp AS ( SELECT Sales.SalesOrderHeader.*, Sales.SalesTerritory.Name, Sales.SalesTerritory.[Group] FROM Sales.SalesOrderHeader INNER JOIN Sales.SalesTerritory ON
(Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID)
WHERE Sales.SalesOrderHeader.TotalDue >= 100000 AND Sales.SalesOrderHeader.TotalDue <= 500000 AND
	  (Sales.SalesTerritory.Name = 'France' OR Sales.SalesTerritory.[Group] = 'North America'))
SELECT * INTO NAmerica_Sales  FROM temp WHERE 1<>1;


-- part2
INSERT INTO NAmerica_Sales
SELECT *
FROM (SELECT Sales.SalesOrderHeader.*, Sales.SalesTerritory.Name, Sales.SalesTerritory.[Group] FROM Sales.SalesOrderHeader INNER JOIN Sales.SalesTerritory ON
(Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID)
WHERE Sales.SalesOrderHeader.TotalDue >= 100000 AND Sales.SalesOrderHeader.TotalDue <= 500000 AND
	  (Sales.SalesTerritory.Name = 'France' OR Sales.SalesTerritory.[Group] = 'North America')
) as temp
WHERE  temp.[Group] = 'North America';



--part3
ALTER TABLE NAmerica_Sales ADD Price_Check CHAR(4) check (Price_Check in ('Low','High','Mid'));


--part4
UPDATE NAmerica_Sales Set NAmerica_Sales.Price_Check =
CASE 
	WHEN NAmerica_Sales.SubTotal > (select AVG(NAmerica_Sales.SubTotal) from NAmerica_Sales) THEN  'High'
	WHEN NAmerica_Sales.SubTotal = (select AVG(NAmerica_Sales.SubTotal) from NAmerica_Sales) THEN  'Mid'
	ELSE  'Low'
END

-- just for check :D
SELECT * FROM NAmerica_Sales;



-- exercise 4

SELECT BusinessEntityID ,max(Rate)FROM HumanResources.EmployeePayHistory
GROUP BY BusinessEntityID
ORDER BY BusinessEntityID


with temp (id,salary,rate) as
(SELECT BusinessEntityID ,max(Rate),NTILE(4) OVER (ORDER BY max(Rate) DESC) FROM HumanResources.EmployeePayHistory
GROUP BY BusinessEntityID
)
SELECT temp.id AS BusinessEntityID,
case 
when temp.rate = 4 then temp.salary * 1.2
when temp.rate = 3 then temp.salary * 1.15
when temp.rate = 2 then temp.salary * 1.1
else temp.salary * 1.05
end as NewSalary,
case 
when temp.salary < 29 then 3
when temp.salary>29 and temp.salary<50 then 2
else 1
end as Level
FROM temp
