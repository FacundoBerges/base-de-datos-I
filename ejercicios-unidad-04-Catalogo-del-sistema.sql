--  Consultas a catálogo.

-- 1) Cuáles tablas contienen la columna LOCALIDAD?

SELECT DISTINCT C.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS C
WHERE UPPER(C.COLUMN_NAME) = 'LOCALIDAD';

--*
SELECT TBNAME
FROM SYSCOLUMNS
WHERE NAME = 'LOCALIDAD';

-- 2) Cuántas columnas tiene la tabla PRODUCTOS?

SELECT COUNT(*) AS CANTIDAD_COLUMNAS_EN_TABLA_PRODUCTOS
FROM INFORMATION_SCHEMA.COLUMNS C
WHERE UPPER(C.TABLE_NAME) = 'PRODUCTOS';

--*
SELECT COLCOUNT
FROM SYSTABLES
WHERE NAME = 'PRODUCTOS';

-- 3) Obtener una lista de todos los usuarios dueños de por lo menos una tabla, junto con el número de tablas que le pertenecen a cada uno.



--*
SELECT  CREATOR, 
        COUNT(*)
FROM SYSTABLES
GROUP BY CREATOR;

-- 4) Obtener una lista de los nombres de todas las tablas que tienen por lo menos un índice.

SELECT DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.STATISTICS
WHERE UPPER(TABLE_SCHEMA) = 'COURSE-DB';

--*
SELECT DISTINCT TBNAME
FROM SYSINDEXES;