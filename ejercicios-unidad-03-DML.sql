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


-- 1) Obtener los detalles completos de todos los productos. 

SELECT *
FROM PRODUCTOS;

-- 2) Obtener los detalles completos de todos los proveedores de Capital. 

SELECT *
FROM PROVEEDORES P
WHERE UPPER(P.LOCALIDAD) LIKE 'CAPITAL%';

-- 3) Obtener todos los envíos en los cuales la cantidad está entre 200 y 300 inclusive. 

SELECT *
FROM PROV_PROD ENVIOS
WHERE 	ENVIOS.CANTIDAD >= 200
	AND ENVIOS.CANTIDAD <= 300;

-- 4) Obtener los números de los productos suministrados por algún proveedor de Avellaneda. 

SELECT DISTINCT PROD.PNRO
FROM PRODUCTOS PROD, PROV_PROD ENVIOS, PROVEEDORES PROV
WHERE 	PROD.PNRO = ENVIOS.PNRO
	AND PROV.NUMERO = ENVIOS.NUMERO
	AND UPPER(PROV.LOCALIDAD) = 'AVELLANEDA';

-- 5) Obtener la cantidad total del producto 001 enviado por el proveedor 103. 

SELECT COUNT(ENVIOS.CANTIDAD)
FROM PROV_PROD ENVIOS
WHERE 	ENVIOS.NUMERO = 103
	AND ENVIOS.PNRO = 1;

-- 6) Obtener los números de los productos y localidades en los cuales la segunda letra del nombre de la localidad sea A. 

SELECT PNRO, LOCALIDAD
FROM PRODUCTOS
WHERE UPPER(LOCALIDAD) LIKE '_A%';

-- 7) Obtener los precios de los productos enviados por el proveedor 102. 

SELECT PROD.PRECIO
FROM PRODUCTOS PROD, PROVEEDORES PROV, PROV_PROD ENVIOS
WHERE PROV.NUMERO = 102
	AND PROV.NUMERO = ENVIOS.NUMERO
	AND ENVIOS.PNRO = PROD.PNRO;

-- 8) Construir una lista de todas las localidades en las cuales esté situado por lo menos un proveedor o un producto. 

SELECT DISTINCT LOCALIDAD
FROM PRODUCTOS 
UNION
SELECT DISTINCT LOCALIDAD
FROM PROVEEDORES;

-- 9) Cambiar a “Chico” el tamaño de todos los productos medianos. 

UPDATE PRODUCTOS PROD
SET PROD.TAMAÑO = 'Chico'
WHERE UPPER(PROD.TAMAÑO) = 'MEDIANO';

-- 10) Eliminar todos los productos para los cuales no haya envíos. 

DELETE FROM PRODUCTOS P
WHERE P.PNRO NOT IN (
	SELECT DISTINCT ENVIOS.PNRO
	FROM PROV_PROD ENVIOS
);

-- 11) Insertar un nuevo proveedor (107) en la tabla PROVEEDORES. El nombre y la localidad son Rosales y Wilde respectivamente; el domicilio no se conoce todavía. 

INSERT INTO PROVEEDORES (NUMERO, NOMBRE, LOCALIDAD)
VALUES (107, 'Rosales', 'Wilde');


DROP TABLE PROV_PROD;
DROP TABLE PRODUCTOS;
DROP TABLE PROVEEDORES;


-- EJERCICIOS DE TABLA 2

-- Dadas las siguientes tablas: 
--      CLIENTES (código_cliente, nombre, domicilio, provincia)
--		PRODUCTOS (código_producto, nombre_producto)
--      ITEM_VENTAS (número_factura, código_producto, cantidad, precio)
--      VENTAS (número_factura, código_cliente, fecha)

CREATE TABLE CLIENTES
(	CÓDIGO_CLIENTE INT,
	NOMBRE VARCHAR(25) NOT NULL,
	DOMICILIO VARCHAR(25),
	PROVINCIA VARCHAR(25),
	PRIMARY KEY (CÓDIGO_CLIENTE)
);

CREATE TABLE PRODUCTOS
(	CÓDIGO_PRODUCTO INT,
	NOMBRE_PRODUCTO VARCHAR(20) NOT NULL,
	PRIMARY KEY (CÓDIGO_PRODUCTO)
);

CREATE TABLE VENTAS
(	NÚMERO_FACTURA INT,
	CÓDIGO_CLIENTE INT NOT NULL,
	FECHA DATE NOT NULL,
	PRIMARY KEY (NÚMERO_FACTURA),
	FOREIGN KEY (CÓDIGO_CLIENTE) REFERENCES CLIENTES (CÓDIGO_CLIENTE)
);

CREATE TABLE ITEM_VENTAS
(	NÚMERO_FACTURA INT,
	CÓDIGO_PRODUCTO INT,
	CANTIDAD INT NOT NULL,
	PRECIO DECIMAL(10, 2) NOT NULL,
	PRIMARY KEY (NÚMERO_FACTURA, CÓDIGO_PRODUCTO),
	FOREIGN KEY (NÚMERO_FACTURA) REFERENCES VENTAS (NÚMERO_FACTURA),
	FOREIGN KEY (CÓDIGO_PRODUCTO) REFERENCES PRODUCTOS (CÓDIGO_PRODUCTO)
);

INSERT INTO CLIENTES (CÓDIGO_CLIENTE, NOMBRE, DOMICILIO, PROVINCIA)
VALUES	(1, 'Thiago', 'Saavedra 567', 'Chaco'),
		(2, 'Mateo', 'Saavedra 567', 'Santa Fe'),
		(3, 'Valentina', 'Moreno 789', 'Salta'),
		(4, 'Emanuel', 'Moreno 789', 'Corrientes'),
		(5, 'Mia', 'Saavedra 567', 'Córdoba'),
		(6, 'Martín', 'San Martin 456', 'Tucumán'),
		(7, 'Mariana', 'Saavedra 567', 'Entre Ríos'),
		(8, 'Isabella', 'Belgrano 123', 'Tucumán'),
		(9, 'Lucas', 'Moreno 789', 'Chaco'),
		(10, 'Emma', 'Castelli 234', 'Córdoba');

INSERT INTO PRODUCTOS (CÓDIGO_PRODUCTO, NOMBRE_PRODUCTO)
VALUES	(1, 'Zanahoria'),
		(2, 'Papa'),
		(3, 'Tomate'),
		(4, 'Lechuga'),
		(5, 'Cebolla');

INSERT INTO VENTAS (NÚMERO_FACTURA, CÓDIGO_CLIENTE, FECHA)
VALUES 	(1, 1, '2023-11-24'),
		(2, 2, '2023-11-16'),
		(3, 3, '2024-05-10'),
		(4, 4, '2024-08-08'),
		(5, 5, '2023-12-02'),
		(6, 6, '2024-02-16'),
		(7, 7, '2024-07-14'),
		(8, 8, '2024-03-14'),
		(9, 9, '2023-10-22'),
		(10, 10, '2024-01-01');

INSERT INTO ITEM_VENTAS (NÚMERO_FACTURA, CÓDIGO_PRODUCTO, CANTIDAD, PRECIO)
VALUES	(1, 4, 7, 657.33),
		(2, 1, 5, 766.47),
		(3, 3, 2, 673.51),
		(4, 4, 6, 358.62),
		(5, 1, 5, 949.7),
		(6, 3, 5, 521.34),
		(7, 2, 3, 652.34),
		(8, 2, 1, 275.8),
		(9, 3, 1, 394.66),
		(10, 4, 7, 515.63),
		(2, 5, 31, 10235.33),
		(4, 2, 30, 15235.33);

-- Resolver las siguientes consultas: 

-- 1. Obtener la cantidad de unidades máxima.

SELECT MAX(CANTIDAD)
FROM ITEM_VENTAS;

-- 2. Obtener la cantidad total de unidades vendidas del producto c. 

SELECT SUM(CANTIDAD)
FROM ITEM_VENTAS
WHERE CÓDIGO_PRODUCTO = 3;

-- 3. Cantidad de unidades vendidas por producto, indicando la descripción del producto, ordenado de mayor a menor por las cantidades vendidas.  

SELECT SUM(I.CANTIDAD) AS CANTIDAD, P.NOMBRE_PRODUCTO AS DESCRIPCION_PRODUCTO 
FROM ITEM_VENTAS I
JOIN PRODUCTOS P ON I.CÓDIGO_PRODUCTO = P.CÓDIGO_PRODUCTO
GROUP BY P.CÓDIGO_PRODUCTO;

-- 4. Cantidad de unidades vendidas por producto, indicando la descripción del producto, ordenado alfabéticamente por nombre de producto para los productos que vendieron más de 30 unidades.  

SELECT SUM(I.CANTIDAD) AS CANTIDAD, P.NOMBRE_PRODUCTO AS  DESCRIPCION_PRODUCTO 
FROM ITEM_VENTAS I
JOIN PRODUCTOS P ON I.CÓDIGO_PRODUCTO = P.CÓDIGO_PRODUCTO
GROUP BY P.CÓDIGO_PRODUCTO
HAVING CANTIDAD > 30
ORDER BY DESCRIPCION_PRODUCTO ASC;

-- 5. Obtener cuantas compras (1 factura = 1 compra) realizó cada cliente indicando el código y nombre del cliente ordenado de mayor a menor.  

SELECT COUNT(V.NÚMERO_FACTURA) AS CANTIDAD_COMPRAS, V.CÓDIGO_CLIENTE AS CÓDIGO_CLIENTE, C.NOMBRE AS NOMBRE_CLIENTE
FROM VENTAS V
JOIN CLIENTES C ON V.CÓDIGO_CLIENTE = C.CÓDIGO_CLIENTE
GROUP BY V.CÓDIGO_CLIENTE
ORDER BY C.NOMBRE DESC;

-- 6. Promedio de unidades vendidas por producto, indicando el código del producto para el cliente 1. 

SELECT P.CÓDIGO_PRODUCTO AS CÓDIGO_PRODUCTO, AVG(I.CANTIDAD) AS PROMEDIO_UNIDADES_VENDIDAS
FROM ITEM_VENTAS I
JOIN PRODUCTOS P ON I.CÓDIGO_PRODUCTO = P.CÓDIGO_PRODUCTO
WHERE I.NÚMERO_FACTURA IN (
	SELECT V.NÚMERO_FACTURA
	FROM VENTAS V
	WHERE V.CÓDIGO_CLIENTE = 1
)
GROUP BY P.CÓDIGO_PRODUCTO;
