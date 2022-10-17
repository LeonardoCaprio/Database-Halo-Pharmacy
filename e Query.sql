USE HaLLoPharmacy5BE01
GO

--1 
SELECT
	[Customer ID] = mc.CustomerID,
	[Customer Name] = CustomerName,
	[Transaction Date] = CONVERT(VARCHAR, TransactionDate, 107),
	[Medicine Bought] = SUM(Quantity)
FROM MsCustomer mc
	JOIN TrSalesHeader tsh ON mc.CustomerID = tsh.CustomerID
	JOIN TrSalesDetail tsd ON tsd.SalesID = tsh.SalesID
WHERE DAY(TransactionDate) BETWEEN 20 and 30
	AND CustomerGender = 'Female'
GROUP BY mc.CustomerID, CustomerName, TransactionDate

-- 2
SELECT
	[Employee Number] = RIGHT(me.EmployeeID, 3),
	[Employee Name] = EmployeeName,
	[Customer Served] = CAST(COUNT(SalesID) AS VARCHAR) + ' customer(s)'
FROM MsEmployee me
	JOIN TrSalesHeader tsh ON me.EmployeeID = tsh.EmployeeID
WHERE EmployeeName LIKE '%b%'
	AND EmployeeGender = 'Female'
GROUP BY me.EmployeeID, EmployeeName

-- 3
SELECT
	[Customer ID] = mc.CustomerID,
	[Customer Name] = CustomerName,
	[Date of Birth] = CONVERT(VARCHAR, CustomerDOB, 106),
	[Transaction Count] = COUNT(tsh.SalesID),
	[Total Purchase] = SUM(Quantity * MedicinePrice)
FROM MsCustomer mc
	JOIN TrSalesHeader tsh ON mc.CustomerID = tsh.CustomerID
	JOIN TrSalesDetail tsd ON tsd.SalesID = tsh.SalesID
	JOIN MsMedicine mm ON mm.MedicineID = tsd.MedicineID
WHERE MONTH(TransactionDate) BETWEEN 1 AND 6
	AND EmployeeID IN ('EM004', 'EM006', 'EM008')
GROUP BY mc.CustomerID, CustomerName, CustomerDOB

-- 4
SELECT
	[Employee ID] = me.EmployeeID,
	[Employee Name] = EmployeeName,
	[Local Phone Number] = STUFF(EmployeePhone, 1, 2, '62'),
	[Transaction Done] = COUNT(SalesID) + COUNT(tph.PurchaseID), --Transaksi yang terhitung adalah transaksi membeli dari vendor dan menjual ke customer
	[Total Medicine Bought] = CAST(SUM(Quantity) AS VARCHAR) + ' item(s)'
FROM MsEmployee me
	JOIN TrSalesHeader tsh ON tsh.EmployeeID = me.EmployeeID
	JOIN TrPurchaseHeader tph ON tph.EmployeeID = me.EmployeeID
	JOIN TrPurchaseDetail tpd ON tpd.PurchaseID = tph.PurchaseID
	JOIN MsVendor mv ON mv.VendorID = tph.VendorID
WHERE DAY(tph.TransactionDate) BETWEEN 10 AND 20
	AND EstablishedYear > 2000	
GROUP BY me.EmployeeID, EmployeeName, EmployeePhone

-- 5
SELECT
	[Medicine ID] = RIGHT(MedicineID, 3),
	[Medicine Name] = UPPER(MedicineName),
	[Category Name] = CategoryName,
	[Price] = 'Rp. ' + CAST(MedicinePrice AS VARCHAR),
	[Medicine Stock] = MedicineStock
FROM MsMedicine mm
	JOIN MsMedicineCategory mdc ON mm.CategoryID = mdc.CategoryID,
	(
		SELECT
			[Average Quantity] = AVG(a.QtySum)
		FROM
		(
			SELECT
				[QtySum] = SUM(Quantity)
			FROM TrSalesDetail
			GROUP BY SalesID
		) a
	) b
WHERE MedicinePrice > 50000
	AND MedicineStock < b.[Average Quantity]

-- 6
SELECT
	[Employee Code] = STUFF(me.EmployeeID, 1, 2, 'EMPLOYEE'),
	[Employee Name] = EmployeeName,
	[TransactionDate] = CONVERT(VARCHAR, TransactionDate, 101),
	[Medicine Name] = MedicineName,
	[Medicine Price] = MedicinePrice,
	Quantity
FROM MsEmployee me
	JOIN TrSalesHeader tsh ON tsh.EmployeeID = me.EmployeeID
	JOIN TrSalesDetail tsd ON tsd.SalesID = tsh.SalesID
	JOIN MsMedicine mm ON mm.MedicineID = tsd.MedicineID,
	(
		SELECT
			[Average Salary] = AVG(a.SalarySum)
		FROM
		(
			SELECT
				[SalarySum] = SUM(EmployeeSalary)
			FROM MsEmployee
			GROUP BY EmployeeID
		) a
	) b
WHERE DAY(TransactionDate) = 2
	AND EmployeeSalary < b.[Average Salary]

-- 7
SELECT
	[Customer ID] = mc.CustomerID,
	[Customer Name] = CustomerName,
	[Local Customer Phone] = STUFF(CustomerPhone, 1, 2, '62'),
	[Date of Birth] = CONVERT(VARCHAR, CustomerDOB, 107),
	[Medicine Bought] = CAST(SUM(Quantity) AS VARCHAR) + ' item(s)'
FROM MsCustomer mc
	JOIN TrSalesHeader tsh ON tsh.CustomerID = mc.CustomerID
	JOIN TrSalesDetail tsd ON tsd.SalesID = tsh.SalesID,
	(
		SELECT
			[Average Quantity] = AVG(a.QtySum)
		FROM
		(
			SELECT
				[QtySum] = SUM(Quantity)
			FROM TrSalesDetail
			GROUP BY SalesID
		) a
	) b,
	(
		SELECT SalesID, [QtySum] = SUM(Quantity)
		FROM TrSalesDetail
		GROUP BY SalesID
	) c
WHERE CustomerGender != 'Male'
	AND c.QtySum > b.[Average Quantity]
	AND c.SalesID = tsh.SalesID
GROUP BY mc.CustomerID, CustomerName, CustomerPhone, CustomerDOB

-- 8 
SELECT
	[Employee ID] = me.EmployeeID,
	[Employee Name] =  LEFT(EmployeeName, CHARINDEX(' ', EmployeeName) - 1) ,
	[Salary] = 'Rp. ' + CAST(CONVERT(MONEY, EmployeeSalary) AS VARCHAR),
	[Data of Birth] = CONVERT(VARCHAR, EmployeeDOB, 107),
	[Transaction Served] = c.TransactionCount
FROM MsEmployee me
	JOIN TrSalesHeader tsh ON tsh.EmployeeID = me.EmployeeID
	JOIN TrSalesDetail tsd ON tsd.SalesID = tsh.SalesID,
	(
		SELECT
			[Average Transaction] = AVG(a.TransactionCount)
		FROM
		(
			SELECT
				[TransactionCount] = COUNT(SalesID)
			FROM TrSalesHeader
			GROUP BY EmployeeID
		) a
	) b,
	(
		SELECT
			EmployeeID, [TransactionCount] = COUNT(SalesID)
		FROM TrSalesHeader
		GROUP BY EmployeeID
	) c
WHERE EmployeeName LIKE '% %'
	AND c.TransactionCount > b.[Average Transaction]
	AND c.EmployeeID = tsh.EmployeeID
GROUP BY me.EmployeeID, EmployeeName, EmployeeSalary, EmployeeDOB, c.TransactionCount

-- 9
CREATE VIEW VendorMaximumAverageQuantityViewer
AS
SELECT
	[Vendor ID] = mv.VendorID,
	[Vendor Name] = VendorName,
	[Average Supplied Quantity] = CAST(AVG(tpd.Quantity) AS VARCHAR) + ' item(s)',
	[Maximum Supplied Quantity] = CAST(MAX(tpd.Quantity) AS VARCHAR) + ' item(s)'
FROM MsVendor mv
	JOIN TrPurchaseHeader tph ON tph.VendorID = mv.VendorID
	JOIN TrPurchaseDetail tpd ON tpd.PurchaseID = tph.PurchaseID
WHERE LEFT(VendorName, CHARINDEX(' ', VendorName) - 1) LIKE '%a%' --Kata 'Corporation' diabaikan
GROUP BY mv.VendorID, VendorName
HAVING MAX(tpd.Quantity) > 5

-- 10
CREATE VIEW VendorSupplyViewer
AS
SELECT
	[Vendor Number] = RIGHT(mv.VendorID, 3),
	[Vendor Name] = VendorName,
	[Vendor Address] = VendorAddress,
	[Total Supplied Value] = 'Rp. ' + CAST(CONVERT(MONEY, SUM(MedicinePrice*Quantity)) AS VARCHAR),
	[Medicine Type Supplied] = CAST(COUNT(mm.MedicineID) AS VARCHAR) + ' medicine(s)'
FROM MsVendor mv
	JOIN TrPurchaseHeader tph ON tph.VendorID = mv.VendorID
	JOIN TrPurchaseDetail tpd ON tpd.PurchaseID = tph.PurchaseID
	JOIN MsMedicine mm ON mm.MedicineID = tpd.MedicineID
GROUP BY mv.VendorID, VendorName, VendorAddress
HAVING SUM(MedicinePrice*Quantity) > 150000
	AND COUNT(mm.MedicineID) > 2