--q1:
CREATE TABLE Departments (
 DeptID varchar(20) PRIMARY KEY,
 name nvarchar(200),
 office nvarchar(100)
)

CREATE TABLE Employees (
 EmpCode varchar(20) PRIMARY KEY,
 name nvarchar(50),
 BirthDate date,
 DeptID varchar(20) references Departments(DeptID)
)

CREATE TABLE Dependants (
 Number int PRIMARY KEY,
 Name nvarchar(50),
 BirthDate date,
 Role nvarchar(30),
 EmpCode varchar(20) references Employees(EmpCode)
)

--Q2:
SELECT * FROM ProductSubcategory
WHERE ProductSubcategory.Category = 'Accessories'

--Q3:
SELECT Product.ProductID, Product.Name, Product.Color, Product.Cost, Product.Price, Product.SellEndDate  FROM Product
where Product.Cost < 100 AND Product.SellEndDate is not NULL
ORDER BY Product.Cost asc
--Q4

SELECT Pro.ProductID, Pro.Name AS ProductName, Pro.Price, ProModel.Name AS ModelName , ProSub.Name AS SubCategoryName, ProSub.Category FROM Product Pro
LEFT JOIN ProductSubcategory ProSub ON Pro.SubcategoryID = ProSub.SubcategoryID
LEFT JOIN ProductModel ProModel ON Pro.ModelID = ProModel.ModelID
WHERE Pro.Price < 100 AND Pro.Color = 'Black'

--Q5
SELECT ProductSub.SubcategoryID, ProductSub.Name AS SubCategoryName, ProductSub.Category, COUNT(Pro.SubcategoryID) AS NumberOfProduct from ProductSubcategory  ProductSub
INNER JOIN Product Pro ON ProductSub.SubcategoryID = Pro.SubcategoryID
group by ProductSub.SubcategoryID, ProductSub.Name, ProductSub.Category
order by ProductSub.Category, NumberOfProduct DESC, SubCategoryName

--Q6
--SELECT Loc.LocationID, Loc.Name LocationName, COUNT(Pro.ProductID) as NumberOfProducts from Location Loc
--INNER JOIN ProductInventory ProInven on Loc.LocationID = ProInven.LocationID
--INNER JOIN Product Pro ON Pro.ProductID = ProInven.ProductID
--GROUP BY Loc.LocationID, Loc.Name

--Q7
--table 1 get count productID following couple Category and name (category | categoryname | numberProduct ** is count of each couple |)
    With tb1 as (SELECT ProSub.Category, ProSub.Name AS SubcategoryName, count(Pro.SubcategoryID) as NumberOfProducts FROM ProductSubcategory ProSub
	 JOIN Product Pro ON ProSub.SubcategoryID = Pro.SubcategoryID
	 GROUP BY ProSub.Category, ProSub.Name
	), 
--table2 get max of each Category	 (category | max(numberProduct))
	tb2 as (Select tb1.Category, Max(tb1.NumberOfProducts) AS NumberOfProducts from tb1
	Group by tb1.Category)
--inner join tb2 into tb1 base same category and same numberProduct
--> only get couple have numberProduct = max of couple
	Select tb1.* from tb1
	inner join tb2 on tb1.Category = tb2.Category AND tb1.NumberOfProducts = tb2.NumberOfProducts
	ORDER BY tb1.NumberOfProducts DESC
	
