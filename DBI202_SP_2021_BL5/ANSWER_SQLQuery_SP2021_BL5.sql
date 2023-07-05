--Q1
Create table items(
 itemID int PRIMARY KEY,
 name nvarchar(255),
 price float
)
Create table itemVariants(
 variantID int PRIMARY KEY,
 detail nvarchar(200),
 color nvarchar(50),
 size nvarchar(30),
 itemID int references items(itemID)
)
Create table categories(
 catID int,
 name nvarchar(255)
)
--Q2
SELECT * FROM Employees
where Employees.Salary > 9000
--Q3
select Jobs.JobID, Jobs.JobTitle, Jobs.min_salary from Jobs
where Jobs.min_salary > 5000  AND Jobs.JobTitle LIKE '%Manage%'
order by Jobs.min_salary desc, Jobs.JobTitle

--Q4
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName,
Employees.Salary, Departments.DepartmentName, Locations.StateProvince, Locations.CountryID FROM Employees
inner join Departments on Employees.DepartmentID = Departments.DepartmentID
inner join Locations on Locations.LocationID = Departments.LocationID
where Employees.Salary > 3000 AND Locations.StateProvince = 'Washington' AND Locations.CountryID = 'US'

--Q5
select Locations.LocationID, Locations.StreetAddress, Locations.City, Locations.StateProvince, 
Locations.CountryID, count(Departments.DepartmentID) AS NumberOfDepartment from Locations
LEFT JOIN Departments ON Locations.LocationID = Departments.LocationID
group by Locations.LocationID, Locations.StreetAddress, Locations.City, Locations.StateProvince, 
Locations.CountryID
order by NumberOfDepartment desc, Locations.LocationID asc

--Q6
select Jobs.JobID, Jobs.JobTitle, count(Employees.EmployeeID) NumberOfEmployees from Jobs
INNER JOIN Employees on Jobs.JobID = Employees.JobID
group by Jobs.JobID, Jobs.JobTitle 
having count(Employees.EmployeeID) = (
 select top(1) count(Employees.EmployeeID) from Jobs
 INNER JOIN Employees on Jobs.JobID = Employees.JobID
 group by Jobs.JobID, Jobs.JobTitle 
 order by count(Employees.EmployeeID) desc
)

--Q7
--c1: 
With tb1 as(
 Select Employees.ManagerID ManageId, COUNT(Employees.ManagerID) NumberOfSubordinates From Employees
 GROUP BY Employees.ManagerID
), tb2 as (
 Select Employees.EmployeeID, Employees.FirstName, Employees.LastName, Employees.Salary,
 Employees.DepartmentID, Departments.DepartmentName, COALESCE(tb1.NumberOfSubordinates, 0) as NumberOfSubordinates From Employees
 left join tb1 on tb1.ManageId = Employees.EmployeeID 
 Inner join Departments ON Departments.DepartmentID = Employees.DepartmentID
)
select tb2.* from tb2
where tb2.Salary > 10000 OR tb2.NumberOfSubordinates > 0
order by tb2.NumberOfSubordinates desc, tb2.LastName asc


select tb1.EmployeeID, tb1.FirstName, tb1.LastName, tb1.Salary,
tb1.DepartmentID, Dep.DepartmentName, COALESCE(tb2.NumberOfSubordinates, 0) as NumberOfSubordinates from Employees tb1
inner join Departments Dep on Dep.DepartmentID = tb1.DepartmentID
           --l?y ra s? l??ng employee c?a m?i manage 
left join ( select Employees.ManagerID, count(Employees.EmployeeID) NumberOfSubordinates from Employees
           group by Employees.ManagerID ) as tb2 ON tb1.EmployeeID = tb2.ManagerID
   WHERE tb1.Salary > 10000 OR tb2.NumberOfSubordinates >= 0
   order by NumberOfSubordinates desc, tb1.LastName asc


--c3
--lay ra ng co luong > 10000 va quan ly it nhat 1 ng
WITH tb1 as (
 Select * from Employees E
where EmployeeID IN (
  select distinct Employees.ManagerID from Employees
  where Employees.ManagerID is not null
  UNION
  select Employees.EmployeeID FROM Employees
  WHERE Employees.Salary > 10000 
)

), tb2 as (
--Dem so luong employee cua moi quan ly
 Select E.ManagerID, count(E.EmployeeID) AS NumberOfSubordinates from Employees E
 GROUP BY E.ManagerID
)
select tb1.EmployeeID, tb1.FirstName, tb1.LastName, tb1.Salary, tb1.DepartmentID, Dep.DepartmentName,
COALESCE(tb2.NumberOfSubordinates, 0) from tb1
left join tb2 on tb1.EmployeeID = tb2.ManagerID
inner join Departments Dep on Dep.DepartmentID = tb1.DepartmentID
order by tb2.NumberOfSubordinates desc, tb1.LastName














--Q8
CREATE PROCEDURE pr1 @countryID varchar(10), @numberOfDepartments int OUTPUT
AS
BEGIN
Select @numberOfDepartments = Count(Locations.CountryID) from Departments
inner join Locations on Departments.LocationID = Locations.LocationID
where Locations.CountryID = @countryID
group by Locations.CountryID 
END
declare @x int
exec pr1 'US', @x output
select @x as NumberOfDepartments

--Q9
CREATE TRIGGER Tr1 ON Employees after insert
as
begin
Select i.EmployeeID, i.FirstName, i.LastName, i.DepartmentID, Departments.DepartmentName FROM inserted i
left join Departments on Departments.DepartmentID = i.DepartmentID
end

insert into Employees(EmployeeID, FirstName, LastName, Email, JobID, DepartmentID)
values(1003, 'Alain', 'Boucher', 'alain.boucher@gmail.com', 'SH_CLERK', 50),
(1004, 'Muriel', 'Visani', 'muriel.visani@gmail.com', 'SA_REP', null)

--Q10
delete from Departments
where Departments.DepartmentID IN (
 SELECT Distinct Departments.DepartmentID from Departments
 inner join Employees on Employees.DepartmentID = Departments.DepartmentID
)
