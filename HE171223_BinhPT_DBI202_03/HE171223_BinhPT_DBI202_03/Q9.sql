DROP TRIGGER Tr1
CREATE TRIGGER Tr1 ON enroll
AFTER INSERT 
AS 
BEGIN 
SELECT i.enrollId,m.assessmentId,ISNULL(m.mark,0)  FROM inserted i
INNER JOIN marks m ON i.enrollId=m.enrollId
END;
INSERT INTO enroll(enrollId,studentId,courseId,semesterId)
VALUES(600,9,11,4)
