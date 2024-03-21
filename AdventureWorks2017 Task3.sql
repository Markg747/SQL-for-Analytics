USE AdventureWorks2017;

--1
SELECT * FROM [HumanResources].[Employee] ORDER BY JobTitle ASC

--2
SELECT * FROM [Person].[Person] ORDER BY LastName ASC

--3
SELECT [Person].[Person].FirstName, [Person].[Person].LastName, [Person].[Person].businessentityid AS Employee_Id
FROM [Person].[Person]
ORDER BY [Person].[Person].LastName

--4
SELECT [Production].[Product].productid, [Production].[Product].productnumber, [Production].[Product].name
FROM [Production].[Product]
WHERE SellStartDate IS NOT NULL AND ProductLine = 'T'
ORDER BY Name ASC;

--5
SELECT [Sales].[SalesOrderHeader].salesorderid, [Sales].[SalesOrderHeader].customerid, [Sales].[SalesOrderHeader].orderdate, 
[Sales].[SalesOrderHeader].subtotal, (TaxAmt/SubTotal * 100) AS PercentageOfTax
FROM [Sales].[SalesOrderHeader]
ORDER BY SubTotal DESC

--6
SELECT DISTINCT JobTitle FROM [HumanResources].[Employee] ORDER BY JobTitle ASC

--7
SELECT [Sales].[SalesOrderHeader].CustomerID, SUM([Sales].[SalesOrderHeader].Freight) TotalFreight
FROM [Sales].[SalesOrderHeader]
GROUP BY [Sales].[SalesOrderHeader].CustomerID
ORDER BY [Sales].[SalesOrderHeader].CustomerID

--8
SELECT [Sales].[SalesOrderHeader].customerid, [Sales].[SalesOrderHeader].SalesPersonID, AVG([Sales].[SalesOrderHeader].Subtotal) AS Average, SUM([Sales].[SalesOrderHeader].subtotal) AS Sum
FROM [Sales].[SalesOrderHeader]
GROUP BY [Sales].[SalesOrderHeader].CustomerID, [Sales].[SalesOrderHeader].SalesPersonId
ORDER BY CustomerId DESC

--9
SELECT [Production].[ProductInventory].ProductID, SUM([Production].[ProductInventory].Quantity) AS Total_Quantity
FROM [Production].[ProductInventory]
WHERE [Production].[ProductInventory].Shelf IN ('A','C','H')
GROUP BY [Production].[ProductInventory].ProductID
HAVING SUM([Production].[ProductInventory].Quantity) > 500
ORDER BY [Production].[ProductInventory].ProductID;

--10
SELECT [Production].[ProductInventory].LocationID, SUM([Production].[ProductInventory].Quantity) * 10 AS SumQuantity
FROM [Production].[ProductInventory]
GROUP BY [Production].[ProductInventory].LocationID

--11
SELECT [Person].[Person].BusinessEntityID, [Person].[Person].FirstName, [Person].[Person].LastName, [Person].[PersonPhone].PhoneNumber
FROM 
[Person].[Person]
INNER JOIN [Person].[PersonPhone]
ON [Person].[Person].BusinessEntityID = [Person].[PersonPhone].BusinessEntityID
WHERE [Person].[Person].LastName LIKE 'L%'
ORDER BY [Person].[Person].LastName, [Person].[Person].FirstName

--12
SELECT [Sales].[SalesOrderHeader].salespersonid, [Sales].[SalesOrderHeader].customerid, SUM([Sales].[SalesOrderHeader].subtotal) AS SumSubtotal
FROM [Sales].[SalesOrderHeader]
WHERE SalesPersonID IS NOT NULL
GROUP BY ROLLUP([Sales].[SalesOrderHeader].SalesPersonId, [Sales].[SalesOrderHeader].CustomerId)
ORDER BY SalesPersonID 

--13
SELECT [Production].[ProductInventory].LocationID, [Production].[ProductInventory].shelf, SUM([Production].[ProductInventory].quantity) AS TotalQuantity
FROM [Production].[ProductInventory]
GROUP BY CUBE ([Production].[ProductInventory].LocationID, [Production].[ProductInventory].Shelf)

--14
SELECT [Production].[ProductInventory].LocationID, [Production].[ProductInventory].Shelf, SUM([Production].[ProductInventory].quantity) AS TotalQuantity
FROM
[Production].[ProductInventory]
GROUP BY GROUPING SETS (ROLLUP([Production].[ProductInventory].LocationID, [Production].[ProductInventory].Shelf), CUBE([Production].[ProductInventory].LocationID, [Production].[ProductInventory].Shelf)) 

--15
SELECT [Production].[ProductInventory].LocationID, SUM([Production].[ProductInventory].Quantity) AS GrandTotal
FROM
[Production].[ProductInventory]
GROUP BY GROUPING SETS ( locationid, () );

--16
SELECT [Person].[Address].City, COUNT([Person].[BusinessEntityAddress].BusinessEntityID) AS NumberOfEmployee
FROM [Person].[Address]
INNER JOIN [Person].[BusinessEntityAddress]
ON [Person].[Address].AddressID = [Person].[BusinessEntityAddress].AddressID
GROUP BY [Person].[Address].City
ORDER BY [Person].[Address].City ASC;

--17
SELECT YEAR([Sales].[SalesOrderHeader].OrderDate) AS Year, SUM([Sales].[SalesOrderHeader].TotalDue) AS TotalSales
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR([Sales].[SalesOrderHeader].OrderDate)
ORDER BY YEAR([Sales].[SalesOrderHeader].OrderDate);

--18
SELECT YEAR([Sales].[SalesOrderHeader].OrderDate) AS Year, SUM([Sales].[SalesOrderHeader].TotalDue) AS TotalSales
FROM [Sales].[SalesOrderHeader]
WHERE YEAR([Sales].[SalesOrderHeader].OrderDate) < 2016
GROUP BY YEAR([Sales].[SalesOrderHeader].OrderDate)
ORDER BY YEAR([Sales].[SalesOrderHeader].OrderDate);

--19
SELECT [Person].[ContactType].ContactTypeID, [Person].[ContactType].name
FROM [Person].[ContactType]
WHERE [Person].[ContactType].Name LIKE '%manager%'
ORDER BY [Person].[ContactType].ContactTypeID DESC

--20
SELECT [Person].[Person].BusinessEntityID, [Person].[Person].LastName, [Person].[Person].FirstName
FROM [Person].[Person]
INNER JOIN [Person].[BusinessEntityContact]
ON [Person].[Person].BusinessEntityID = [Person].[BusinessEntityContact].PersonID
INNER JOIN [Person].[ContactType]
ON [Person].[ContactType].ContactTypeID = [Person].[BusinessEntityContact].ContactTypeID
WHERE [Person].[ContactType].Name = 'Purchasing Manager'
ORDER BY [Person].[Person].LastName, [Person].[Person].FirstName;

--21
SELECT [Person].[Person].LastName, [Sales].[SalesPerson].SalesYTD, [Person].[Address].PostalCode
FROM [Person].[Person]
INNER JOIN [Sales].[SalesPerson]
ON [Sales].[SalesPerson].BusinessEntityID = [Person].[Person].BusinessEntityID
INNER JOIN [Person].[BusinessEntityAddress]
ON [Person].[BusinessEntityAddress].BusinessEntityID = [Sales].[SalesPerson].BusinessEntityID
INNER JOIN [Person].[Address]
ON [Person].[Address].AddressID = [Person].[BusinessEntityAddress].AddressID
WHERE [Sales].[SalesPerson].TerritoryID IS NOT NULL AND [Sales].[SalesPerson].SalesYTD IS NOT NULL
ORDER BY [Sales].[SalesPerson].SalesYTD DESC;

SELECT ROW_NUMBER() OVER (PARTITION BY PostalCode ORDER BY SalesYTD DESC) AS "Row Number",
pp.LastName, sp.SalesYTD, pa.PostalCode
FROM Sales.SalesPerson AS sp
    INNER JOIN Person.Person AS pp
        ON sp.BusinessEntityID = pp.BusinessEntityID
    INNER JOIN Person.Address AS pa
        ON pa.AddressID = pp.BusinessEntityID
WHERE TerritoryID IS NOT NULL
    AND SalesYTD <> 0
ORDER BY PostalCode;

/**ROW_NUMBER() OVER (PARTITION BY PostalCode ORDER BY SalesYTD DESC) AS "Row Number": 
This assigns a unique row number to each row within each partition defined by PostalCode, 
ordered by SalesYTD in descending order.
This query is using the ROW_NUMBER() window function to assign a row number within each partition defined by PostalCode, 
ordered by SalesYTD in descending order. Then, it selects the LastName, SalesYTD, and PostalCode columns from the SalesPerson, 
Person, and Address tables, respectively, joining them together based on certain criteria.**/

--22
SELECT [Person].[ContactType].ContactTypeID, [Person].[ContactType].Name, COUNT([Person].[BusinessEntityContact].ContactTypeID) AS NumberOfContacts
FROM [Person].[ContactType]
INNER JOIN [Person].[BusinessEntityContact]
ON [Person].[ContactType].ContactTypeID = [Person].[BusinessEntityContact].ContactTypeID
GROUP BY [Person].[ContactType].ContactTypeID, [Person].[ContactType].Name
HAVING COUNT([Person].[BusinessEntityContact].ContactTypeID) > 100
ORDER BY COUNT([Person].[BusinessEntityContact].ContactTypeID) DESC

--23
SELECT CAST([HumanResources].[EmployeePayHistory].RateChangeDate AS DATE) AS Date, CONCAT([Person].[Person].LastName,', ',  [Person].[Person].MiddleName,' ', [Person].[Person].FirstName) AS EmployeeName, [HumanResources].[EmployeePayHistory].Rate * 40 AS WeeklySalary
FROM [Person].[Person]
INNER JOIN [HumanResources].[EmployeePayHistory]
ON [HumanResources].[EmployeePayHistory].BusinessEntityID = [Person].[Person].BusinessEntityID
ORDER BY EmployeeName;

--24 **
SELECT CAST([HumanResources].[EmployeePayHistory].RateChangeDate AS DATE) AS Date, CONCAT([Person].[Person].LastName,', ',  [Person].[Person].MiddleName,' ', [Person].[Person].FirstName) AS EmployeeName, [HumanResources].[EmployeePayHistory].Rate * 40 AS WeeklySalary
FROM [Person].[Person]
INNER JOIN [HumanResources].[EmployeePayHistory]
ON [HumanResources].[EmployeePayHistory].BusinessEntityID = [Person].[Person].BusinessEntityID
WHERE [HumanResources].[EmployeePayHistory].RateChangeDate IN(
SELECT MAX(RateChangeDate) FROM [HumanResources].[EmployeePayHistory]
WHERE [HumanResources].[EmployeePayHistory].BusinessEntityID = [Person].[Person].BusinessEntityID)
ORDER BY EmployeeName

--25
SELECT [Sales].[SalesOrderDetail].SalesOrderID, [Sales].[SalesOrderDetail].ProductID, [Sales].[SalesOrderDetail].OrderQty,
SUM([Sales].[SalesOrderDetail].OrderQty) OVER (PARTITION BY SalesOrderID)  AS SUM,
AVG(CAST([Sales].[SalesOrderDetail].OrderQty AS DECIMAL(10,7))) OVER (PARTITION BY SalesOrderID) AS AVERAGE, 
COUNT([Sales].[SalesOrderDetail].OrderQty) OVER (PARTITION BY SalesOrderID) AS COUNT, 
MAX([Sales].[SalesOrderDetail].OrderQty) OVER (PARTITION BY SalesOrderID) AS MAX, 
MIN([Sales].[SalesOrderDetail].OrderQty) OVER (PARTITION BY SalesOrderID) AS MIN
FROM [Sales].[SalesOrderDetail]
WHERE [Sales].[SalesOrderDetail].SalesOrderID IN ('43659', '43664')

/**OVER: This keyword indicates that you're using a window function.
PARTITION BY: This clause divides the result set into partitions or groups based on the specified column or expression.
When you use OVER (PARTITION BY SalesOrderID), you're instructing the window function to calculate values separately for
each distinct value of SalesOrderID. In other words:
The result set is divided into partitions (grouped by), with each partition containing rows that have the same SalesOrderID.
Within each partition, the window function calculates its result independently. For example, if you use SUM(OrderQty), 
it calculates the sum of OrderQty within each partition.**/


--26**
SELECT [Sales].[SalesOrderDetail].SalesOrderID, [Sales].[SalesOrderDetail].ProductID, [Sales].[SalesOrderDetail].OrderQty,
SUM([Sales].[SalesOrderDetail].OrderQty) OVER (PARTITION BY SalesOrderID)  AS SUM,
AVG(CAST([Sales].[SalesOrderDetail].OrderQty AS DECIMAL(10,7))) OVER (PARTITION BY SalesOrderID) AS AVERAGE, 
COUNT([Sales].[SalesOrderDetail].OrderQty) OVER (PARTITION BY SalesOrderID) AS COUNT
FROM [Sales].[SalesOrderDetail]
WHERE [Sales].[SalesOrderDetail].SalesOrderID IN ('43659', '43664') AND
[Sales].[SalesOrderDetail].ProductID LIKE '71%'

--27
SELECT [Sales].[SalesOrderDetail].SalesOrderID, SUM([Sales].[SalesOrderDetail].OrderQty * [Sales].[SalesOrderDetail].UnitPrice) AS Total
FROM 
[Sales].[SalesOrderDetail]
GROUP BY [Sales].[SalesOrderDetail].SalesOrderID
HAVING SUM([Sales].[SalesOrderDetail].LineTotal) > 100000

--28
 SELECT [Production].[Product].ProductID, [Production].[Product].Name
 FROM [Production].[Product]
 WHERE [Production].[Product].Name LIKE 'Lock Washer%'
 ORDER BY [Production].[Product].ProductID ASC;

 --29
 SELECT [Production].[Product].ProductID, [Production].[Product].name, [Production].[Product].Color
 FROM [Production].[Product]
 ORDER BY [Production].[Product].ListPrice

 --30
 SELECT [HumanResources].[Employee].BusinessEntityID, [HumanResources].[Employee].JobTitle, [HumanResources].[Employee].HireDate
 FROM [HumanResources].[Employee]
 ORDER BY [HumanResources].[Employee].HireDate ASC

 --31
 SELECT [Person].[Person].lastname, [Person].[Person].firstname
 FROM [Person].[Person]
 WHERE [Person].[Person].LastName LIKE 'R%'
 ORDER BY [Person].[Person].FirstName ASC, [Person].[Person].LastName DESC

 --32
 SELECT [HumanResources].[Employee].BusinessEntityID, [HumanResources].[Employee].SalariedFlag
 FROM [HumanResources].[Employee]
 ORDER BY
 CASE
	WHEN [HumanResources].[Employee].SalariedFlag = CAST(1 AS BIT) THEN  [HumanResources].[Employee].BusinessEntityID END DESC,
 CASE
	WHEN [HumanResources].[Employee].SalariedFlag = CAST(0 AS BIT) THEN  [HumanResources].[Employee].BusinessEntityID END ASC

	/**This is how you use if and else if statements, but in sql you use CASE, WHEN and THEN as shown above
	for boolean TRUE is CAST(1 AS BIT) FALSE is CAST(0 AS BIT)**/

 --33
SELECT [Sales].[SalesPerson].BusinessEntityID,
[Person].[Person].LastName, 
[Sales].[SalesTerritory].Name AS TerritoryName, 
[Person].[CountryRegion].Name AS CountryRegionName
FROM [Sales].[SalesPerson]
INNER JOIN [Person].[Person]
ON [Person].[Person].BusinessEntityID = [Sales].[SalesPerson].BusinessEntityID
INNER JOIN [Sales].[SalesTerritory]
ON [Sales].[SalesTerritory].TerritoryID = [Sales].[SalesPerson].TerritoryID
INNER JOIN [Person].[CountryRegion]
ON [Person].[CountryRegion].CountryRegionCode = [Sales].[SalesTerritory].CountryRegionCode
ORDER BY
	CASE 
		WHEN [Person].[CountryRegion].Name = 'United States' THEN [Sales].[SalesTerritory].Name
		ELSE [Person].[CountryRegion].Name
		END

		/**This is how you use if and else statements, but in sql you use CASE, WHEN and THEN as shown above**/
--34
SELECT [Person].[Person].FirstName, [Person].[Person].LastName, 
ROW_NUMBER() OVER (ORDER BY [Person].[Address].PostalCode) AS RowNumber,
RANK() OVER (ORDER BY [Person].[Address].PostalCode) AS Rank,
Dense_Rank() OVER (ORDER BY [Person].[Address].PostalCode) AS DenseRank,
NTILE(4) OVER (ORDER BY [Person].[Address].PostalCode) AS Quartile,
[Sales].[SalesPerson].SalesYTD, [Person].[Address].PostalCode
FROM [Sales].[SalesPerson]
INNER JOIN [Person].[Person]
ON [Person].[Person].BusinessEntityID = [Sales].[SalesPerson].BusinessEntityID
INNER JOIN 
[Person].[BusinessEntityAddress]
ON [Person].[BusinessEntityAddress].BusinessEntityID = [Sales].[SalesPerson].BusinessEntityID
INNER JOIN
[Person].[Address]
ON [Person].[Address].AddressID = [Person].[BusinessEntityAddress].AddressID
WHERE TerritoryID IS NOT NULL AND SalesYTD <> 0;

--35
SELECT * FROM [HumanResources].[Department]
ORDER BY DepartmentID
OFFSET 10 ROWS

/**To remove n number of rows you need to order the list first then OFFSET the number of rows
you want to remove**/

--36
SELECT * FROM [HumanResources].[Department]
ORDER BY DepartmentID
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;

--37
SELECT [Production].[Product].Name, [Production].[Product].Color, [Production].[Product].ListPrice
FROM [Production].[Product]
WHERE [Production].[Product].Color IN ('blue', 'Red')
ORDER BY [Production].[Product].ListPrice;

--38
SELECT [Production].[Product].Name, [Sales].[SalesOrderDetail].SalesOrderID
FROM [Production].[Product]
FULL JOIN
[Sales].[SalesOrderDetail]
ON [Production].[Product].ProductID = [Sales].[SalesOrderDetail].ProductID
ORDER BY [Production].[Product].Name

--39
SELECT [Production].[Product].Name, [Sales].[SalesOrderDetail].SalesOrderID
FROM [Production].[Product]
LEFT JOIN
[Sales].[SalesOrderDetail]
ON [Production].[Product].ProductID = [Sales].[SalesOrderDetail].ProductID
ORDER BY [Production].[Product].Name

--40
SELECT [Production].[Product].Name, [Sales].[SalesOrderDetail].SalesOrderID
FROM [Production].[Product]
INNER JOIN
[Sales].[SalesOrderDetail]
ON [Production].[Product].ProductID = [Sales].[SalesOrderDetail].ProductID
ORDER BY [Production].[Product].Name

--41
SELECT [Sales].[SalesTerritory].Name, [Sales].[SalesPerson].BusinessEntityID
FROM [Sales].[SalesTerritory]
RIGHT JOIN [Sales].[SalesPerson]
ON [Sales].[SalesTerritory].TerritoryID = [Sales].[SalesPerson].TerritoryID

--42
SELECT CONCAT([Person].[Person].FirstName,' ', [Person].[Person].LastName) AS EmployeeName, [Person].[Address].City
FROM [Person].[Person]
INNER JOIN [HumanResources].[Employee]
ON [HumanResources].[Employee].BusinessEntityID = [Person].[Person].BusinessEntityID
INNER JOIN [Person].[BusinessEntityAddress]
ON [Person].[BusinessEntityAddress].BusinessEntityID = [Person].[Person].BusinessEntityID
INNER JOIN [Person].[Address]
ON [Person].[Address].AddressID = [Person].[BusinessEntityAddress].AddressID
ORDER BY LastName, FirstName

--43
SELECT BusinessEntityID, FirstName, LastName
FROM 
	(SELECT * FROM Person.Person
	 WHERE PersonType = 'IN') AS PersonsDerivedTable
WHERE LastName = 'Adams'
ORDER BY FirstName

--44
SELECT BusinessEntityID, FirstName, LastName
FROM (
	SELECT * FROM Person.Person
	WHERE BusinessEntityID < 1500) AS Deriv
WHERE FirstName LIKE 'M%' AND LastName LIKE 'Al%'

--45
SELECT ProductID, Name, Color
FROM (
	SELECT * FROM Production.Product
	WHERE Name IN ('Blade', 'Crown Race', 'AWC Logo Cap')) AS Deriv

OR

SELECT ProductID, a.Name, Color  
FROM Production.Product AS a  
INNER JOIN (VALUES ('Blade'), ('Crown Race'), ('AWC Logo Cap')) AS b(Name)   
ON a.Name = b.Name;

--46
SELECT [Sales].[SalesOrderHeader].SalesPersonID, 
COUNT([Sales].[SalesOrderHeader].SalesOrderID) AS TotalSales, 
YEAR([Sales].[SalesOrderHeader].OrderDate) AS Year
FROM [Sales].[SalesOrderHeader]
WHERE [Sales].[SalesOrderHeader].SalesPersonID IS NOT NULL
GROUP BY [Sales].[SalesOrderHeader].SalesPersonID, YEAR([Sales].[SalesOrderHeader].OrderDate)
ORDER BY [Sales].[SalesOrderHeader].SalesPersonID

--47
SELECT AVG(TotalNumberSales)
FROM
	(SELECT [Sales].[SalesOrderHeader].SalesPersonID, COUNT(*) AS TotalNumberSales
	FROM [Sales].[SalesOrderHeader]
	GROUP BY [Sales].[SalesOrderHeader].SalesPersonID
	HAVING [Sales].[SalesOrderHeader].SalesPersonID IS NOT NULL) AS Deriv

--48
SELECT [Production].[ProductPhoto].ProductPhotoID, [Production].[ProductPhoto].ThumbNailPhoto
FROM [Production].[ProductPhoto]
WHERE [Production].[ProductPhoto].LargePhotoFileName LIKE '%green%'

--49
SELECT [Person].[Address].AddressLine1, [Person].[Address].Addressline2, [Person].[Address].City, 
[Person].[Address].PostalCode, [Person].[StateProvince].countryregioncode
FROM [Person].[Address]
INNER JOIN [Person].[StateProvince]
ON [Person].[StateProvince].StateProvinceID = [Person].[Address].StateProvinceID
WHERE [Person].[Address].City LIKE 'Pa%'
AND [Person].[StateProvince].CountryRegionCode != 'US' 
ORDER BY AddressLine1

--50
SELECT TOP 20 [HumanResources].[Employee].JobTitle, [HumanResources].[Employee].HireDate
FROM [HumanResources].[Employee]
ORDER BY [HumanResources].[Employee].HireDate DESC

--51
SELECT * FROM [Sales].[SalesOrderDetail]
INNER JOIN [Sales].[SalesOrderHeader]
ON [Sales].[SalesOrderHeader].SalesOrderID = [Sales].[SalesOrderDetail].SalesOrderID
WHERE [Sales].[SalesOrderHeader].TotalDue > 100
AND ([Sales].[SalesOrderDetail].OrderQty > 5 OR [Sales].[SalesOrderDetail].UnitPriceDiscount < 1000)

--52
SELECT [Production].[Product].Name, [Production].[Product].Color
FROM [Production].[Product]
WHERE [Production].[Product].Name LIKE '%Red%'

--53
SELECT [Production].[Product].Name, [Production].[Product].ListPrice
FROM [Production].[Product]
WHERE [Production].[Product].Name LIKE '%Mountain%' AND [Production].[Product].ListPrice = 80.99

--54
SELECT [Production].[Product].Name, [Production].[Product].Color
FROM [Production].[Product]
WHERE [Production].[Product].Name LIKE'%Mountain%'OR [Production].[Product].Name LIKE '%Road%'

--55
SELECT [Production].[Product].Name, [Production].[Product].Color
FROM [Production].[Product]
WHERE [Production].[Product].Name LIKE'%Mountain%' AND [Production].[Product].Name LIKE '%Black%'

--56
SELECT [Production].[Product].Name, [Production].[Product].Color
FROM [Production].[Product]
WHERE [Production].[Product].Name LIKE 'Chain %' OR [Production].[Product].Name LIKE 'Chain'

--57
SELECT [Production].[Product].Name, [Production].[Product].Color
FROM [Production].[Product]
WHERE [Production].[Product].Name LIKE 'Chain %' OR [Production].[Product].Name LIKE 'Chain' 
OR [Production].[Product].Name LIKE 'Full%'

--58
SELECT CONCAT([Person].[Person].FirstName, ' ', [Person].[Person].LastName, ' ', [Person].[EmailAddress].EmailAddress)
FROM [Person].[Person]
INNER JOIN [Person].[EmailAddress]
ON [Person].[EmailAddress].BusinessEntityID = [Person].[Person].BusinessEntityID
WHERE [Person].[Person].BusinessEntityID = 1

--59
SELECT [Production].[Product].Name,	CHARINDEX('Yellow', [Production].[Product].Name) AS Position
FROM [Production].[Product]
WHERE [Production].[Product].Name LIKE '%Yellow%'
ORDER BY Position

--60
SELECT CONCAT([Production].[Product].Name, ' Color:- ', [Production].[Product].Color,
' Product Number: ', [Production].[Product].ProductNumber), [Production].[Product].Color
FROM [Production].[Product]

--61
SELECT CONCAT([Production].[Product].Name,'|', [Production].[Product].ProductNumber,'|', [Production].[Product].Color, CHAR(10))
FROM [Production].[Product]

--62
SELECT LEFT([Production].[Product].Name, 5)
FROM [Production].[Product]

--63
SELECT LEN([Sales].[vIndividualCustomer].[FirstName]) AS Length, [Sales].[vIndividualCustomer].FirstName, [Sales].[vIndividualCustomer].LastName
FROM 
[Sales].[vIndividualCustomer]
WHERE [Sales].[vIndividualCustomer].CountryRegionName = 'Australia'

--64
SELECT LEN([Sales].[vStoreWithContacts].FirstName) AS Length, [Sales].[vStoreWithContacts].FirstName, [Sales].[vStoreWithContacts].LastName
FROM [Sales].[vStoreWithContacts]
INNER JOIN [Sales].[vStoreWithAddresses]
ON [Sales].[vStoreWithContacts].BusinessEntityID = [Sales].[vStoreWithAddresses].BusinessEntityID
WHERE [Sales].[vStoreWithAddresses].CountryRegionName = 'Australia'
ORDER BY Length ASC

--65
SELECT LOWER([Production].[Product].Name) AS Lower, UPPER([Production].[Product].Name) AS Upper, LOWER(UPPER([Production].[Product].Name)) AS LowerUpper
FROM [Production].[Product]
WHERE [Production].[Product].ListPrice BETWEEN 1000 AND 1220

--66
SELECT LTRIM('     five space then the text') AS SpaceRemoved

--67
SELECT [Production].[Product].ProductNumber, 
SUBSTRING([Production].[Product].ProductNumber, 3, LEN([Production].[Product].ProductNumber)) AS TrimmedProductName
FROM [Production].[Product]
WHERE [Production].[Product].ProductNumber LIKE 'HN%'
/**3 is the starting position from which you want to extract the substring.
Since you want to trim the first two characters, you start from the third character.

LEN([Production].[Product].ProductNumber) determines the length of the substring to extract. 
This ensures that you get the substring from the third character to the end of the original string.**/

--OR 

SELECT productnumber,LTRIM(productnumber , 'HN') as "TrimmedProductnumber"
from production.product
where left(productnumber,2)='HN';

--68
SELECT [Production].[Product].Name, CONCAT(REPLICATE('0', 4), [Production].[Product].ProductLine) AS LineCode
FROM [Production].[Product]
WHERE [Production].[Product].ProductLine = 'T'

--69
SELECT [Person].[Person].FirstName, REVERSE([Person].[Person].FirstName)
FROM [Person].[Person]
WHERE [Person].[Person].BusinessEntityID < 6

--70
SELECT [Production].[Product].Name, [Production].[Product].ProductNumber, RIGHT([Production].[Product].Name,8)
FROM [Production].[Product]
ORDER BY [Production].[Product].ProductNumber

--71
SELECT RTRIM('text then five spaces     ')

--72
SELECT [Production].[Product].ProductNumber, [Production].[Product].Name
FROM [Production].[Product]
WHERE [Production].[Product].Name LIKE '% S' OR
[Production].[Product].Name LIKE '% M' OR
[Production].[Product].Name LIKE'% L'

--73
SELECT STRING_AGG(COALESCE([Person].[Person].FirstName, ' N/A'), ',')
FROM [Person].[Person]
/**STRING_AGG: This is an aggregate function that concatenates values from multiple rows into a single string 
with a specified separator. In this case, it concatenates the FirstName values from the [Person].[Person] table.

COALESCE: This function returns the first non-NULL value in a list of expressions. 
In this case, it replaces any NULL values in the FirstName column with the string 'N/A'.

'N/A': This is the string used to replace NULL values in the FirstName column.

,: This is the separator used to separate the concatenated values. **/

--74
