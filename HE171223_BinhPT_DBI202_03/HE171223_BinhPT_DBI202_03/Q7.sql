WITH tb1 AS(SELECT e.enrollId,SUM(a.[percent]*m.mark) as AverageMark   FROM enroll e
INNER JOIN marks m ON m.enrollId=e.enrollId
INNER JOIN Assessments a ON a.id=m.assessmentId
GROUP BY e.enrollId)
SELECT e.enrollId,c.id as 'CourseId',c.title,s.id As'studentId',s.name AS 'StudentName',se.id as 'semesterId',se.code as'SemesterCode',t.AverageMark FROM Students s
INNER JOIN enroll e ON e.studentId=s.id
INNER JOIN Courses c ON c.id=e.courseId
INNER JOIN semesters se ON e.semesterId=se.id
INNER JOIN tb1 t ON t.enrollId=e.enrollId
WHERE c.code='DBI202'
ORDER BY s.id ASC,se.id DESC