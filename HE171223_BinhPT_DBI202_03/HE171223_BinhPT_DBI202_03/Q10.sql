WITH tb1 AS(SELECT id,Students.name as 'name',birthdate,gender,Departments.Name as 'DepartmentName'    FROM Departments
INNER JOIN Students ON Students.department=Departments.Code
WHERE Departments.Name='Business Administration')
DELETE FROM tb1
WHERe tb1.id=101
INSERT INTO tb1(id,name,birthdate,gender)
VALUES(110,'Mary Jane','2001-05-12','Female')

SELECT*FROM enroll

