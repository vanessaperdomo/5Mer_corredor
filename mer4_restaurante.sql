-- MER4 - Restaurante

CREATE DATABASE restaurante;
USE restaurante;

CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(20),
    correo VARCHAR(100)
);

CREATE TABLE Empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    puesto VARCHAR(50),
    salario DECIMAL(10,2)
);

CREATE TABLE Mesa (
    id_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numero INT,
    capacidad INT,
    ubicacion VARCHAR(50)
);

CREATE TABLE Reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    hora TIME,
    id_cliente INT,
    id_mesa INT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_mesa) REFERENCES Mesa(id_mesa)
);

CREATE TABLE Plato (
    id_plato INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    descripcion TEXT
);

CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    id_cliente INT,
    id_empleado INT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Pedido_Plato (
    id_pedido INT,
    id_plato INT,
    cantidad INT,
    PRIMARY KEY (id_pedido, id_plato),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_plato) REFERENCES Plato(id_plato)
);

INSERT INTO Cliente(nombre, telefono, correo) VALUES
('Juan Pérez', '3123456789', 'juan@mail.com'),
('Ana Torres', '3009876543', 'ana@mail.com'),
('Luis Díaz', '3112345678', 'luis@mail.com');

INSERT INTO Empleado(nombre, puesto, salario) VALUES
('Carlos Ramírez', 'Mesero', 1200000),
('Marta Ruiz', 'Cocinera', 1500000),
('Pedro López', 'Administrador', 2000000);

INSERT INTO Mesa(numero, capacidad, ubicacion) VALUES
(1, 4, 'Interior'),
(2, 2, 'Terraza'),
(3, 6, 'VIP');

INSERT INTO Reserva(fecha, hora, id_cliente, id_mesa) VALUES
('2025-06-22', '19:00:00', 1, 1),
('2025-06-23', '20:00:00', 2, 2),
('2025-06-24', '21:00:00', 3, 3);

INSERT INTO Plato(nombre, precio, descripcion) VALUES
('Pasta Carbonara', 25000, 'Pasta con salsa cremosa y tocino'),
('Pizza Margarita', 30000, 'Pizza con tomate, albahaca y mozzarella'),
('Ensalada César', 18000, 'Lechuga, pollo y aderezo César');

INSERT INTO Pedido(fecha, id_cliente, id_empleado) VALUES
('2025-06-22', 1, 1),
('2025-06-23', 2, 2),
('2025-06-24', 3, 3);

INSERT INTO Pedido_Plato(id_pedido, id_plato, cantidad) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 3);

UPDATE Cliente SET telefono = '3100000000' WHERE id_cliente = 1;
UPDATE Empleado SET salario = 1600000 WHERE id_empleado = 2;
UPDATE Mesa SET capacidad = 5 WHERE id_mesa = 1;
UPDATE Plato SET precio = 27000 WHERE id_plato = 1;
UPDATE Reserva SET hora = '19:30:00' WHERE id_reserva = 1;

DELETE FROM Pedido_Plato WHERE id_pedido = 1 AND id_plato = 1;
DELETE FROM Reserva WHERE id_reserva = 2;
DELETE FROM Mesa WHERE id_mesa = 3;
DELETE FROM Cliente WHERE id_cliente = 3;
DELETE FROM Pedido WHERE id_pedido = 3;

SELECT c.nombre, p.fecha FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente;

SELECT e.nombre, p.id_pedido FROM Empleado e
JOIN Pedido p ON e.id_empleado = p.id_empleado;

SELECT r.fecha, m.numero FROM Reserva r
JOIN Mesa m ON r.id_mesa = m.id_mesa;

SELECT pl.nombre, pp.cantidad FROM Plato pl
JOIN Pedido_Plato pp ON pl.id_plato = pp.id_plato;

SELECT m.numero, COUNT(r.id_reserva) AS reservas
FROM Mesa m
JOIN Reserva r ON m.id_mesa = r.id_mesa
GROUP BY m.numero;

SELECT nombre FROM Cliente WHERE id_cliente = (SELECT MAX(id_cliente) FROM Cliente);
SELECT precio FROM Plato WHERE id_plato = (SELECT id_plato FROM Pedido_Plato WHERE id_pedido = 2);
SELECT nombre FROM Mesa WHERE id_mesa = (SELECT id_mesa FROM Reserva GROUP BY id_mesa ORDER BY COUNT(*) DESC LIMIT 1);
SELECT nombre FROM Empleado WHERE id_empleado = (SELECT MAX(id_empleado) FROM Empleado);
SELECT nombre FROM Plato WHERE id_plato IN (SELECT id_plato FROM Pedido_Plato WHERE cantidad > 2);

DELIMITER //
CREATE FUNCTION fn_total_clientes() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Cliente;
  RETURN total;
END;//

CREATE FUNCTION fn_total_pedidos() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Pedido;
  RETURN total;
END;//

CREATE FUNCTION fn_nombre_plato(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(100);
  SELECT nombre INTO nombre FROM Plato WHERE id_plato = pid;
  RETURN nombre;
END;//

CREATE FUNCTION fn_salario_empleado(pid INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
  DECLARE salario DECIMAL(10,2);
  SELECT salario INTO salario FROM Empleado WHERE id_empleado = pid;
  RETURN salario;
END;//

CREATE FUNCTION fn_capacidad_mesa(pid INT) RETURNS INT DETERMINISTIC
BEGIN
  DECLARE capacidad INT;
  SELECT capacidad INTO capacidad FROM Mesa WHERE id_mesa = pid;
  RETURN capacidad;
END;//

CREATE FUNCTION fn_total_platos() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Plato;
  RETURN total;
END;//

CREATE FUNCTION fn_precio_plato(pid INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
  DECLARE precio DECIMAL(10,2);
  SELECT precio INTO precio FROM Plato WHERE id_plato = pid;
  RETURN precio;
END;//

CREATE FUNCTION fn_total_reservas() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Reserva;
  RETURN total;
END;//

CREATE FUNCTION fn_turno_reserva(pid INT) RETURNS TIME DETERMINISTIC
BEGIN
  DECLARE hora TIME;
  SELECT hora INTO hora FROM Reserva WHERE id_reserva = pid;
  RETURN hora;
END;//

CREATE FUNCTION fn_pedido_cliente(pid INT) RETURNS INT DETERMINISTIC
BEGIN
  DECLARE cid INT;
  SELECT id_cliente INTO cid FROM Pedido WHERE id_pedido = pid;
  RETURN cid;
END;//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_insertar_plato(
  IN pnombre VARCHAR(100),
  IN pprecio DECIMAL(10,2),
  IN pdescripcion TEXT
)
BEGIN
  INSERT INTO Plato(nombre, precio, descripcion) VALUES(pnombre, pprecio, pdescripcion);
END;//
DELIMITER ;

DROP DATABASE restaurante;