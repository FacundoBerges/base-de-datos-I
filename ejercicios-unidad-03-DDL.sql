CREATE TABLE PROVEEDORES 
(	NUMERO INT,
	NOMBRE VARCHAR(20) NOT NULL,
	DOMICILIO VARCHAR(20),
	LOCALIDAD VARCHAR(20),
	PRIMARY KEY (NUMERO)
);

CREATE TABLE PRODUCTOS
(	PNRO INT,
	PNOMBRE VARCHAR(20) NOT NULL,
	PRECIO INT NOT NULL,
	TAMAÑO VARCHAR(20),
	LOCALIDAD VARCHAR(20),
	PRIMARY KEY (PNRO)
);

CREATE TABLE PROV_PROD
(	NUMERO INT,
	PNRO INT,
	CANTIDAD INT NOT NULL,
	PRIMARY KEY (NUMERO, PNRO),
	FOREIGN KEY (NUMERO) REFERENCES PROVEEDORES (NUMERO),
	FOREIGN KEY (PNRO) REFERENCES PRODUCTOS (PNRO)
);

INSERT INTO PROVEEDORES (NUMERO, NOMBRE, DOMICILIO, LOCALIDAD)
VALUES 	(101, 'Gómez', 'Nazca 920', 'Capital Federal'),
		(102, 'Pérez', 'Argerich 1030', 'Capital Federal'),
		(103, 'Vázquez', 'Sarmiento 450', 'Ramos Mejia'),
		(104, 'López', 'Alsina 720', 'Avellaneda'),
		(105, 'Juarez', 'San Martín 122', 'Wilde'),
		(106, 'Dominguez', 'Perón 241', 'Florencio Varela');

--(PNRO, PNOMBRE, PRECIO, TAMAÑO, LOCALIDAD) implicito
INSERT INTO PRODUCTOS 
VALUES 	(001, 'Talco', 500, 'Chico', 'Capital Federal'),
		(002, 'Talco', 700, 'Mediano', 'Capital Federal'),
		(003, 'Crema', 3500, 'Grande', 'Ramos Mejia'),
		(004, 'Cepillo', 2500, 'Grande', 'Avellaneda'),
		(005, 'Esmalte', 1200, 'Normal', 'Chacarita');


INSERT INTO PROV_PROD (NUMERO, PNRO, CANTIDAD)
VALUES 	(101, 001, 300),
		(101, 002, 200),
		(101, 003, 400),
		(101, 004, 200),
		(101, 005, 100),
		(102, 001, 300),
		(102, 002, 400),
		(103, 002, 200),
		(104, 002, 200),
		(104, 004, 300);

-- 1) Crear una vista formada por los números de proveedores y números de productos situados en diferentes localidades.

CREATE VIEW V_NRO_PROV_NRO_PROD_DIF_LOCALIDADES AS (	
	SELECT PROV.NUMERO, PROD.PNRO
	FROM PROVEEDORES PROV, PRODUCTOS PROD
	WHERE PROV.LOCALIDAD <> PROD.LOCALIDAD
	ORDER BY PROV.NUMERO
);

SELECT *
FROM V_NRO_PROV_NRO_PROD_DIF_LOCALIDADES;

-- 2) Agregar la columna IMPORTADOR a la tabla productos.

ALTER TABLE PRODUCTOS ADD COLUMN IMPORTADOR VARCHAR(20);

SELECT *
FROM PRODUCTOS;

-- 3) Crear una vista formada por los registros de los proveedores que viven en Wilde.

CREATE VIEW V_PROVEEDORES_WILDE AS (	
	SELECT *
	FROM PROVEEDORES P
	WHERE UPPER(P.LOCALIDAD) = 'WILDE'
);

SELECT *
FROM V_PROVEEDORES_WILDE;

-- 4) Crear las tablas departamentos y empleados con sus relaciones, y las tablas pacientes y medicamentos con sus relaciones.

-- Departamentos
CREATE TABLE DEPARTAMENTOS
(	ID INT AUTO_INCREMENT,
	NOMBRE VARCHAR(20),
	PRIMARY KEY (ID)
);

INSERT INTO DEPARTAMENTOS (NOMBRE)
VALUES 	('IT'),
		('RRHH'),
		('Ventas');

-- Empleados
CREATE TABLE EMPLEADOS
(	ID INT AUTO_INCREMENT,
	NOMBRE VARCHAR(20) NOT NULL,
	APELLIDO VARCHAR(20) NOT NULL,
	DIRECCION VARCHAR(20),
	LOCALIDAD VARCHAR(20),
	ID_DEPTO INT NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (ID_DEPTO) REFERENCES DEPARTAMENTOS (ID)
);

INSERT INTO EMPLEADOS (NOMBRE, APELLIDO, DIRECCION, LOCALIDAD, ID_DEPTO)
VALUES 	('Raul', 'Gómez', 'Nazca 920', 'Capital Federal', 1),
		('Juana', 'Pérez', 'Argerich 1030', 'Capital Federal', 2),
		('Rodrigo', 'Vázquez', 'Sarmiento 450', 'Ramos Mejia', 3),
		('David', 'López', 'Alsina 720', 'Avellaneda', 1),
		('Romina', 'Juarez', 'San Martín 122', 'Wilde', 2),
		('Fernanda', 'Dominguez', 'Perón 241', 'Florencio Varela', 1),
		('María', 'Fernandez', 'Rosas 295', 'Wilde', 3);


-- Medicamentos
CREATE TABLE MEDICAMENTOS
(	ID INT AUTO_INCREMENT,
	NOMBRE VARCHAR(25),
	PRIMARY KEY (ID)
);

INSERT INTO MEDICAMENTOS (NOMBRE)
VALUES 	('Paracetamol'),
		('Omeprazol'),
		('Salbutamol'),
		('Omeprazol'),
		('Aspirina'),
		('Ibuprofeno');

-- Pacientes
CREATE TABLE PACIENTES
(	ID_PACIENTE INT AUTO_INCREMENT,
	APELLIDO_NOMBRE VARCHAR(30) NOT NULL,
	DIRECCION VARCHAR(20),
	LOCALIDAD VARCHAR(20),
	PRIMARY KEY (ID_PACIENTE) 
);

INSERT INTO PACIENTES (APELLIDO_NOMBRE, DIRECCION, LOCALIDAD)
VALUES 	('Gómez, Raul', 'Nazca 920', 'Capital Federal'),
		('Martínez, Joaquín', 'Nazca 920', 'Capital Federal'),
		('Pérez, Juana', 'Argerich 1030', 'Capital Federal'),
		('Vázquez, Rodrigo', 'Sarmiento 450', 'Ramos Mejia'),
		('López, David', 'Alsina 720', 'Avellaneda'),
		('Juarez, Romina', 'San Martín 122', 'Wilde'),
		('Dominguez, Fernanda', 'Perón 241', 'Florencio Varela'),
		('Fernandez, María', 'Rosas 295', 'Wilde');

CREATE TABLE CANTIDAD_DOSIS_MEDICAMENTOS_POR_PACIENTES
(	ID_PACIENTE INT,
	ID_MEDICAMENTO INT,
	DOSIS_DIARIA INT NOT NULL,
	PRIMARY KEY (ID_PACIENTE, ID_MEDICAMENTO),
	FOREIGN KEY (ID_PACIENTE) REFERENCES PACIENTES (ID_PACIENTE),
	FOREIGN KEY (ID_MEDICAMENTO) REFERENCES MEDICAMENTOS (ID)
);

INSERT INTO CANTIDAD_DOSIS_MEDICAMENTOS_POR_PACIENTES (ID_PACIENTE, ID_MEDICAMENTO, DOSIS_DIARIA)
VALUES 	(1, 1, 1),
		(1, 2, 1),
		(2, 3, 2),
		(3, 6, 3),
		(4, 2, 1),
		(4, 5, 2),
		(4, 4, 1),
		(5, 4, 2),
		(6, 5, 1),
		(6, 1, 2),
		(7, 6, 3);


DROP VIEW V_PROVEEDORES_WILDE;
DROP VIEW V_NRO_PROV_NRO_PROD_DIF_LOCALIDADES;

DROP TABLE PROV_PROD;
DROP TABLE PRODUCTOS;
DROP TABLE PROVEEDORES;

DROP TABLE EMPLEADOS;
DROP TABLE DEPARTAMENTOS;

DROP TABLE CANTIDAD_DOSIS_MEDICAMENTOS_POR_PACIENTES;
DROP TABLE MEDICAMENTOS;
DROP TABLE PACIENTES;