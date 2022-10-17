USE HaLLoPharmacy5BE01
GO

-- Sales
INSERT TrSalesHeader VALUES
('SL016','EM003','CU007','2021-07-02')

INSERT TrSalesDetail VALUES
('SL016','MD006',5),
('SL016','MD012',15)

UPDATE MsMedicine
SET MedicineStock -= 5
WHERE MedicineID = 'MD006'

UPDATE MsMedicine
SET MedicineStock -= 15
WHERE MedicineID = 'MD012'


-- Purchase
INSERT TrPurchaseHeader VALUES
('PC016','EM006','VN005','2021-08-15')

INSERT TrPurchaseDetail VALUES
('PC016','MD004',10),
('PC016','MD008',25)

UPDATE MsMedicine
SET MedicineStock += 10
WHERE MedicineID = 'MD004'

UPDATE MsMedicine
SET MedicineStock -= 25
WHERE MedicineID = 'MD008'