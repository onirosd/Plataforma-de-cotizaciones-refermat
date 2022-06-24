CREATE TABLE Customer
( 
    codCustomer         INTEGER PRIMARY KEY,
	numRucCustomer      TEXT  NULL ,
	numRut              TEXT  NULL ,
	strName             TEXT  NULL ,
	strCelphone         text  NULL ,
	strMail             TEXT NULL ,
	strAddress          TEXT NULL ,
	codTiCustomer       INTEGER  NULL ,
	codCompany          INTEGER  NULL 
)

GO

CREATE TABLE Autentication
( 
	codUser             INTEGER  NOT NULL ,
	strNameUser         TEXT NULL ,
	strPassUser         TEXT  NULL ,
	dteCreateDate       DATETIME  NULL ,
	dteUpdateUser       TEXT  NULL ,
	strCreateUser       TEXT  NULL ,
	strUpdateDate       DATETIME  NULL ,
	flgState            INTEGER  NULL ,
	codCompany          INTEGER  NULL ,
	codPerson           TEXT  NOT NULL ,
	codList             TEXT  NULL 
)
GO

CREATE TABLE Company
( 
	codCompany            INTEGER  NOT NULL ,
	strDesCompany         TEXT NULL 
)
GO

CREATE TABLE Ti_Person
( 
	codPerson           INTEGER  NOT NULL,
	strDesPerson        TEXT  NULL,
	strPosition         TEXT  NULL,
	strCelphone         TEXT  NULL 
)
GO

CREATE TABLE Ti_List
( 
	codList          INTEGER  NOT NULL,
	strDescription   TEXT  NULL
)
GO


CREATE TABLE Sync_Log(
	codLog INTEGER PRIMARY KEY,
	dteSyncDate  DATETIME  NULL ,
	strDay       TEXT  NULL,
	strhour      TEXT  NULL,
	codUser      INTEGER
)


CREATE TABLE config_general(
    codconfigGeneral INTEGER,
	strCodOperation TEXT,
	strDescription TEXT,
	flgEnabled  INTEGER,
	pivot1 TEXT,
	pivot2 TEXT,
	pivote3 TEXT
	
)


CREATE TABLE Sync_Log(
	codLog INTEGER PRIMARY KEY,
	dteSyncDate  DATETIME  NULL ,
	strDay       TEXT  NULL,
	strhour      TEXT  NULL,
	codUser      INTEGER
)


CREATE TABLE Bank(
	codBank INTEGER,
	strDescription TEXT NULL
)


CREATE TABLE PayCondition(
	codPayCondition INTEGER,
	strDescription TEXT NULL
)


CREATE TABLE PaymentMethod(
	codPaymentMethod INTEGER,
	strDescription TEXT NULL
)


CREATE TABLE BillingType(
	codBillingType INTEGER,
	strDescription TEXT NULL
)


CREATE TABLE Currency(
	codCurrency INTEGER,
	strDescription TEXT NULL
)



CREATE TABLE Billing
( 
	codBilling          INTEGER NOT NULL,
	codUser             INTEGER NOT NULL,
	codCustomer         INTEGER NOT NULL,
	codBillingType      INTEGER NOT NULL,
	codPaymentMethod    INTEGER NOT NULL,
	strOperation        TEXT ,
	dteBillingDate      TEXT ,
	codBank             INTEGER NOT NULL,
	codCurrency         INTEGER NOT NULL,
	numAmountOperation  REAL ,
	strComments         TEXT ,
	flg_State           INTEGER,
	strCreateUser       TEXT,
	dteCreateDate       DATETIME DEFAULT CURRENT_TIMESTAMP ,
	codCompany          INTEGER NOT NULL,
    flgSync             INTEGER,
    flgCodRealSystem    INTEGER
)


