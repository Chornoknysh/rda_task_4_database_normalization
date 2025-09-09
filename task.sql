-- 1. Пересоздаємо базу
DROP DATABASE IF EXISTS ShopDB;
CREATE DATABASE ShopDB;
USE ShopDB;

-- 2. Таблиці з ENGINE=InnoDB, NOT NULL/UNIQUE та UNSIGNED для кількості

-- 2.1 Країни
CREATE TABLE Countries (
  ID INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.2 Продукти
CREATE TABLE Products (
  ID INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.3 Склади
CREATE TABLE Warehouses (
  ID INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(50) NOT NULL,
  Address VARCHAR(100) NOT NULL,
  CountryID INT NOT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT fk_warehouses_country
    FOREIGN KEY (CountryID) REFERENCES Countries(ID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.4 Інвентар
CREATE TABLE Inventory (
  ProductID INT NOT NULL,
  WarehouseID INT NOT NULL,
  WarehouseAmount INT UNSIGNED NOT NULL,
  PRIMARY KEY (ProductID, WarehouseID),
  CONSTRAINT fk_inventory_product
    FOREIGN KEY (ProductID) REFERENCES Products(ID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_inventory_warehouse
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(ID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Тестові дані

INSERT INTO Countries (ID, Name) VALUES
  (1, 'Country1'),
  (2, 'Country2');

INSERT INTO Products (ID, Name) VALUES
  (1, 'AwersomeProduct');

INSERT INTO Warehouses (ID, Name, Address, CountryID) VALUES
  (1, 'Warehouse-1', 'City-1, Street-1', 1),
  (2, 'Warehouse-2', 'City-2, Street-2', 2);

INSERT INTO Inventory (ProductID, WarehouseID, WarehouseAmount) VALUES
  (1, 1, 2),
  (1, 2, 5);

-- 4. VIEW для сумісності зі старим тестовим скриптом
CREATE VIEW ProductInventory AS
SELECT
  (@rownum := @rownum + 1) AS ID,
  p.Name           AS ProductName,
  i.WarehouseAmount,
  w.Name           AS WarehouseName,
  w.Address        AS WarehouseAddress,
  w.CountryID
FROM (SELECT @rownum := 0) AS init
JOIN Inventory i
  ON TRUE
JOIN Products p
  ON i.ProductID = p.ID
JOIN Warehouses w
  ON i.WarehouseID = w.ID
ORDER BY i.ProductID, i.WarehouseID;

