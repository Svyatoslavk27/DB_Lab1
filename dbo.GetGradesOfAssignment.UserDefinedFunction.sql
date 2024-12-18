USE [DBUniversity]
GO
/****** Object:  UserDefinedFunction [dbo].[GetGradesOfAssignment]    Script Date: 17.12.2024 08:01:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetGradesOfAssignment] (@AssignmentId INT)
RETURNS @AssignmentGrades TABLE
(
    GradeId INT,
	GradeValue INT,
	AssignmentDate DATETIME
)
AS
BEGIN
    INSERT INTO @AssignmentGrades
    SELECT [grade_id], [value], [assignment_date]
    FROM [DBUniversity].[dbo].[grades] 
    WHERE [submission_id] IN
		(SELECT [submission_id]
		FROM [DBUniversity].[dbo].[submissions]
		WHERE [assignment_id]= @AssignmentId)
	AND [IsDeleted]=0;
    RETURN;
END;



GO
