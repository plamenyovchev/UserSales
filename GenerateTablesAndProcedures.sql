USE [UserSales]
GO
/****** Object:  Table [dbo].[DomainsTemp]    Script Date: 14.6.2015 г. 15:16:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DomainsTemp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Domain] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DomainsTemp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FirstLastTemp]    Script Date: 14.6.2015 г. 15:16:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FirstLastTemp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_FirstLastTemp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sales]    Script Date: 14.6.2015 г. 15:16:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [nvarchar](3) NOT NULL,
	[Volume] [int] NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 14.6.2015 г. 15:16:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET IDENTITY_INSERT [dbo].[FirstLastTemp] OFF
GO
ALTER TABLE [dbo].[Sales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[Sales] CHECK CONSTRAINT [FK_Sales_Users]
GO
/****** Object:  StoredProcedure [dbo].[Initialization]    Script Date: 14.6.2015 г. 15:16:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Plamen Yovchev>
-- Create date: <14.06.2015>
-- Description:	<Initialization of the database>
-- =============================================
CREATE PROCEDURE [dbo].[Initialization]
AS

DELETE FROM [dbo].[FirstLastTemp]
DELETE FROM [dbo].[DomainsTemp]
SET IDENTITY_INSERT [dbo].[DomainsTemp] ON 

INSERT [dbo].[DomainsTemp] ([ID], [Domain]) VALUES (1, N'hotmail.com')
INSERT [dbo].[DomainsTemp] ([ID], [Domain]) VALUES (2, N'gmail.com')
INSERT [dbo].[DomainsTemp] ([ID], [Domain]) VALUES (3, N'live.com')
SET IDENTITY_INSERT [dbo].[DomainsTemp] OFF
SET IDENTITY_INSERT [dbo].[FirstLastTemp] ON 

INSERT [dbo].[FirstLastTemp] ([ID], [FirstName], [LastName]) VALUES (1, N'John', N'Johnson')
INSERT [dbo].[FirstLastTemp] ([ID], [FirstName], [LastName]) VALUES (2, N'Mark', N'Lamas')
INSERT [dbo].[FirstLastTemp] ([ID], [FirstName], [LastName]) VALUES (3, N'Lisa', N'Jackson')
INSERT [dbo].[FirstLastTemp] ([ID], [FirstName], [LastName]) VALUES (4, N'Maria', N'Brown')
INSERT [dbo].[FirstLastTemp] ([ID], [FirstName], [LastName]) VALUES (5, N'Sonya', N'Mason')
INSERT [dbo].[FirstLastTemp] ([ID], [FirstName], [LastName]) VALUES (6, N'Philip', N'Rodrigez')
INSERT [dbo].[FirstLastTemp] ([ID], [FirstName], [LastName]) VALUES (7, N'Jose', N'Roberts')
INSERT [dbo].[FirstLastTemp] ([ID], [FirstName], [LastName]) VALUES (8, N'Lorenzo', N'Thomas')
INSERT [dbo].[FirstLastTemp] ([ID], [FirstName], [LastName]) VALUES (9, N'George', N'Rose')
SET IDENTITY_INSERT [dbo].[FirstLastTemp] OFF


GO
/****** Object:  StoredProcedure [dbo].[Seed]    Script Date: 14.6.2015 г. 15:16:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Plamen Yovchev>
-- Create date: <14.06.2015>
-- Description:	<Initialization of the database>
-- =============================================
CREATE PROCEDURE [dbo].[Seed]
AS

DELETE FROM UserSales.dbo.Sales
DBCC CHECKIDENT ('UserSales.dbo.Sales',RESEED, 0)
DELETE FROM UserSales.dbo.Users
DBCC CHECKIDENT ('UserSales.dbo.Users',RESEED, 0)

DECLARE @length int = 1
DECLARE @usersCount int
DECLARE @randomSales int


		INSERT INTO Users (FirstName,LastName,Email) 
		Select TOP 100 
		flt.FirstName as FirstName
		,flt2.LastName AS LastName
		,(flt.FirstName +'.' + flt2.LastName +'@'+ dm.Domain) AS Email
		From dbo.FirstLastTemp flt 
		CROSS JOIN dbo.FirstLastTemp flt2 
		CROSS JOIN dbo.DomainsTemp dm
		GROUP BY flt.FirstName, flt2.LastName, dm.Domain
		ORDER BY NEWID(); 

			WHILE @length <= 100
				BEGIN 
					set @randomSales = ROUND(((20 - 1) * RAND() + 1), 0)
					WHILE @randomSales > 0
						BEGIN
							INSERT INTO Sales (ProductCode, Volume, UserID)
							SELECT
							sale.ProductCode,
							sale.Volume,
							sale.UserID
							FROM 
							(SELECT 
								SUBSTRING(CONVERT(varchar(40), NEWID()),0,4) as ProductCode,
								ROUND(((200 - 1) * RAND() + 1), 0) AS Volume,
								(SELECT
										u.ID
									FROM Users AS u
									WHERE u.ID = @length) as UserID
							) as sale

							set @randomSales = @randomSales -1;
						END

					set @length = @length + 1
				END
GO
