CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;

DROP TABLE IF EXISTS Historial_Laboral;
DROP TABLE IF EXISTS Historial_Salarial;
DROP TABLE IF EXISTS Trabajos;
DROP TABLE IF EXISTS Estudios;
DROP TABLE IF EXISTS Universidades;
DROP TABLE IF EXISTS Departamentos;
DROP TABLE IF EXISTS Empleados;

CREATE TABLE Empleados
(
DNI CHAR(9),
Nombre VARCHAR(10) NOT NULL,
Apellido1 VARCHAR(15) NOT NULL,
Apellido2 VARCHAR(15),
Direcc1 VARCHAR(25),
Direcc2 VARCHAR(20),
Ciudad VARCHAR(20),
Municipio VARCHAR(20),
Cod_Postal VARCHAR(5),
Sexo ENUM('H','M','O'),
Fecha_Nac DATE,
CONSTRAINT Empleados_DNI_pk PRIMARY KEY(DNI)
);

CREATE TABLE Departamentos
(
Dpto_Cod DECIMAL(5),
Nombre_Dpto VARCHAR(30) NOT NULL UNIQUE,
Jefe CHAR(9),
Presupuesto INT NOT NULL,
Pres_Actual INT,
CONSTRAINT Departamentos_Dept_Cod_pk PRIMARY KEY(Dpto_Cod),
CONSTRAINT Departamentos_Jefe_fk FOREIGN KEY (Jefe) 
	REFERENCES Empleados(DNI) ON UPDATE CASCADE
);

CREATE TABLE Universidades
(
Univ_Cod DECIMAL(5),
Nombre_Univ VARCHAR(25) NOT NULL,
Ciudad VARCHAR(20),
Municipio VARCHAR(20),
Cod_Postal VARCHAR(5),
CONSTRAINT Universidades_Univ_Cod_pk PRIMARY KEY (Univ_Cod)
);

CREATE TABLE Estudios
(
Empleado_DNI CHAR(9),
Universidad DECIMAL(5) NOT NULL,
Año SMALLINT,
Grado VARCHAR(3),
Especialidad VARCHAR(20),
CONSTRAINT Estudios_Empleado_DNI_pk 
	PRIMARY KEY (Empleado_DNI, Grado, Especialidad),
CONSTRAINT Estudios_Universidad_fk 
	FOREIGN KEY (Universidad) REFERENCES Universidades(Univ_Cod) 
    ON UPDATE CASCADE,
CONSTRAINT Estudios_Empleado_DNI_fk 
	FOREIGN KEY (Empleado_DNI) REFERENCES Empleados(DNI) 
		ON UPDATE CASCADE
);

CREATE TABLE Trabajos
(
Codigo DECIMAL(5),
Nombre VARCHAR(20) NOT NULL,
Salario_Min DECIMAL(4) NOT NULL,
Salario_Max DECIMAL(4) NOT NULL,
CONSTRAINT Trabajos_Nombre_uu UNIQUE (Nombre),
CONSTRAINT Trabajos_Codigo_pk PRIMARY KEY(Codigo)
);

CREATE TABLE Historial_Laboral
(
Empleado_DNI CHAR(9),
Trabajo_Cod DECIMAL(5),
Fecha_Inicio DATE,
Fecha_Fin DATE,
Dpto_Cod DECIMAL(5),
Supervisor_DNI CHAR(9),
CONSTRAINT H_Labl_Fechas_ck 
	CHECK (Fecha_Inicio<=Fecha_Fin or Fecha_Fin IS NULL),
CONSTRAINT H_Labl_Empleado_pk 
	PRIMARY KEY(Empleado_DNI,Fecha_Inicio),
CONSTRAINT H_Labl_Empleado_fk 
	FOREIGN KEY (Empleado_DNI) REFERENCES Empleados(DNI) 
		ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT H_Labl_Trabajo_Cod_fk 
	FOREIGN KEY (Trabajo_Cod) REFERENCES Trabajos(Codigo) 
		ON UPDATE CASCADE,
CONSTRAINT H_Labl_Dept_Cod_fk 
	FOREIGN KEY (Dpto_Cod) REFERENCES Departamentos(Dpto_Cod) 
		ON UPDATE CASCADE,
CONSTRAINT H_Labl_Supervisor_fk FOREIGN KEY (Supervisor_DNI) 
	REFERENCES Empleados(DNI) ON UPDATE CASCADE
);

CREATE TABLE Historial_Salarial
(
Empleado_DNI CHAR(9),
Salario INT NOT NULL,
Fecha_Comienzo DATE,
Fecha_Fin DATE,
CONSTRAINT H_Salarial_Fechas_ck 
	CHECK (Fecha_Comienzo<=Fecha_Fin OR Fecha_Fin IS NULL),
CONSTRAINT Historial_Salarial_Empleado_pk 
	PRIMARY KEY(Empleado_DNI,Fecha_Comienzo),
CONSTRAINT Historial_Salarial_Empleado_fk 
	FOREIGN KEY (Empleado_DNI) REFERENCES Empleados(DNI) 
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX trabajo_Nombre ON TRABAJOS(Nombre ASC);
CREATE INDEX empleados_Alfab ON EMPLEADOS(Apellido1 ASC,
	Apellido2 ASC, Nombre ASC);
    
ALTER TABLE HISTORIAL_LABORAL ADD 
	FOREIGN KEY (EMPLEADO_DNI, FECHA_INICIO) REFERENCES
		HISTORIAL_SALARIAL(EMPLEADO_DNI, FECHA_COMIENZO)
			ON UPDATE CASCADE ON DELETE CASCADE