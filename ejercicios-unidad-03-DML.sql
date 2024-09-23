-- EJERCICIOS DE TABLA 1

-- Realizar las siguientes proposiciones SQL con la siguiente estructura: 
--      PROVEEDORES (NUMERO, NOMBRE, DOMICILIO, LOCALIDAD) 
--      PRODUCTOS (PNRO, PNOMBRE, PRECIO, TAMAÑO, LOCALIDAD) 
--      PROV-PROD (NUMERO, PNRO, CANTIDAD)

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

CREATE TABLE PROV-PROD
(	NUMERO INT,
	PNRO INT,
	CANTIDAD INT NOT NULL,
	PRIMARY KEY (NUMERO, PNRO),
	FOREIGN KEY (NUMERO) REFERENCES PROVEEDORES (NUMERO),
	FOREIGN KEY (PNRO) REFERENCES PRODUCTOS (PNRO)
);

INSERT INTO PROVEEDORES (NUMERO, NOMBRE, DOMICILIO, LOCALIDAD)
VALUES 
	(101, 'Gómez', 'Nazca 920', 'Capital Federal'),
	(102, 'Pérez', 'Argerich 1030', 'Capital Federal'),
	(103, 'Vázquez', 'Sarmiento 450', 'Ramos Mejia'),
	(104, 'López', 'Alsina 720', 'Avellaneda'),
	(105, 'Juarez', 'San Martín 122', 'Wilde'),
	(106, 'Dominguez', 'Perón 241', 'Florencio Varela'),
	(107, 'Fernandez', 'Rosas 295', 'Wilde');

--(PNRO, PNOMBRE, PRECIO, TAMAÑO, LOCALIDAD) implicito
INSERT INTO PRODUCTOS 
VALUES 
	(001, 'Talco', 500, 'Chico', 'Capital Federal'),
	(002, 'Talco', 700, 'Mediano', 'Capital Federal'),
	(003, 'Crema', 3500, 'Grande', 'Ramos Mejia'),
	(004, 'Cepillo', 2500, 'Grande', 'Avellaneda'),
	(005, 'Esmalte', 1200, 'Normal', 'Chacarita');


INSERT INTO PROV-PROD (NUMERO, PNRO, CANTIDAD)
VALUES 
	(101, 001, 300),
	(101, 002, 200),
	(101, 003, 400),
	(101, 004, 200),
	(101, 005, 100),
	(102, 001, 300),
	(102, 002, 400),
	(103, 002, 200),
	(104, 002, 200),
	(104, 004, 300);


-- 1) Obtener los detalles completos de todos los productos. 

SELECT *
FROM PRODUCTOS;

-- 2) Obtener los detalles completos de todos los proveedores de Capital. 

SELECT *
FROM PROVEEDORES P
WHERE UPPER(P.LOCALIDAD) LIKE '%CAPITAL%';

-- 3) Obtener todos los envíos en los cuales la cantidad está entre 200 y 300 inclusive. 

SELECT *
FROM PROV-PROD PP
WHERE 	PP.CANTIDAD >= 200
	AND PP.CANTIDAD <= 300;

-- 4) Obtener los números de los productos suministrados por algún proveedor de Avellaneda. 

SELECT DISTINCT PROD.PNRO
FROM PRODUCTOS PROD, PROV-PROD PP, PROVEEDORES PROV
WHERE 	PROD.PNRO = PP.PNRO
	AND PROV.NUMERO = PP.NUMERO
	AND UPPER(PROV.LOCALIDAD) = 'AVELLANEDA';

-- 5) Obtener la cantidad total del producto 001 enviado por el proveedor 103. 

SELECT COUNT(PP.CANTIDAD)
FROM PROV-PROD PP
WHERE 	PP.NUMERO = 103
	AND PP.PNRO = 1;

-- 6) Obtener los números de los productos y localidades en los cuales la segunda letra del nombre de la localidad sea A. 

SELECT PROD.PNRO, PROD.LOCALIDAD
FROM PRODUCTOS PROD
WHERE UPPER(PROD.LOCALIDAD) LIKE '_A%';

-- 7) Obtener los precios de los productos enviados por el proveedor 102. 

SELECT PROD.PRECIO
FROM PRODUCTOS PROD, PROVEEDORES PROV, PROV-PROD PP
WHERE PROV.NUMERO = 102
	AND PROV.NUMERO = PP.NUMERO
	AND PP.PNRO = PROD.PNRO;

-- 8) Construir una lista de todas las localidades en las cuales esté situado por lo menos un proveedor o un producto. 

SELECT DISTINCT PROD.LOCALIDAD
FROM PRODUCTOS PROD
UNION
SELECT DISTINCT PROV.LOCALIDAD
FROM PROVEEDORES PROV;

-- 9) Cambiar a “Chico” el tamaño de todos los productos medianos. 

UPDATE PRODUCTOS PROD
SET PROD.TAMAÑO = 'Chico'
WHERE UPPER(PROD.TAMAÑO) = 'MEDIANO';

-- 10) Eliminar todos lo sproductos para los cuales no haya envíos. 
-- 11) Insertar un nuevo proveedor (107) en la tabla PROVEEDORES. El nombre y la localidad son Rosales y Wilde respectivamente; el domicilio no se conoce todavía. 

