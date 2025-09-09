-- 🔄 Пересоздаємо базу
DROP DATABASE IF EXISTS ShopDB;
CREATE DATABASE ShopDB;
USE ShopDB;

-- 🌍 Таблиця країн
CREATE TABLE Countries (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
);

-- 📦 Таблиця продуктів
CREATE TABLE Products (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
);

-- 🏬 Таблиця складів
CREATE TABLE Warehouses (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100),
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES Countries(ID) ON DELETE NO ACTION
);

-- 📊 Таблиця інвентаря (кількість товарів на складах)
CREATE TABLE Inventory (
    ProductID INT,
    WarehouseID INT,
    WarehouseAmount INT,
    PRIMARY KEY (ProductID, WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Products(ID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(ID)
);

-- 🧪 Тестові дані

-- Країни
INSERT INTO Countries (ID, Name) VALUES
    (1, 'Country1'),
    (2, 'Country2');

-- Продукт
INSERT INTO Products (ID, Name) VALUES
    (1, 'AwersomeProduct');

-- Склади
INSERT INTO Warehouses (ID, Name, Address, CountryID) VALUES
    (1, 'Warehouse-1', 'City-1, Street-1', 1),
    (2, 'Warehouse-2', 'City-2, Street-2', 2);

-- Інвентар
INSERT INTO Inventory (ProductID, WarehouseID, WarehouseAmount) VALUES
    (1, 1, 2),
    (1, 2, 5);

-- 👁️ Створюємо VIEW для сумісності з test.sql (імітація старої ProductInventory)
CREATE VIEW ProductInventory AS
SELECT
    ROW_NUMBER() OVER () AS ID,
    p.Name AS ProductName,
    i.WarehouseAmount,
    w.Name AS WarehouseName,
    w.Address AS WarehouseAddress,
    w.CountryID
FROM Inventory i
JOIN Products p ON i.ProductID = p.ID
JOIN Warehouses w ON i.WarehouseID = w.ID;
