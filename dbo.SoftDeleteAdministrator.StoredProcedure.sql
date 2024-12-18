USE [DBUniversity]
GO
/****** Object:  StoredProcedure [dbo].[SoftDeleteAdministrator]    Script Date: 17.12.2024 07:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SoftDeleteAdministrator]
    @AdministratorId INT
AS
BEGIN
    UPDATE [DBUniversity].[dbo].[administrators]
    SET IsDeleted = 1              
    WHERE administrator_id = @AdministratorId;
END;
GO
