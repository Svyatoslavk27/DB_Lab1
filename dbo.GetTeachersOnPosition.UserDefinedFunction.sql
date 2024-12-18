USE [DBUniversity]
GO
/****** Object:  UserDefinedFunction [dbo].[GetTeachersOnPosition]    Script Date: 17.12.2024 08:01:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetTeachersOnPosition] (@PositionName NVARCHAR(64))
RETURNS @PositionTeachers TABLE
(
    TeacherId INT,
	FirstName NVARCHAR(32),
	LastName NVARCHAR(32),
	BirthDate DATETIME,
	Email NVARCHAR(32),
	PhoneNumber NVARCHAR(32),
    HireDate DATETIME,
	DepartmentId INT,
	AccountId INT
)
AS
BEGIN
    INSERT INTO @PositionTeachers
    SELECT [teacher_id], [first_name], [last_name], [birth_date], [email], [phone_number], [hire_date], [department_id], [account_id] 
    FROM [DBUniversity].[dbo].[teachers] 
    WHERE [position_id] IN
		(SELECT [position_id]
		FROM [DBUniversity].[dbo].[teacher_positions]
		WHERE [position_name] LIKE '%' + @PositionName + '%')   
    RETURN;
END;

GO
