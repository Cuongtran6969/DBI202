--Q1:
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
SELECT Loc.LocationID, Loc.Name LocationName, COUNT(Pro.ProductID) as NumberOfProducts from Location Loc
INNER JOIN ProductInventory ProInven on Loc.LocationID = ProInven.LocationID
INNER JOIN Product Pro ON Pro.ProductID = ProInven.ProductID
GROUP BY Loc.LocationID, Loc.Name

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
--Q8
--b1: create Procedure with procedure name and param will reiceve
CREATE PROCEDURE proc_product_model @modelIID int, @NumberOfProducts INT OUTPUT
AS 
BEGIN
--b2: statement with param
SELECT @NumberOfProducts = Count(DISTINCT Pro.ModelID) from Product Pro
WHERE Pro.ModelID = @modelIID
GROUP BY Pro.ModelID
END
--b3: test pass param to Procedure
declare @x int
exec proc_product_model 9, @x output
select @x as NumberOfProduct

--Q9
--drop trigger tr_insert_Product
--b1: create trigger  On table relation Object insert 
--CREATE Trigger tr_insert_Product ON Product instead of insert 
CREATE Trigger tr_insert_Product ON Product after insert 
AS
BEGIN
--b2: statement get Product after insrted
   SELECT i.ProductID, i.Name as ProductName, i.ModelID, ProModel.Name AS ModelName FROM inserted i
   INNER JOIN ProductModel ProModel on ProModel.ModelID = i.ModelID
END
--b3: test insert into a Product
 -- insert into Product(ProductID, Name, Cost, Price, ModelID, SellStartDate)
  --values(1000, 'Product Test', 12.5, 15.5, 1, '2021-10-25')

--Q10
DELETE FROM ProductInventory
WHERE ProductInventory.ProductID IN (SELECT Product.ProductID FROM Product WHERE Product.ModelID = 33)
