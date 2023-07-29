
CREATE PROCEDURE P1 (@studentId int, @courseId int,@x int output)
AS
BEGIN
SELECT @x = COUNT(e.enrollId)
FROM enroll e 
INNER JOIN Students s ON s.id=e.studentId
INNER JOIN Courses c ON c.id=e.courseId
WHERE c.id=@courseId AND s.id=@studentId
END;

declare @x int
exec P1 19,12,@x output
SELECT @x as NumberOfEnrollmentTimes

