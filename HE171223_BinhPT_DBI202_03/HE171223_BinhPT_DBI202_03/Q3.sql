SELECT s.id,s.name AS 'StudentName',s.birthdate,s.gender,d.Name AS 'DepartmentName' FROM Students s
INNER JOIN Departments d ON d.Code=s.department
WHERE d.Name= N'Multimedia Communications'

