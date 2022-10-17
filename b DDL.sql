CREATE DATABASE HalloPharmacy5BE01 
GO

/*
Anggota Kelompok 5 BE01
- 2440014420 || Daniel
- 2440015410 || Samuel Evan Saputra
- 2440015322 || Leonardo Caprio
- 2440013020 || Nathalie Wijaya
*/

USE HalloPharmacy5BE01 
GO

CREATE TABLE MsCustomer (
	CustomerID CHAR(5) PRIMARY KEY CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]') NOT NULL,
	CustomerName VARCHAR(255) NOT NULL,
	CustomerPhone VARCHAR(15) NOT NULL,
	CustomerAddress VARCHAR(255) NOT NULL,
	CustomerEmail VARCHAR(255) CHECK(CustomerEmail LIKE '%@hallo.com') NOT NULL,
	CustomerPassword VARCHAR(255) NOT NULL,
	CustomerDOB DATE NOT NULL,
	CustomerGender VARCHAR(6) CHECK (CustomerGender LIKE 'Male' OR CustomerGender LIKE 'Female') NOT NULL
)
GO

CREATE TABLE MsEmployee (
	EmployeeID CHAR(5) PRIMARY KEY CHECK (EmployeeID LIKE 'EM[0-9][0-9][0-9]') NOT NULL,
	EmployeeName VARCHAR(255) NOT NULL,
	EmployeePhone VARCHAR(15) NOT NULL,
	EmployeeAddress VARCHAR(255) NOT NULL,
	EmployeeEmail VARCHAR(255) CHECK(EmployeeEmail LIKE '%@hallo.com') NOT NULL,
	EmployeeDOB DATE NOT NULL,
	EmployeeGender VARCHAR(6) CHECK (EmployeeGender LIKE 'Male' OR EmployeeGender LIKE 'Female') NOT NULL,
	EmployeeSalary FLOAT NOT NULL 
)
GO

CREATE TABLE MsVendor (
	VendorID CHAR(5) PRIMARY KEY CHECK(VendorID LIKE 'VN[0-9][0-9][0-9]') NOT NULL,
	VendorName VARCHAR(255) CHECK(LEN(VendorName) > 3) NOT NULL,
	VendorPhone VARCHAR(15) NOT NULL,
	VendorAddress VARCHAR(255) NOT NULL,
	VendorEmail VARCHAR(255) CHECK(VendorEmail LIKE '%.com')NOT NULL,
	EstablishedYear INT NOT NULL,
)
GO

CREATE TABLE MsMedicineCategory (
	CategoryID CHAR(5) PRIMARY KEY CHECK (CategoryID LIKE 'CT[0-9][0-9][0-9]') NOT NULL,
	CategoryName VARCHAR(255) CHECK (CategoryName NOT IN ('Amidopyrine', 'Phenacetin', 'Methaqualone')) NOT NULL
)
GO

CREATE TABLE MsMedicine (
	MedicineID CHAR(5) PRIMARY KEY CHECK (MedicineID LIKE 'MD[0-9][0-9][0-9]') NOT NULL,
	MedicineName VARCHAR(255) NOT NULL,
	MedicinePrice FLOAT CHECK(MedicinePrice BETWEEN 5000 AND 100000) NOT NULL,
	MedicineDescription VARCHAR(255) NOT NULL,
	MedicineStock INT NOT NULL,
	CategoryID CHAR(5) FOREIGN KEY REFERENCES MsMedicineCategory(CategoryID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL
)
GO

CREATE TABLE TrSalesHeader (
	SalesID CHAR(5) PRIMARY KEY CHECK (SalesID LIKE 'SL[0-9][0-9][0-9]') NOT NULL,
	EmployeeID CHAR(5) FOREIGN KEY REFERENCES MsEmployee(EmployeeID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	CustomerID CHAR(5) FOREIGN KEY REFERENCES MsCustomer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TransactionDate DATE NOT NULL
)
GO

CREATE TABLE TrSalesDetail (
	SalesID CHAR(5) FOREIGN KEY REFERENCES TrSalesHeader(SalesID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	MedicineID CHAR(5) FOREIGN KEY REFERENCES MsMedicine(MedicineID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY(SalesID, MedicineID)
)
GO

CREATE TABLE TrPurchaseHeader (
	PurchaseID CHAR(5) PRIMARY KEY CHECK (PurchaseID LIKE 'PC[0-9][0-9][0-9]') NOT NULL,
	EmployeeID CHAR(5) FOREIGN KEY REFERENCES MsEmployee(EmployeeID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	VendorID CHAR(5) FOREIGN KEY REFERENCES MsVendor(VendorID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TransactionDate DATE NOT NULL,
)
GO

CREATE TABLE TrPurchaseDetail (
	PurchaseID CHAR(5) FOREIGN KEY REFERENCES TrPurchaseHeader(PurchaseID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	MedicineID CHAR(5) FOREIGN KEY REFERENCES MsMedicine(MedicineID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY(PurchaseID, MedicineID)
)
GO
