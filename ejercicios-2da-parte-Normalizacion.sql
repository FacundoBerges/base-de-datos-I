-- Normalización de bases de datos relacionales.

-- 1) Tenemos los siguientes requerimientos para una base de datos universitaria con que se manejan las boletas de notas de los estudiantes. 
--     Para cada alumno consta su nombre, número de legajo, dirección, teléfono, otro teléfono opcional, fecha de nacimiento, sexo, departamento de carrera, departamento de especialidad.
--     Para cada departamento, figura su respectivo código con su nombre.
--     Para cada curso, el nombre del curso, su código, número de horas semanales, nivel, profesor a cargo, año.
--     Las boletas se conforman del número de legajo, curso, nota y fecha.

--     A) Diseñar un conjunto de relaciones normalizadas.
--     B) Llevar todas las relaciones hasta 2FN.
--     C) Especificar los atributos clave de cada relación.


-- Departamentos
CREATE TABLE departamentos (
    codigo INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT PK_departamentos PRIMARY KEY (codigo)
);

-- Alumnos
CREATE TABLE alumnos (
    nombre VARCHAR(100) NOT NULL,
    legajo INT AUTO_INCREMENT,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    otro_telefono VARCHAR(20),
    fecha_nacimiento DATE NOT NULL,
    sexo ENUM('M', 'F') NOT NULL,
    codigo_departamento_carrera INT NOT NULL,
    codigo_departamento_especialidad INT NOT NULL,
    CONSTRAINT PK_alumnos PRIMARY KEY (legajo),
    CONSTRAINT FK_alumnos_departamento_carrera FOREIGN KEY (codigo_departamento_carrera) REFERENCES departamentos(codigo),
    CONSTRAINT FK_alumnos_departamento_especialidad FOREIGN KEY (codigo_departamento_especialidad) REFERENCES departamentos(codigo),
    CONSTRAINT CK_alumnos_sexo CHECK (sexo IN ('M', 'F')),
    CONSTRAINT CK_alumnos_fecha_nacimiento CHECK (fecha_nacimiento <= CURRENT_DATE)
);

-- Profesores
CREATE TABLE profesores (
    legajo INT,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT PK_profesores PRIMARY KEY (legajo)
);

-- Cursos
CREATE TABLE cursos (
    codigo INT,
    nombre VARCHAR(100) NOT NULL,
    horas_semanales INT NOT NULL,
    nivel INT NOT NULL,
    legajo_profesor INT NOT NULL,
    anio INT,
    CONSTRAINT PK_cursos PRIMARY KEY (codigo),
    CONSTRAINT FK_cursos_profesor FOREIGN KEY (legajo_profesor) REFERENCES profesores(legajo),
    CONSTRAINT CK_cursos_nivel CHECK (nivel BETWEEN 1 AND 5),
    CONSTRAINT CK_cursos_horas_semanales CHECK (horas_semanales > 0)
);

-- Boletas
CREATE TABLE boletas (
    legajo INT,
    codigo_curso INT,
    nota INT NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT PK_boletas PRIMARY KEY (legajo, codigo_curso),
    CONSTRAINT FK_boletas_alumnos FOREIGN KEY (legajo) REFERENCES alumnos(legajo),
    CONSTRAINT FK_boletas_cursos FOREIGN KEY (codigo_curso) REFERENCES cursos(codigo),
    CONSTRAINT CK_boletas_nota CHECK (nota BETWEEN 1 AND 10),
    CONSTRAINT CK_boletas_fecha CHECK (fecha <= CURRENT_DATE)
);


-- 2)  Se trata de hacer una versión normalizada de la estructura que describe una compra de libros a una compañía XZ.
    
--     Un pedido consiste en el nombre del cliente, la fecha de pedido, el ISBN (código internacional único) del libro pedido, el título, el autor, la cantidad que ha sido pedida, 
--     y el importe total del período para un libro determinado.

-- Autor
CREATE TABLE autores (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT PK_autores PRIMARY KEY (id)
);

-- Libros
CREATE TABLE libros (
    isbn VARCHAR(13),
    titulo VARCHAR(100) NOT NULL,
    id_autor INT NOT NULL,
    CONSTRAINT PK_libros PRIMARY KEY (isbn),
    CONSTRAINT FK_libros_autores FOREIGN KEY (id_autor) REFERENCES autores(id)
);

-- Clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT PK_clientes PRIMARY KEY (id)
);

-- Pedidos
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    fecha_pedido DATE NOT NULL DEFAULT CURRENT_DATE,
    importe_total DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_pedidos PRIMARY KEY (id),
    CONSTRAINT FK_pedidos_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    CONSTRAINT CK_pedidos_fecha_pedido CHECK (fecha_pedido <= CURRENT_DATE),
    CONSTRAINT CK_pedidos_importe_total CHECK (importe_total > 0)
);

-- Detalles_pedidos
CREATE TABLE detalles_pedidos (
    id_pedido INT,
    isbn VARCHAR(13),
    cantidad INT NOT NULL,
    CONSTRAINT PK_detalles_pedidos PRIMARY KEY (id_pedido, isbn),
    CONSTRAINT FK_detalles_pedidos_pedidos FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    CONSTRAINT FK_detalles_pedidos_libros FOREIGN KEY (isbn) REFERENCES libros(isbn),
    CONSTRAINT CK_detalles_pedidos_cantidad CHECK (cantidad > 0),
);


-- 3) Tenemos el siguiente conjunto de datos que se va a grabar en una BD de personal de una compañía:

--      • La compañía tiene un conjunto de departamentos.
--      • Cada departamento tiene un conjunto de empleados, un conjunto de proyectos y un conjunto de oficinas.
--      • Cada empleado tiene una historia de empleos. Para cada empleo, tiene una historia de salarios.
--      • Cada oficina tiene un conjunto de teléfonos.

--      La base de datos debe contener la siguiente información:

--      • Para cada departamento: Nro. de departamento (único), presupuesto de cada departamento y número de empleado del gerente del departamento (único).
--      • Para cada empleado: Nro. de empleado (único), nro. de proyecto actual, nro. de oficina y nro. de teléfono; además, 
--              el título de cada trabajo que ha tenido el empleado, junto con la fecha y el salario para cada salario distinto recibido en ese trabajo.
--      • Para cada proyecto: Nro. de proyecto (único) y presupuesto del proyecto.
--      • Para cada oficina: Nro. de oficina (único), área en m2. y números de todos los teléfonos de esa oficina.

-- Diseñar un conjunto apropiado de relaciones normalizadas hasta 3FN.

-- Empleados
CREATE TABLE empleados (
    numero INT,
    numero_proyecto_actual INT NOT NULL,
    numero_oficina INT NOT NULL,
    CONSTRAINT PK_empleados PRIMARY KEY (numero),
    CONSTRAINT FK_empleados_proyecto_actual FOREIGN KEY (numero_proyecto_actual) REFERENCES proyectos(numero),
    CONSTRAINT FK_empleados_oficina FOREIGN KEY (numero_oficina) REFERENCES oficinas(numero)
);

-- Departamentos
CREATE TABLE departamentos (
    numero INT,
    presupuesto DECIMAL(10, 2) NOT NULL,
    numero_empleado_gerente INT NOT NULL,
    CONSTRAINT PK_departamentos PRIMARY KEY (numero),
    CONSTRAINT FK_departamentos_gerente FOREIGN KEY (numero_empleado_gerente) REFERENCES empleados(numero),
    CONSTRAINT UK_departamentos_gerente UNIQUE (numero_empleado_gerente),
    CONSTRAINT CK_departamentos_presupuesto CHECK (presupuesto > 0)
);

-- Proyectos
CREATE TABLE proyectos (
    numero INT,
    presupuesto DECIMAL(10, 2) NOT NULL,
    nro_departamento INT NOT NULL,
    CONSTRAINT PK_proyectos PRIMARY KEY (numero),
    CONSTRAINT FK_proyectos_departamento FOREIGN KEY (nro_departamento) REFERENCES departamentos(numero),
    CONSTRAINT CK_proyectos_presupuesto CHECK (presupuesto > 0)
);

-- Oficinas
CREATE TABLE oficinas (
    numero INT,
    area_en_m2 INT NOT NULL,
    nro_departamento INT NOT NULL,
    CONSTRAINT PK_oficinas PRIMARY KEY (numero),
    CONSTRAINT FK_oficinas_departamento FOREIGN KEY (nro_departamento) REFERENCES departamentos(numero),
    CONSTRAINT CK_oficinas_area CHECK (area_en_m2 > 0)
);

-- Telefonos
CREATE TABLE telefonos (
    numero INT,
    numero_oficina INT NOT NULL,
    CONSTRAINT PK_telefonos PRIMARY KEY (numero),
    CONSTRAINT FK_telefonos_oficina FOREIGN KEY (numero_oficina) REFERENCES oficinas(numero)
);

-- Historia de empleos
CREATE TABLE historia_empleos (
    numero_hist_empleo INT AUTO_INCREMENT,
    numero_empleado INT,
    titulo VARCHAR(100) NOT NULL,
    fecha_desde DATE NOT NULL,
    fecha_hasta DATE,
    CONSTRAINT PK_historia_empleos PRIMARY KEY (numero_hist_empleo),
    CONSTRAINT FK_historia_empleos_empleado FOREIGN KEY (numero_empleado) REFERENCES empleados(numero),
    CONSTRAINT CK_historia_empleos_fecha CHECK (fecha_desde <= CURRENT_DATE)
);

-- Historia de salarios
CREATE TABLE historia_salarios (
    numero_hist_salario INT AUTO_INCREMENT,
    numero_hist_empleo INT NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_historia_salarios PRIMARY KEY (numero_hist_salario),
    CONSTRAINT FK_historia_salarios_historia_empleos FOREIGN KEY (numero_hist_empleo) REFERENCES historia_empleos(numero_hist_empleo),
    CONSTRAINT CK_historia_salarios_salario CHECK (salario > 0)
);


-- 4) Supongamos que tenemos una relación para proveer la asignación de empleados temporarios a los proyectos: 

-- PROY-ASIGN (NRO-EMP, TEL, SUELDO-HORA, NRO-PROY, FECHA-FINAL) 
CREATE TABLE proyecto_asignado (
    numero_empleado INT,
    telefono VARCHAR(20) NOT NULL,
    sueldo_hora DECIMAL(10, 2) NOT NULL,
    numero_proyecto INT NOT NULL,
    fecha_final DATE NOT NULL,
    CONSTRAINT PK_proyecto_asignado PRIMARY KEY (numero_empleado, numero_proyecto),
    CONSTRAINT FK_proyecto_asignado_empleado FOREIGN KEY (numero_empleado) REFERENCES empleados(numero),
    CONSTRAINT FK_proyecto_asignado_proyecto FOREIGN KEY (numero_proyecto) REFERENCES proyectos(numero),
    CONSTRAINT CK_proyecto_asignado_fecha_final CHECK (fecha_final <= CURRENT_DATE),
    CONSTRAINT CK_proyecto_asignado_sueldo_hora CHECK (sueldo_hora > 0)
);

--  A) ¿Está en 1FN?
No está en 1FN porque los atributos telefono y sueldo_hora podrían estar llevados a una tabla 'empleados', ya que podrían no relacionarse directamente con el proyecto asignado. 

--  B) ¿Está en 2FN? 
No está en 2FN porque no está en 1FN. Si además existiera el caso de que un empleado puede tener a cargo varios proyectos, la clave primaria debería estar compuesta de numero_empleado y numero_proyecto.

--  C) ¿Está en 3FN?
No está en 3FN porque no está en 2FN.

En caso de que se quiera asignar un empleado a varios proyectos, se debería crear una tabla 'empleados_proyectos' que contenga la relación entre empleados y proyectos.
O bien asignar como clave primaria de la tabla 'proyecto_asignado' la combinación de numero_empleado y numero_proyecto, 
asignando un numero distinto de teléfono, sueldo por hora y fecha final para cada proyecto asignado.
