USE [DBUniversity]
GO
/****** Object:  StoredProcedure [dbo].[SoftDeleteComment]    Script Date: 17.12.2024 07:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SoftDeleteComment]
    @CommentId INT
AS
BEGIN
    UPDATE [DBUniversity].[dbo].[classroom_comments]
    SET IsDeleted = 1              
    WHERE comment_id = @CommentId;
END;
GO
