-- MER 2 - Inventario

DROP DATABASE inventario;
CREATE DATABASE inventario;
USE inventario;

CREATE TABLE Proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100),
    contacto      VARCHAR(50),
    telefono      VARCHAR(20),
    email         VARCHAR(100)
);

CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(50),
    descripcion  TEXT
);

CREATE TABLE Producto (
    id_producto  INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100),
    descripcion  TEXT,
    precio       DECIMAL(10,2),
    stock        INT,
    id_categoria INT,
    marca        VARCHAR(50),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

CREATE TABLE Bodega (
    id_bodega  INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(100),
    ubicacion   VARCHAR(100),
    capacidad   INT DEFAULT 0
);

CREATE TABLE Movimiento (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    tipo          VARCHAR(20),
    fecha         DATE,
    id_bodega     INT,
    usuario       VARCHAR(50),
    FOREIGN KEY (id_bodega) REFERENCES Bodega(id_bodega)
);

CREATE TABLE Producto_Proveedor (
    id_producto     INT,
    id_proveedor    INT,
    precio_compra   DECIMAL(10,2) DEFAULT 0,
    PRIMARY KEY (id_producto, id_proveedor),
    FOREIGN KEY (id_producto)  REFERENCES Producto(id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

CREATE TABLE Detalle_Movimiento (
    id_movimiento INT,
    id_producto   INT,
    cantidad      INT,
    observaciones TEXT,
    PRIMARY KEY (id_movimiento, id_producto),
    FOREIGN KEY (id_movimiento) REFERENCES Movimiento(id_movimiento),
    FOREIGN KEY (id_producto)   REFERENCES Producto(id_producto)
);


INSERT INTO Proveedor(nombre, contacto, telefono, email) VALUES
 ('Distribuidora A', 'Laura Rivas',  '3101234567', 'a@mail.com'),
 ('Mayorista B',     'Carlos Méndez','3117654321', 'b@mail.com'),
 ('Importadora C',   'Andrés Torres','3129988776', 'c@mail.com'),
 ('Proveedor_aux',   'Eliminar',     '3999999999', 'aux@mail.com');

INSERT INTO Categoria(nombre, descripcion) VALUES
 ('Electrónica', 'Dispositivos electrónicos'),
 ('Papelería',    'Útiles de oficina'),
 ('Aseo',         'Productos de limpieza'),
 ('Cat_aux',      'Eliminar');

INSERT INTO Producto(nombre, descripcion, precio, stock, id_categoria, marca) VALUES
 ('Laptop HP',   'Portátil 15"',     2500000.00, 10, 1, 'HP'),
 ('Resma Papel', 'Carta 500 hojas',     15000.00, 60, 2, 'Norma'),
 ('Detergente',  'Líquido universal',    8000.00, 25, 3, 'Ariel'),
 ('Prod_aux',    'Eliminar',            9999.00,  5, 4, 'X');

INSERT INTO Bodega(nombre, ubicacion, capacidad) VALUES
 ('Central', 'Zona Centro', 100),
 ('Norte',   'Parque Industrial', 150),
 ('Sur',     'Zona Franca', 200),
 ('Bodega_aux', 'Eliminar', 10);

INSERT INTO Movimiento(tipo, fecha, id_bodega, usuario) VALUES
 ('Entrada','2025-06-01',1,'admin'),
 ('Salida', '2025-06-02',2,'admin'),
 ('Entrada','2025-06-03',3,'admin'),
 ('Mov_aux','2025-06-04',4,'admin');

INSERT INTO Producto_Proveedor(id_producto, id_proveedor, precio_compra) VALUES
 (1,1,2400000.00),(2,2,12000.00),(3,3,7000.00),(4,4,500.00);

INSERT INTO Detalle_Movimiento(id_movimiento, id_producto, cantidad, observaciones) VALUES
 (1,1,5,'ok'),(2,2,10,'ok'),(3,3,7,'ok'),(4,4,1,'aux');


UPDATE Producto   SET precio = 2600000.00 WHERE id_producto = 1;
UPDATE Producto   SET stock  = stock + 5   WHERE id_producto = 2;
UPDATE Proveedor  SET telefono = '3201112233' WHERE id_proveedor = 2;
UPDATE Bodega     SET capacidad = 180 WHERE id_bodega = 3;
UPDATE Categoria  SET nombre = 'Tecnología' WHERE id_categoria = 1;


DELETE FROM Detalle_Movimiento WHERE id_movimiento = 4 AND id_producto = 4;
DELETE FROM Producto_Proveedor  WHERE id_producto   = 4 AND id_proveedor = 4;
DELETE FROM Movimiento          WHERE id_movimiento = 4;
DELETE FROM Producto            WHERE id_producto   = 4;
DELETE FROM Proveedor           WHERE id_proveedor  = 4;
DELETE FROM Bodega              WHERE id_bodega     = 4;
DELETE FROM Categoria           WHERE id_categoria  = 4;


DELIMITER //
CREATE FUNCTION fn_total_productos() RETURNS INT DETERMINISTIC
BEGIN
    DECLARE t INT; 
    SELECT COUNT(*) INTO t FROM Producto; 
    RETURN t;
END//

CREATE FUNCTION fn_stock_producto(pid INT) RETURNS INT DETERMINISTIC
BEGIN 
    DECLARE s INT; 
    SELECT stock INTO s FROM Producto WHERE id_producto = pid; 
    RETURN s; 
END//

CREATE FUNCTION fn_precio_producto(pid INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN 
    DECLARE p DECIMAL(10,2); 
    SELECT precio INTO p FROM Producto WHERE id_producto = pid; 
    RETURN p; 
END//

CREATE FUNCTION fn_total_categorias() RETURNS INT DETERMINISTIC
BEGIN 
    DECLARE t INT; 
    SELECT COUNT(*) INTO t FROM Categoria; 
    RETURN t; 
END//

CREATE FUNCTION fn_ubicacion_bodega(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN 
    DECLARE u VARCHAR(100); 
    SELECT ubicacion INTO u FROM Bodega WHERE id_bodega = pid; 
    RETURN u; 
END//

CREATE FUNCTION fn_total_bodegas() RETURNS INT DETERMINISTIC
BEGIN 
    DECLARE t INT; 
    SELECT COUNT(*) INTO t FROM Bodega; 
    RETURN t; 
END//

CREATE FUNCTION fn_total_movimientos() RETURNS INT DETERMINISTIC
BEGIN 
    DECLARE t INT; 
    SELECT COUNT(*) INTO t FROM Movimiento; 
    RETURN t; 
END//

CREATE FUNCTION fn_producto_nombre(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN 
    DECLARE n VARCHAR(100); 
    SELECT nombre INTO n FROM Producto WHERE id_producto = pid; 
    RETURN n; 
END//

CREATE FUNCTION fn_categoria_nombre(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN 
    DECLARE n VARCHAR(100); 
    SELECT nombre INTO n FROM Categoria WHERE id_categoria = pid; 
    RETURN n; 
END//

CREATE FUNCTION fn_proveedor_nombre(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN 
    DECLARE n VARCHAR(100); 
    SELECT nombre INTO n FROM Proveedor WHERE id_proveedor = pid; 
    RETURN n; 
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_insertar_producto(
    IN pnombre VARCHAR(100),
    IN pdescripcion TEXT,
    IN pprecio DECIMAL(10,2),
    IN pstock INT,
    IN pid_categoria INT,
    IN pmarca VARCHAR(50)
)
BEGIN
    INSERT INTO Producto(nombre, descripcion, precio, stock, id_categoria, marca)
    VALUES (pnombre, pdescripcion, pprecio, pstock, pid_categoria, pmarca);
END//
DELIMITER ;


SELECT p.nombre AS producto, c.nombre AS categoria
FROM Producto p
JOIN Categoria c ON p.id_categoria = c.id_categoria;

SELECT m.tipo, m.fecha, b.nombre AS bodega
FROM Movimiento m
JOIN Bodega b ON m.id_bodega = b.id_bodega;


SELECT pr.nombre AS producto, pv.nombre AS proveedor, pp.precio_compra
FROM Producto_Proveedor pp
JOIN Producto pr  ON pp.id_producto  = pr.id_producto
JOIN Proveedor pv ON pp.id_proveedor = pv.id_proveedor;

SELECT pr.nombre, SUM(dm.cantidad) AS total_movido
FROM Detalle_Movimiento dm
JOIN Producto pr ON dm.id_producto = pr.id_producto
GROUP BY pr.nombre;


SELECT DISTINCT usuario FROM Movimiento;

SELECT nombre, stock
FROM Producto
WHERE stock > (SELECT AVG(stock) FROM Producto);


SELECT c.nombre
FROM Categoria c
WHERE c.id_categoria IN (
    SELECT DISTINCT p.id_categoria
    FROM Producto p
);

SELECT pv.nombre, pp.precio_compra
FROM Proveedor pv
JOIN Producto_Proveedor pp ON pv.id_proveedor = pp.id_proveedor
WHERE pp.precio_compra < (
    SELECT AVG(precio_compra)
    FROM Producto_Proveedor
    WHERE precio_compra > 0
);

SELECT nombre, capacidad
FROM Bodega
WHERE capacidad > (
    SELECT AVG(capacidad)
    FROM Bodega
);

SELECT DISTINCT p.nombre
FROM Producto p
WHERE p.id_producto IN (
    SELECT dm.id_producto
    FROM Detalle_Movimiento dm
    JOIN Movimiento m ON dm.id_movimiento = m.id_movimiento
    WHERE m.tipo = 'Entrada'
);

ALTER TABLE Producto
ADD COLUMN fecha_registro DATE;

ALTER TABLE Producto
DROP COLUMN fecha_registro;

ALTER TABLE Proveedor
ADD COLUMN telefono_alt VARCHAR(20);

ALTER TABLE Proveedor
DROP COLUMN telefono_alt;


DROP TABLE Detalle_Movimiento;
DROP TABLE Producto_Proveedor;
DROP TABLE Movimiento;
DROP TABLE Producto;
DROP TABLE Proveedor;
DROP TABLE Bodega;
DROP TABLE Categoria;

DROP DATABASE inventario;
