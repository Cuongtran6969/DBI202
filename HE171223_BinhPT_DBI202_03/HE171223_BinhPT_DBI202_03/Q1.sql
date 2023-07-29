CREATE TABLE Products
(ProductNo nvarchar(50) PRIMARY KEY ,
Name nvarchar(50),
Description nvarchar(255),
Category nvarchar(50)
)
CREATE TABLE Colors
(ColorCode nvarchar(20) PRIMARY KEY,
Name nvarchar(100),
)
CREATE TABLE Sizes
(SizeCode varchar(15) PRIMARY KEY ,
Description nvarchar(200)
)
CREATE TABLE ProductAttributes
(
ProductNo nvarchar(50),
ColorCode nvarchar(20),
SizeCode varchar(15),
quantity int,
Price decimal(10,2),
 Foreign Key(ProductNo) references Products(ProductNo),
Foreign Key(ColorCode ) references Colors(ColorCode),
Foreign Key(SizeCode ) references Sizes(SizeCode)
)
