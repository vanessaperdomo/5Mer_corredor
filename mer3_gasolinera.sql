-- MER3 - Gasolinera

CREATE DATABASE gasolinera;
USE gasolinera;

CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    cedula VARCHAR(20),
    telefono VARCHAR(20)
);

CREATE TABLE Empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    cargo VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Combustible (
    id_combustible INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50),
    precio DECIMAL(10,2),
    cantidad INT
);

CREATE TABLE Turno (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    dia VARCHAR(20),
    hora_inicio TIME,
    hora_fin TIME
);

CREATE TABLE Venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    total DECIMAL(10,2),
    id_combustible INT,
    FOREIGN KEY (id_combustible) REFERENCES Combustible(id_combustible)
);

CREATE TABLE Venta_Cliente (
    id_cliente INT,
    id_venta INT,
    PRIMARY KEY (id_cliente, id_venta),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
);

CREATE TABLE Empleado_Turno (
    id_empleado INT,
    id_turno INT,
    PRIMARY KEY (id_empleado, id_turno),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    FOREIGN KEY (id_turno) REFERENCES Turno(id_turno)
);

INSERT INTO Cliente(nombre, cedula, telefono) VALUES
('Laura Gómez', '12345678', '3101234567'),
('Pedro Ruiz', '87654321', '3117654321'),
('Ana Torres', '11223344', '3129988776');

INSERT INTO Empleado(nombre, cargo, telefono) VALUES
('Luis Rojas', 'Cajero', '3101112233'),
('Carla Mendoza', 'Supervisor', '3112223344'),
('Javier Mora', 'Atendedor', '3123334455');

INSERT INTO Combustible(tipo, precio, cantidad) VALUES
('Gasolina Corriente', 9500.00, 10000),
('Gasolina Extra', 11000.00, 5000),
('Diesel', 8700.00, 7000);

INSERT INTO Turno(dia, hora_inicio, hora_fin) VALUES
('Lunes', '06:00:00', '14:00:00'),
('Martes', '14:00:00', '22:00:00'),
('Miércoles', '22:00:00', '06:00:00');

INSERT INTO Venta(fecha, total, id_combustible) VALUES
('2025-06-01', 50000.00, 1),
('2025-06-02', 30000.00, 2),
('2025-06-03', 20000.00, 3);

INSERT INTO Venta_Cliente(id_cliente, id_venta) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Empleado_Turno(id_empleado, id_turno) VALUES
(1, 1),
(2, 2),
(3, 3);

UPDATE Combustible SET precio = 9800.00 WHERE id_combustible = 1;
UPDATE Cliente SET telefono = '3133334444' WHERE id_cliente = 2;
UPDATE Empleado SET cargo = 'Gerente' WHERE id_empleado = 2;
UPDATE Turno SET dia = 'Jueves' WHERE id_turno = 2;
UPDATE Venta SET total = 55000.00 WHERE id_venta = 1;

DELETE FROM Venta_Cliente WHERE id_cliente = 3 AND id_venta = 3;
DELETE FROM Empleado_Turno WHERE id_empleado = 3 AND id_turno = 3;
DELETE FROM Venta WHERE id_venta = 3;
DELETE FROM Empleado WHERE id_empleado = 3;
DELETE FROM Cliente WHERE id_cliente = 3;

SELECT cl.nombre AS cliente, v.fecha, v.total
FROM Cliente cl
INNER JOIN Venta_Cliente vc ON cl.id_cliente = vc.id_cliente
INNER JOIN Venta v ON vc.id_venta = v.id_venta;

SELECT e.nombre AS empleado, t.dia, t.hora_inicio
FROM Empleado e
LEFT JOIN Empleado_Turno et ON e.id_empleado = et.id_empleado
LEFT JOIN Turno t ON et.id_turno = t.id_turno;

SELECT t.dia AS turno, e.nombre AS empleado
FROM Empleado_Turno et
RIGHT JOIN Turno t ON et.id_turno = t.id_turno
RIGHT JOIN Empleado e ON et.id_empleado = e.id_empleado;

SELECT cl.nombre AS cliente, v.fecha, v.total
FROM Cliente cl
LEFT JOIN Venta_Cliente vc ON cl.id_cliente = vc.id_cliente
LEFT JOIN Venta v ON vc.id_venta = v.id_venta

UNION

SELECT cl.nombre AS cliente, v.fecha, v.total
FROM Venta v
LEFT JOIN Venta_Cliente vc ON v.id_venta = vc.id_venta
LEFT JOIN Cliente cl ON vc.id_cliente = cl.id_cliente;

SELECT v.fecha, c.tipo, v.total
FROM Venta v
INNER JOIN Combustible c ON v.id_combustible = c.id_combustible
WHERE c.tipo = 'Gasolina Corriente';

SELECT nombre FROM Cliente
WHERE id_cliente = (SELECT MAX(id_cliente) FROM Cliente);

SELECT tipo FROM Combustible
WHERE id_combustible = (SELECT id_combustible FROM Venta WHERE id_venta = 1);

SELECT nombre FROM Empleado
WHERE id_empleado IN (SELECT id_empleado FROM Empleado_Turno WHERE id_turno = 2);

SELECT precio FROM Combustible
WHERE id_combustible = (SELECT MIN(id_combustible) FROM Combustible);

SELECT total FROM Venta
WHERE id_combustible = (SELECT id_combustible FROM Combustible WHERE tipo = 'Diesel');

DELIMITER //

CREATE FUNCTION fn_total_clientes() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Cliente;
  RETURN total;
END;//

CREATE FUNCTION fn_total_empleados() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Empleado;
  RETURN total;
END;//

CREATE FUNCTION fn_total_combustibles() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Combustible;
  RETURN total;
END;//

CREATE FUNCTION fn_nombre_cliente(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(100);
  SELECT nombre INTO nombre FROM Cliente WHERE id_cliente = pid;
  RETURN nombre;
END;//

CREATE FUNCTION fn_nombre_empleado(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(100);
  SELECT nombre INTO nombre FROM Empleado WHERE id_empleado = pid;
  RETURN nombre;
END;//

CREATE FUNCTION fn_precio_combustible(pid INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
  DECLARE p DECIMAL(10,2);
  SELECT precio INTO p FROM Combustible WHERE id_combustible = pid;
  RETURN p;
END;//

CREATE FUNCTION fn_turno_dia(pid INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
  DECLARE d VARCHAR(20);
  SELECT dia INTO d FROM Turno WHERE id_turno = pid;
  RETURN d;
END;//

CREATE FUNCTION fn_total_ventas() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Venta;
  RETURN total;
END;//

CREATE FUNCTION fn_total_turnos() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Turno;
  RETURN total;
END;//

CREATE FUNCTION fn_cargo_empleado(pid INT) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
  DECLARE c VARCHAR(50);
  SELECT cargo INTO c FROM Empleado WHERE id_empleado = pid;
  RETURN c;
END;//

CREATE PROCEDURE sp_insertar_cliente(
  IN pnombre VARCHAR(100),
  IN pcedula VARCHAR(20),
  IN ptelefono VARCHAR(20)
)
BEGIN
  INSERT INTO Cliente(nombre, cedula, telefono)
  VALUES(pnombre, pcedula, ptelefono);
END;//

DELIMITER ;

ALTER TABLE Cliente
ADD COLUMN correo VARCHAR(100);

ALTER TABLE Cliente
DROP COLUMN correo;

ALTER TABLE Empleado
ADD COLUMN correo VARCHAR(100);

ALTER TABLE Empleado
DROP COLUMN correo;

DROP TABLE Empleado_Turno;
DROP TABLE Venta_Cliente;
DROP TABLE Venta;
DROP TABLE Turno;
DROP TABLE Combustible;
DROP TABLE Empleado;
DROP TABLE Cliente;

DROP DATABASE gasolinera;
