-- 1) Crear una vista para un usuario al cual se permite tener acceso a todos los registros de proveedores pero sin las situaciones. 
--      Luego asignarle permisos a un usuario sobre esa vista.

CREATE VIEW V_PROVEEDORES AS (
    SELECT ID_PROVEEDOR, NOMBRE, DIRECCION, TELEFONO, EMAIL
    FROM PROVEEDORES
);

GRANT SELECT ON V_PROVEEDORES TO USUARIO1;


-- 2) Crear una vista para un usuario al cual se permite tener acceso sólo a los registros de los proveedores situados en Avellaneda, sin las situaciones. 
--         Luego asignarle permisos a un usuario sobre esa vista.

CREATE VIEW V_PROVEEDORES_AVELLANEDA AS (
    SELECT ID_PROVEEDOR, NOMBRE, DIRECCION, TELEFONO, EMAIL
    FROM PROVEEDORES
    WHERE LOWER(DIRECCION) = 'avellaneda'
);

GRANT SELECT ON V_PROVEEDORES_AVELLANEDA TO usuario2;


-- 3) La tabla DATPERS se define así:  

CREATE TABLE DATPERS ( 
   IDENTUSUARIO  VARCHAR (8) 
   SEXO VARCHAR(1),
   DEPENDIENTES DECIMAL(2),
   OCUPACIÓN VARCHAR(20),
   SALARIO DECIMAL(7),
   IMPUESTO DECIMAL(7),
   AUDITORÍAS DECIMAL(2),
   PRIMARY KEY (IDENTUSUARIO)
);

-- Escribir proposiciones en SQL para conceder lo siguiente: 

CREATE PUBLIC SYNONYM DATPERS FOR ADMIN.DATPERS;

-- A) Al usuario Gómez, autorización de selección sobre toda la tabla.
GRANT SELECT ON DATPERS TO Gómez;

-- B) Al usuario López, autorización de inserción y eliminación sobre toda la tabla.
GRANT INSERT, DELETE ON DATPERS TO López;

-- C) Al usuario Sánchez, autorización de selección sobre toda la tabla y autoridad de actualización sobre los campos SALARIO e IMPUESTO (solamente).
GRANT SELECT, UPDATE (SALARIO, IMPUESTO) ON DATPERS TO Sánchez;

-- D) Al usuario Torres, autorización de selección sobre los campos IDENTUSUARIO, SALARIO e IMPUESTO (únicamente).
CREATE VIEW V_IDENTUSUARIO_SALARIO_IMPUESTO AS (
    SELECT IDENTUSUARIO, SALARIO, IMPUESTO
    FROM DATPERS
);

CREATE PUBLIC SYNONYM V_IDENTUSUARIO_SALARIO_IMPUESTO FOR ADMIN.V_IDENTUSUARIO_SALARIO_IMPUESTO;

GRANT SELECT ON V_IDENTUSUARIO_SALARIO_IMPUESTO TO Torres;

-- E) Al usuario  Pérez, autorización de selección igual a la de Torres y autorización de actualización sobre los campos Salario e Impuesto (solamente).
GRANT SELECT ON V_IDENTUSUARIO_SALARIO_IMPUESTO TO Pérez;
GRANT UPDATE (SALARIO, IMPUESTO) ON DATPERS TO Pérez;

-- F) Al usuario  Villalba, autorización de selección sobre los registros de predicadores (únicamente). (Predicadores es un tipo de ocupación).
CREATE VIEW V_PREDICADORES AS (
    SELECT IDENTUSUARIO, SEXO, DEPENDIENTES, OCUPACIÓN, SALARIO, IMPUESTO, AUDITORÍAS
    FROM DATPERS
    WHERE LOWER(OCUPACIÓN) = 'predicadores'
);

CREATE PUBLIC SYNONYM V_PREDICADORES FOR ADMIN.V_PREDICADORES;

GRANT SELECT ON V_PREDICADORES TO Villalba;

-- G) Al usuario  Giménez, autorización de selección igual a la de Torres y autoridad de actualización sobre los campos IMPUESTO y AUDITORIA (únicamente).
GRANT SELECT ON V_IDENTUSUARIO_SALARIO_IMPUESTO TO Giménez;
GRANT UPDATE (IMPUESTO, AUDITORÍAS) ON DATPERS TO Giménez;

-- H) Al usuario Aguero, autorización de selección sobre los salarios máximos y mínimos por clase de ocupación pero ninguna otra autorización.
CREATE VIEW V_SALARIOS_MAX_MIN AS (
    SELECT OCUPACIÓN, MAX(SALARIO) AS SALARIO_MAX, MIN(SALARIO) AS SALARIO_MIN
    FROM DATPERS
    GROUP BY OCUPACIÓN
);

CREATE PUBLIC SYNONYM V_SALARIOS_MAX_MIN FOR ADMIN.V_SALARIOS_MAX_MIN;

GRANT SELECT ON V_SALARIOS_MAX_MIN TO Aguero;