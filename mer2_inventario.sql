-- MER 2 - Inventario

CREATE DATABASE inventario;
USE inventario;

CREATE TABLE Proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    contacto VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10,2),
    stock INT,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

CREATE TABLE Bodega (
    id_bodega INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    ubicacion VARCHAR(100)
);

CREATE TABLE Movimiento (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(20),
    fecha DATE,
    id_bodega INT,
    FOREIGN KEY (id_bodega) REFERENCES Bodega(id_bodega)
);

CREATE TABLE Producto_Proveedor (
    id_producto INT,
    id_proveedor INT,
    PRIMARY KEY (id_producto, id_proveedor),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

CREATE TABLE Detalle_Movimiento (
    id_movimiento INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_movimiento, id_producto),
    FOREIGN KEY (id_movimiento) REFERENCES Movimiento(id_movimiento),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

INSERT INTO Proveedor(nombre, contacto, telefono) VALUES
('Distribuidora A', 'Laura Rivas', '3101234567'),
('Mayorista B', 'Carlos Méndez', '3117654321'),
('Importadora C', 'Andrés Torres', '3129988776'),
('Fast Supply', 'Sandra Peña', '3138765432');

INSERT INTO Categoria(nombre) VALUES
('Electrónica'),
('Papelería'),
('Aseo'),
('Alimentos');

INSERT INTO Producto(nombre, descripcion, precio, stock, id_categoria) VALUES
('Laptop HP', 'Portátil 15 pulgadas', 2500000.00, 10, 1),
('Resma papel', 'Papel carta 500 hojas', 15000.00, 50, 2),
('Detergente', 'Líquido 1L', 8000.00, 30, 3),
('Café', '250g molido', 12000.00, 20, 4);

INSERT INTO Bodega(nombre, ubicacion) VALUES
('Principal', 'Centro'),
('Norte', 'Zona Industrial'),
('Sur', 'Parque Empresarial'),
('Express', 'Centro histórico');

INSERT INTO Movimiento(tipo, fecha, id_bodega) VALUES
('Entrada', '2025-06-01', 1),
('Salida', '2025-06-02', 2),
('Entrada', '2025-06-03', 3),
('Salida', '2025-06-04', 4);

INSERT INTO Producto_Proveedor(id_producto, id_proveedor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO Detalle_Movimiento(id_movimiento, id_producto, cantidad) VALUES
(1, 1, 5),
(2, 2, 10),
(3, 3, 15),
(4, 4, 3);

UPDATE Producto SET precio = 2600000.00 WHERE id_producto = 1;
UPDATE Proveedor SET telefono = '3201112233' WHERE id_proveedor = 2;
UPDATE Bodega SET ubicacion = 'Zona Franca' WHERE id_bodega = 3;
UPDATE Categoria SET nombre = 'Tecnología' WHERE id_categoria = 1;
UPDATE Movimiento SET tipo = 'Ajuste' WHERE id_movimiento = 4;

DELETE FROM Producto_Proveedor WHERE id_producto = 1 AND id_proveedor = 1;
DELETE FROM Detalle_Movimiento WHERE id_movimiento = 2 AND id_producto = 2;
DELETE FROM Movimiento WHERE id_movimiento = 2;
DELETE FROM Producto WHERE id_producto = 3;
DELETE FROM Proveedor WHERE id_proveedor = 3;

SELECT p.nombre, c.nombre AS categoria FROM Producto p
JOIN Categoria c ON p.id_categoria = c.id_categoria;

SELECT m.tipo, b.nombre AS bodega FROM Movimiento m
JOIN Bodega b ON m.id_bodega = b.id_bodega;

SELECT dp.id_movimiento, pr.nombre FROM Detalle_Movimiento dp
JOIN Producto pr ON dp.id_producto = pr.id_producto;

SELECT pp.id_proveedor, p.nombre AS producto FROM Producto_Proveedor pp
JOIN Producto p ON pp.id_producto = p.id_producto;

SELECT p.nombre, SUM(dm.cantidad) AS total_movido FROM Producto p
JOIN Detalle_Movimiento dm ON p.id_producto = dm.id_producto
GROUP BY p.nombre;

SELECT nombre FROM Proveedor WHERE id_proveedor = (SELECT MAX(id_proveedor) FROM Proveedor);

SELECT nombre FROM Producto WHERE id_producto = (SELECT id_producto FROM Detalle_Movimiento WHERE id_movimiento = 1);

SELECT nombre FROM Bodega WHERE id_bodega = (SELECT id_bodega FROM Movimiento WHERE tipo = 'Entrada' LIMIT 1);

SELECT nombre FROM Categoria WHERE id_categoria = (SELECT id_categoria FROM Producto GROUP BY id_categoria ORDER BY COUNT(*) DESC LIMIT 1);

SELECT nombre FROM Producto WHERE id_producto IN (SELECT id_producto FROM Detalle_Movimiento WHERE cantidad > 5);

DELIMITER //
CREATE FUNCTION fn_total_productos() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Producto;
  RETURN total;
END;//

CREATE FUNCTION fn_stock_producto(pid INT) RETURNS INT DETERMINISTIC
BEGIN
  DECLARE s INT;
  SELECT stock INTO s FROM Producto WHERE id_producto = pid;
  RETURN s;
END;//

CREATE FUNCTION fn_precio_producto(pid INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
  DECLARE p DECIMAL(10,2);
  SELECT precio INTO p FROM Producto WHERE id_producto = pid;
  RETURN p;
END;//

CREATE FUNCTION fn_total_categorias() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Categoria;
  RETURN total;
END;//

CREATE FUNCTION fn_ubicacion_bodega(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE ubicacion VARCHAR(100);
  SELECT ubicacion INTO ubicacion FROM Bodega WHERE id_bodega = pid;
  RETURN ubicacion;
END;//

CREATE FUNCTION fn_total_bodegas() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Bodega;
  RETURN total;
END;//

CREATE FUNCTION fn_total_movimientos() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Movimiento;
  RETURN total;
END;//

CREATE FUNCTION fn_producto_nombre(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(100);
  SELECT nombre INTO nombre FROM Producto WHERE id_producto = pid;
  RETURN nombre;
END;//

CREATE FUNCTION fn_categoria_nombre(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(100);
  SELECT nombre INTO nombre FROM Categoria WHERE id_categoria = pid;
  RETURN nombre;
END;//

CREATE FUNCTION fn_proveedor_nombre(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(100);
  SELECT nombre INTO nombre FROM Proveedor WHERE id_proveedor = pid;
  RETURN nombre;
END;//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_insertar_producto(
  IN pnombre VARCHAR(100),
  IN pdescripcion TEXT,
  IN pprecio DECIMAL(10,2),
  IN pstock INT,
  IN pid_categoria INT
)
BEGIN
  INSERT INTO Producto(nombre, descripcion, precio, stock, id_categoria)
  VALUES(pnombre, pdescripcion, pprecio, pstock, pid_categoria);
END;//
DELIMITER ;

DROP DATABASE inventario;
