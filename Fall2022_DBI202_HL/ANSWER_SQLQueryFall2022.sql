--Q1
Create table Staffs (
 StaffID int Primary key,
 Name nvarchar(100),
)

Create table Logins (
 username nvarchar(50) Primary Key,
 Password nvarchar(255),
 Role nvarchar(100),
 StaffId int references Staffs(StaffID)
)
Create table Reports (
 ReportNumber int Primary key,
 Date Date,
 IssueReturn nvarchar(200),
 username nvarchar(50) references Logins(username)
)

--Q2
SELECT St.StockItemID, St.StockItemName, St.SupplierID, St.Color FROM StockItems St
WHERE St.Color = 'Blue'

--Q3
SELECT SupTran.SupplierTransactionID, SupTran.SupplierID, Sup.SupplierName, SupTran.TransactionDate , SupTran.TransactionAmount
FROM SupplierTransactions SupTran, Suppliers Sup
where SupTran.SupplierID = Sup.SupplierID and (SupTran.TransactionDate BETWEEN '2013-02-01' and '2013-02-15')

--Q4
SELECT StockItems.StockItemID, StockItems.StockItemName, StockItems.SupplierID,
Suppliers.SupplierName, StockItems.OuterPackageID, PackageTypes.PackageTypeName as OuterPackageTypeName,
StockItems.UnitPrice FROM StockItems 
INNER JOIN Suppliers ON Suppliers.SupplierID = StockItems.SupplierID
INNER JOIN PackageTypes on StockItems.OuterPackageID = PackageTypes.PackageTypeID
where StockItems.StockItemID >= 135
order by OuterPackageTypeName, StockItems.StockItemName

--Q5
select Suppliers.SupplierID, Suppliers.SupplierName, COUNT(PurchaseOrders.SupplierID) AS NumberOfPurchaseOrders from Suppliers
LEFT JOIN PurchaseOrders on PurchaseOrders.SupplierID = Suppliers.SupplierID
GROUP BY Suppliers.SupplierID, Suppliers.SupplierName
ORDER BY NumberOfPurchaseOrders desc, Suppliers.SupplierName asc


--Q6
SELECT StockItems.UnitPackageID, PackageTypes.PackageTypeName AS UnitPackageTypeName, count(StockItems.OuterPackageID) AS NumberOfStockItem FROM StockItems
inner join PackageTypes on PackageTypes.PackageTypeID = StockItems.OuterPackageID
Group by StockItems.UnitPackageID, PackageTypes.PackageTypeName
having count(StockItems.OuterPackageID) = (
 SELECT top(1) count(StockItems.OuterPackageID) AS NumberOfStockItem FROM StockItems
 inner join PackageTypes on PackageTypes.PackageTypeID = StockItems.OuterPackageID
 Group by StockItems.UnitPackageID, PackageTypes.PackageTypeName
 order by NumberOfStockItem asc
)

--Q7
SELECT * from PackageTypes
SELECT * from StockItems

--step: tb1 to get count of unit (packageID = UnitId)
With tb1 as (
 SELECT PackageTypes.PackageTypeID, PackageTypes.PackageTypeName as PackageTypeName, COUNT(StockItems.UnitPackageID) AS NumberOfStockItems_UnitPackage FROM PackageTypes
left join StockItems on PackageTypes.PackageTypeID = StockItems.UnitPackageID
where PackageTypes.PackageTypeName in ('Each', 'Carton', 'Packet', 'Pair', 'Bag', 'Box')
Group by PackageTypes.PackageTypeID, PackageTypes.PackageTypeName
),
--step: tb2 to get count of outer (packageID = OuterId)
tb2 as ( SELECT PackageTypes.PackageTypeID, COUNT(StockItems.OuterPackageID) AS NumberOfStockItems_OuterPackage FROM PackageTypes
left join StockItems on PackageTypes.PackageTypeID = StockItems.OuterPackageID
where PackageTypes.PackageTypeName in ('Each', 'Carton', 'Packet', 'Pair', 'Bag', 'Box')
Group by PackageTypes.PackageTypeID)
--step3: join 2 tb to get value
select tb1.PackageTypeID, tb1.NumberOfStockItems_UnitPackage, tb2.NumberOfStockItems_OuterPackage from tb1
INNER JOIN tb2 on tb1.PackageTypeID = tb2.PackageTypeID
ORDER BY tb2.NumberOfStockItems_OuterPackage DESC, tb1.PackageTypeName


--Q8
Create Procedure Proc4 @stockItemId int, @OrderYear int, @numberOfPurchaseOrders int OUTPUT
AS
BEGIN
SELECT @numberOfPurchaseOrders =  COUNT(PurchaseOrders.PurchaseOrderID) FROM PurchaseOrders
Inner join PurchaseOrderLines on PurchaseOrderLines.PurchaseOrderID = PurchaseOrders.PurchaseOrderID
WHERE PurchaseOrderLines.StockItemID = @stockItemId AND year(PurchaseOrders.OrderDate) = @OrderYear 
END

declare @x int
exec Proc4 95, 2013,@x output
select @x as NumberOfPurchaseOrders
select * from PackageTypes
--Q9
CREATE Trigger Tr4 ON StockItems instead of insert
AS
BEGIN
SELECT i.StockItemId, i.StockItemName, i.OuterPackageID, PackageTypes.PackageTypeName AS OuterPackageTypeName, i.UnitPrice, i.TaxRate FROM inserted i 
inner join PackageTypes on PackageTypes.PackageTypeID = i.OuterPackageID
end

INSERT into StockItems (StockItemID, StockItemName, UnitPackageID, OuterPackageID, QuantityPerOuter, IsChillerStock, TaxRate, UnitPrice, TypicalWeightPerUnit, Color)
VALUES (309, N'T-shirt Mickey', 10, 9, 1, 0, 0.15, 12.0, 0.45, 1);

INSERT into StockItems (StockItemID, StockItemName, UnitPackageID, OuterPackageID, QuantityPerOuter, IsChillerStock, TaxRate, UnitPrice, TypicalWeightPerUnit, Color)
VALUES (308, N'T-shirt Red bull', 7, 6, 1, 0, 0.15, 10.5, 0.4, 4);

--Q10
Delete FROM PackageTypes
where PackageTypes.PackageTypeID NOT IN (
 SELECT StockItems.UnitPackageID FROM StockItems
 union 
 SELECT StockItems.OuterPackageID FROM StockItems
)


