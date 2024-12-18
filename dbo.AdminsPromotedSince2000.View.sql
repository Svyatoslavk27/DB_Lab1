USE [DBUniversity]
GO
/****** Object:  View [dbo].[AdminsPromotedSince2000]    Script Date: 17.12.2024 7:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AdminsPromotedSince2000]
AS
SELECT [administrator_id], [first_name], [last_name], [birth_date], [email], [phone_number], [hire_date], [department_id], [account_id]
FROM [DBUniversity].[dbo].[administrators] 
WHERE [hire_date] > '01.01.2000'
AND [IsDeleted]=0


GO
