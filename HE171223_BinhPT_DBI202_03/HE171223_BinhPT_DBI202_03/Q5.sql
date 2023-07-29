SELECT s.id AS 'StudentId',s.name AS 'StudentName',d.Name AS'DepartmentName',COUNT(DISTINCT c.id) as 'NumberOfEnrolledCourses' FROM Students s
INNER JOIN Departments d ON d.Code=s.department
LEFT JOIN enroll e ON e.studentId=s.id
LEFT JOIN Courses c ON c.id = e.courseId
WHERE d.Name='Business Administration'
GROUP BY s.id,s.name,d.Name
