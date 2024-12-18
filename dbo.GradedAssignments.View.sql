USE [DBUniversity]
GO
/****** Object:  View [dbo].[GradedAssignments]    Script Date: 17.12.2024 07:52:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GradedAssignments]
AS
SELECT [assignment_id], [assignment_name], [max_grade], [assignment_time], [deadline]
FROM [DBUniversity].[dbo].[assignments] 
WHERE [assignment_id] IN
	(SELECT [assignment_id]
	FROM [DBUniversity].[dbo].[submissions] 
	WHERE [is_graded]=1)
GO
