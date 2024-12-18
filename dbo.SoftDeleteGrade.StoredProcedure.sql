USE [DBUniversity]
GO
/****** Object:  StoredProcedure [dbo].[SoftDeleteGrade]    Script Date: 17.12.2024 07:52:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SoftDeleteGrade]
    @GradeId INT
AS
BEGIN
    UPDATE [DBUniversity].[dbo].[grades]
    SET IsDeleted = 1              
    WHERE grade_id = @GradeId;
END;
GO
