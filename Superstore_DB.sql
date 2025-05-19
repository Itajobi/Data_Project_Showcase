--1.Dataset Preparation

--The Superstore dataset consisted of four sheets in an Excel file:
-- CustomerName
-- Orders
-- Returns
-- Users
--Each sheet was separated, cleaned, and formatted to align with the database schema before insertion.

--Duplicate removed
--Blank cells removed

--2.Database Creation and structure


CREATE DATABASE Superstore_DB

USE Superstore_DB

CREATE TABLE Customers (
 CustomerName VARCHAR(255) NOT NULL,  
 OrderID INT PRIMARY KEY
);

CREATE INDEX idx_customer_name ON Customers(CustomerName)



CREATE TABLE Orders (
   RowID              INT PRIMARY KEY,
   OrderID            INT,
   OrderDate          DATE,
   OrderPriority      VARCHAR(50),
   OrderQuantity      INT,
   Sales              FLOAT(10),
   Discount           FLOAT(5),
   ShipMode           VARCHAR(50),
   Profit             FLOAT(10),
   UnitPrice          FLOAT(10),
   ShippingCost       FLOAT(10),
   CustomerName       VARCHAR(255),
   Province           VARCHAR(100),
   Region             VARCHAR(100),
   CustomerSegment    VARCHAR(100),
   ProductCategory    VARCHAR(100),
   ProductSubCategory VARCHAR(100),
   ProductName        VARCHAR(255),
   ProductContainer   VARCHAR(100),
    ProductBaseMargin FLOAT(5),
    ShipDate          DATE,
CONSTRAINT FK_Orders_Customer FOREIGN KEY (OrderID) REFERENCES Customers (OrderID)
);

CREATE INDEX idx_order_date ON Orders(OrderDate)


CREATE TABLE Returns (
OrderID         INT PRIMARY KEY,
Status           VARCHAR(20)
CONSTRAINT FK_Returns_Customer FOREIGN KEY (OrderID) REFERENCES Customers (OrderID)
);

CREATE INDEX idx_Order_ID ON Returns(OrderID)




CREATE TABLE Users (
Region         VARCHAR(20) NOT NULL,	
Manager        VARCHAR(50) NOT NULL
);

--Report
--The database Superstore_DB was created using the SQL query below
--This command initialized the database, preparing it to store multiple tables.
--Four tables were created within Superstore_DB to organize data effectively:
--Customers – Stores customer details.
--Orders – Records purchased items.
--Returns – Tracks returned products.
--Users – Maintains user profiles and access permissions.

--Each table was structured with carefully defined columns, data types, and constraints
--Created Indexing for Customers, Orders and Returns Tables to help in filtering, sorting, and joining operations.
--See below SQL Script used




--3.Data import Process

--The formatted Superstore data was imported from Excel using the SQL query below
--The four tables was converted into CSV files
--The BULK INSERT was used to insert data into tables below


BULK INSERT Customers
FROM 'C:\Users\xpert\OneDrive\Desktop\Customers.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW=2, 
    FIELDTERMINATOR=',',
    ROWTERMINATOR='\n'
);


SELECT * FROM Customers


BULK INSERT Orders
FROM 'C:\Users\xpert\OneDrive\Desktop\Orders.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW=2, 
    FIELDTERMINATOR=',', 
    ROWTERMINATOR='\n'    
);

SELECT * FROM Orders
SELECT TOP 10 * FROM Orders


BULK INSERT Returns
FROM 'C:\Users\xpert\OneDrive\Desktop\Returns.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW=2,  
    FIELDTERMINATOR=',',  
    ROWTERMINATOR='\n'
 );  


INSERT INTO Users VALUES
('Central',	'Chris'),
('East',	'Erin'),
('South',	'Sam'),
('West',	'William'),
('West',	'Pat'),
('Central',	'Pat'),
('East',	'Pat'),
('South',	'Pat');

SELECT * FROM Users


--4 Verification
--Record Count Validation
--Verified the total number of rows in each table to ensure full data import.
--All tables imported successfully, with correct row counts of 5496, 8336, 572 and 8 respectively.

--Foreign Key Relationship Testing
--Ensured Orders table OrderID correctly linked to Customers table OrderID with the SQL Query below
--No orphaned records detected between Orders and Customers.
--Indexing applied for faster queries and optimized retrieval.

SELECT Orders.OrderID, Customers.OrderID
FROM Orders
LEFT JOIN Customers ON Orders.OrderID = Customers.OrderID
WHERE Customers.OrderID IS NULL;


SELECT COUNT(*) FROM Orders;
SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM Returns;
SELECT COUNT(*) FROM Users;


--Challenge

--Bulk Insert Errors Due to Date Format Issues
--The OrderDate and ShipDate was in DD-MM-YYY format which was no accepted by SQL server
--Issue: SQL Server expected YYYY-MM-DD, but the CSV file contained dates in DD-MM-YYYY, causing conversion errors

--Resolution
--The date format was corrected in Excel before saving as CSV 
--I highlighted the 2 columns, right click, choose format cells and choose date format YYYY-MM-DD

--4 Analysis syntax
SELECT Customers.CustomerName, COUNT(Customers.OrderID) AS TotalOrders
FROM Customers
JOIN Orders ON Orders.OrderID = Customers.OrderID
GROUP BY Customers.CustomerName;


CREATE VIEW CustomerSegmentView AS
SELECT c.OrderID, c.CustomerName, o.CustomerSegment
FROM Customers c
JOIN Orders o ON c.OrderID = o.OrderID
WHERE o.CustomerSegment IS NOT NULL;

SELECT * FROM CustomerSegmentView

SELECT o.CustomerSegment, COUNT(o.OrderID) AS TotalOrders
FROM Orders o
JOIN Customers c ON o.OrderID = c.OrderID
GROUP BY o.CustomerSegment
ORDER BY TotalOrders DESC;