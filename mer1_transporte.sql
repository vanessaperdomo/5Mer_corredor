-- MER 1 - Transporte 
-- Aprendiz: Laura Vanessa Perez Perdomo

CREATE DATABASE transporte;
USE transporte;

CREATE TABLE Empresa (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(100)
);

CREATE TABLE Vehiculo (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10),
    modelo VARCHAR(50),
    anio INT,
    id_empresa INT,
    FOREIGN KEY (id_empresa) REFERENCES Empresa(id_empresa)
);

CREATE TABLE Chofer (
    id_chofer INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    licencia VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Ruta (
    id_ruta INT AUTO_INCREMENT PRIMARY KEY,
    origen VARCHAR(100),
    destino VARCHAR(100),
    duracion INT
);

CREATE TABLE Horario (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    hora_salida TIME,
    hora_llegada TIME,
    dia VARCHAR(20)
);

CREATE TABLE Vehiculo_Ruta (
    id_vehiculo INT,
    id_ruta INT,
    observacion TEXT,
    PRIMARY KEY (id_vehiculo, id_ruta),
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculo(id_vehiculo),
    FOREIGN KEY (id_ruta) REFERENCES Ruta(id_ruta)
);

CREATE TABLE Chofer_Horario (
    id_chofer INT,
    id_horario INT,
    turno VARCHAR(20),
    PRIMARY KEY (id_chofer, id_horario),
    FOREIGN KEY (id_chofer) REFERENCES Chofer(id_chofer),
    FOREIGN KEY (id_horario) REFERENCES Horario(id_horario)
);

INSERT INTO Empresa(nombre, telefono, direccion) VALUES
('TransAndes', '3216549870', 'Av. Principal 123'),
('ViaExpress', '3204567890', 'Cra 45 #56-78'),
('RutaSegura', '3198765432', 'Cl 12 #34-56'),
('Valle', '3202565271', 'Cl 10 #33-50');

INSERT INTO Vehiculo(placa, modelo, anio, id_empresa) VALUES
('ABC123', 'Toyota', 2015, 1),
('XYZ789', 'Mercedes', 2018, 2),
('LMN456', 'Ford', 2020, 3),
('HJI567', 'Lamborguine', 2024, 4);

INSERT INTO Chofer(nombre, licencia, telefono) VALUES
('Carlos Perez', 'B12345', '3101234567'),
('Marta Lopez', 'C67890', '3117654321'),
('Luis Gomez', 'A54321', '3129988776'),
('Luis Martines', 'A54371', '3144214909');

INSERT INTO Ruta(origen, destino, duracion) VALUES
('Bogota', 'Medellin', 8),
('Cali', 'Pereira', 5),
('Barranquilla', 'Cartagena', 2),
('Cartagena', 'buga', 6);

INSERT INTO Horario(hora_salida, hora_llegada, dia) VALUES
('06:00:00', '14:00:00', 'Lunes'),
('08:00:00', '13:00:00', 'Miercoles'),
('09:00:00', '11:00:00', 'Viernes'),
('02:00:00', '11:00:00', 'Sabados');

INSERT INTO Vehiculo_Ruta(id_vehiculo, id_ruta, observacion) VALUES
(1, 1, 'Ruta principal'),
(2, 2, 'Ruta secundaria'),
(3, 3, 'Ruta costera'),
(4, 4, 'Ruta tercera');

INSERT INTO Chofer_Horario(id_chofer, id_horario, turno) VALUES
(1, 1, 'Mañana'),
(2, 2, 'Tarde'),
(3, 3, 'Noche'),
(4, 4, 'Diurno');

UPDATE Vehiculo 
SET modelo = 'Hyundai H1' 
WHERE id_vehiculo = 1;

UPDATE Chofer 
SET telefono = '3130001111' 
WHERE id_chofer = 2;

UPDATE Ruta 
SET duracion = 3 
WHERE id_ruta = 3;

UPDATE Empresa 
SET direccion = 'Calle lol' 
WHERE id_empresa = 1;

UPDATE Horario 
SET dia = 'Domingo' 
WHERE id_horario = 2;

DELETE FROM Vehiculo_Ruta 
WHERE id_vehiculo = 1 AND id_ruta = 1;

DELETE FROM Vehiculo_Ruta 
WHERE id_vehiculo = 3 AND id_ruta = 3;

DELETE FROM Chofer_Horario 
WHERE id_chofer = 2 AND id_horario = 2;

DELETE FROM Vehiculo 
WHERE id_vehiculo = 3;

DELETE FROM Empresa 
WHERE id_empresa = 3;

-- 5 select joins

SELECT v.placa, r.origen, r.destino 
FROM Vehiculo v
JOIN Vehiculo_Ruta vr ON v.id_vehiculo = vr.id_vehiculo
JOIN Ruta r ON vr.id_ruta = r.id_ruta;

SELECT ch.nombre, h.hora_salida, h.dia 
FROM Chofer ch
JOIN Chofer_Horario chh ON ch.id_chofer = chh.id_chofer
JOIN Horario h ON chh.id_horario = h.id_horario;

SELECT e.nombre, v.modelo 
FROM Empresa e
JOIN Vehiculo v ON e.id_empresa = v.id_empresa;

SELECT c.nombre, r.origen 
FROM Chofer c
JOIN Chofer_Horario chh ON c.id_chofer = chh.id_chofer
JOIN Horario h ON chh.id_horario = h.id_horario
JOIN Ruta r ON r.id_ruta = 1;

SELECT r.origen, COUNT(vr.id_vehiculo) AS cantidad_vehiculos
FROM Ruta r
JOIN Vehiculo_Ruta vr ON r.id_ruta = vr.id_ruta
GROUP BY r.origen;

-- 5 subconsultas

SELECT nombre 
FROM Chofer 
WHERE id_chofer = (
    SELECT MAX(id_chofer) 
    FROM Chofer
);

SELECT modelo 
FROM Vehiculo 
WHERE id_vehiculo = (
    SELECT id_vehiculo 
    FROM Vehiculo_Ruta 
    WHERE id_ruta = 2
);

SELECT origen 
FROM Ruta 
WHERE id_ruta = (
    SELECT id_ruta 
    FROM Vehiculo_Ruta 
    GROUP BY id_ruta 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

SELECT nombre 
FROM Empresa 
WHERE id_empresa = (
    SELECT MAX(id_empresa) 
    FROM Empresa
);
    
SELECT nombre 
FROM Chofer 
WHERE id_chofer IN (
    SELECT id_chofer 
    FROM Chofer_Horario 
    WHERE turno = 'Mañana'
);


DELIMITER //
CREATE FUNCTION fn_total_vehiculos() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Vehiculo;
  RETURN total;
END;//

CREATE FUNCTION fn_total_choferes() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Chofer;
  RETURN total;
END;//

CREATE FUNCTION fn_total_empresas() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Empresa;
  RETURN total;
END;//

CREATE FUNCTION fn_nombre_chofer(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(100);
  SELECT nombre INTO nombre FROM Chofer WHERE id_chofer = pid;
  RETURN nombre;
END;//

CREATE FUNCTION fn_ruta_origen(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE origen VARCHAR(100);
  SELECT origen INTO origen FROM Ruta WHERE id_ruta = pid;
  RETURN origen;
END;//

CREATE FUNCTION fn_duracion_ruta(pid INT) RETURNS INT DETERMINISTIC
BEGIN
  DECLARE d INT;
  SELECT duracion INTO d FROM Ruta WHERE id_ruta = pid;
  RETURN d;
END;//

CREATE FUNCTION fn_horario_dia(pid INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
  DECLARE d VARCHAR(20);
  SELECT dia INTO d FROM Horario WHERE id_horario = pid;
  RETURN d;
END;//

CREATE FUNCTION fn_total_rutas() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Ruta;
  RETURN total;
END;//

CREATE FUNCTION fn_total_horarios() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Horario;
  RETURN total;
END;//

CREATE FUNCTION fn_turno_chofer(pid INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
  DECLARE turno VARCHAR(20);
  SELECT turno INTO turno FROM Chofer_Horario WHERE id_chofer = pid LIMIT 1;
  RETURN turno;
END;//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_insertar_ruta(
  IN porigen VARCHAR(100),
  IN pdestino VARCHAR(100),
  IN pduracion INT
)
BEGIN
  INSERT INTO Ruta(origen, destino, duracion) VALUES(porigen, pdestino, pduracion);
END;//
DELIMITER ;

DROP DATABASE transporte;

