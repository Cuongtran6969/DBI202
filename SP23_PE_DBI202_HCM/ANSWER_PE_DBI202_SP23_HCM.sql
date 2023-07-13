--Q1
Create table Professor (
 SSN int Primary key,
 Name varchar(50),
 Street varchar(50),
 Number varchar(50)
)

Create table Course (
 CID int Primary key,
 CName varchar(50),
 SSN int references Professor(SSN)
)
--Q2
Select D.Dname department, sum(E.Salary)/count(E.Ssn) from DEPARTMENT D
INNER JOIN EMPLOYEE E  ON D.Dnumber = E.Dno
group by D.Dname

--Q3

Select E.Fname, E.Lname from Employee E
WHERE E.Ssn IN (
 Select Super_ssn from EMPLOYEE E
 GROUP BY E.Super_ssn
 HAVING count(E.Ssn) > 6
)

--Q4
with tb1 as (
Select * from DEPENDENT DE 
where DE.Relationship = 'Son' or DE.Relationship = 'Daughter'
)
select (E.Fname+' '+E.Lname) as EmployeeName from EMPLOYEE E
Where E.Ssn IN (
 Select E.Ssn from EMPLOYEE E
 inner join tb1 on tb1.Essn = E.Ssn
 GROUP BY E.Ssn
 Having COUNT(tb1.Essn) > 2 
 )

 --Q5
with tb1 as (
 Select DE.Dnumber from DEPARTMENT DE
 inner join EMPLOYEE E ON DE.Dnumber = E.Dno
 group by DE.Dnumber
 having count(E.Ssn) > 5
), tb2 as (
 Select * from EMPLOYEE E
 where E.Dno in ( Select DE.Dnumber from DEPARTMENT DE
 inner join EMPLOYEE E ON DE.Dnumber = E.Dno
 group by DE.Dnumber
 having count(E.Ssn) > 5) and E.Salary > 40000
 )
 select tb2.Dno Dnumber, DE.Dname, count(tb2.Dno) NumberOfEmployee from tb2
 inner join DEPARTMENT DE on tb2.Dno = DE.Dnumber
 group by tb2.Dno, DE.Dname


--Q6
SELECT * FROM EMPLOYEE E
WHERE E.Ssn in (
 Select E.Ssn from EMPLOYEE E
 where E.Ssn NOT IN (
 Select Distinct DE.Essn from DEPENDENT DE
 )
 UNION
 Select DE.Essn from DEPENDENT DE
 where 2023 - YEAR(DE.Bdate) < 18 AND DE.Essn NOT IN (
 Select E.Ssn from EMPLOYEE E
  where E.Ssn NOT IN (
   Select Distinct DE.Essn from DEPENDENT DE
  )
 )
 )
 order by E.Fname

--Q7
with tb1 as (
  --emp co tham gia
 SELECT E.Dno FROM EMPLOYEE E
  where E.Dno in (
  SELECT PR.Dnum FROM PROJECT PR
  WHERE PR.Pname = 'ProductZ'
 )
 union
 Select E.Dno from WORKS_ON W
 inner join PROJECT PR on W.Pno = PR.Pnumber
 inner join EMPLOYEE E on E.Ssn = W.Essn 
 WHERE PR.Pname = 'ProductZ'
)
 Select D.Dnumber, D.Dname from DEPARTMENT D
 where D.Dnumber not in (select * from tb1)

--Q8
CREATE PROCEDURE proc_SumSalary @depNo int, @sumOfSalarys int OUTPUT
AS
BEGIN
Select @sumOfSalarys = SUM(E.Salary) from EMPLOYEE E
where E.Dno = @depNo
group by E.Dno
END

--ko nop
declare @x int
exec proc_SumSalary 1, @x output
select @x as sumOfSalarys

--Q9
CREATE TRIGGER tr_no_insert ON EMPLOYEE after insert
AS
BEGIN
DECLARE 
 @Fname varchar(15),
 @Minit char(1),
 @Lname varchar(15),
 @Ssn char(9),
 @Bdate date,
 @Address varchar(30),
 @Sex char(1),
 @Salary decimal(10,2),
 @Super_ssn char(9),
 @DepNo int

Select @DepNo = Dno, @Fname = Fname, @Minit = Minit, @Lname = Lname, @Ssn = Ssn, @Bdate = Bdate,
@Address = Address, @Sex = Sex, @Salary = Salary, @Super_ssn = Super_ssn, @DepNo = Dno FROM inserted

 IF((Select count(E.Ssn) FROM EMPLOYEE E where E.Dno = @DepNo) < 5)

   begin
    insert into EMPLOYEE(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
    values (@Fname, @Minit, @Lname, @Ssn, @Bdate, @Address, @Sex, @Salary, @Super_ssn, @DepNo)
    print 'inserted'
   end

 ELSE

   begin
    print 'no insert'
   end
END

--ko nop
insert dbo.EMPLOYEE
values('Tester', 'T', 'Tester', 000111000, '2023/03/07', 'testing', 'F', 40000, 987654321, 5)

--Q10
UPDATE EMPLOYEE
SET Salary = Salary + (Salary * 0.1)
WHERE Ssn in (SELECT DE.Essn FROM DEPENDENT DE
              WHERE (YEAR(getdate()) -  YEAR( DE.Bdate)) < 18
)



