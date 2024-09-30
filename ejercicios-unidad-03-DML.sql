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

--! Entregue con COUNT y era SUM.
SELECT SUM(ENVIOS.CANTIDAD)
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

--! Correccion del profesor 
SELECT DISTINCT PROD.PRECIO
FROM PRODUCTOS PROD, PROV_PROD ENVIOS
WHERE ENVIOS.NUMERO = 102
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

DELETE 
FROM PRODUCTOS P
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

SELECT MAX(CANTIDAD) AS CANTIDAD
FROM ITEM_VENTAS;

-- 2. Obtener la cantidad total de unidades vendidas del producto c. 

SELECT SUM(CANTIDAD) AS TOTAL
FROM ITEM_VENTAS
WHERE CÓDIGO_PRODUCTO = 3;

-- 3. Cantidad de unidades vendidas por producto, indicando la descripción del producto, ordenado de mayor a menor por las cantidades vendidas.  

SELECT 	SUM(I.CANTIDAD) AS CANTIDAD, 
		P.NOMBRE_PRODUCTO AS DESCRIPCION_PRODUCTO 
FROM ITEM_VENTAS I
JOIN PRODUCTOS P ON I.CÓDIGO_PRODUCTO = P.CÓDIGO_PRODUCTO
GROUP BY P.CÓDIGO_PRODUCTO
ORDER BY SUM(I.CANTIDAD) DESC;

-- 4. Cantidad de unidades vendidas por producto, indicando la descripción del producto, ordenado alfabéticamente por nombre de producto para los productos que vendieron más de 30 unidades.  

SELECT 	SUM(I.CANTIDAD) AS CANTIDAD, 
		P.NOMBRE_PRODUCTO AS  DESCRIPCION_PRODUCTO 
FROM ITEM_VENTAS I
JOIN PRODUCTOS P ON I.CÓDIGO_PRODUCTO = P.CÓDIGO_PRODUCTO
GROUP BY P.CÓDIGO_PRODUCTO
HAVING CANTIDAD > 30
ORDER BY DESCRIPCION_PRODUCTO ASC;

-- 5. Obtener cuantas compras (1 factura = 1 compra) realizó cada cliente indicando el código y nombre del cliente ordenado de mayor a menor.  

SELECT 	COUNT(V.NÚMERO_FACTURA) AS CANTIDAD_COMPRAS, 
		V.CÓDIGO_CLIENTE AS CÓDIGO_CLIENTE, 
		C.NOMBRE AS NOMBRE_CLIENTE
FROM VENTAS V
JOIN CLIENTES C ON V.CÓDIGO_CLIENTE = C.CÓDIGO_CLIENTE
GROUP BY V.CÓDIGO_CLIENTE
ORDER BY C.NOMBRE DESC;

-- 6. Promedio de unidades vendidas por producto, indicando el código del producto para el cliente 1. 

SELECT 	P.CÓDIGO_PRODUCTO AS CÓDIGO_PRODUCTO, 
		AVG(I.CANTIDAD) AS PROMEDIO_UNIDADES_VENDIDAS
FROM ITEM_VENTAS I
JOIN PRODUCTOS P ON I.CÓDIGO_PRODUCTO = P.CÓDIGO_PRODUCTO
WHERE I.NÚMERO_FACTURA IN (
	SELECT V.NÚMERO_FACTURA
	FROM VENTAS V
	WHERE V.CÓDIGO_CLIENTE = 1
)
GROUP BY P.CÓDIGO_PRODUCTO;


DROP TABLE ITEM_VENTAS;
DROP TABLE VENTAS;
DROP TABLE PRODUCTOS;
DROP TABLE CLIENTES;


-- EJERCICIOS DE TABLA 3 

-- Se tiene la siguiente base de datos relacional:
-- 		Documentos (cod_documento, descripción)
--		Oficinas (cod_oficina, codigo_director, descripcion)
-- 		Empleados (cod_empleado, apellido, nombre, fecha_nacimiento, num_doc, cod_jefe, cod_oficina, cod_documento)
--		Datos_contratos (cod_empleado, fecha_contrato, cuota, ventas) 
-- 		Fabricantes (cod_fabricante, razón_social) 
-- 		Listas (cod_lista, descripción, ganancia) 
-- 		Productos (cod_producto, descripcion, precio, cantidad_stock, punto_reposición, cod_fabricante) 
-- 		Precios (cod_producto, cod_lista, precio) 
-- 		Clientes (cod_cliente, cod_lista, razón_social) 
-- 		Pedidos (cod_pedido, fecha_pedido, cod_empleado, cod_cliente) 
-- 		Detalle_pedidos (cod_pedido, numero_linea, cod_producto, cantidad) 

CREATE TABLE DOCUMENTOS
(	COD_DOCUMENTO INT,
	DESCRIPCION VARCHAR(25) NOT NULL,
	PRIMARY KEY (COD_DOCUMENTO)
);

CREATE TABLE OFICINAS
(	COD_OFICINA INT,
	CODIGO_DIRECTOR INT,
	DESCRIPCION VARCHAR(25) NOT NULL,
	PRIMARY KEY (COD_OFICINA)
);

CREATE TABLE EMPLEADOS
(	COD_EMPLEADO INT,
	APELLIDO VARCHAR(25) NOT NULL,
	NOMBRE VARCHAR(25) NOT NULL,
	FECHA_NACIMIENTO DATE,
	NUM_DOC VARCHAR(10),
	COD_JEFE INT,
	COD_OFICINA INT NOT NULL,
	COD_DOCUMENTO INT NOT NULL,
	PRIMARY KEY (COD_EMPLEADO),
	FOREIGN KEY (COD_DOCUMENTO) REFERENCES DOCUMENTOS (COD_DOCUMENTO),
	FOREIGN KEY (COD_OFICINA) REFERENCES OFICINAS (COD_OFICINA)
);

CREATE TABLE DATOS_CONTRATOS
(	COD_EMPLEADO INT,
	FECHA_CONTRATO DATE,
	CUOTA INT,
	VENTAS INT,
	PRIMARY KEY (COD_EMPLEADO, FECHA_CONTRATO),
	FOREIGN KEY (COD_EMPLEADO) REFERENCES EMPLEADOS (COD_EMPLEADO)
);

CREATE TABLE FABRICANTES
(	COD_FABRICANTE INT,
	RAZON_SOCIAL VARCHAR(25) NOT NULL,
	PRIMARY KEY (COD_FABRICANTE)
);

CREATE TABLE LISTAS
(	COD_LISTA INT,
	DESCRIPCION VARCHAR(25) NOT NULL,
	GANANCIA DECIMAL(10,2),
	PRIMARY KEY (COD_LISTA)
);

CREATE TABLE PRODUCTOS
(	COD_PRODUCTO INT,
	DESCRIPCION VARCHAR(25) NOT NULL,
	PRECIO DECIMAL(10,2),
	CANTIDAD_STOCK INT,
	PUNTO_REPOSICION INT,
	COD_FABRICANTE INT,
	PRIMARY KEY (COD_PRODUCTO),
	FOREIGN KEY (COD_FABRICANTE) REFERENCES FABRICANTES (COD_FABRICANTE)
);

CREATE TABLE PRECIOS
(	COD_PRODUCTO INT,
	COD_LISTA INT,
	PRECIO DECIMAL(10,2),
	PRIMARY KEY (COD_PRODUCTO, COD_LISTA),
	FOREIGN KEY (COD_PRODUCTO) REFERENCES PRODUCTOS (COD_PRODUCTO),
	FOREIGN KEY (COD_LISTA) REFERENCES LISTAS (COD_LISTA)
);

CREATE TABLE CLIENTES
(	COD_CLIENTE INT,
	COD_LISTA INT NOT NULL,
	RAZON_SOCIAL VARCHAR(25) NOT NULL,
	PRIMARY KEY (COD_CLIENTE),
	FOREIGN KEY (COD_LISTA) REFERENCES LISTAS (COD_LISTA)
);

CREATE TABLE PEDIDOS
(	COD_PEDIDO INT,
	FECHA_PEDIDO DATE NOT NULL,
	COD_EMPLEADO INT,
	COD_CLIENTE INT,
	PRIMARY KEY (COD_PEDIDO),
	FOREIGN KEY (COD_EMPLEADO) REFERENCES EMPLEADOS (COD_EMPLEADO),
	FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTES (COD_CLIENTE)
);

CREATE TABLE DETALLE_PEDIDOS
(	COD_PEDIDO INT,
	NUMERO_LINEA INT,
	COD_PRODUCTO INT,
	CANTIDAD INT,
	PRIMARY KEY (COD_PEDIDO, NUMERO_LINEA),
	FOREIGN KEY (COD_PEDIDO) REFERENCES PEDIDOS (COD_PEDIDO),
	FOREIGN KEY (COD_PRODUCTO) REFERENCES PRODUCTOS (COD_PRODUCTO)
);


INSERT INTO DOCUMENTOS (COD_DOCUMENTO, DESCRIPCION) 
VALUES 	(1, 'Factura de compra'),
		(2, 'Contrato de servicios'),
		(3, 'Informe de auditoría'),
		(4, 'Presupuesto de gastos'),
		(5, 'Plan de negocios');

INSERT INTO OFICINAS (COD_OFICINA, CODIGO_DIRECTOR, DESCRIPCION)
VALUES	(1, 6, 'Ventas'),
		(2, 19, 'Recursos Humanos'),
		(3, 4, 'Marketing'),
		(4, 16, 'Finanzas'),
		(5, 12, 'Innovación'),
		(6, 8, 'Proyectos'),
		(7, 17, 'Calidad'),
		(8, NULL, 'Logística'),
		(9, 20, 'Tecnología'),
		(10, 11, 'Administración');

INSERT INTO EMPLEADOS (COD_EMPLEADO, APELLIDO, NOMBRE, FECHA_NACIMIENTO, NUM_DOC, COD_JEFE, COD_OFICINA, COD_DOCUMENTO)
VALUES	(1, 'Leftley', 'Sophi', '1988-10-07', 25828801, 42, 10, 4),
		(2, 'Mallows', 'Adoree', '1990-12-04', 47900101, 40, 10, 3),
		(3, 'Gothard', 'Gwyneth', '1989-01-23', 15044899, 45, 7, 2),
		(4, 'Beckinsall', 'Aindrea', '1993-03-22', 21190722, 42, 6, 1),
		(5, 'Garwell', 'Nels', '1973-05-21', 29472012, 38, 10, 5),
		(6, 'MacWhan', 'Kerri', '1991-07-19', 41890364, 33, 8, 3),
		(7, 'Ledwidge', 'Faun', '1974-07-04', 34810419, 41, 3, 1),
		(8, 'Duckham', 'Jase', '1989-05-21', 41206783, 24, 7, 2),
		(9, 'Fawcus', 'Corly', '1980-09-11', 6120041, 44, 7, 1),
		(10, 'Pinn', 'Kaia', '1972-01-25', 34949095, 41, 5, 2),
		(11, 'Gómez', 'María', '1989-05-21', 41206783, 24, 7, 2),
		(12, 'Fernández', 'María', '1980-09-11', 6120041, 44, 7, 1),
		(13, 'López', 'María', '1972-01-25', 34949095, 41, 5, 2);

INSERT INTO DATOS_CONTRATOS (COD_EMPLEADO, FECHA_CONTRATO, CUOTA, VENTAS)
VALUES	(1, '2023-03-29', 14, 6),
		(2, '2022-06-19', 25, 9),
		(3, '2023-09-23', 26, 2),
		(4, '2023-09-01', 31, 6),
		(5, '2023-10-19', 25, 1),
		(6, '2022-06-30', 3, 2),
		(7, '2022-01-17', 1, 6),
		(8, '2020-10-18', 23, 1),
		(9, '2022-06-28', 7, 10),
		(10, '2022-01-23', 32, 5);

INSERT INTO FABRICANTES (COD_FABRICANTE, RAZON_SOCIAL)
VALUES	(1, 'Kreiger Inc'),
		(2, 'Johnson Inc'),
		(3, 'Hodkiewicz Inc'),
		(4, 'O Keefe-Cormier'),
		(5, 'Roberts Inc'),
		(6, 'Klein-Hauck'),
		(7, 'Fadel LLC'),
		(8, 'Runolfs, Stamm and Bruen'),
		(9, 'McDermott LLC'),
		(10, 'Kshlerin, Huels and Grant');

INSERT INTO LISTAS (COD_LISTA, DESCRIPCION, GANANCIA)
VALUES	(1, 'Descripción 1', 15947.78),
		(2, 'Descripción 2', 24538.29),
		(3, 'Descripción 3', 85361.62),
		(4, 'Descripción 4', 60826.34),
		(5, 'Descripción 5', 54519.53),
		(6, 'Descripción 6', 14541.9),
		(7, 'Descripción 7', 36383.85),
		(8, 'Descripción 8', 84778.79),
		(9, 'Descripción 9', 90314.71),
		(10, 'Descripción 10', 27335.35);

INSERT INTO PRODUCTOS (COD_PRODUCTO, DESCRIPCION, PRECIO, CANTIDAD_STOCK, PUNTO_REPOSICION, COD_FABRICANTE)
VALUES	(1, 'Laptop', 50901.4, 75, 4, 5),
		(2, 'Smartphone', 66954.33, 82, 5, 6),
		(3, 'Headphones', 83076.03, 89, 0, 2),
		(4, 'Camera', 35726.73, 81, 6, 8),
		(5, 'Tablet', 82769.27, 33, 4, 4),
		(6, 'Smartwatch', 53778.94, 84, 2, 6),
		(7, 'Speaker', 13181.93, 65, 7, 7),
		(8, 'Gaming Console', 93699.13, 27, 5, 7),
		(9, 'Fitness Tracker', 69087.87, 34, 6, 2),
		(10, 'Portable Charger', 17566.55, 15, 8, 10);

INSERT INTO PRECIOS (COD_PRODUCTO, COD_LISTA, PRECIO)
VALUES	(5, 10, 58486.62),
		(4, 5, 14574.83),
		(2, 6, 55144.91),
		(4, 6, 26740.07),
		(6, 4, 2494.85),
		(10, 9, 37306.85),
		(8, 5, 81675.06),
		(10, 7, 88685.0),
		(10, 5, 95686.19),
		(3, 6, 68582.25);

INSERT INTO CLIENTES (COD_CLIENTE, COD_LISTA, RAZON_SOCIAL)
VALUES	(1, 1, 'Dooley Group'),
		(2, 7, 'Schmitt-Ortiz'),
		(3, 4, 'Sauer-Gorczany'),
		(4, 9, 'Grimes-Reinger'),
		(5, 5, 'Feest, Cormier and Hickle'),
		(6, 2, 'Friesen, Metz and Boyer'),
		(7, 9, 'Hilpert-Beahan'),
		(8, 9, 'Leffler and Sons'),
		(9, 4, 'McKenzie-Kirlin'),
		(10, 3, 'Larson, Mills and Abshire');

INSERT INTO PEDIDOS (COD_PEDIDO, FECHA_PEDIDO, COD_EMPLEADO, COD_CLIENTE)
VALUES	(1, '2020-11-16', 4, 3),
		(2, '2022-07-17', 7, 7),
		(3, '2020-07-11', 9, 1),
		(4, '2021-09-14', 3, 9),
		(5, '2020-12-19', 1, 5),
		(6, '2020-12-11', 10, 5),
		(7, '2021-07-27', 9, 1),
		(8, '2022-05-08', 7, 10),
		(9, '2022-08-11', 3, 4),
		(10, '2021-01-08', 8, 2),
		(11, '2022-03-10', 2, 8),
		(12, '2024-02-08', 5, 2),
		(13, '2020-03-28', 8, 1);

INSERT INTO DETALLE_PEDIDOS (COD_PEDIDO, NUMERO_LINEA, COD_PRODUCTO, CANTIDAD)
VALUES	(9, 7, 9, 84),
		(1, 4, 2, 78),
		(6, 1, 1, 64),
		(5, 15, 2, 69),
		(10, 22, 4, 12),
		(9, 18, 1, 22),
		(2, 10, 5, 40),
		(10, 3, 5, 43),
		(2, 25, 1, 51),
		(7, 13, 7, 80);

-- Resolver las siguientes consultas utilizando sentencias SQL: 

--		Consultas simples (una sola tabla)

-- 1) Obtener una lista con los nombres de las distintas oficinas de la empresa. 

SELECT DISTINCT O.DESCRIPCION
FROM OFICINAS O;

-- 2) Obtener una lista de todos los productos indicando descripción del producto, su precio de costo y su precio de costo IVA incluído (tomar el IVA como 21%). 

SELECT 	P.DESCRIPCION AS DESCRIPCION_PRODUCTO, 
		P.PRECIO AS PRECIO_DE_COSTO, 
		TRUNCATE(P.PRECIO + P.PRECIO * 21/100, 2) AS PRECIO_CON_IVA
FROM PRODUCTOS P;

-- 3) Obtener una lista indicando para cada empleado apellido, nombre, fecha de cumpleaños y edad. 

SELECT 	E.APELLIDO AS APELLIDO,
		E.NOMBRE AS NOMBRE,
		CONCAT(DAY(E.FECHA_NACIMIENTO), '/', MONTH(E.FECHA_NACIMIENTO)) AS FECHA_DE_CUMPLEAÑOS,
		TIMESTAMPDIFF(YEAR, E.FECHA_NACIMIENTO, CURDATE()) AS EDAD
FROM EMPLEADOS E;

-- 4) Listar todos los empleados que tiene un jefe asignado.

SELECT * 
FROM EMPLEADOS E
WHERE E.COD_JEFE IS NOT NULL;

-- 5) Listar los empleados de nombre “María” ordenado por apellido.

SELECT *
FROM EMPLEADOS E
WHERE UPPER(E.NOMBRE) LIKE 'MARIA%'
ORDER BY E.APELLIDO;

-- 6) Listar los clientes cuya razón social comience con “L” ordenado por código de cliente.

SELECT *
FROM CLIENTES C
WHERE UPPER(C.RAZON_SOCIAL) LIKE 'L%'
ORDER BY C.COD_CLIENTE;

-- 7) Listar toda la información de los pedidos de Marzo ordenado por fecha de pedido.

SELECT *
FROM PEDIDOS P
WHERE MONTH(P.FECHA_PEDIDO) = 3
ORDER BY P.FECHA_PEDIDO;

-- 8) Listar las oficinas que no tienen asignado director.

SELECT *
FROM OFICINAS O
WHERE O.CODIGO_DIRECTOR IS NULL;

-- 9) Listar los 4 productos de menor precio de costo.

SELECT *
FROM PRODUCTOS P
ORDER BY P.PRECIO ASC
LIMIT 4;

-- 10) Listar los códigos de empleados de los tres que tengan la mayor cuota.

SELECT D.COD_EMPLEADO AS CODIGO_EMPLEADO
FROM DATOS_CONTRATOS D
ORDER BY D.CUOTA DESC
LIMIT 3;

--		Consultas multitablas

-- 1) De cada producto listar descripción, razón social del fabricante y stock ordenado por razón social y descripción.

SELECT 	P.DESCRIPCION AS DESCRIPCION, 
		F.RAZON_SOCIAL AS RAZON_SOCIAL,
		P.CANTIDAD_STOCK AS STOCK
FROM PRODUCTOS P
JOIN FABRICANTES F ON P.COD_FABRICANTE = F.COD_FABRICANTE
ORDER BY F.RAZON_SOCIAL, P.DESCRIPCION;

-- 2) De cada pedido listar código de pedido, fecha de pedido, apellido del empleado y razón social del cliente.

SELECT 	P.COD_PEDIDO AS CODIGO_PEDIDO,
		P.FECHA_PEDIDO AS FECHA_PEDIDO,
		E.APELLIDO AS APELLIDO_EMPLEADO,
		C.RAZON_SOCIAL AS RAZON_SOCIAL_CLIENTE
FROM PEDIDOS P
JOIN EMPLEADOS E ON P.COD_EMPLEADO = E.COD_EMPLEADO
JOIN CLIENTES C ON P.COD_CLIENTE = C.COD_CLIENTE;

-- 3) Listar por cada empleado apellido, cuota asignada, oficina a la que pertenece ordenado en forma descendente por cuota.

SELECT 	E.APELLIDO AS APELLIDO_EMPLEADO,
		D.CUOTA AS CUOTA_ASIGNADA,
		O.DESCRIPCION AS OFICINA
FROM EMPLEADOS E
JOIN OFICINAS O ON E.COD_OFICINA = O.COD_OFICINA
JOIN DATOS_CONTRATOS D ON E.COD_EMPLEADO = D.COD_EMPLEADO
ORDER BY CUOTA_ASIGNADA DESC;

-- 4) Listar sin repetir la razón social de todos aquellos clientes que hicieron pedidos en Abril.

SELECT DISTINCT C.RAZON_SOCIAL
FROM CLIENTES C
JOIN PEDIDOS P ON C.COD_CLIENTE = P.COD_CLIENTE
WHERE MONTH(P.FECHA_PEDIDO) = 4;

-- 5) Listar sin repetir los productos que fueron pedidos en Marzo.

SELECT DISTINCT PROD.DESCRIPCION AS PRODUCTO
FROM PRODUCTOS PROD
JOIN DETALLE_PEDIDOS D ON D.COD_PRODUCTO = PROD.COD_PRODUCTO
JOIN PEDIDOS PED ON PED.COD_PEDIDO = D.COD_PEDIDO
WHERE MONTH(PED.FECHA_PEDIDO) = 3;

-- 6) Listar aquellos empleados que están contratados por más de 10 años ordenado por cantidad de años en forma descendente.

SELECT *
FROM EMPLEADOS E
JOIN DATOS_CONTRATOS D ON E.COD_EMPLEADO = D.COD_EMPLEADO
WHERE TIMESTAMPDIFF(YEAR, D.FECHA_CONTRATO, CURDATE()) > 10
ORDER BY D.FECHA_CONTRATO;

-- 7) Obtener una lista de los clientes mayoristas ordenada por razón social.

SELECT C.RAZON_SOCIAL
FROM CLIENTES C
JOIN PEDIDOS P ON C.COD_CLIENTE = P.COD_CLIENTE
JOIN DETALLE_PEDIDOS D ON P.COD_PEDIDO = D.COD_PEDIDO
WHERE D.CANTIDAD > 50;

--! CORRECCION DEL PROFESOR
SELECT 	C.COD_CLIENTE,
		C.RAZON_SOCIAL,
		C.COD_LISTA
FROM CLIENTES C, LISTAS L
WHERE 	C.COD_LISTA = L.COD_LISTA
	AND UPPER(L.DESCRIPCION) = 'MAYORISTA'
ORDER BY C.RAZON_SOCIAL;

-- 8) Obtener una lista sin repetir que indique qué productos compró cada cliente, ordenada por razón social y descripción.

SELECT DISTINCT P.DESCRIPCION AS PRODUCTO,
				C.RAZON_SOCIAL AS CLIENTE
FROM PRODUCTOS P
JOIN DETALLE_PEDIDOS D ON P.COD_PRODUCTO = D.COD_PRODUCTO
JOIN PEDIDOS PE ON D.COD_PEDIDO = PE.COD_PEDIDO
JOIN CLIENTES C ON PE.COD_CLIENTE = C.COD_CLIENTE
ORDER BY C.RAZON_SOCIAL, P.DESCRIPCION;

-- 9) Obtener una lista con la descripción de aquellos productos cuyo stock está por debajo del punto de reposición indicando cantidad a comprar y razón social del fabricante ordenada por razón social y descripción.

SELECT 	P.DESCRIPCION,
		(P.PUNTO_REPOSICION - P.CANTIDAD_STOCK) AS CANTIDAD_A_COMPRAR,
		F.RAZON_SOCIAL AS RAZON_SOCIAL_FABRICANTE
FROM PRODUCTOS P
JOIN FABRICANTES F ON P.COD_FABRICANTE = F.COD_FABRICANTE
WHERE P.CANTIDAD_STOCK < P.PUNTO_REPOSICION
ORDER BY F.RAZON_SOCIAL, P.DESCRIPCION;

-- 10) Listar aquellos empleados cuya cuota es menor a 50000 o mayor a 100000.

SELECT *
FROM EMPLEADOS E
JOIN DATOS_CONTRATOS D ON E.COD_EMPLEADO = D.COD_EMPLEADO
WHERE D.CUOTA < 50000
	OR D.CUOTA > 100000;


DROP TABLE DETALLE_PEDIDOS;
DROP TABLE PEDIDOS;
DROP TABLE CLIENTES;
DROP TABLE PRECIOS;
DROP TABLE PRODUCTOS;
DROP TABLE LISTAS;
DROP TABLE FABRICANTES;
DROP TABLE DATOS_CONTRATOS;
DROP TABLE EMPLEADOS;
DROP TABLE OFICINAS;
DROP TABLE DOCUMENTOS;
