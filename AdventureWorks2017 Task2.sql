USE AdventureWorks2017

/**1.
Write a relevant SQL query to retrieve the required information from the 'Person.Person' table.**/

SELECT FirstName, LastName, EmailAddress 
FROM [Person].[Person] 
INNER JOIN [Person].[EmailAddress]
ON [Person].[Person].BusinessEntityID = [Person].[EmailAddress].BusinessEntityID;

/**2.
Compose an SQL query to count the total number of 
sales orders within the provided date range from the 'Sales.SalesOrderHeader' table.**/

SELECT COUNT(SalesOrderID) AS OrdersIn2013
FROM [Sales].[SalesOrderHeader] 
WHERE OrderDate 
BETWEEN '2013-01-01' AND '2013-12-31';

/**3.
Craft an SQL query to retrieve the product name, standard cost, 
and list price from the 'Production.Product' table.**/

SELECT Name, StandardCost, ListPrice FROM [Production].[Product]
WHERE StandardCost != 0 AND ListPrice != 0;

/**4.
Develop an SQL query to count the number of employees 
grouped by their job title from the 'HumanResources.Employee' table.**/

SELECT JobTitle, COUNT(BusinessEntityID) AS EmployeeNo
FROM [HumanResources].[Employee]
GROUP BY JobTitle;

/**5.
Construct an SQL query to retrieve the distinct list of 
product categories from the 'Production.ProductCategory' table.**/

SELECT DISTINCT name FROM [Production].[ProductCategory];

/**6.
Write an SQL query to calculate the total sales amount for
each order from the 'Sales.SalesOrderDetail' table.**/

SELECT SalesOrderID, SUM(LineTotal) AS TotalSales
FROM [Sales].[SalesOrderDetail]
GROUP BY SalesOrderID
ORDER BY SalesOrderID;

/**7.
Develop an SQL query to retrieve the store name and geographical 
location from the 'Sales.Store' table.**/

  SELECT [Sales].[Store].name, city, [Person].[StateProvince].name AS ProvinceOrState, [Person].[CountryRegion].name AS Country
  FROM [Sales].[Store]
  INNER JOIN [Person].[BusinessEntityAddress] 
  ON [Person].[BusinessEntityAddress].BusinessEntityID = [Sales].[Store].BusinessEntityID
  INNER JOIN [Person].[Address]
  ON [Person].[Address].AddressID = [Person].[BusinessEntityAddress].AddressID
  INNER JOIN [Person].[StateProvince]
  ON [Person].[StateProvince].StateProvinceID = [Person].[Address].StateProvinceID
  INNER JOIN [Person].[CountryRegion]
  ON [Person].[CountryRegion].CountryRegionCode = [Person].[StateProvince].CountryRegionCode;

  /**Cities in Canada**/
  SELECT [Person].[Address].City AS City, [Person].[StateProvince].Name AS StateOrProvince, [Person].[CountryRegion].Name AS Country
  FROM [Person].[Address]
  INNER JOIN [Person].[StateProvince]
  ON [Person].[StateProvince].StateProvinceID = [Person].[Address].StateProvinceID
  INNER JOIN [Person].[CountryRegion]
  ON [Person].[CountryRegion].CountryRegionCode = [Person].[StateProvince].CountryRegionCode
  WHERE [Person].[StateProvince].Name = 'Ontario'
  ORDER BY City;

  /**8.
  Craft an SQL query to retrieve the subcategory name and its 
  corresponding category name from the 'Production.ProductSubcategory' table.**/

  SELECT [Production].[ProductSubcategory].Name AS SubCategoryName, [Production].[ProductCategory].name AS CategoryName
  FROM [Production].[ProductSubcategory]
  INNER JOIN [Production].[ProductCategory]
  ON [Production].[ProductCategory].ProductCategoryID = [Production].[ProductSubcategory].ProductCategoryID;

  /**9.
  Develop an SQL query to retrieve the unique list of cities from the 'Person.Address' table.**/
  SELECT DISTINCT city FROM [Person].[Address];

  /**10.
  Construct an SQL query to retrieve the product model name and its corresponding 
  product model ID from the 'Production.ProductModel' table.**/

  SELECT [Production].[ProductModel].Name AS ProductModelName, [Production].[ProductModel].ProductModelID
  FROM [Production].[ProductModel];

  /**11.
  Write an SQL query to retrieve the customer's first name, last name, and phone number 
  from the 'Sales.Customer' table.**/

  SELECT CustomerID, firstName,lastName, phoneNumber, EmailAddress
FROM [Sales].[Customer]
INNER JOIN [Person].[BusinessEntityContact]
ON [Person].[BusinessEntityContact].PersonID = [Sales].[Customer].PersonID
INNER JOIN [Person].[Person]
ON [Person].[Person].BusinessEntityID = [Person].[BusinessEntityContact].PersonID
INNER JOIN [Person].[PersonPhone]
ON [Person].[PersonPhone].BusinessEntityID = [Person].[Person].BusinessEntityID
INNER JOIN [Person].[EmailAddress]
ON [Person].[EmailAddress].BusinessEntityID = [Person].[Person].BusinessEntityID

/**12.
Develop an SQL query to retrieve the count of unique business entities from 
the 'Person.BusinessEntity' table.**/

SELECT DISTINCT COUNT(BusinessEntityID) FROM [Person].[BusinessEntity];

/**13.
Craft an SQL query to retrieve the distinct list of components from the
'Production.BillOfMaterials' table.**/

SELECT DISTINCT COUNT(BillOfMaterialsID) FROM [Production].[BillOfMaterials];

/**14.
Construct an SQL query to retrieve the vendor's name, contact person,
and email address from the 'Purchasing.Vendor' table.**/

SELECT [Purchasing].[Vendor].Name, [Person].[PersonPhone].PhoneNumber,[Person].[EmailAddress].EmailAddress
FROM [Purchasing].[Vendor]
INNER JOIN 
[Person].[BusinessEntityContact]
ON [Person].[BusinessEntityContact].BusinessEntityID = [Purchasing].[Vendor].BusinessEntityID
INNER JOIN
[Person].[Person]
ON [Person].[Person].BusinessEntityID = [Person].[BusinessEntityContact].PersonID
INNER JOIN
[Person].[PersonPhone]
ON [Person].[PersonPhone].BusinessEntityID = [Person].[Person].BusinessEntityID
INNER JOIN
[Person].[EmailAddress]
ON [Person].[EmailAddress].BusinessEntityID = [Person].[Person].BusinessEntityID

/**15.
Write an SQL query to retrieve the location name and its corresponding 
address from the 'Production.Location' table.**/
 SELECT [Production].[Location].Name,[Person].[Address].city, [Person].[StateProvince].Name
  FROM
  [Production].[Location]
  INNER JOIN
  [Person].[Address]
  ON [Production].[Location].LocationID = [Person].[Address].AddressID
  INNER JOIN
  [Person].[StateProvince]
  ON [Person].[Address].StateProvinceID = [Person].[StateProvince].StateProvinceID

/**16.
Develop an SQL query to retrieve the candidate's name and their resume 
from the 'HumanResources.JobCandidate' table**/

SELECT [Person].[Person].FirstName, [Person].[Person].LastName, [HumanResources].[JobCandidate].Resume
FROM [Person].[Person]
INNER JOIN
[HumanResources].[JobCandidate]
ON
[Person].[Person].BusinessEntityID = [HumanResources].[JobCandidate].BusinessEntityID

/**17.
Craft an SQL query to calculate the total amount spent on each purchase order 
from the 'Purchasing.PurchaseOrderHeader' table.**/

SELECT [Purchasing].[PurchaseOrderHeader].purchaseOrderID, SUM(LineTotal) AS TotalSpent
FROM [Purchasing].[PurchaseOrderHeader]
INNER JOIN
[Purchasing].[PurchaseOrderDetail]
ON
[Purchasing].[PurchaseOrderDetail].PurchaseOrderID = [Purchasing].[PurchaseOrderHeader].PurchaseOrderID
GROUP BY [Purchasing].[PurchaseOrderHeader].PurchaseOrderID

/**18.
Construct an SQL query to retrieve the contact's first name, last name, 
and phone number from the 'Sales.StoreContact' table.**/

SELECT [Person].[Person].FirstName,
[Person].[Person].LastName,[Person].[PersonPhone].PhoneNumber,[Person].[EmailAddress].EmailAddress
FROM [Sales].[Store]
INNER JOIN [Person].[BusinessEntityContact]
ON [Person].[BusinessEntityContact].BusinessEntityID = [Sales].[Store].BusinessEntityID
INNER JOIN [Person].[Person]
ON [Person].[Person].BusinessEntityID = [Person].[BusinessEntityContact].PersonID
INNER JOIN [Person].[PersonPhone] 
ON [Person].[Person].BusinessEntityID = [Person].[PersonPhone].BusinessEntityID
INNER JOIN 
[Person].[EmailAddress]
ON [Person].[EmailAddress].BusinessEntityID = [Person].[Person].BusinessEntityID

/**19.
Write an SQL query to retrieve the list of products and their available quantities 
from the 'Production.ProductInventory' table.**/

SELECT [Production].[Product].Name, SUM([Production].[ProductInventory].Quantity) AS Quantity
FROM
[Production].[Product]
INNER JOIN
[Production].[ProductInventory]
ON [Production].[Product].ProductID = [Production].[ProductInventory].ProductID
GROUP BY [Production].[Product].Name

/**20.
Develop an SQL query to retrieve the territory name and its corresponding country from the 
'Sales.SalesTerritory' table.**/

SELECT [Sales].[SalesTerritory].Name AS Territory, [Person].[CountryRegion].Name AS Country
FROM [Sales].[SalesTerritory]
INNER JOIN [Person].[CountryRegion]
ON [Person].[CountryRegion].CountryRegionCode = [Sales].[SalesTerritory].CountryRegionCode