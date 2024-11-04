--  Crear el diagrama Entidad / Relación y transformarlo a tablas del modelo relacional.

-- ENTIDAD     ATRIBUTO 

-- Proyectos   código 
--             nombre 

-- Empleados   legajo 
--             nombre 

-- Relación    Asignado a 

-- a) Cardinalidad 1 : 1 
-- b) Cardinalidad 1 : N 
-- c) Cardinalidad N : N 

-- A)
CREATE TABLE proyectos (
    codigo INT,
    nombre VARCHAR(50) NOT NULL,
    codigo_empleado INT NOT NULL,
    CONSTRAINT PK_proyectos PRIMARY KEY (codigo),
    CONSTRAINT FK_empleado_proyecto FOREIGN KEY (codigo_empleado) REFERENCES empleados(legajo)
);

CREATE TABLE empleados (
    legajo INT,
    nombre VARCHAR(50),
    codigo_proyecto INT NOT NULL,
    CONSTRAINT pk_empleados PRIMARY KEY (legajo),
    CONSTRAINT fk_proyecto_empleado FOREIGN KEY (codigo_proyecto) REFERENCES proyectos(codigo)
);

-- B)
CREATE TABLE proyectos (
    codigo INT,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT PK_proyectos PRIMARY KEY (codigo)
);

CREATE TABLE empleados (
    legajo INT,
    nombre VARCHAR(50),
    codigo_proyecto INT NOT NULL,
    CONSTRAINT pk_empleados PRIMARY KEY (legajo),
    CONSTRAINT fk_proyecto_empleado FOREIGN KEY (codigo_proyecto) REFERENCES proyectos(codigo)
);

-- C)
CREATE TABLE proyectos (
    codigo INT,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT PK_proyectos PRIMARY KEY (codigo)
);

CREATE TABLE empleados (
    legajo INT,
    nombre VARCHAR(50),
    CONSTRAINT pk_empleados PRIMARY KEY (legajo),
    CONSTRAINT fk_proyecto_empleado FOREIGN KEY (codigo_proyecto) REFERENCES proyectos(codigo)
);

CREATE TABLE proyectos_empleados (
    legajo_empleado INT,
    codigo_proyecto INT,
    CONSTRAINT pk_asignado_a PRIMARY KEY (legajo_empleado, codigo_proyecto),
    CONSTRAINT fk_empleado_asignado_a FOREIGN KEY (legajo_empleado) REFERENCES empleados(legajo),
    CONSTRAINT fk_proyecto_asignado_a FOREIGN KEY (codigo_proyecto) REFERENCES proyectos(codigo)
);


-- 2. Crear el diagrama Entidad / Relación y transformarlo a tablas del modelo relacional. 
--     Entidades: 
--         a) Municipalidades 
--         b) Viviendas 
--         c) Personas 
--     Relaciones: 
--         a) Habita 
--         b) Empadronado en 
--         c) Propietario de 
--     Supuestos datos: 
--         a) Cada persona sólo puede habitar en una vivienda. 
--         b) Cada persona puede ser propietaria de más de una vivienda. 
--         c) Una persona está empadronada en una sola municipalidad.
--         d) En una vivienda pueden habitar más de una persona.
--         e) Una vivienda puede ser propiedad de más de una persona. 
--         f) Una vivienda pertenece a una sola municipalidad. 
--         g) Una municipalidad puede tener muchas viviendas. 
--         h) En una Municipalidad pueden estar empadronadas muchas personas. 

CREATE TABLE municipalidades (
    id INT,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT PK_municipalidades PRIMARY KEY (id)
);

CREATE TABLE viviendas (
    id INT,
    direccion VARCHAR(50) NOT NULL,
    id_municipalidad INT NOT NULL,
    CONSTRAINT PK_viviendas PRIMARY KEY (id),
    CONSTRAINT FK_municipalidad_vivienda FOREIGN KEY (id_municipalidad) REFERENCES municipalidades(id)
);

CREATE TABLE personas (
    dni INT,
    nombre VARCHAR(50) NOT NULL,
    id_vivienda INT NOT NULL,
    id_municipalidad INT NOT NULL,
    CONSTRAINT PK_personas PRIMARY KEY (dni),
    CONSTRAINT FK_vivienda_persona FOREIGN KEY (id_vivienda) REFERENCES viviendas(id),
    CONSTRAINT FK_municipalidad_persona FOREIGN KEY (id_municipalidad) REFERENCES municipalidades(id)
);

CREATE TABLE propietarios_viviendas (
    dni INT,
    id_vivienda INT,
    CONSTRAINT PK_propietarios_viviendas PRIMARY KEY (dni, id_vivienda),
    CONSTRAINT FK_persona_propietarios_viviendas FOREIGN KEY (dni) REFERENCES personas(dni),
    CONSTRAINT FK_vivienda_propietarios_viviendas FOREIGN KEY (id_vivienda) REFERENCES viviendas(id)
);


-- 3. Crear el diagrama Entidad / Relación y transformarlo a tablas del modelo relacional. 

-- ENTIDAD         ATRIBUTO 

-- Pacientes       Código_paciente 
--                 Apellido
--                 Dirección
--                 Fecha_nacimiento
--                 Sexo
--                 Localidad

-- Empleados       Código_empleado
--                 Apellido  
--                 Salario 
--                 Localidad 

-- Doctores        Código_doctor 
--                 Apellido 
--                 Localidad 

-- Salas           Código_sala  
--                 Nombre   
--                 Numero_de_camas 

-- Especialidades  Código_especialidad
--                 Nombre 

-- Funciones       Código_función   
--                 Nombre 

-- Turnos          Código_turno 
--                 Horario

-- Relaciones:
--     Supuestos datos: 
--         a) Un paciente puede estar internado en una sola sala.
--         b) Un paciente puede ser atendido por varios doctores.
--         c) En una sala puede haber muchos pacientes internados.
--         d) Un empleado puede tener asignado una sola función.
--         e) Un empleado puede trabajar en más de un turno.
--         f) Una función puede ser cumplida por más de un empleado.
--         g) Un doctor puede atender a más de un paciente.
--         h) Un doctor puede ejercer varias especialidades.
--         i) Un doctor puede trabajar en más de un turno.
--         j) Una especialidad puede ser ejercida por más de un doctor.
--         k) En un turno pueden trabajar más de un empleado.
--         l) En un turno pueden trabajar más de un doctor.

-- Turnos
CREATE TABLE turnos (
    codigo INT,
    horario TIME NOT NULL,
    CONSTRAINT PK_turnos PRIMARY KEY (codigo)
);

-- Funciones
CREATE TABLE funciones (
    codigo INT,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT PK_funciones PRIMARY KEY (codigo)
);

-- Especialidades
CREATE TABLE especialidades (
    codigo INT,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT PK_especialidades PRIMARY KEY (codigo)
);

-- Salas
CREATE TABLE salas (
    codigo INT,
    nombre VARCHAR(50) NOT NULL,
    numero_camas INT NOT NULL,
    CONSTRAINT PK_salas PRIMARY KEY (codigo)
);

-- Doctores
CREATE TABLE doctores (
    codigo INT,
    apellido VARCHAR(50) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    CONSTRAINT PK_doctores PRIMARY KEY (codigo)
);

-- Empleados
CREATE TABLE empleados (
    codigo INT,
    apellido VARCHAR(50) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    codigo_funcion INT NOT NULL,
    CONSTRAINT PK_empleados PRIMARY KEY (codigo),
    CONSTRAINT FK_funcion_empleado FOREIGN KEY (codigo_funcion) REFERENCES funciones(codigo)
);

-- Pacientes
CREATE TABLE pacientes (
    codigo INT,
    apellido VARCHAR(50) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    codigo_sala INT NOT NULL,
    CONSTRAINT PK_pacientes PRIMARY KEY (codigo),
    CONSTRAINT FK_sala_paciente FOREIGN KEY (codigo_sala) REFERENCES salas(codigo)
);

-- Relaciones
CREATE TABLE doctores_pacientes (
    codigo_doctor INT,
    codigo_paciente INT,
    CONSTRAINT PK_doctores_pacientes PRIMARY KEY (codigo_doctor, codigo_paciente),
    CONSTRAINT FK_doctor_doctores_pacientes FOREIGN KEY (codigo_doctor) REFERENCES doctores(codigo),
    CONSTRAINT FK_paciente_doctores_pacientes FOREIGN KEY (codigo_paciente) REFERENCES pacientes(codigo)
);

CREATE TABLE doctores_especialidades (
    codigo_doctor INT,
    codigo_especialidad INT,
    CONSTRAINT PK_doctores_especialidades PRIMARY KEY (codigo_doctor, codigo_especialidad),
    CONSTRAINT FK_doctor_doctores_especialidades FOREIGN KEY (codigo_doctor) REFERENCES doctores(codigo),
    CONSTRAINT FK_especialidad_doctores_especialidades FOREIGN KEY (codigo_especialidad) REFERENCES especialidades(codigo)
);

CREATE TABLE doctores_turnos (
    codigo_doctor INT,
    codigo_turno INT,
    CONSTRAINT PK_doctores_turnos PRIMARY KEY (codigo_doctor, codigo_turno),
    CONSTRAINT FK_doctor_doctores_turnos FOREIGN KEY (codigo_doctor) REFERENCES doctores(codigo),
    CONSTRAINT FK_turno_doctores_turnos FOREIGN KEY (codigo_turno) REFERENCES turnos(codigo)
);

CREATE TABLE empleados_turnos (
    codigo_empleado INT,
    codigo_turno INT,
    CONSTRAINT PK_empleados_turnos PRIMARY KEY (codigo_empleado, codigo_turno),
    CONSTRAINT FK_empleado_empleados_turnos FOREIGN KEY (codigo_empleado) REFERENCES empleados(codigo),
    CONSTRAINT FK_turno_empleados_turnos FOREIGN KEY (codigo_turno) REFERENCES turnos(codigo)
);


-- 4. Crear el diagrama Entidad / Relación y transformarlo a tablas del modelo relacional. 

-- El departamento de formación de una empresa desea construir una base de datos para planificar y gestionar la formación de sus empleados. 
-- La empresa organiza cursos internos de formación de los que desea conocer 
--      el código de curso, el nombre, una breve descripción, el número de horas de duración y el costo del curso. 
-- Un curso puede tener como prerequisito haber realizado otro(s) previamente. 
-- Un curso que es un prerequisito puede serlo de forma obligatoria o sólo recomendable. 
-- Un mismo curso puede ser impartido en diferentes lugares, fechas y con diferentes horarios (día entero, mañana, tarde). 
-- En una misma fecha sólo puede impartirse una edición de un curso. 
-- Los cursos se imparten por personal de la empresa. 
-- De los empleados se desea almacenar su código de empleado, nombre y apellidos, dirección, teléfono, cuit/cuil, fecha de nacimiento, nacionalidad, sexo y salario, así como si está capacitado para impartir cursos.





-- 5. Crear el diagrama Entidad / Relación y transformarlo a tablas del modelo relacional.

-- La municipalidad de Bariloche desea guardar información sobre las estancias que existen en su 
-- jurisdicción y brindan alojamiento a pasajeros. Para ello decide crear una base de datos que 
-- contemple las siguientes consideraciones: 
-- Un alojamiento rural (estancia) se identifica por su nombre (“La Tranquila”, “La Rosita”, etc) que no 
-- se repite, tiene una dirección, un teléfono y una persona de contacto que pertenece al personal del 
-- establecimiento. 
-- En cada establecimiento trabajan una serie de personas que se identifican por un código de 
-- personal. Se requiere conocer el nombre completo, la dirección y el CUIL. 
-- Aunque en un establecimiento trabajen varias personas, una persona puede trabajar en un solo 
-- establecimiento. 
-- Los alojamientos se alquilan por habitaciones con una fecha de ingreso y la cantidad de días de 
-- permanencia; se desea conocer cuántas habitaciones componen la estancia, de qué tipo (single, 
-- doble, triple, etc) es cada una de ellas, si posee cuarto de baño y el precio diario. 
-- En algunas de estas estancias se realizan actividades organizadas para los huéspedes (senderismo, 
-- bicicleta de montaña, etc). Estas actividades se identifican por un código. Es de interés saber el 
-- nombre de la actividad, la descripción y el nivel de dificultad de dicha actividad (de 1 a 10). 
-- Estas actividades se realizan un día a la semana, por ejemplo: en la estancia “La Tranquila” se 
-- practica alpinismo los sábados y se desea guardar esta información. Puede haber algún día que no 
-- se practique ninguna actividad. 
-- Se pide: 
-- Diseñar el esquema relacional. Indicar las claves primarias y claves externas. 