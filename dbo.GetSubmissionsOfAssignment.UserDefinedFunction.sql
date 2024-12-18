USE [DBUniversity]
GO
/****** Object:  UserDefinedFunction [dbo].[GetSubmissionsOfAssignment]    Script Date: 17.12.2024 08:01:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetSubmissionsOfAssignment] (@SubmissionId INT)
RETURNS @SubmissionAssignment TABLE
(
    AssignmentId INT,
	AssignmentName NVARCHAR(64),
	MaxGrade INT,
	AssignmentTime DATETIME,
	Deadline DATETIME
)
AS
BEGIN
    INSERT INTO @SubmissionAssignment
    SELECT [assignment_id], [assignment_name], [max_grade], [assignment_time], [deadline] 
    FROM [DBUniversity].[dbo].[assignments] 
    WHERE [assignment_id] IN
		(SELECT [assignment_id]
		FROM [DBUniversity].[dbo].[submissions]
		WHERE [submission_id]= @SubmissionId)   
    RETURN;
END;


GO
