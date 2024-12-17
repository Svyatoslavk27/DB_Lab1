USE [DBUniversity]
GO
/****** Object:  View [dbo].[GradedSubmissions]    Script Date: 17.12.2024 07:52:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GradedSubmissions]
AS
SELECT [submission_id], [assignment_id], [student_id], [submission_time]
FROM [DBUniversity].[dbo].[submissions] 
WHERE [is_graded]=1   
GO
