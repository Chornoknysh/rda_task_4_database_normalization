-- 1. Пересоздаємо базу
DROP DATABASE IF EXISTS ShopDB;
CREATE DATABASE ShopDB;
USE ShopDB;

-- 2. Нормалізована структура

-- 2.1 Країни
CREATE TABLE Countries (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
);

-- 2.2 Продукти
CREATE TABLE Products (
    ID INT PRIMARY KEY,
    Name VARCHAR(50)
);

-- 2.3 Склади
CREATE TABLE Warehouses (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100),
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES Countries(ID)
);

-- 2.4 Інвентар: кількість продуктів на кожному складі
CREATE TABLE Inventory (
    ProductID INT,
    WarehouseID INT,
    WarehouseAmount INT,
    PRIMARY KEY (ProductID, WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Products(ID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(ID)
);

-- 3. Заповнення тестових даних

-- 3.1 Країни (як в оригіналі)
INSERT INTO Countries (ID, Name) VALUES
  (1, 'Country1'),
  (2, 'Country2');

-- 3.2 Продукт (AwersomeProduct)
INSERT INTO Products (ID, Name) VALUES
  (1, 'AwersomeProduct');

-- 3.3 Склады
INSERT INTO Warehouses (ID, Name, Address, CountryID) VALUES
  (1, 'Warehouse-1', 'City-1, Street-1', 1),
  (2, 'Warehouse-2', 'City-2, Street-2', 2);

-- 3.4 Інвентар
INSERT INTO Inventory (ProductID, WarehouseID, WarehouseAmount) VALUES
  (1, 1, 2),
  (1, 2, 5);
