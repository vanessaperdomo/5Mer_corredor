-- MER5 - Hospital

CREATE DATABASE hospital;
USE hospital;

CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    cedula VARCHAR(20),
    telefono VARCHAR(20)
);

CREATE TABLE Doctor (
    id_doctor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    hora TIME,
    id_paciente INT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
);

CREATE TABLE Sala (
    id_sala INT AUTO_INCREMENT PRIMARY KEY,
    numero INT,
    tipo VARCHAR(50)
);

CREATE TABLE Turno (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    dia VARCHAR(20),
    hora_inicio TIME,
    hora_fin TIME
);

CREATE TABLE Doctor_Turno (
    id_doctor INT,
    id_turno INT,
    PRIMARY KEY (id_doctor, id_turno),
    FOREIGN KEY (id_doctor) REFERENCES Doctor(id_doctor),
    FOREIGN KEY (id_turno) REFERENCES Turno(id_turno)
);

CREATE TABLE Cita_Sala (
    id_cita INT,
    id_sala INT,
    PRIMARY KEY (id_cita, id_sala),
    FOREIGN KEY (id_cita) REFERENCES Cita(id_cita),
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala)
);

INSERT INTO Paciente(nombre, cedula, telefono) VALUES
('Ana Torres', '12345678', '3101112233'),
('Luis Rojas', '87654321', '3112223344'),
('María Gómez', '11223344', '3123334455');

INSERT INTO Doctor(nombre, especialidad, telefono) VALUES
('Carlos Pérez', 'Cardiología', '3200001111'),
('Laura Ruiz', 'Pediatría', '3211112222'),
('Jorge Mora', 'Cirugía', '3222223333');

INSERT INTO Cita(fecha, hora, id_paciente) VALUES
('2025-06-01', '08:00:00', 1),
('2025-06-02', '10:00:00', 2),
('2025-06-03', '14:00:00', 3);

INSERT INTO Sala(numero, tipo) VALUES
(101, 'Consulta'),
(102, 'Emergencia'),
(103, 'Cirugía');

INSERT INTO Turno(dia, hora_inicio, hora_fin) VALUES
('Lunes', '07:00:00', '15:00:00'),
('Martes', '15:00:00', '23:00:00'),
('Miércoles', '23:00:00', '07:00:00');

INSERT INTO Doctor_Turno(id_doctor, id_turno) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Cita_Sala(id_cita, id_sala) VALUES
(1, 1),
(2, 2),
(3, 3);

UPDATE Paciente SET telefono = '3109998888' WHERE id_paciente = 2;
UPDATE Doctor SET especialidad = 'Neurología' WHERE id_doctor = 2;
UPDATE Cita SET hora = '11:00:00' WHERE id_cita = 1;
UPDATE Sala SET tipo = 'Terapia' WHERE id_sala = 2;
UPDATE Turno SET dia = 'Jueves' WHERE id_turno = 2;

DELETE FROM Cita_Sala      
WHERE id_cita = 3 AND id_sala = 3;

DELETE FROM Doctor_Turno   
WHERE id_doctor = 3 AND id_turno = 3;

DELETE FROM Cita          
WHERE id_cita = 3;

DELETE FROM Doctor         
WHERE id_doctor = 3;

DELETE FROM Paciente       
WHERE id_paciente = 3;

SELECT p.nombre, c.fecha, c.hora
FROM Paciente p
INNER JOIN Cita c ON p.id_paciente = c.id_paciente;

SELECT d.nombre, t.dia, t.hora_inicio
FROM Doctor d
LEFT JOIN Doctor_Turno dt ON d.id_doctor = dt.id_doctor
LEFT JOIN Turno t ON dt.id_turno = t.id_turno;

SELECT t.dia, d.nombre
FROM Doctor_Turno dt
RIGHT JOIN Turno t ON dt.id_turno = t.id_turno
RIGHT JOIN Doctor d ON dt.id_doctor = d.id_doctor;

SELECT c.id_cita, s.numero
FROM Cita c
LEFT JOIN Cita_Sala cs ON c.id_cita = cs.id_cita
LEFT JOIN Sala s ON cs.id_sala = s.id_sala
UNION
SELECT c.id_cita, s.numero
FROM Sala s
LEFT JOIN Cita_Sala cs ON s.id_sala = cs.id_sala
LEFT JOIN Cita c ON cs.id_cita = c.id_cita;

SELECT c.fecha, s.tipo
FROM Cita c
INNER JOIN Cita_Sala cs ON c.id_cita = cs.id_cita
INNER JOIN Sala s ON cs.id_sala = s.id_sala;

SELECT nombre FROM Paciente
WHERE id_paciente = (SELECT MAX(id_paciente) FROM Paciente);

SELECT especialidad FROM Doctor
WHERE id_doctor = (SELECT id_doctor FROM Doctor_Turno WHERE id_turno = 2);

SELECT tipo FROM Sala
WHERE id_sala = (SELECT id_sala FROM Cita_Sala WHERE id_cita = 2);

SELECT hora FROM Cita
WHERE id_paciente = (SELECT id_paciente FROM Paciente WHERE nombre = 'Ana Torres');

SELECT dia FROM Turno
WHERE id_turno = (SELECT MIN(id_turno) FROM Turno);

DELIMITER //

CREATE FUNCTION fn_total_pacientes() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Paciente;
  RETURN total;
END;//

CREATE FUNCTION fn_total_doctores() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Doctor;
  RETURN total;
END;//

CREATE FUNCTION fn_total_citas() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Cita;
  RETURN total;
END;//

CREATE FUNCTION fn_nombre_paciente(pid INT) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(100);
  SELECT nombre INTO nombre FROM Paciente WHERE id_paciente = pid;
  RETURN nombre;
END;//

CREATE FUNCTION fn_especialidad_doctor(pid INT) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
  DECLARE esp VARCHAR(50);
  SELECT especialidad INTO esp FROM Doctor WHERE id_doctor = pid;
  RETURN esp;
END;//

CREATE FUNCTION fn_dia_turno(pid INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
  DECLARE dia VARCHAR(20);
  SELECT dia INTO dia FROM Turno WHERE id_turno = pid;
  RETURN dia;
END;//

CREATE FUNCTION fn_tipo_sala(pid INT) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
  DECLARE tipo VARCHAR(50);
  SELECT tipo INTO tipo FROM Sala WHERE id_sala = pid;
  RETURN tipo;
END;//

CREATE FUNCTION fn_total_turnos() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Turno;
  RETURN total;
END;//

CREATE FUNCTION fn_total_salas() RETURNS INT DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Sala;
  RETURN total;
END;//

CREATE FUNCTION fn_telefono_paciente(pid INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
  DECLARE tel VARCHAR(20);
  SELECT telefono INTO tel FROM Paciente WHERE id_paciente = pid;
  RETURN tel;
END;//

CREATE PROCEDURE sp_insertar_cita(
  IN pfecha DATE,
  IN phora TIME,
  IN pid_paciente INT
)
BEGIN
  INSERT INTO Cita(fecha, hora, id_paciente)
  VALUES(pfecha, phora, pid_paciente);
END;//

DELIMITER ;

ALTER TABLE Doctor ADD COLUMN correo VARCHAR(20);
ALTER TABLE Doctor DROP COLUMN correo;

DROP TABLE Cita_Sala;
DROP TABLE Doctor_Turno;
DROP TABLE Turno;
DROP TABLE Sala;
DROP TABLE Cita;
DROP TABLE Doctor;
DROP TABLE Paciente;

DROP DATABASE hospital;
