USE [master]
GO
/****** Object:  Database [DBUniversity]    Script Date: 17.12.2024 07:41:17 ******/
CREATE DATABASE [DBUniversity]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DBUniversity', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DBUniversity.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DBUniversity_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DBUniversity_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DBUniversity] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DBUniversity].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DBUniversity] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DBUniversity] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DBUniversity] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DBUniversity] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DBUniversity] SET ARITHABORT OFF 
GO
ALTER DATABASE [DBUniversity] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DBUniversity] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DBUniversity] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DBUniversity] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DBUniversity] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DBUniversity] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DBUniversity] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DBUniversity] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DBUniversity] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DBUniversity] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DBUniversity] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DBUniversity] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DBUniversity] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DBUniversity] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DBUniversity] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DBUniversity] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DBUniversity] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DBUniversity] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DBUniversity] SET  MULTI_USER 
GO
ALTER DATABASE [DBUniversity] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DBUniversity] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DBUniversity] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DBUniversity] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DBUniversity] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DBUniversity] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [DBUniversity] SET QUERY_STORE = ON
GO
ALTER DATABASE [DBUniversity] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DBUniversity]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCategorySubjects]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCategorySubjects] (@CategoryId INT)
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
    WHERE [category_id] = @CategoryId;    
    RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[GetGradesOfAssignment]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GetGroupSize]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetGroupSize] (@GroupId INT)
RETURNS INT
AS
BEGIN
    DECLARE @StudentCount INT;
    SELECT @StudentCount = COUNT(*) 
    FROM [DBUniversity].[dbo].[students] 
    WHERE [group_id] = @GroupId;
    RETURN @StudentCount;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[GetPositionTeachers]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetPositionTeachers] (@PositionId INT)
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
    WHERE [position_id] = @PositionId;    
    RETURN;
END;

GO
/****** Object:  UserDefinedFunction [dbo].[GetStudentScholarship]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetStudentScholarship] (@StudentId INT)
RETURNS @StudentScholarship TABLE
(
    ScholarshipId INT,
	ScholarshipName NVARCHAR(32),
	MoneyValue INT
)
AS
BEGIN
    INSERT INTO @StudentScholarship
    SELECT [scholarship_id], [scholarship_name], [money_value] 
    FROM [DBUniversity].[dbo].[scholarships] 
    WHERE [scholarship_id] IN
		(SELECT [scholarship_id]
		FROM [DBUniversity].[dbo].[students]
		WHERE [student_id]= @StudentId)   
    RETURN;
END;

GO
/****** Object:  UserDefinedFunction [dbo].[GetSubjectsOfCategory]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GetSubmissionAssignment]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetSubmissionAssignment] (@SubmissionId INT)
RETURNS @SubmissionAssignment TABLE
(
    AssignmentId INT,
	AssignmentName NVARCHAR(64),
	MaxGrade INT,
	AssignmentTime DATETIME,
	Deadline DATETIME
)
AS
BEGIN
    INSERT INTO @SubmissionAssignment
    SELECT [assignment_id], [assignment_name], [max_grade], [assignment_time], [deadline] 
    FROM [DBUniversity].[dbo].[assignments] 
    WHERE [assignment_id] IN
		(SELECT [assignment_id]
		FROM [DBUniversity].[dbo].[submissions]
		WHERE [submission_id]= @SubmissionId)   
    RETURN;
END;

GO
/****** Object:  UserDefinedFunction [dbo].[GetSubmissionsOfAssignment]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetSubmissionsOfAssignment] (@SubmissionId INT)
RETURNS @SubmissionAssignment TABLE
(
    AssignmentId INT,
	AssignmentName NVARCHAR(64),
	MaxGrade INT,
	AssignmentTime DATETIME,
	Deadline DATETIME
)
AS
BEGIN
    INSERT INTO @SubmissionAssignment
    SELECT [assignment_id], [assignment_name], [max_grade], [assignment_time], [deadline] 
    FROM [DBUniversity].[dbo].[assignments] 
    WHERE [assignment_id] IN
		(SELECT [assignment_id]
		FROM [DBUniversity].[dbo].[submissions]
		WHERE [submission_id]= @SubmissionId)   
    RETURN;
END;


GO
/****** Object:  UserDefinedFunction [dbo].[GetTeachersOnPosition]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  Table [dbo].[classroom_accounts]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[classroom_accounts](
	[account_id] [int] NOT NULL,
	[account_username] [nchar](32) NULL,
	[status] [nchar](32) NULL,
	[LastModifiedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ClassroomAdministrators]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ClassroomAdministrators]
AS
SELECT [account_id], [account_username]
FROM [DBUniversity].[dbo].[classroom_accounts] 
WHERE [status] = 'administrator';

GO
/****** Object:  Table [dbo].[join_requests]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[join_requests](
	[request_id] [int] NOT NULL,
	[classroom_id] [int] NULL,
	[student_id] [int] NULL,
	[status] [nchar](32) NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AcceptedRequests]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AcceptedRequests]
AS
SELECT [request_id], [classroom_id], [student_id]
FROM [DBUniversity].[dbo].[join_requests] 
WHERE [status] = 'accepted';

GO
/****** Object:  Table [dbo].[students]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[students](
	[student_id] [int] NOT NULL,
	[first_name] [nchar](32) NULL,
	[last_name] [nchar](32) NULL,
	[birth_date] [date] NULL,
	[email] [nchar](32) NULL,
	[phone_number] [nchar](32) NULL,
	[enrollment_date] [date] NULL,
	[scholarship_id] [int] NULL,
	[group_id] [int] NULL,
	[account_id] [int] NULL,
 CONSTRAINT [PK__students__2A33069ADBECE219] PRIMARY KEY CLUSTERED 
(
	[student_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[scholarships]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[scholarships](
	[scholarship_id] [int] NOT NULL,
	[scholarship_name] [nchar](64) NULL,
	[money_value] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[scholarship_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[HighScholarshipStudents]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  Table [dbo].[submissions]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[submissions](
	[submission_id] [int] NOT NULL,
	[assignment_id] [int] NULL,
	[student_id] [int] NULL,
	[submission_time] [datetime] NULL,
	[is_graded] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[submission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GradedSubmissions]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  Table [dbo].[assignments]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[assignments](
	[assignment_id] [int] NOT NULL,
	[assignment_name] [nchar](64) NULL,
	[classroom_id] [int] NULL,
	[max_grade] [int] NULL,
	[assignment_time] [datetime] NULL,
	[deadline] [datetime] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[assignment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GradedAssignments]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  Table [dbo].[administrators]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[administrators](
	[administrator_id] [int] NOT NULL,
	[first_name] [nchar](32) NULL,
	[last_name] [nchar](32) NULL,
	[birth_date] [date] NULL,
	[email] [nchar](32) NULL,
	[phone_number] [nchar](32) NULL,
	[hire_date] [date] NULL,
	[department_id] [int] NULL,
	[account_id] [int] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK__administ__3871E7AC52C8E7A1] PRIMARY KEY CLUSTERED 
(
	[administrator_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AdminsPromotedAfter2000]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AdminsPromotedAfter2000]
AS
SELECT [administrator_id], [first_name], [last_name], [birth_date], [email], [phone_number], [hire_date], [department_id], [account_id]
FROM [DBUniversity].[dbo].[administrators] 
WHERE [hire_date] > '01.01.2000'


GO
/****** Object:  View [dbo].[AdminsPromotedSince2000]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  Table [dbo].[classroom_comments]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[classroom_comments](
	[comment_id] [int] NOT NULL,
	[classroom_id] [int] NULL,
	[account_id] [int] NULL,
	[text] [nchar](2048) NULL,
	[comment_date] [date] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK__classroo__E7957687F4FB54B8] PRIMARY KEY CLUSTERED 
(
	[comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[classrooms]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[classrooms](
	[classroom_id] [int] NOT NULL,
	[subject_id] [int] NULL,
	[teacher_id] [int] NULL,
	[group_id] [int] NULL,
	[link] [nchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[classroom_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[departments]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[departments](
	[department_id] [int] NOT NULL,
	[department_name] [nchar](64) NULL,
	[LastModifiedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[department_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[enrollments]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[enrollments](
	[enrollment_id] [int] NOT NULL,
	[student_id] [int] NULL,
	[subject_id] [int] NULL,
	[enrollment_date] [datetime] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[enrollment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[grades]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[grades](
	[grade_id] [int] NOT NULL,
	[student_id] [int] NULL,
	[submission_id] [int] NULL,
	[value] [int] NULL,
	[assignment_date] [datetime] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[grade_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lessons]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lessons](
	[lesson_id] [int] NOT NULL,
	[subject_id] [int] NULL,
	[teacher_id] [int] NULL,
	[group_id] [int] NULL,
	[department_id] [int] NULL,
	[lesson_time] [datetime] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[lesson_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[student_groups]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[student_groups](
	[group_id] [int] NOT NULL,
	[name] [nchar](32) NULL,
	[LastModifiedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[subject_categories]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subject_categories](
	[category_id] [int] NOT NULL,
	[category_name] [nchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[subjects]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subjects](
	[subject_id] [int] NOT NULL,
	[subject_name] [nchar](64) NULL,
	[creation_date] [datetime] NULL,
	[category_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[subject_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[teacher_positions]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[teacher_positions](
	[position_id] [int] NOT NULL,
	[position_name] [nchar](64) NULL,
	[salary] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[position_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[teachers]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[teachers](
	[teacher_id] [int] NOT NULL,
	[first_name] [nchar](32) NULL,
	[last_name] [nchar](32) NULL,
	[birth_date] [date] NULL,
	[email] [nchar](32) NULL,
	[phone_number] [nchar](32) NULL,
	[hire_date] [date] NULL,
	[department_id] [int] NULL,
	[position_id] [int] NULL,
	[account_id] [int] NULL,
 CONSTRAINT [PK__teachers__03AE777E1C71C19D] PRIMARY KEY CLUSTERED 
(
	[teacher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[classroom_accounts] ADD  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [dbo].[departments] ADD  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [dbo].[scholarships] ADD  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [dbo].[student_groups] ADD  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [dbo].[administrators]  WITH CHECK ADD  CONSTRAINT [FK__administr__accou__7E37BEF6] FOREIGN KEY([account_id])
REFERENCES [dbo].[classroom_accounts] ([account_id])
GO
ALTER TABLE [dbo].[administrators] CHECK CONSTRAINT [FK__administr__accou__7E37BEF6]
GO
ALTER TABLE [dbo].[administrators]  WITH CHECK ADD  CONSTRAINT [FK__administr__depar__73BA3083] FOREIGN KEY([department_id])
REFERENCES [dbo].[departments] ([department_id])
GO
ALTER TABLE [dbo].[administrators] CHECK CONSTRAINT [FK__administr__depar__73BA3083]
GO
ALTER TABLE [dbo].[assignments]  WITH CHECK ADD FOREIGN KEY([classroom_id])
REFERENCES [dbo].[classrooms] ([classroom_id])
GO
ALTER TABLE [dbo].[classroom_comments]  WITH CHECK ADD  CONSTRAINT [FK__classroom__class__778AC167] FOREIGN KEY([classroom_id])
REFERENCES [dbo].[classrooms] ([classroom_id])
GO
ALTER TABLE [dbo].[classroom_comments] CHECK CONSTRAINT [FK__classroom__class__778AC167]
GO
ALTER TABLE [dbo].[classrooms]  WITH CHECK ADD FOREIGN KEY([subject_id])
REFERENCES [dbo].[subjects] ([subject_id])
GO
ALTER TABLE [dbo].[classrooms]  WITH CHECK ADD  CONSTRAINT [FK__classroom__teach__6E01572D] FOREIGN KEY([teacher_id])
REFERENCES [dbo].[teachers] ([teacher_id])
GO
ALTER TABLE [dbo].[classrooms] CHECK CONSTRAINT [FK__classroom__teach__6E01572D]
GO
ALTER TABLE [dbo].[enrollments]  WITH CHECK ADD  CONSTRAINT [FK__enrollmen__stude__6A30C649] FOREIGN KEY([student_id])
REFERENCES [dbo].[students] ([student_id])
GO
ALTER TABLE [dbo].[enrollments] CHECK CONSTRAINT [FK__enrollmen__stude__6A30C649]
GO
ALTER TABLE [dbo].[enrollments]  WITH CHECK ADD FOREIGN KEY([subject_id])
REFERENCES [dbo].[subjects] ([subject_id])
GO
ALTER TABLE [dbo].[grades]  WITH CHECK ADD  CONSTRAINT [FK__grades__student___6B24EA82] FOREIGN KEY([student_id])
REFERENCES [dbo].[students] ([student_id])
GO
ALTER TABLE [dbo].[grades] CHECK CONSTRAINT [FK__grades__student___6B24EA82]
GO
ALTER TABLE [dbo].[grades]  WITH CHECK ADD FOREIGN KEY([submission_id])
REFERENCES [dbo].[submissions] ([submission_id])
GO
ALTER TABLE [dbo].[join_requests]  WITH CHECK ADD FOREIGN KEY([classroom_id])
REFERENCES [dbo].[classrooms] ([classroom_id])
GO
ALTER TABLE [dbo].[join_requests]  WITH CHECK ADD  CONSTRAINT [FK__join_requ__stude__6C190EBB] FOREIGN KEY([student_id])
REFERENCES [dbo].[students] ([student_id])
GO
ALTER TABLE [dbo].[join_requests] CHECK CONSTRAINT [FK__join_requ__stude__6C190EBB]
GO
ALTER TABLE [dbo].[lessons]  WITH CHECK ADD FOREIGN KEY([department_id])
REFERENCES [dbo].[departments] ([department_id])
GO
ALTER TABLE [dbo].[lessons]  WITH CHECK ADD FOREIGN KEY([subject_id])
REFERENCES [dbo].[subjects] ([subject_id])
GO
ALTER TABLE [dbo].[lessons]  WITH CHECK ADD  CONSTRAINT [FK__lessons__teacher__6EF57B66] FOREIGN KEY([teacher_id])
REFERENCES [dbo].[teachers] ([teacher_id])
GO
ALTER TABLE [dbo].[lessons] CHECK CONSTRAINT [FK__lessons__teacher__6EF57B66]
GO
ALTER TABLE [dbo].[students]  WITH CHECK ADD  CONSTRAINT [FK__students__accoun__7C4F7684] FOREIGN KEY([account_id])
REFERENCES [dbo].[classroom_accounts] ([account_id])
GO
ALTER TABLE [dbo].[students] CHECK CONSTRAINT [FK__students__accoun__7C4F7684]
GO
ALTER TABLE [dbo].[students]  WITH CHECK ADD  CONSTRAINT [FK__students__group___7F2BE32F] FOREIGN KEY([group_id])
REFERENCES [dbo].[student_groups] ([group_id])
GO
ALTER TABLE [dbo].[students] CHECK CONSTRAINT [FK__students__group___7F2BE32F]
GO
ALTER TABLE [dbo].[students]  WITH CHECK ADD  CONSTRAINT [FK__students__schola__7A672E12] FOREIGN KEY([scholarship_id])
REFERENCES [dbo].[scholarships] ([scholarship_id])
GO
ALTER TABLE [dbo].[students] CHECK CONSTRAINT [FK__students__schola__7A672E12]
GO
ALTER TABLE [dbo].[subjects]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[subject_categories] ([category_id])
GO
ALTER TABLE [dbo].[submissions]  WITH CHECK ADD FOREIGN KEY([assignment_id])
REFERENCES [dbo].[assignments] ([assignment_id])
GO
ALTER TABLE [dbo].[submissions]  WITH CHECK ADD  CONSTRAINT [FK__submissio__stude__6D0D32F4] FOREIGN KEY([student_id])
REFERENCES [dbo].[students] ([student_id])
GO
ALTER TABLE [dbo].[submissions] CHECK CONSTRAINT [FK__submissio__stude__6D0D32F4]
GO
ALTER TABLE [dbo].[teachers]  WITH CHECK ADD  CONSTRAINT [FK__teachers__accoun__7D439ABD] FOREIGN KEY([account_id])
REFERENCES [dbo].[classroom_accounts] ([account_id])
GO
ALTER TABLE [dbo].[teachers] CHECK CONSTRAINT [FK__teachers__accoun__7D439ABD]
GO
ALTER TABLE [dbo].[teachers]  WITH CHECK ADD  CONSTRAINT [FK__teachers__depart__72C60C4A] FOREIGN KEY([department_id])
REFERENCES [dbo].[departments] ([department_id])
GO
ALTER TABLE [dbo].[teachers] CHECK CONSTRAINT [FK__teachers__depart__72C60C4A]
GO
ALTER TABLE [dbo].[teachers]  WITH CHECK ADD  CONSTRAINT [FK__teachers__positi__7B5B524B] FOREIGN KEY([position_id])
REFERENCES [dbo].[teacher_positions] ([position_id])
GO
ALTER TABLE [dbo].[teachers] CHECK CONSTRAINT [FK__teachers__positi__7B5B524B]
GO
/****** Object:  StoredProcedure [dbo].[AssignmentGrades]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AssignmentGrades] @AssignmentId INT
AS
BEGIN
    SELECT * 
    FROM [DBUniversity].[dbo].[grades]
    WHERE [submission_id] IN
		(SELECT [submission_id]
		FROM [DBUniversity].[dbo].[submissions]
		WHERE [assignment_id]= @AssignmentId)
END;
GO
/****** Object:  StoredProcedure [dbo].[GetClassroomSubmissions]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetClassroomSubmissions] @ClassroomId INT
AS
BEGIN
    SELECT * 
    FROM [DBUniversity].[dbo].[submissions]
    WHERE [assignment_id] IN
		(SELECT [assignment_id]
		FROM [DBUniversity].[dbo].[assignments]
		WHERE [classroom_id]= @ClassroomId)
END;
GO
/****** Object:  StoredProcedure [dbo].[GetGroupStudents]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetGroupStudents]
    @GroupId INT
AS
BEGIN
    SELECT * 
    FROM [DBUniversity].[dbo].[students]
    WHERE [group_id] = @GroupId;
END;
GO
/****** Object:  StoredProcedure [dbo].[SoftDeleteAdministrator]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  StoredProcedure [dbo].[SoftDeleteAssignment]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SoftDeleteAssignment]
    @AssignmentId INT
AS
BEGIN
    UPDATE [DBUniversity].[dbo].[assignments]
    SET IsDeleted = 1              
    WHERE assignment_id = @AssignmentId;
END;
GO
/****** Object:  StoredProcedure [dbo].[SoftDeleteComment]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  StoredProcedure [dbo].[SoftDeleteGrade]    Script Date: 17.12.2024 07:41:17 ******/
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
/****** Object:  StoredProcedure [dbo].[StudentGrades]    Script Date: 17.12.2024 07:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[StudentGrades] @StudentId INT
AS
BEGIN
    SELECT * 
    FROM [DBUniversity].[dbo].[grades]
    WHERE [student_id] = @StudentId;
END;
GO
USE [master]
GO
ALTER DATABASE [DBUniversity] SET  READ_WRITE 
GO
