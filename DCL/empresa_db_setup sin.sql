-- =============================================================================
--  empresa_db — Script completo de configuración
--  Motor: MariaDB 10.4+
--  Descripción: Base de datos de RRHH y nóminas para el taller de
--               vistas, usuarios y niveles de acceso
-- =============================================================================

-- -----------------------------------------------------------------------------
--  0. LIMPIEZA Y CREACIÓN DE LA BASE DE DATOS
-- -----------------------------------------------------------------------------
DROP DATABASE IF EXISTS empresa_db;
CREATE DATABASE empresa_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE empresa_db;

-- -----------------------------------------------------------------------------
--  1. TABLAS
-- -----------------------------------------------------------------------------

CREATE TABLE departamentos (
    id           INT            AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(80)    NOT NULL UNIQUE,
    presupuesto  DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    director_id  INT,                          -- FK diferida: se actualiza tras insertar empleados
    CONSTRAINT chk_presupuesto CHECK (presupuesto >= 0)
);

CREATE TABLE empleados (
    id          INT            AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(100)   NOT NULL,
    email       VARCHAR(150)   NOT NULL UNIQUE,
    cargo       VARCHAR(80)    NOT NULL,
    salario     DECIMAL(10,2)  NOT NULL,
    dept_id     INT            NOT NULL,
    fecha_alta  DATE           NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_emp_dept
        FOREIGN KEY (dept_id) REFERENCES departamentos(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_salario CHECK (salario > 0)
);

-- Añadir FK de director ahora que empleados existe
ALTER TABLE departamentos
    ADD CONSTRAINT fk_dept_director
        FOREIGN KEY (director_id) REFERENCES empleados(id)
        ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE nominas (
    id            INT            AUTO_INCREMENT PRIMARY KEY,
    empleado_id   INT            NOT NULL,
    periodo       CHAR(7)        NOT NULL,        -- formato: YYYY-MM
    salario_bruto DECIMAL(10,2)  NOT NULL,
    retenciones   DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    salario_neto  DECIMAL(10,2)  NOT NULL,
    CONSTRAINT fk_nom_emp
        FOREIGN KEY (empleado_id) REFERENCES empleados(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_nomina_periodo UNIQUE (empleado_id, periodo),
    CONSTRAINT chk_nomina CHECK (salario_bruto >= salario_neto AND salario_neto >= 0)
);

CREATE TABLE proyectos (
    id          INT            AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(150)   NOT NULL,
    dept_id     INT            NOT NULL,
    presupuesto DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    estado      ENUM('planificacion','activo','pausado','cerrado') NOT NULL DEFAULT 'planificacion',
    CONSTRAINT fk_proy_dept
        FOREIGN KEY (dept_id) REFERENCES departamentos(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE asignaciones (
    empleado_id  INT          NOT NULL,
    proyecto_id  INT          NOT NULL,
    rol          VARCHAR(80)  NOT NULL,
    horas        INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (empleado_id, proyecto_id),
    CONSTRAINT fk_asig_emp
        FOREIGN KEY (empleado_id) REFERENCES empleados(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_asig_proy
        FOREIGN KEY (proyecto_id) REFERENCES proyectos(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_horas CHECK (horas >= 0)
);

CREATE TABLE evaluaciones (
    id            INT    AUTO_INCREMENT PRIMARY KEY,
    empleado_id   INT    NOT NULL,
    evaluador_id  INT    NOT NULL,
    puntuacion    TINYINT NOT NULL,
    comentarios   TEXT,
    fecha         DATE   NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_eval_emp
        FOREIGN KEY (empleado_id)  REFERENCES empleados(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_eval_evaluador
        FOREIGN KEY (evaluador_id) REFERENCES empleados(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_puntuacion CHECK (puntuacion BETWEEN 1 AND 10)
);

-- -----------------------------------------------------------------------------
--  2. ÍNDICES
-- -----------------------------------------------------------------------------
CREATE INDEX idx_emp_dept       ON empleados(dept_id);
CREATE INDEX idx_emp_cargo      ON empleados(cargo);
CREATE INDEX idx_nom_periodo    ON nominas(periodo);
CREATE INDEX idx_nom_emp        ON nominas(empleado_id);
CREATE INDEX idx_proy_dept      ON proyectos(dept_id);
CREATE INDEX idx_proy_estado    ON proyectos(estado);
CREATE INDEX idx_eval_emp       ON evaluaciones(empleado_id);
CREATE INDEX idx_eval_fecha     ON evaluaciones(fecha);

-- -----------------------------------------------------------------------------
--  3. PROCEDIMIENTO DE AUDITORÍA (usado en ejercicio 9)
-- -----------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE registrar_acceso(
    IN p_usuario   VARCHAR(100),
    IN p_accion    VARCHAR(200)
)
BEGIN
    -- En un entorno real escribiría en una tabla de log.
    -- Aquí simplemente emite una nota de diagnóstico.
    SELECT CONCAT('[ACCESO] ', NOW(), ' | ', p_usuario, ' | ', p_accion) AS log_entry;
END$$
DELIMITER ;

-- -----------------------------------------------------------------------------
--  4. DATOS DE MUESTRA
-- -----------------------------------------------------------------------------

-- Departamentos (sin director aún)
INSERT INTO departamentos (nombre, presupuesto) VALUES
    ('Dirección General',   500000.00),   -- id=1
    ('Recursos Humanos',    180000.00),   -- id=2
    ('Tecnología',          420000.00),   -- id=3
    ('Finanzas',            250000.00),   -- id=4
    ('Proyectos',           350000.00);   -- id=5

-- Empleados
INSERT INTO empleados (nombre, email, cargo, salario, dept_id, fecha_alta) VALUES
    ('Laura Gómez',      'l.gomez@empresa.es',       'Directora General',       6500.00, 1, '2018-03-01'),
    ('Carlos Martín',    'c.martin@empresa.es',      'Director de RRHH',        4800.00, 2, '2019-06-15'),
    ('Ana López',        'a.lopez@empresa.es',       'Directora de Tecnología', 5200.00, 3, '2019-01-20'),
    ('Pedro Sánchez',    'p.sanchez@empresa.es',     'Director Financiero',     5500.00, 4, '2018-09-10'),
    ('Marta Fernández',  'm.fernandez@empresa.es',   'Jefa de Proyectos',       4600.00, 5, '2020-02-28'),
    ('Javier Ruiz',      'j.ruiz@empresa.es',        'Técnico de RRHH',         2800.00, 2, '2021-05-03'),
    ('Sara Díaz',        's.diaz@empresa.es',        'Desarrolladora Senior',   3500.00, 3, '2020-11-11'),
    ('Miguel Torres',    'm.torres@empresa.es',      'Analista Financiero',     3100.00, 4, '2021-08-20'),
    ('Elena Jiménez',    'e.jimenez@empresa.es',     'Desarrolladora Junior',   2600.00, 3, '2022-03-14'),
    ('Roberto Moreno',   'r.moreno@empresa.es',      'Coordinador de Proyectos',3200.00, 5, '2021-10-05'),
    ('Isabel Castillo',  'i.castillo@empresa.es',    'Técnica de Selección',    2700.00, 2, '2022-07-18'),
    ('David Herrera',    'd.herrera@empresa.es',     'DevOps Engineer',         3800.00, 3, '2020-04-22'),
    ('Patricia Vega',    'p.vega@empresa.es',        'Contable Senior',         3300.00, 4, '2019-12-01'),
    ('Álvaro Núñez',     'a.nunez@empresa.es',       'Project Manager',         4000.00, 5, '2020-07-07'),
    ('Cristina Blanco',  'c.blanco@empresa.es',      'Diseñadora UX',           3000.00, 3, '2022-01-10');

-- Asignar directores a departamentos
UPDATE departamentos SET director_id = 1 WHERE id = 1;
UPDATE departamentos SET director_id = 2 WHERE id = 2;
UPDATE departamentos SET director_id = 3 WHERE id = 3;
UPDATE departamentos SET director_id = 4 WHERE id = 4;
UPDATE departamentos SET director_id = 5 WHERE id = 5;

-- Nóminas (últimos 3 meses para todos los empleados)
INSERT INTO nominas (empleado_id, periodo, salario_bruto, retenciones, salario_neto)
SELECT
    e.id,
    p.periodo,
    e.salario                                             AS salario_bruto,
    ROUND(e.salario * 0.22, 2)                            AS retenciones,
    ROUND(e.salario - (e.salario * 0.22), 2)              AS salario_neto
FROM empleados e
CROSS JOIN (
    SELECT '2026-01' AS periodo
    UNION ALL SELECT '2026-02'
    UNION ALL SELECT '2026-03'
) p;

-- Proyectos
INSERT INTO proyectos (nombre, dept_id, presupuesto, estado) VALUES
    ('Portal del empleado v2',      3, 85000.00,  'activo'),
    ('Migración cloud',             3, 150000.00, 'activo'),
    ('Reestructuración salarial',   2, 20000.00,  'planificacion'),
    ('Auditoría contable 2026',     4, 35000.00,  'activo'),
    ('Nuevo ERP',                   5, 200000.00, 'planificacion'),
    ('Onboarding digital',          2, 15000.00,  'cerrado');

-- Asignaciones
INSERT INTO asignaciones (empleado_id, proyecto_id, rol, horas) VALUES
    (7,  1, 'Desarrolladora principal', 320),
    (9,  1, 'Desarrolladora frontend',  180),
    (12, 1, 'DevOps',                   100),
    (15, 1, 'Diseño UX',                140),
    (7,  2, 'Arquitecta técnica',        80),
    (12, 2, 'Ingeniero infraestructura',240),
    (6,  3, 'Analista',                  60),
    (11, 3, 'Coordinadora',              40),
    (8,  4, 'Analista principal',       160),
    (13, 4, 'Contable',                 120),
    (10, 5, 'Coordinador',              200),
    (14, 5, 'Project Manager',          280),
    (6,  6, 'Gestor de contenidos',      90),
    (11, 6, 'Técnica de selección',      75);

-- Evaluaciones
INSERT INTO evaluaciones (empleado_id, evaluador_id, puntuacion, comentarios, fecha) VALUES
    (6,  2,  8, 'Buen desempeño en gestión administrativa.',        '2025-12-20'),
    (7,  3,  9, 'Excelente contribución técnica en proyectos.',     '2025-12-18'),
    (8,  4,  7, 'Cumple objetivos con margen de mejora.',           '2025-12-22'),
    (9,  3,  8, 'Integración rápida y buena actitud.',              '2025-12-19'),
    (10, 5,  9, 'Coordinación ejemplar en proyecto ERP.',           '2025-12-21'),
    (11, 2,  8, 'Proceso de selección muy bien gestionado.',        '2025-12-17'),
    (12, 3, 10, 'Migración cloud sin incidencias. Sobresaliente.',  '2025-12-23'),
    (13, 4,  7, 'Trabajo riguroso, comunicación mejorable.',        '2025-12-20'),
    (14, 5,  8, 'Buena planificación del proyecto ERP.',            '2025-12-21'),
    (15, 3,  9, 'Diseño UX muy valorado por los usuarios.',         '2025-12-18');


