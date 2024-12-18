USE [DBUniversity]
GO
/****** Object:  UserDefinedFunction [dbo].[GetSubjectsOfCategory]    Script Date: 17.12.2024 08:01:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetSubjectsOfCategory] (@CategoryName NVARCHAR(64))
RETURNS @CategorySubjects TABLE
(
    SubjectId INT,
    SubjectName NVARCHAR(100)
)
AS
BEGIN
    INSERT INTO @CategorySubjects
    SELECT [subject_id], [subject_name] 
    FROM [DBUniversity].[dbo].[subjects] 
    WHERE [category_id] IN
		(SELECT [category_id]
		FROM [DBUniversity].[dbo].[subject_categories]
		WHERE [category_name] LIKE '%' + @CategoryName + '%')       
    RETURN;
END;



GO
