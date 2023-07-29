SELECT s.id as'studentid',s.name as 'StudentName',d.Name as 'department',se.code as 'SemesterCode',se.year as'year',c.title as 'CourseTitle'  FROM Students s
INNER JOIN Departments d ON d.Code=s.department
INNER JOIN enroll e ON e.studentId=s.id
INNER JOIN Courses c ON c.id=e.courseId
INNER JOIN semesters se ON se.id=e.semesterId 
WHERE c.title='Operating Systems'
ORDER BY se.year ASC,se.code ASC,s.id ASC