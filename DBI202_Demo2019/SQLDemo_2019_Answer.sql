--Q1
Create table Students (
 StudentID int Primary key,
 Name nvarchar(50),
 Address nvarchar(200),
 Gender char(1)
)

Create table Classes (
 GroupID char(6) Primary key,
 courseID char(6),
 NoCredits int,
 Semester char(10),
 year int
)

Create table Attend (
 Date date Primary key,
 Slot int Primary key,
 Attend bit,
)

Create table Teachers (
 TeacherID int Primary key,
 Name nvarchar(50),
 Address nvarchar(200),
 Gender char(1)
)
--Q2
Select * from SubCategory sub
where sub.CategoryID = 3

--Q3
Select Cus.ID, Cus.CustomerName, Cus.City, Cus.State from Customer Cus
inner join Orders O on O.CustomerID = Cus.ID
where O.OrderDate Between '2017-12-05' AND '2017-12-10' AND (DAY(O.ShipDate) - DAY(O.OrderDate) < 3)
ORDER BY Cus.State ASC, Cus.City DESC

--Q4
SELECT S.ID as SubCategoryID, S.SubCategoryName, Count(P.ID) NumberOfProduct FROM SubCategory S
inner join Product P ON P.SubCategoryID = S.ID
group by S.ID, S.SubCategoryName
having Count(P.ID) > 100
order by NumberOfProduct desc
--Q5
select OD.ProductID, P.ProductName, od.Quantity from Product P
inner join OrderDetails OD ON P.ID = OD.ProductID
where od.Quantity = (
 select top(1) od.Quantity from Product P
 inner join OrderDetails OD ON P.ID = OD.ProductID
 order by od.Quantity desc
 )

 --Q6
Select C.ID, C.CustomerName, COUNT(O.ID) NumberOfOrders FROM Customer C
inner join Orders O on O.CustomerID = C.ID
group by C.ID, C.CustomerName
having COUNT(O.ID) = (
 SELECT top (1) COUNT(O.ID) FROM Customer C
 inner join Orders O on O.CustomerID = C.ID
 group by C.ID
 order by COUNT(O.ID) desc
)

--Q7
WITH TB1 AS (
     SELECT top(5) Sub.ID, count(Pro.ID) as NumberOfProduct FROM SubCategory Sub
     inner join Product Pro ON  Pro.SubCategoryID = Sub.ID
     group by Sub.ID
     order by count(Pro.ID) asc
), TB2 AS (
     SELECT top(5) Sub.ID, count(Pro.ID) as NumberOfProduct FROM SubCategory Sub
     inner join Product Pro ON  Pro.SubCategoryID = Sub.ID
     group by Sub.ID
     order by count(Pro.ID) desc
), TB3 AS (
   SELECT * from TB2
   union
   SELECT * from TB1
)
SELECT * FROM TB3
ORDER BY TB3.NumberOfProduct DESC

--Q8
CREATE PROCEDURE TotalAmount @OrderID nvarchar(255), @TotalAmount float OUTPUT
AS 
BEGIN
SELECT @TotalAmount = (OD.SalePrice * OD.Quantity * (1 - OD.Discount))  from OrderDetails OD
WHERE OD.OrderID = @OrderID
END 
declare @t float
exec TotalAmount 'CA-2014-100006', @t output
print @t

--Q9
CREATE Trigger insertSubCategory ON SubCategory after insert 
AS
BEGIN
--b2: statement get Product after insrted
   SELECT i.SubCategoryName, Category.CategoryName FROM inserted i
   INNER JOIN Category on Category.ID = i.CategoryID
END

insert into SubCategory(SubCategoryName, CategoryID)
values('Beds', 2)

--Q10
insert into Category
values('Sports')
insert into SubCategory
values((select C.ID from Category C
where C.CategoryName = 'Sports'),'Tennis'),
      ((select C.ID from Category C
where C.CategoryName = 'Sports'),'Football')


