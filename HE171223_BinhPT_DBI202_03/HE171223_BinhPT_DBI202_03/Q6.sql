
SELECT c.id as 'courseId',c.title as 'code',COUNT(DISTINCT a.type) AS 'NumberOfAssessmentType',COUNT(a.id) AS 'NumberOfAssessments' FROM Courses c
INNER JOIN Assessments a ON c.id=a.courseId
GROUP BY c.id,c.title
HAVING COUNT(a.id) IN (SELECT MAX(cnt) FROM (SELECT COUNT(a.id) as cnt  FROM Courses c
INNER JOIN Assessments a ON c.id=a.courseId
GROUP BY c.code) as subqueries)

