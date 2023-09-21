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

-- create PassportData
CREATE TABLE dbo.PassportData(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Number] [nchar](9) NOT NULL,
	[IssueDate] [date] NOT NULL,
	[Identification] [nchar](14) NOT NULL,)
ALTER TABLE [dbo].[PassportData]  WITH CHECK ADD  CONSTRAINT [CK__PassportD__Ident__628FA481] CHECK  (([Identification] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Za-z][0-9][0-9][0-9][A-Za-z][A-Za-z][0-9]'))
ALTER TABLE [dbo].[PassportData] CHECK CONSTRAINT [CK__PassportD__Ident__628FA481]
ALTER TABLE [dbo].[PassportData]  WITH CHECK ADD  CONSTRAINT [CK__PassportD__Numbe__619B8048] CHECK  (([Number] like '[A-Za-z][A-Za-z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
ALTER TABLE [dbo].[PassportData] CHECK CONSTRAINT [CK__PassportD__Numbe__619B8048]

-- create Contracts
CREATE TABLE dbo.Contracts(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Responsibilities] [nvarchar](100) NOT NULL,
	[StartDeadline] [date] NOT NULL,
	[EndDeadline] [date] NOT NULL,)

-- create Addresses
CREATE TABLE dbo.Addresses(
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[City] [nvarchar](50) NOT NULL,
	[Street] [nvarchar](50) NOT NULL,
	[House] [nvarchar](50) NOT NULL,
	[Apartment] [nvarchar](50) NOT NULL,)

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
	[Address] [int] NOT NULL,
	[PassportData] [int] NOT NULL,)
ALTER TABLE [dbo].[Clients]  WITH CHECK ADD  CONSTRAINT [FK_Clients_Addresses] FOREIGN KEY([Address])
REFERENCES [dbo].[Addresses] ([Id])
ALTER TABLE [dbo].[Clients] CHECK CONSTRAINT [FK_Clients_Addresses]
ALTER TABLE [dbo].[Clients]  WITH CHECK ADD  CONSTRAINT [FK_Clients_PassportData] FOREIGN KEY([PassportData])
REFERENCES [dbo].[PassportData] ([Id])
ALTER TABLE [dbo].[Clients] CHECK CONSTRAINT [FK_Clients_PassportData]

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
VALUES ('Штатный работник'), ('Совместитель')

-- fill PassportData
GO
DECLARE @Counter INT = 1;
WHILE @Counter <= 100
BEGIN
    DECLARE @PassportNumber VARCHAR(9) = 
	      CHAR(65 + RAND()*(26-0))
		+ CHAR(65 + RAND()*(26-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0))
		+ CHAR(48 + RAND()*(10-0));

    DECLARE @RandomIdentification VARCHAR(14) =
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

    INSERT INTO PassportData (Number, IssueDate, Identification)
    VALUES (
        @PassportNumber,
        DATEADD(DAY, -CAST(CHECKSUM(NEWID()) % 3650 AS INT), GETDATE()),
        @RandomIdentification
    );

    SET @Counter = @Counter + 1;
END;

-- fill Addresses
GO
DECLARE @StreetNames TABLE (Name NVARCHAR(50))
    INSERT INTO @StreetNames (Name)
    VALUES
        ('Пролетарская улица'),
        ('Ленинская улица'),
        ('Гагарина улица'),
        ('Советская улица'),
        ('Пушкинская улица'),
        ('Московская улица'),
        ('Кировская улица'),
        ('Парковая улица'),
        ('Садовая улица'),
        ('Комсомольская улица'),
        ('Школьная улица'),
        ('Жукова улица'),
        ('Мичурина улица'),
        ('Свердлова улица'),
        ('Октябрьская улица'),
        ('Горького улица'),
        ('Красноармейская улица'),
        ('Рабочая улица'),
        ('Зеленая улица'),
        ('Трудовая улица'),
        ('Полярная улица'),
        ('Красная улица'),
        ('Строителей улица'),
        ('Молодежная улица'),
        ('Центральная улица'),
        ('Новая улица'),
        ('Солнечная улица'),
        ('Заречная улица'),
        ('Пионерская улица'),
        ('Речная улица'),
        ('Восточная улица'),
        ('Западная улица'),
        ('Южная улица'),
        ('Северная улица'),
        ('Цветочная улица'),
        ('Лесная улица'),
        ('Юбилейная улица'),
        ('Гранитная улица'),
        ('Маяковского улица'),
        ('Первомайская улица'),
        ('Коммунальная улица'),
        ('Чкалова улица'),
        ('Горная улица'),
        ('Сиреневая улица'),
        ('Сосновая улица'),
        ('Дружбы улица'),
        ('Озерная улица'),
        ('Заводская улица'),
        ('Вокзальная улица'),
        ('Партизанская улица'),
        ('Островская улица'),
        ('Городская улица'),
        ('Карла Маркса улица'),
        ('Железнодорожная улица'),
        ('Набережная улица'),
        ('Мирная улица'),
        ('Севастопольская улица'),
        ('Колхозная улица'),
        ('Совхозная улица'),
        ('Театральная улица'),
        ('Лермонтова улица'),
        ('Пушкинская улица'),
        ('Мичуринская улица'),
        ('Свердловская улица'),
        ('Щорса улица'),
        ('Смирнова улица'),
        ('Гусарская улица'),
        ('Петровская улица'),
        ('Космонавтов улица'),
        ('Суворова улица'),
        ('Фрунзе улица'),
        ('Толстого улица'),
        ('Горького улица'),
        ('Шевченко улица'),
        ('Греческая улица'),
        ('Воронцовская улица'),
        ('Скверная улица'),
        ('Сельская улица'),
        ('Холодильная улица'),
        ('Степная улица'),
        ('Заводская улица'),
        ('Космическая улица'),
        ('Речная улица'),
        ('Парковая улица'),
        ('Береговая улица'),
        ('Школьная улица'),
        ('Соседская улица'),
        ('Луговая улица'),
        ('Озерная улица'),
        ('Красивая улица'),
        ('Полевая улица'),
        ('Дачная улица'),
        ('Живописная улица'),
        ('Просторная улица'),
        ('Зеленая улица'),
        ('Чистая улица'),
        ('Тихая улица'),
        ('Песчаная улица');
   
DECLARE @CityNames TABLE (Name NVARCHAR(50))
    INSERT INTO @CityNames (Name)
    VALUES 
		('Москва'),
		('Санкт-Петербург'),
		('Нью-Йорк'),
		('Лондон'),
		('Париж'),
		('Токио'),
		('Пекин'),
		('Берлин'),
		('Рим'),
		('Амстердам'),
		('Мадрид'),
		('Лос-Анджелес'),
		('Сидней'),
		('Дублин'),
		('Сингапур'),
		('Рио-де-Жанейро'),
		('Каир'),
		('Мумбаи');

    DECLARE @House INT
    DECLARE @Apartment INT
    DECLARE @RandomStreet NVARCHAR(50)
	DECLARE @RandomCity NVARCHAR(50)
	
    WHILE (SELECT COUNT(*) FROM dbo.Addresses) < 100
    BEGIN
        SELECT TOP 1 @RandomStreet = Name FROM @StreetNames ORDER BY NEWID()
        SELECT TOP 1 @RandomCity = Name FROM @CityNames ORDER BY NEWID()
		SET @House = CAST(RAND() * 100 AS INT) + 1
        SET @Apartment = CAST(RAND() * 20 AS INT) + 1

        INSERT INTO dbo.Addresses(City, Street, House, Apartment)
        VALUES (@RandomCity, @RandomStreet, @House, @Apartment)
    END

-- fill Contracts
GO
DECLARE @Responsibilities TABLE (Name NVARCHAR(100))
    INSERT INTO @Responsibilities (Name)
    VALUES 
		('Страховой агент'),
		('Актюарий'),
		('Агент по обслуживанию клиентов'),
		('Менеджер по продажам'),
		('Администратор страховых полисов'),
		('Эксперт по риску'),
		('Управляющий отделом страхования'),
		('Аналитик по страхованию'),
		('Администратор базы данных страхования');
	
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
		('Свидетельство о происшествии'),
		('Полицейский протокол'),
		('Медицинская справка'),
		('Диагностический отчет'),
		('Договор страхования'),
		('Фотографии ущерба'),
		('Подтверждающее письмо клиента'),
		('Справка с места работодателя'),
		('Свидетельство о смерти'),
		('Свидетельство о рождении');
	
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
		('Автомобильное страхование'),
		('Страхование жизни'),
		('Медицинское страхование'),
		('Страхование недвижимости'),
		('Страхование от несчастных случаев'),
		('Страхование ответственности'),
		('Страхование имущества'),
		('Страхование путешествий'),
		('Страхование бизнеса'),
		('Страхование грузов');

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
		('Иван'),
		('Анна'),
		('Петр'),
		('Екатерина'),
		('Александр'),
		('София'),
		('Михаил'),
		('Елена'),
		('Дмитрий'),
		('Мария');

DECLARE @AgentSurnames TABLE (Name NVARCHAR(20))
    INSERT INTO @AgentSurnames (Name)
    VALUES 
		('Иванов'),
		('Петров'),
		('Сидоров'),
		('Смирнов'),
		('Козлов'),
		('Михайлов'),
		('Александров'),
		('Егоров'),
		('Васильев'),
		('Кузнецов');

DECLARE @AgentMiddleNames TABLE (Name NVARCHAR(20))
    INSERT INTO @AgentMiddleNames (Name)
    VALUES 
		('Иванович'),
		('Петрович'),
		('Сидорович'),
		('Михайлович'),
		('Александрович'),
		('Дмитриевич'),
		('Сергеевич'),
		('Андреевич'),
		('Николаевич'),
		('Геннадьевич');

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
WHILE (SELECT COUNT(*) FROM dbo.Clients) < 100
    BEGIN
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
        INSERT INTO dbo.Clients(Name, Surname, MiddleName, Birthdate, MobilePhone, Address, PassportData)
        VALUES (@AgentName, @AgentSurname, @AgentMiddleName, DATEADD(DAY, -CAST(CHECKSUM(NEWID()) % 3650 AS INT), GETDATE()), @MobilePhone, RAND()*(100)+1, RAND()*(100)+1)
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
	ad.City,
	ad.Street,
	ad.House,
	ad.Apartment,
	pd.Number,
	pd.IssueDate,
	pd.Identification,
	p.PolicyTerm,
	p.PolicyPayment
FROM
    Policies p,
	InsuranceAgents ia,
	InsuranceTypes it,
	Clients c,
	AgentTypes a,
	Contracts co,
	Addresses ad,
	PassportData pd

-- CREATE PROCEDURES
-- Insert Addresses
GO
CREATE PROCEDURE InsertAddress
    @City NVARCHAR(50),
    @Street NVARCHAR(50),
    @House NVARCHAR(50),
    @Apartment NVARCHAR(50)
AS
BEGIN
    INSERT INTO Addresses (City, Street, House, Apartment)
    VALUES (@City, @Street, @House, @Apartment);
END;

-- Insert PassportData
GO
CREATE PROCEDURE InsertPassportData
    @Number NVARCHAR(9),
    @IssueDate DATE,
    @Identification NVARCHAR(14)
AS
BEGIN
    INSERT INTO PassportData(Number, IssueDate, Identification)
    VALUES (@Number, @IssueDate, @Identification);
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