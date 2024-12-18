USE [DBUniversity]
GO
/****** Object:  View [dbo].[HighScholarshipStudents]    Script Date: 17.12.2024 07:52:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[HighScholarshipStudents]
AS
SELECT [student_id], [first_name], [last_name], [birth_date], [email], [phone_number], [enrollment_date], [scholarship_id], [group_id], [account_id]
FROM [DBUniversity].[dbo].[students] 
WHERE [scholarship_id] IN
		(SELECT [scholarship_id]
		FROM [DBUniversity].[dbo].[scholarships]
		WHERE [money_value] > 2000)   
GO
