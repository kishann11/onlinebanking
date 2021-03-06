USE [master]
GO
/****** Object:  Database [OnlineBanking]    Script Date: 8/7/2017 11:06:20 AM ******/
CREATE DATABASE [OnlineBanking]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OnlineBanking', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\OnlineBanking.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'OnlineBanking_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\OnlineBanking_log.ldf' , SIZE = 2304KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [OnlineBanking] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OnlineBanking].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OnlineBanking] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OnlineBanking] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OnlineBanking] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OnlineBanking] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OnlineBanking] SET ARITHABORT OFF 
GO
ALTER DATABASE [OnlineBanking] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [OnlineBanking] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [OnlineBanking] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OnlineBanking] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OnlineBanking] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OnlineBanking] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OnlineBanking] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OnlineBanking] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OnlineBanking] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OnlineBanking] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OnlineBanking] SET  DISABLE_BROKER 
GO
ALTER DATABASE [OnlineBanking] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OnlineBanking] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OnlineBanking] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OnlineBanking] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OnlineBanking] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OnlineBanking] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OnlineBanking] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OnlineBanking] SET RECOVERY FULL 
GO
ALTER DATABASE [OnlineBanking] SET  MULTI_USER 
GO
ALTER DATABASE [OnlineBanking] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OnlineBanking] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OnlineBanking] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OnlineBanking] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'OnlineBanking', N'ON'
GO
USE [OnlineBanking]
GO
/****** Object:  StoredProcedure [dbo].[FLAGGEDCUSTOMERSTABLE]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FLAGGEDCUSTOMERSTABLE] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount float
	DECLARE @ssn1 int
	DECLARE @ssn2 int
    -- Insert statements for procedure here

	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno, amount FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno, @amount 

	WHILE @@FETCH_STATUS=-9
	BEGIN
	SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
	SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;

	SELECT @ssn1=ssn from customerinfo where customerid=@customerid1;
	SELECT @ssn2=ssn from customerinfo where customerid=@customerid2;

	SELECT @amount=@amount+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid1);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn1)
		INSERT INTO flaggedcustomers VALUES (@ssn1,@amount,'sent')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn1


	SELECT @amount=@amount+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid2);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn2)
		INSERT INTO flaggedcustomers VALUES (@ssn2,@amount,'received')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn2
	END
END

GO
/****** Object:  StoredProcedure [dbo].[FLAGGEDCUSTOMERSTABLE1]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FLAGGEDCUSTOMERSTABLE1] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount float
	DECLARE @ssn1 int
	DECLARE @ssn2 int
    -- Insert statements for procedure here

	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno, amount FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno, @amount 

	WHILE @@FETCH_STATUS=-9
	BEGIN
	SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
	SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;

	SELECT @ssn1=ssn from customerinfo where customerid=@customerid1;
	SELECT @ssn2=ssn from customerinfo where customerid=@customerid2;

	SELECT @amount=@amount+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid1);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn1)
		INSERT INTO flaggedcustomers VALUES (@ssn1,@amount,'sent')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn1


	SELECT @amount=@amount+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid2);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn2)
		INSERT INTO flaggedcustomers VALUES (@ssn2,@amount,'received')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn2
	END

	insert into flaggedcustomers values(53244526,46723,'sent');
END

GO
/****** Object:  StoredProcedure [dbo].[FLAGGEDCUSTOMERSTABLE3]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FLAGGEDCUSTOMERSTABLE3] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount float
	DECLARE @ssn1 int
	DECLARE @ssn2 int
    -- Insert statements for procedure here

	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno, amount FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno, @amount 

	WHILE @@FETCH_STATUS=-9
	BEGIN
	insert into flaggedcustomers values(77688567,46723,'sent');
	SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
	SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;

	SELECT @ssn1=ssn from customerinfo where customerid=@customerid1;
	SELECT @ssn2=ssn from customerinfo where customerid=@customerid2;

	SELECT @amount=@amount+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid1);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn1)
		INSERT INTO flaggedcustomers VALUES (@ssn1,@amount,'sent')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn1


	SELECT @amount=@amount+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid2);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn2)
		INSERT INTO flaggedcustomers VALUES (@ssn2,@amount,'received')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn2
	END

	
END

GO
/****** Object:  StoredProcedure [dbo].[FLAGGEDCUSTOMERSTABLE4]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FLAGGEDCUSTOMERSTABLE4] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount float
	DECLARE @ssn1 int
	DECLARE @ssn2 int
    -- Insert statements for procedure here

	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno, amount FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno, @amount 

	WHILE @@FETCH_STATUS=0
	BEGIN
	SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
	SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;

	SELECT @ssn1=ssn from customerinfo where customerid=@customerid1;
	SELECT @ssn2=ssn from customerinfo where customerid=@customerid2;

	SELECT @amount=@amount+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid1);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn1)
		INSERT INTO flaggedcustomers VALUES (@ssn1,@amount,'sent')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn1


	SELECT @amount=@amount+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid2);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn2)
		INSERT INTO flaggedcustomers VALUES (@ssn2,@amount,'received')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn2
	END

	
END

GO
/****** Object:  StoredProcedure [dbo].[FLAGGEDCUSTOMERSTABLE5]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FLAGGEDCUSTOMERSTABLE5] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount float
	DECLARE @ssn1 int
	DECLARE @ssn2 int
    -- Insert statements for procedure here

	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno, amount FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno, @amount 

	WHILE @@FETCH_STATUS=-1
	BEGIN
	SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
	SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;

	SELECT @ssn1=ssn from customerinfo where customerid=@customerid1;
	SELECT @ssn2=ssn from customerinfo where customerid=@customerid2;

	SELECT @amount=@amount+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid1);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn1)
		INSERT INTO flaggedcustomers VALUES (@ssn1,@amount,'sent')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn1


	SELECT @amount=@amount+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid2);
	IF NOT EXISTS(SELECT * FROM flaggedcustomers f WHERE f.ssn=@ssn2)
		INSERT INTO flaggedcustomers VALUES (@ssn2,@amount,'received')
	ELSE
		UPDATE flaggedcustomers SET amount=amount+@amount WHERE ssn=@ssn2
	END

	
END

GO
/****** Object:  StoredProcedure [dbo].[FLAGGEDCUSTOMERSTABLE6]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FLAGGEDCUSTOMERSTABLE6] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount float=0
	DECLARE @amount1 float=0
	DECLARE @ssn1 int
	DECLARE @ssn2 int
    -- Insert statements for procedure here

	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno, amount FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno, @amount 

	WHILE @@FETCH_STATUS=-1
	BEGIN
	SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
	SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;

	SELECT @ssn1=ssn from customerinfo where customerid=@customerid1;
	SELECT @ssn2=ssn from customerinfo where customerid=@customerid2;

	IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1)
		BEGIN
			SELECT @amount=@amount+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid1);
			IF(@amount>10000)
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount,'sent');    
		END

		IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2)
		BEGIN
			SELECT @amount=@amount+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid2)
			IF(@amount>10000)
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount,'received');
		END
	END

	
END

GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLE]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLE]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount float
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno, amount FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno, @amount 

	WHILE @@FETCH_STATUS=-9
	BEGIN
		SELECT @customerid1=customerid FROM accountinfo WHERE @senderaccno=accountno;
		SELECT @customerid2=customerid FROM accountinfo WHERE @receiveraccno=accountno;

		IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE customerid=@customerid1)
		BEGIN
			SELECT @amount=@amount+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid1);
			IF(@amount>10000)
				INSERT INTO dbo.flaggedcustomers VALUES (@customerid1,@amount,'sent');    
		END

		IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE customerid=@customerid2)
		BEGIN
			SELECT @amount=@amount+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
			WHERE customerid=@customerid2)
			IF(@amount>10000)
				INSERT INTO dbo.flaggedcustomers VALUES (@customerid2,@amount,'received');

		END
	END
	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLEFINAL]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLEFINAL]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @ssn1 int
	DECLARE @ssn2 int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount1 float=0
	DECLARE @amount2 float=0
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno, amount FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno
	WHILE @@FETCH_STATUS=-1
	BEGIN
		SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
		SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;
		SELECT @ssn1=ssn FROM customerinfo where customerid=@customerid1
		SELECT @ssn2=ssn FROM customerinfo where customerid=@customerid2

		SELECT @amount1=@amount1+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid1);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1 and stat='sent')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount1,'sent'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount1 where ssn=@ssn1 and stat='sent'  
		
		
		SELECT @amount2=@amount2+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid2);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2 and stat='received')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount1,'received'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount2 where ssn=@ssn2 and stat='received'  
		

	END
	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLEFINAL1]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLEFINAL1]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @ssn1 int
	DECLARE @ssn2 int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount1 float=0
	DECLARE @amount2 float=0
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno, amount FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno
	WHILE @@FETCH_STATUS=-9
	BEGIN
		SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
		SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;
		SELECT @ssn1=ssn FROM customerinfo where customerid=@customerid1
		SELECT @ssn2=ssn FROM customerinfo where customerid=@customerid2

		SELECT @amount1=@amount1+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid1);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1 and stat='sent')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount1,'sent'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount1 where ssn=@ssn1 and stat='sent'  
		
		
		SELECT @amount2=@amount2+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid2);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2 and stat='received')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount1,'received'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount2 where ssn=@ssn2 and stat='received'  
		

	END
	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLEFINAL10]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLEFINAL10]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @ssn1 int
	DECLARE @ssn2 int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount1 float=0
	DECLARE @amount2 float=0
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR
	FOR
	SELECT senderaccno, receiveraccno FROM transactions WHERE DATE=CONVERT(date,GETDATE()) 
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @senderaccno, @receiveraccno
	WHILE @@FETCH_STATUS=0
	BEGIN

		SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
		SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;
		SELECT @ssn1=ssn FROM customerinfo where customerid=@customerid1
		SELECT @ssn2=ssn FROM customerinfo where customerid=@customerid2
		SELECT @amount1=sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid1);
		IF(@amount1>10000)
		BEGIN
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1 and stat='sent')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount1,'sent'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount1 where ssn=@ssn1 and stat='sent' ;
		END
		SELECT @amount2=sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid2);
		
		IF(@amount2>10000)
		BEGIN
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2 and stat='received')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount2,'received'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount2 where ssn=@ssn2 and stat='received';
		END


		FETCH NEXT FROM transactionrows INTO @senderaccno,@receiveraccno;

	END

	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLEFINAL2]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLEFINAL2]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @ssn1 int
	DECLARE @ssn2 int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount1 float=0
	DECLARE @amount2 float=0
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno
	WHILE @@FETCH_STATUS=-9
	BEGIN
		SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
		SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;
		SELECT @ssn1=ssn FROM customerinfo where customerid=@customerid1
		SELECT @ssn2=ssn FROM customerinfo where customerid=@customerid2

		SELECT @amount1=@amount1+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid1);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1 and stat='sent')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount1,'sent'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount1 where ssn=@ssn1 and stat='sent'  
		
		
		SELECT @amount2=@amount2+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid2);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2 and stat='received')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount1,'received'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount2 where ssn=@ssn2 and stat='received'  
		

	END
	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLEFINAL3]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLEFINAL3]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @ssn1 int
	DECLARE @ssn2 int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount1 float=0
	DECLARE @amount2 float=0
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno
	WHILE @@FETCH_STATUS=-9
	BEGIN
		SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
		SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;
		SELECT @ssn1=ssn FROM customerinfo where customerid=@customerid1
		SELECT @ssn2=ssn FROM customerinfo where customerid=@customerid2
		insert into flaggedcustomers values (25143543,6758,'sent')
		SELECT @amount1=@amount1+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid1);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1 and stat='sent')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount1,'sent'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount1 where ssn=@ssn1 and stat='sent'  
		
		
		SELECT @amount2=@amount2+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid2);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2 and stat='received')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount1,'received'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount2 where ssn=@ssn2 and stat='received'  
		

	END
	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLEFINAL4]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLEFINAL4]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @ssn1 int
	DECLARE @ssn2 int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount1 float=0
	DECLARE @amount2 float=0
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno FROM transactions where date=CONVERT(date,GETDATE())
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno
	WHILE @@FETCH_STATUS=0
	BEGIN
		SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
		SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;
		SELECT @ssn1=ssn FROM customerinfo where customerid=@customerid1
		SELECT @ssn2=ssn FROM customerinfo where customerid=@customerid2
		insert into flaggedcustomers values (25143543,6758,'sent')
		SELECT @amount1=@amount1+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid1);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1 and stat='sent')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount1,'sent'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount1 where ssn=@ssn1 and stat='sent'  
		
		
		SELECT @amount2=@amount2+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid2);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2 and stat='received')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount1,'received'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount2 where ssn=@ssn2 and stat='received'  
		

	END
	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLEFINAL5]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLEFINAL5]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @ssn1 int
	DECLARE @ssn2 int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount1 float=0
	DECLARE @amount2 float=0
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR
	FOR
	SELECT senderaccno, receiveraccno FROM transactions WHERE DATE=CONVERT(date,GETDATE()) 
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @senderaccno, @receiveraccno
	WHILE @@FETCH_STATUS=0
	BEGIN
		SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
		SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;
		IF(@customerid1=@customerid2)
			CONTINUE;


		SELECT @ssn1=ssn FROM customerinfo where customerid=@customerid1
		SELECT @ssn2=ssn FROM customerinfo where customerid=@customerid2
		SELECT @amount1=sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid1);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1 and stat='sent')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount1,'sent'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount1 where ssn=@ssn1 and stat='sent'  
		
		
		SELECT @amount2=sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid2);
		IF(@amount2>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2 and stat='received')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount2,'received'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount2 where ssn=@ssn2 and stat='received';
		FETCH NEXT FROM transactionrows INTO @senderaccno,@receiveraccno
	END

	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLEFINAL6]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLEFINAL6]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @ssn1 int
	DECLARE @ssn2 int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount1 float=0
	DECLARE @amount2 float=0
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno FROM transactions where date=DATEADD(day, -1, convert(date, GETDATE()))
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno
	WHILE @@FETCH_STATUS=0
	BEGIN
		SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
		SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;
		SELECT @ssn1=ssn FROM customerinfo where customerid=@customerid1
		SELECT @ssn2=ssn FROM customerinfo where customerid=@customerid2
		insert into flaggedcustomers values (25143543,6758,'sent')
		SELECT @amount1=@amount1+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid1);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1 and stat='sent')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount1,'sent'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount1 where ssn=@ssn1 and stat='sent'  
		
		
		SELECT @amount2=@amount2+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid2);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2 and stat='received')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount1,'received'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount2 where ssn=@ssn2 and stat='received'  
		

	END
	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  StoredProcedure [dbo].[UPDATIONTABLEFINAL7]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nikitha
-- Create date: 27/7/2017
-- Description:	updating flag table
-- =============================================
CREATE PROCEDURE [dbo].[UPDATIONTABLEFINAL7]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @tid int
	DECLARE @senderaccno int
	DECLARE @receiveraccno int
	DECLARE @ssn1 int
	DECLARE @ssn2 int
	DECLARE @customerid1 int
	DECLARE @customerid2 int
	DECLARE @amount1 float=0
	DECLARE @amount2 float=0
    -- Insert statements for procedure here
	DECLARE transactionrows CURSOR READ_ONLY
	FOR
	SELECT transactionid, senderaccno, receiveraccno FROM transactions where date=DATEADD(day, -1, convert(date, GETDATE()))
	OPEN transactionrows
	FETCH NEXT FROM transactionrows INTO @tid, @senderaccno, @receiveraccno
	WHILE @@FETCH_STATUS=-1
	BEGIN
		SELECT @customerid1=customerid FROM accountinfo WHERE accountno=@senderaccno;
		SELECT @customerid2=customerid FROM accountinfo WHERE accountno=@receiveraccno;
		SELECT @ssn1=ssn FROM customerinfo where customerid=@customerid1
		SELECT @ssn2=ssn FROM customerinfo where customerid=@customerid2
		insert into flaggedcustomers values (25143543,6758,'sent')
		SELECT @amount1=@amount1+sum(amount) FROM transactions WHERE senderaccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid1);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn1 and stat='sent')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn1,@amount1,'sent'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount1 where ssn=@ssn1 and stat='sent'  
		
		
		SELECT @amount2=@amount2+sum(amount) FROM transactions WHERE receiveraccno IN (SELECT accountno FROM accountinfo
		WHERE customerid=@customerid2);
		IF(@amount1>10000)
			IF NOT EXISTS(SELECT * FROM flaggedcustomers WHERE ssn=@ssn2 and stat='received')
				INSERT INTO dbo.flaggedcustomers VALUES (@ssn2,@amount1,'received'); 
			ELSE
				UPDATE flaggedcustomers set amount=amount+@amount2 where ssn=@ssn2 and stat='received'  
		

	END
	CLOSE transactionrows
    DEALLOCATE transactionrows
END
GO
/****** Object:  Table [dbo].[accountinfo]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[accountinfo](
	[accountno] [int] IDENTITY(12345678,1) NOT NULL,
	[accounttype] [varchar](50) NOT NULL,
	[customerid] [int] NOT NULL,
	[balance] [money] NOT NULL,
	[dateofcreation] [date] NOT NULL,
	[flag] [bit] NOT NULL,
 CONSTRAINT [PK_accountinfo] PRIMARY KEY CLUSTERED 
(
	[accountno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bankerlogin]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bankerlogin](
	[bankerid] [int] NOT NULL,
	[pass] [varchar](max) NOT NULL,
	[lastlogin] [smalldatetime] NULL,
 CONSTRAINT [PK_bankerlogin] PRIMARY KEY CLUSTERED 
(
	[bankerid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[beneficiary]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[beneficiary](
	[customerid] [int] NOT NULL,
	[beneficiaryaccno] [int] NOT NULL,
	[beneficiaryname] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[closedaccounts]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[closedaccounts](
	[accountno] [int] NOT NULL,
	[dateofclosing] [date] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[creditscore]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[creditscore](
	[ssn] [int] NOT NULL,
	[creditscore] [smallint] NOT NULL,
 CONSTRAINT [PK_creditscore] PRIMARY KEY CLUSTERED 
(
	[ssn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[customerinfo]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[customerinfo](
	[customerid] [int] IDENTITY(1,1) NOT NULL,
	[ssn] [int] NOT NULL,
	[firstname] [varchar](50) NOT NULL,
	[lastname] [varchar](50) NOT NULL,
	[dob] [date] NOT NULL,
	[homeaddress] [varchar](max) NOT NULL,
	[phoneno] [bigint] NOT NULL,
	[emailid] [varchar](50) NOT NULL,
	[stat] [bit] NOT NULL,
	[pass] [varchar](max) NOT NULL,
	[lastlogin] [datetime] NULL,
 CONSTRAINT [PK_customerinfo] PRIMARY KEY CLUSTERED 
(
	[customerid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_customerinfo] UNIQUE NONCLUSTERED 
(
	[customerid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[flaggedcustomers]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[flaggedcustomers](
	[ssn] [int] NOT NULL,
	[amount] [money] NOT NULL,
	[stat] [varchar](50) NOT NULL,
 CONSTRAINT [PK_flaggedcustomers] PRIMARY KEY CLUSTERED 
(
	[ssn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[security]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[security](
	[customerid] [varchar](50) NOT NULL,
	[question1] [smallint] NOT NULL,
	[answer1] [varchar](50) NOT NULL,
	[question2] [varchar](50) NOT NULL,
	[answer2] [varchar](50) NOT NULL,
 CONSTRAINT [PK_security] PRIMARY KEY CLUSTERED 
(
	[customerid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[securityquestion]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[securityquestion](
	[qid] [smallint] NOT NULL,
	[qname] [varchar](max) NOT NULL,
 CONSTRAINT [PK_securityquestion] PRIMARY KEY CLUSTERED 
(
	[qid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[transactions]    Script Date: 8/7/2017 11:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transactions](
	[transactionid] [int] IDENTITY(24586347,1) NOT NULL,
	[senderaccno] [int] NOT NULL,
	[receiveraccno] [int] NOT NULL,
	[amount] [money] NOT NULL,
	[date] [date] NOT NULL,
	[time] [time](7) NOT NULL,
 CONSTRAINT [PK_transactions] PRIMARY KEY CLUSTERED 
(
	[transactionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[accountinfo] ADD  CONSTRAINT [DF_accountinfo_flag]  DEFAULT ((1)) FOR [flag]
GO
ALTER TABLE [dbo].[customerinfo] ADD  CONSTRAINT [DF_customerinfo_stat]  DEFAULT ((1)) FOR [stat]
GO
ALTER TABLE [dbo].[accountinfo]  WITH CHECK ADD  CONSTRAINT [FK_accountinfo_customerinfo] FOREIGN KEY([customerid])
REFERENCES [dbo].[customerinfo] ([customerid])
GO
ALTER TABLE [dbo].[accountinfo] CHECK CONSTRAINT [FK_accountinfo_customerinfo]
GO
ALTER TABLE [dbo].[beneficiary]  WITH CHECK ADD  CONSTRAINT [FK_beneficiary_accountinfo] FOREIGN KEY([beneficiaryaccno])
REFERENCES [dbo].[accountinfo] ([accountno])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[beneficiary] CHECK CONSTRAINT [FK_beneficiary_accountinfo]
GO
ALTER TABLE [dbo].[closedaccounts]  WITH CHECK ADD  CONSTRAINT [FK_closedaccounts_accountinfo] FOREIGN KEY([accountno])
REFERENCES [dbo].[accountinfo] ([accountno])
GO
ALTER TABLE [dbo].[closedaccounts] CHECK CONSTRAINT [FK_closedaccounts_accountinfo]
GO
ALTER TABLE [dbo].[security]  WITH CHECK ADD  CONSTRAINT [FK_security_securityquestion] FOREIGN KEY([question1])
REFERENCES [dbo].[securityquestion] ([qid])
GO
ALTER TABLE [dbo].[security] CHECK CONSTRAINT [FK_security_securityquestion]
GO
ALTER TABLE [dbo].[transactions]  WITH CHECK ADD  CONSTRAINT [FK_transactions_accountinfo] FOREIGN KEY([senderaccno])
REFERENCES [dbo].[accountinfo] ([accountno])
GO
ALTER TABLE [dbo].[transactions] CHECK CONSTRAINT [FK_transactions_accountinfo]
GO
ALTER TABLE [dbo].[transactions]  WITH CHECK ADD  CONSTRAINT [FK_transactions_accountinfo1] FOREIGN KEY([receiveraccno])
REFERENCES [dbo].[accountinfo] ([accountno])
GO
ALTER TABLE [dbo].[transactions] CHECK CONSTRAINT [FK_transactions_accountinfo1]
GO
USE [master]
GO
ALTER DATABASE [OnlineBanking] SET  READ_WRITE 
GO
