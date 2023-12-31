-- CREATE DATA
use master
CREATE DATABASE InsuranceCompany
GO
ALTER DATABASE InsuranceCompany SET RECOVERY SIMPLE
GO
USE InsuranceCompany

-- CREATE TABLES
-- create InsuranceTypes
CREATE TABLE dbo.InsuranceTypes(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [text] NULL,)

-- create SupportingDocuments
CREATE TABLE dbo.SupportingDocuments(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [text] NULL,)

-- create Contracts
CREATE TABLE dbo.Contracts(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Responsibilities] [nvarchar](100) NOT NULL,
	[StartDeadline] [date] NOT NULL,
	[EndDeadline] [date] NOT NULL,)

-- create AgentTypes
CREATE TABLE dbo.AgentTypes(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Type] [nchar](50) NOT NULL,)

-- create InsuranceAgents
CREATE TABLE dbo.InsuranceAgents(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](20) NOT NULL,
	[Surname] [nvarchar](20) NOT NULL,
	[MiddleName] [nvarchar](20) NOT NULL,
	[AgentType] [int] NOT NULL,
	[Salary] [money] NOT NULL,
	[Contract] [int] NOT NULL,
	[TransactionPercent] [float] NOT NULL,)
ALTER TABLE [dbo].[InsuranceAgents]  WITH CHECK ADD  CONSTRAINT [FK_InsuranceAgents_AgentTypes] FOREIGN KEY([AgentType])
REFERENCES [dbo].[AgentTypes] ([Id])
ALTER TABLE [dbo].[InsuranceAgents] CHECK CONSTRAINT [FK_InsuranceAgents_AgentTypes]
ALTER TABLE [dbo].[InsuranceAgents]  WITH CHECK ADD  CONSTRAINT [FK_InsuranceAgents_Contracts] FOREIGN KEY([Contract])
REFERENCES [dbo].[Contracts] ([Id])
ALTER TABLE [dbo].[InsuranceAgents] CHECK CONSTRAINT [FK_InsuranceAgents_Contracts]
ALTER TABLE [dbo].[InsuranceAgents]  WITH CHECK ADD CHECK  (([TransactionPercent]>=(0) AND [TransactionPercent]<=(1)))

-- create Clients
CREATE TABLE dbo.Clients(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](20) NOT NULL,
	[Surname] [nvarchar](20) NOT NULL,
	[MiddleName] [nvarchar](20) NOT NULL,
	[Birthdate] [date] NOT NULL,
	[MobilePhone] [nvarchar](20) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Street] [nvarchar](50) NOT NULL,
	[House] [nvarchar](50) NOT NULL,
	[Apartment] [nvarchar](50) NOT NULL,
	[PassportNumber] [nchar](9) NOT NULL,
	[PassportIssueDate] [date] NOT NULL,
	[PassportIdentification] [nchar](14) NOT NULL,)
ALTER TABLE [dbo].[Clients]  WITH CHECK ADD  CONSTRAINT [CK__PassportD__Ident__628FA481] CHECK  (([PassportIdentification] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Za-z][0-9][0-9][0-9][A-Za-z][A-Za-z][0-9]'))
ALTER TABLE [dbo].[Clients] CHECK CONSTRAINT [CK__PassportD__Ident__628FA481]
ALTER TABLE [dbo].[Clients]  WITH CHECK ADD  CONSTRAINT [CK__PassportD__Numbe__619B8048] CHECK  (([PassportNumber] like '[A-Za-z][A-Za-z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
ALTER TABLE [dbo].[Clients] CHECK CONSTRAINT [CK__PassportD__Numbe__619B8048]

-- create InsuranceCases
CREATE TABLE dbo.InsuranceCases(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Client] [int] NOT NULL,
	[InsuranceAgent] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Description] [text] NULL,
	[SupportingDocument] [int] NOT NULL,
	[InsurancePayment] [money] NOT NULL,)
ALTER TABLE [dbo].[InsuranceCases]  WITH CHECK ADD  CONSTRAINT [FK_InsuranceCases_Clients] FOREIGN KEY([Client])
REFERENCES [dbo].[Clients] ([Id])
ALTER TABLE [dbo].[InsuranceCases] CHECK CONSTRAINT [FK_InsuranceCases_Clients]
ALTER TABLE [dbo].[InsuranceCases]  WITH CHECK ADD  CONSTRAINT [FK_InsuranceCases_InsuranceAgents] FOREIGN KEY([InsuranceAgent])
REFERENCES [dbo].[InsuranceAgents] ([Id])
ALTER TABLE [dbo].[InsuranceCases] CHECK CONSTRAINT [FK_InsuranceCases_InsuranceAgents]
ALTER TABLE [dbo].[InsuranceCases]  WITH CHECK ADD  CONSTRAINT [FK_InsuranceCases_SupportingDocuments] FOREIGN KEY([SupportingDocument])
REFERENCES [dbo].[SupportingDocuments] ([Id])
ALTER TABLE [dbo].[InsuranceCases] CHECK CONSTRAINT [FK_InsuranceCases_SupportingDocuments]

-- create Policies
CREATE TABLE dbo.Policies(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[InsuranceAgent] [int] NOT NULL,
	[ApplicationDate] [date] NOT NULL,
	[PolicyNumber] [nchar](16) NOT NULL,
	[InsuranceType] [int] NOT NULL,
	[Client] [int] NOT NULL,
	[PolicyTerm] [int] NOT NULL,
	[PolicyPayment] [money] NOT NULL,)
ALTER TABLE [dbo].[Policies]  WITH CHECK ADD  CONSTRAINT [FK_Policies_Clients] FOREIGN KEY([Client])
REFERENCES [dbo].[Clients] ([Id])
ALTER TABLE [dbo].[Policies] CHECK CONSTRAINT [FK_Policies_Clients]
ALTER TABLE [dbo].[Policies]  WITH CHECK ADD  CONSTRAINT [FK_Policies_InsuranceAgents] FOREIGN KEY([InsuranceAgent])
REFERENCES [dbo].[InsuranceAgents] ([Id])
ALTER TABLE [dbo].[Policies] CHECK CONSTRAINT [FK_Policies_InsuranceAgents]
ALTER TABLE [dbo].[Policies]  WITH CHECK ADD  CONSTRAINT [FK_Policies_InsuranceTypes] FOREIGN KEY([InsuranceType])
REFERENCES [dbo].[InsuranceTypes] ([Id])
ALTER TABLE [dbo].[Policies] CHECK CONSTRAINT [FK_Policies_InsuranceTypes]
ALTER TABLE [dbo].[Policies]  WITH CHECK ADD  CONSTRAINT [CK_Policies] CHECK  (([PolicyNumber] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
ALTER TABLE [dbo].[Policies] CHECK CONSTRAINT [CK_Policies]

-- create PolicyInsuranceCases
CREATE TABLE dbo.PolicyInsuranceCases(
	[PolicyId] [int] NOT NULL,
	[InsuranceCaseId] [int] NOT NULL
)
ALTER TABLE [dbo].[PolicyInsuranceCases]  WITH CHECK ADD  CONSTRAINT [FK_PolicyInsuranceCases_InsuranceCases] FOREIGN KEY([InsuranceCaseId])
REFERENCES [dbo].[InsuranceCases] ([Id])
ALTER TABLE [dbo].[PolicyInsuranceCases] CHECK CONSTRAINT [FK_PolicyInsuranceCases_InsuranceCases]
ALTER TABLE [dbo].[PolicyInsuranceCases]  WITH CHECK ADD  CONSTRAINT [FK_PolicyInsuranceCases_Policies] FOREIGN KEY([PolicyId])
REFERENCES [dbo].[Policies] ([Id])
ALTER TABLE [dbo].[PolicyInsuranceCases] CHECK CONSTRAINT [FK_PolicyInsuranceCases_Policies]

-- FILL TABLES
-- fill AgentTypes
GO
INSERT INTO AgentTypes
VALUES ('������� ��������'), ('������������')

-- fill Contracts
GO
DECLARE @Responsibilities TABLE (Name NVARCHAR(100))
    INSERT INTO @Responsibilities (Name)
    VALUES 
		('��������� �����'),
		('��������'),
		('����� �� ������������ ��������'),
		('�������� �� ��������'),
		('������������� ��������� �������'),
		('������� �� �����'),
		('����������� ������� �����������'),
		('�������� �� �����������'),
		('������������� ���� ������ �����������');
	
	DECLARE @Responsibility NVARCHAR(100)
    
	WHILE (SELECT COUNT(*) FROM dbo.Contracts) < 100
    BEGIN
        SELECT TOP 1 @Responsibility = Name FROM @Responsibilities ORDER BY NEWID()
        
        INSERT INTO dbo.Contracts(Responsibilities, StartDeadline, EndDeadline)
        VALUES (@Responsibility, DATEADD(DAY, -CAST(CHECKSUM(NEWID()) % 3650 AS INT), GETDATE()), DATEADD(DAY, -CAST(CHECKSUM(NEWID()) % 3650 AS INT), GETDATE()))
    END

-- fill SupportingDocuments
GO
DECLARE @SupportingDocumentNames TABLE (Name NVARCHAR(100))
    INSERT INTO @SupportingDocumentNames (Name)
    VALUES 
		('������������� � ������������'),
		('����������� ��������'),
		('����������� �������'),
		('��������������� �����'),
		('������� �����������'),
		('���������� ������'),
		('�������������� ������ �������'),
		('������� � ����� ������������'),
		('������������� � ������'),
		('������������� � ��������');
	
	DECLARE @SupportingDocumentName NVARCHAR(100)
    
	WHILE (SELECT COUNT(*) FROM dbo.SupportingDocuments) < 100
    BEGIN
        SELECT TOP 1 @SupportingDocumentName = Name FROM @SupportingDocumentNames ORDER BY NEWID()
		
        INSERT INTO dbo.SupportingDocuments(Name)
        VALUES (@SupportingDocumentName)
    END

-- fill InsuranceTypes
GO
DECLARE @InsuranceTypeNames TABLE (Name NVARCHAR(100))
    INSERT INTO @InsuranceTypeNames (Name)
    VALUES 
		('������������� �����������'),
		('����������� �����'),
		('����������� �����������'),
		('����������� ������������'),
		('����������� �� ���������� �������'),
		('����������� ���������������'),
		('����������� ���������'),
		('����������� �����������'),
		('����������� �������'),
		('����������� ������');

	DECLARE @InsuranceTypeName NVARCHAR(100)
    
	WHILE (SELECT COUNT(*) FROM dbo.InsuranceTypes) < 100
    BEGIN
        SELECT TOP 1 @InsuranceTypeName = Name FROM @InsuranceTypeNames ORDER BY NEWID()
		
        INSERT INTO dbo.InsuranceTypes(Name)
        VALUES (@InsuranceTypeName)
    END

-- fill InsuranceAgents
GO
DECLARE @AgentNames TABLE (Name NVARCHAR(20))
    INSERT INTO @AgentNames (Name)
    VALUES 
		('����'),
		('����'),
		('����'),
		('���������'),
		('���������'),
		('�����'),
		('������'),
		('�����'),
		('�������'),
		('�����');

DECLARE @AgentSurnames TABLE (Name NVARCHAR(20))
    INSERT INTO @AgentSurnames (Name)
    VALUES 
		('������'),
		('������'),
		('�������'),
		('�������'),
		('������'),
		('��������'),
		('�����������'),
		('������'),
		('��������'),
		('��������');

DECLARE @AgentMiddleNames TABLE (Name NVARCHAR(20))
    INSERT INTO @AgentMiddleNames (Name)
    VALUES 
		('��������'),
		('��������'),
		('���������'),
		('����������'),
		('�������������'),
		('����������'),
		('���������'),
		('���������'),
		('����������'),
		('�����������');

	DECLARE @AgentName NVARCHAR(20)
    DECLARE @AgentSurname NVARCHAR(20)
    DECLARE @AgentMiddleName NVARCHAR(20)
    
	WHILE (SELECT COUNT(*) FROM dbo.InsuranceAgents) < 100
    BEGIN
        SELECT TOP 1 @AgentName = Name FROM @AgentNames ORDER BY NEWID()
		SELECT TOP 1 @AgentSurname = Name FROM @AgentSurnames ORDER BY NEWID()
		SELECT TOP 1 @AgentMiddleName = Name FROM @AgentMiddleNames ORDER BY NEWID()
		
        INSERT INTO dbo.InsuranceAgents(Name, Surname, MiddleName, AgentType, Salary, Contract, TransactionPercent)
        VALUES (@AgentName, @AgentSurname, @AgentMiddleName, RAND()*(2)+1, RAND()*100, RAND()*(100)+1, RAND())
    END

-- fill Clients
DECLARE @MobilePhone NVARCHAR(20)
DECLARE @PassportNumber VARCHAR(9)
DECLARE @RandomIdentification VARCHAR(14)
DECLARE @StreetNames TABLE (Name NVARCHAR(50))
    INSERT INTO @StreetNames (Name)
    VALUES
        ('������������ �����'),
        ('��������� �����'),
        ('�������� �����'),
        ('��������� �����'),
        ('���������� �����'),
        ('���������� �����'),
        ('��������� �����'),
        ('�������� �����'),
        ('������� �����'),
        ('������������� �����'),
        ('�������� �����'),
        ('������ �����'),
        ('�������� �����'),
        ('��������� �����'),
        ('����������� �����'),
        ('�������� �����'),
        ('��������������� �����'),
        ('������� �����'),
        ('������� �����'),
        ('�������� �����'),
        ('�������� �����'),
        ('������� �����'),
        ('���������� �����'),
        ('���������� �����'),
        ('����������� �����'),
        ('����� �����'),
        ('��������� �����'),
        ('�������� �����'),
        ('���������� �����'),
        ('������ �����'),
        ('��������� �����'),
        ('�������� �����'),
        ('����� �����'),
        ('�������� �����'),
        ('��������� �����'),
        ('������ �����'),
        ('��������� �����'),
        ('��������� �����'),
        ('����������� �����'),
        ('������������ �����'),
        ('������������ �����'),
        ('������� �����'),
        ('������ �����'),
        ('��������� �����'),
        ('�������� �����'),
        ('������ �����'),
        ('������� �����'),
        ('��������� �����'),
        ('���������� �����'),
        ('������������ �����'),
        ('���������� �����'),
        ('��������� �����'),
        ('����� ������ �����'),
        ('��������������� �����'),
        ('���������� �����'),
        ('������ �����'),
        ('��������������� �����'),
        ('��������� �����'),
        ('��������� �����'),
        ('����������� �����'),
        ('���������� �����'),
        ('���������� �����'),
        ('����������� �����'),
        ('������������ �����'),
        ('����� �����'),
        ('�������� �����'),
        ('��������� �����'),
        ('���������� �����'),
        ('����������� �����'),
        ('�������� �����'),
        ('������ �����'),
        ('�������� �����'),
        ('�������� �����'),
        ('�������� �����'),
        ('��������� �����'),
        ('������������ �����'),
        ('�������� �����'),
        ('�������� �����'),
        ('����������� �����'),
        ('������� �����'),
        ('��������� �����'),
        ('����������� �����'),
        ('������ �����'),
        ('�������� �����'),
        ('��������� �����'),
        ('�������� �����'),
        ('��������� �����'),
        ('������� �����'),
        ('������� �����'),
        ('�������� �����'),
        ('������� �����'),
        ('������ �����'),
        ('���������� �����'),
        ('���������� �����'),
        ('������� �����'),
        ('������ �����'),
        ('����� �����'),
        ('�������� �����');
   
DECLARE @CityNames TABLE (Name NVARCHAR(50))
    INSERT INTO @CityNames (Name)
    VALUES 
		('������'),
		('�����-���������'),
		('���-����'),
		('������'),
		('�����'),
		('�����'),
		('�����'),
		('������'),
		('���'),
		('���������'),
		('������'),
		('���-��������'),
		('������'),
		('������'),
		('��������'),
		('���-��-�������'),
		('����'),
		('������');

DECLARE @House INT
DECLARE @Apartment INT
DECLARE @RandomStreet NVARCHAR(50)
DECLARE @RandomCity NVARCHAR(50)
 
WHILE (SELECT COUNT(*) FROM dbo.Clients) < 100
    BEGIN
		SET @PassportNumber = 
	      CHAR(65 + RAND()*(26-0))
		+ CHAR(65 + RAND()*(26-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0));

		SET @RandomIdentification =
			  CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(65 + RAND()*(26-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(65 + RAND()*(26-0))
			+ CHAR(65 + RAND()*(26-0))
			+ CHAR(48 + RAND()*(10-0))
        SELECT TOP 1 @AgentName = Name FROM @AgentNames ORDER BY NEWID()
		SELECT TOP 1 @AgentSurname = Name FROM @AgentSurnames ORDER BY NEWID()
		SELECT TOP 1 @AgentMiddleName = Name FROM @AgentMiddleNames ORDER BY NEWID()
		SET @MobilePhone = '+375' 
		    + CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0))
		SELECT TOP 1 @RandomStreet = Name FROM @StreetNames ORDER BY NEWID()
        SELECT TOP 1 @RandomCity = Name FROM @CityNames ORDER BY NEWID()
		SET @House = CAST(RAND() * 100 AS INT) + 1
        SET @Apartment = CAST(RAND() * 20 AS INT) + 1
        INSERT INTO dbo.Clients(Name, Surname, MiddleName, Birthdate, MobilePhone, City, Street, House, Apartment, PassportNumber, PassportIssueDate, PassportIdentification)
        VALUES (@AgentName, @AgentSurname, @AgentMiddleName, DATEADD(DAY, -CAST(CHECKSUM(NEWID()) % 3650 AS INT), GETDATE()), @MobilePhone, @RandomCity, @RandomStreet, @House, @Apartment, @PassportNumber, DATEADD(DAY, -CAST(CHECKSUM(NEWID()) % 3650 AS INT), GETDATE()), @RandomIdentification)
    END

-- fill InsuranceCases
WHILE (SELECT COUNT(*) FROM dbo.InsuranceCases) < 100
    BEGIN
        INSERT INTO dbo.InsuranceCases(Client, InsuranceAgent, Date, SupportingDocument, InsurancePayment)
        VALUES (RAND()*(100)+1, RAND()*(100)+1, DATEADD(DAY, -CAST(CHECKSUM(NEWID()) % 3650 AS INT), GETDATE()), RAND() * (100)+1, RAND() * 100)
    END

-- fill Policies
DECLARE @PolicyNumber NVARCHAR(16)
WHILE (SELECT COUNT(*) FROM dbo.Policies) < 100
    BEGIN
		SET @PolicyNumber = CHAR(48 + RAND()*(10-0)) + CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0)) + CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0)) + CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0)) + CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0)) + CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0)) + CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0)) + CHAR(48 + RAND()*(10-0))
			+ CHAR(48 + RAND()*(10-0)) + CHAR(48 + RAND()*(10-0))

        INSERT INTO dbo.Policies(InsuranceAgent, ApplicationDate, PolicyNumber, InsuranceType, Client, PolicyTerm, PolicyPayment)
        VALUES (RAND()*(100)+1, DATEADD(DAY, -CAST(CHECKSUM(NEWID()) % 3650 AS INT), GETDATE()), @PolicyNumber, RAND()*(100)+1, RAND()*(100)+1, RAND() * 30, RAND() * 100)
    END

-- fill PolicyInsuranceCases
WHILE (SELECT COUNT(*) FROM dbo.PolicyInsuranceCases) < 100
    BEGIN
        INSERT INTO dbo.PolicyInsuranceCases(PolicyId, InsuranceCaseId)
        VALUES (RAND()*(100)+1, RAND()*(100)+1)
    END

-- CREATE VIEWS
-- Policy view
GO
CREATE VIEW PolicyView
AS
SELECT
    ia.Name as AgentName,
	ia.Surname as AgentSurname,
	ia.MiddleName as AgentMiddleName,
	a.Type,
	ia.Salary,
	co.Responsibilities,
	co.StartDeadline,
	co.EndDeadline,
	ia.TransactionPercent,
	p.ApplicationDate,
	p.PolicyNumber,
	it.Name as InsuranceTypeName,
	c.Name as ClientName,
	c.Surname as ClientSurname,
	c.MiddleName ClintMiddleName,
	c.Birthdate,
	c.MobilePhone,
	c.City,
	c.Street,
	c.House,
	c.Apartment,
	c.PassportNumber,
	c.PassportIssueDate,
	c.PassportIdentification,
	p.PolicyTerm,
	p.PolicyPayment
FROM
    Policies p,
	InsuranceAgents ia,
	InsuranceTypes it,
	Clients c,
	AgentTypes a,
	Contracts co

-- Clients view
GO
CREATE VIEW ClientsView
AS
SELECT
    c.Name,
	c.Surname,
	c.MiddleName,
	c.Birthdate,
	c.MobilePhone,
	c.City,
	c.Street,
	c.House,
	c.Apartment,
	c.PassportNumber,
	c.PassportIssueDate,
	c.PassportIdentification
FROM
    Clients c

-- InsuranceAgents view
GO
CREATE VIEW InsuranceAgentsView
AS
SELECT
    ia.Name,
	ia.Surname,
	ia.MiddleName,
	ag.Type,
	ia.Salary,
	c.Responsibilities,
	c.StartDeadline,
	c.EndDeadline,
	ia.TransactionPercent
FROM
	InsuranceAgents ia,
	AgentTypes ag,
	Contracts c

-- CREATE PROCEDURES
-- Insert Clients
GO
CREATE PROCEDURE InsertClients
	@Name nvarchar(20),
	@Surname nvarchar(20),
	@MiddleName nvarchar(20),
	@Birthdate date,
	@MobilePhone nvarchar(20),
	@City nvarchar(50),
	@Street nvarchar(50),
	@House nvarchar(50),
	@Apartment nvarchar(50),
	@PassportNumber nchar(9),
	@PassportIssueDate date,
	@PassportIdentification nchar(14)
AS
BEGIN
    INSERT INTO Clients(Name, Surname, MiddleName, Birthdate, MobilePhone, City, Street, House, Apartment, PassportNumber, PassportIssueDate, PassportIdentification)
    VALUES (@Name, @Surname, @MiddleName, @Birthdate, @MobilePhone, @City, @Street, @House, @Apartment, @PassportNumber, @PassportIssueDate, @PassportIdentification);
END;

-- Insert InsuranceCases
GO
CREATE PROCEDURE InsertInsuranceCases
    @Client INT, 
	@InsuranceAgent INT, 
	@Date DATE,  
	@SupportingDocument INT, 
	@InsurancePayment MONEY
AS
BEGIN
    INSERT INTO InsuranceCases(Client, InsuranceAgent, Date, SupportingDocument, InsurancePayment)
    VALUES (@Client, @InsuranceAgent, @Date, @SupportingDocument, @InsurancePayment);
END;

-- Insert InsuranceAgents
GO
CREATE PROCEDURE InsertInsuranceAgents
    @Name nvarchar(20),
	@Surname nvarchar(20),
	@MiddleName nvarchar(20),
	@AgentType int,
	@Salary money,
	@Contract int,
	@TransactionPercent float
AS
BEGIN
    INSERT INTO InsuranceAgents(Name, Surname, MiddleName, AgentType, Salary, Contract, TransactionPercent)
    VALUES (@Name, @Surname, @MiddleName, @AgentType, @Salary, @Contract, @TransactionPercent);
END;