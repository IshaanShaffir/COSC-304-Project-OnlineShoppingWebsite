CREATE DATABASE orders;
go;

USE orders;
go;

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(100),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(1000),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Pre-Builts');
INSERT INTO category(categoryName) VALUES ('Graphic Cards');
INSERT INTO category(categoryName) VALUES ('Motherboards');
INSERT INTO category(categoryName) VALUES ('Ram Kits');
INSERT INTO category(categoryName) VALUES ('Power Supply Units');
INSERT INTO category(categoryName) VALUES ('CPUs');
INSERT INTO category(categoryName) VALUES ('Cooling');
INSERT INTO category(categoryName) VALUES ('Cases');
INSERT INTO category(categoryName) VALUES ('Peripherals');
INSERT INTO category(categoryName) VALUES ('Storage');
INSERT INTO category(categoryName) VALUES ('Monitors');

-- Pre-Builts
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Alienware Aurora R16', 1, 'Pre-built gaming PC', 2600.00);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Lenovo Legion Tower', 1, 'Pre-built gaming PC', 3430.00);

-- Graphic Cards
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('NVIDIA GeForce RTX 4060Ti', 2, 'Graphics Card', 530.00);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('NVIDIA GeForce RTX 4090Ti Founder’s Edition', 2, 'Graphics Card', 5000.00);

-- Motherboards
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Gigabyte B650 Eagle AX AM5', 3, 'Motherboard', 219.99);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('ASUS TUF Gaming B760-Plus WIFI', 3, 'Motherboard', 225.99);

-- Ram Kits
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Corsair Vengeance DDR5', 4, 'RAM Kit', 140.00);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Kingston Fury Beast DDR5', 4, 'RAM Kit', 79.99);

-- Power Supply Units
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Corsair CX750 80 Plus Bronze', 5, 'Power Supply Unit', 89.99);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('ASUS ROG Thor 850W Platinum II', 5, 'Power Supply Unit', 329.50);

-- CPUs
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('AMD Ryzen™ 9 9900X', 6, 'CPU', 569.99);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Intel Core i9-13900K', 6, 'CPU', 536.88);

-- Cooling
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('NZXT Kraken 240 240mm AIO', 7, 'Cooling System', 159.99);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Cooler Master MasterLiquid 120L Core', 7, 'Cooling System', 84.99);

-- Cases
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('NZXT H5 Flow', 8, 'PC Case', 94.99);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Corsair 3500X', 8, 'PC Case', 99.99);

-- Peripherals
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Logitech G PRO X Superlight Wireless', 9, 'Wireless Gaming Mouse', 139.99);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Razer Gaming Mouse Wireless Viper V3 Pro', 9, 'Wireless Gaming Mouse', 199.99);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('SteelSeries Apex 3 RGB Gaming Keyboard', 9, 'Gaming Keyboard', 69.99);

-- Storage
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('SAMSUNG 990 PRO SSD 4TB', 10, 'SSD Storage', 629.99);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('SAMSUNG 990 EVO SSD 2TB', 10, 'SSD Storage', 319.99);

-- Monitors
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('ASUS TUF Gaming 32"', 11, 'Gaming Monitor', 349.99);
INSERT INTO product (productName, categoryId, productDesc, productPrice) VALUES ('Samsung 49" Odyssey G9', 11, 'Curved Gaming Monitor', 1699.99);


INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 18);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 19);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 10);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 22);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 21.35);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 25);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 30);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 40);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 97);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 31);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);

-- New SQL DDL for lab 8
UPDATE Product SET productImageURL = 'img/1.jpeg' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/2.jpeg' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/3.jpeg' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/4.jpeg' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/5.jpeg' WHERE ProductId = 5;
UPDATE Product SET productImageURL = 'img/6.jpeg' WHERE ProductId = 6;
UPDATE Product SET productImageURL = 'img/7.jpeg' WHERE ProductId = 7;
UPDATE Product SET productImageURL = 'img/8.jpeg' WHERE ProductId = 8;
UPDATE Product SET productImageURL = 'img/9.jpeg' WHERE ProductId = 9;
UPDATE Product SET productImageURL = 'img/10.jpeg' WHERE ProductId = 10;
UPDATE Product SET productImageURL = 'img/11.jpeg' WHERE ProductId = 11;
UPDATE Product SET productImageURL = 'img/12.jpeg' WHERE ProductId = 12;
UPDATE Product SET productImageURL = 'img/13.jpeg' WHERE ProductId = 13;
UPDATE Product SET productImageURL = 'img/14.jpeg' WHERE ProductId = 14;
UPDATE Product SET productImageURL = 'img/15.jpeg' WHERE ProductId = 15;
UPDATE Product SET productImageURL = 'img/16.jpeg' WHERE ProductId = 16;
UPDATE Product SET productImageURL = 'img/17.jpeg' WHERE ProductId = 17;
UPDATE Product SET productImageURL = 'img/18.jpeg' WHERE ProductId = 18;
UPDATE Product SET productImageURL = 'img/19.jpeg' WHERE ProductId = 19;
UPDATE Product SET productImageURL = 'img/20.jpeg' WHERE ProductId = 20;
UPDATE Product SET productImageURL = 'img/21.jpeg' WHERE ProductId = 21;
UPDATE Product SET productImageURL = 'img/22.jpeg' WHERE ProductId = 22;
UPDATE Product SET productImageURL = 'img/23.jpeg' WHERE ProductId = 23;
