-- =============================================================================
--  empresa_db — Script de ampliación para la prueba final
--  Motor: MariaDB 10.4+
--  Requisito: ejecutar empresa_db_setup.sql ANTES que este script
--  Descripción: añade tabla de accesos, tabla de clientes (dato externo
--               sensible), tabla de contratos y datos adicionales necesarios
--               para los ejercicios de evaluación
-- =============================================================================

USE empresa_db;

-- -----------------------------------------------------------------------------
--  1. NUEVAS TABLAS
-- -----------------------------------------------------------------------------

-- log_accesos: registro de accesos al sistema (datos de auditoría)
-- Solo el administrador de seguridad debe poder leer/escribir aquí
CREATE TABLE IF NOT EXISTS log_accesos (
    id          INT           AUTO_INCREMENT PRIMARY KEY,
    usuario_bd  VARCHAR(100)  NOT NULL,
    accion      VARCHAR(200)  NOT NULL,
    tabla_afect VARCHAR(80),
    fecha_hora  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_origen   VARCHAR(45),
    resultado   ENUM('ok','denegado','error') NOT NULL DEFAULT 'ok'
);

-- clientes: empresas clientes a las que se asignan proyectos
-- Contiene datos fiscales sensibles; acceso muy restringido
CREATE TABLE IF NOT EXISTS clientes (
    id          INT            AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(150)  NOT NULL,
    cif          CHAR(9)       NOT NULL UNIQUE,
    email        VARCHAR(150),
    telefono     VARCHAR(20),
    limite_credito DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    activo       TINYINT(1)    NOT NULL DEFAULT 1
);

-- contratos: vincula proyectos con clientes e incluye importes económicos
CREATE TABLE IF NOT EXISTS contratos (
    id            INT            AUTO_INCREMENT PRIMARY KEY,
    proyecto_id   INT            NOT NULL,
    cliente_id    INT            NOT NULL,
    fecha_inicio  DATE           NOT NULL,
    fecha_fin     DATE,
    importe       DECIMAL(12,2)  NOT NULL,
    estado        ENUM('borrador','activo','finalizado','cancelado')
                  NOT NULL DEFAULT 'borrador',
    CONSTRAINT fk_cont_proyecto
        FOREIGN KEY (proyecto_id) REFERENCES proyectos(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cont_cliente
        FOREIGN KEY (cliente_id)  REFERENCES clientes(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_proy_cliente UNIQUE (proyecto_id, cliente_id),
    CONSTRAINT chk_importe CHECK (importe > 0)
);

-- -----------------------------------------------------------------------------
--  2. NUEVOS ÍNDICES
-- -----------------------------------------------------------------------------
CREATE INDEX idx_log_usuario  ON log_accesos(usuario_bd);
CREATE INDEX idx_log_fecha    ON log_accesos(fecha_hora);
CREATE INDEX idx_cont_estado  ON contratos(estado);
CREATE INDEX idx_cont_cliente ON contratos(cliente_id);

-- -----------------------------------------------------------------------------
--  3. DATOS DE MUESTRA — CLIENTES
-- -----------------------------------------------------------------------------
INSERT INTO clientes (razon_social, cif, email, telefono, limite_credito, activo) VALUES
    ('Grupo Tecnalia S.A.',         'A12345678', 'contratos@tecnalia.es',  '916001100', 500000.00, 1),
    ('Innovasoft Solutions S.L.',   'B87654321', 'info@innovasoft.es',     '934002200', 250000.00, 1),
    ('Consultores Del Norte S.A.',  'A11223344', 'admin@cdnorte.es',       '944003300', 180000.00, 1),
    ('Digital Factory S.L.',        'B55667788', 'hello@digitalfactory.es','912004400', 320000.00, 1),
    ('Servicios Globales Corp.',    'A99887766', 'legal@serviciosglob.es', '917005500',  90000.00, 0);

-- -----------------------------------------------------------------------------
--  4. DATOS DE MUESTRA — CONTRATOS
-- -----------------------------------------------------------------------------
INSERT INTO contratos (proyecto_id, cliente_id, fecha_inicio, fecha_fin, importe, estado) VALUES
    (1, 1, '2025-01-15', '2025-12-31', 85000.00,  'activo'),
    (2, 4, '2025-03-01', '2026-02-28', 148000.00, 'activo'),
    (4, 2, '2025-06-01', '2025-11-30', 34000.00,  'finalizado'),
    (5, 1, '2026-01-10', NULL,         195000.00, 'borrador'),
    (6, 3, '2024-09-01', '2025-01-31', 14500.00,  'finalizado');

-- -----------------------------------------------------------------------------
--  5. DATOS DE MUESTRA — LOG DE ACCESOS (entradas iniciales de prueba)
-- -----------------------------------------------------------------------------
INSERT INTO log_accesos (usuario_bd, accion, tabla_afect, fecha_hora, ip_origen, resultado) VALUES
    ('rrhh_admin',    'SELECT',        'empleados',    '2026-03-10 09:14:22', '127.0.0.1',     'ok'),
    ('auditor',       'SELECT',        'nominas',      '2026-03-10 10:02:05', '203.0.113.42',  'ok'),
    ('jefe_proyecto', 'INSERT',        'asignaciones', '2026-03-10 11:30:00', '10.0.1.15',     'ok'),
    ('app_empresa',   'UPDATE',        'empleados',    '2026-03-10 12:00:00', '192.168.5.10',  'ok'),
    ('jefe_proyecto', 'SELECT',        'nominas',      '2026-03-10 12:45:10', '10.0.1.15',     'denegado'),
    ('externo_web',   'SELECT',        'contratos',    '2026-03-11 08:00:00', '198.51.100.8',  'denegado'),
    ('rrhh_admin',    'UPDATE',        'nominas',      '2026-03-11 09:20:00', '127.0.0.1',     'ok'),
    ('auditor',       'SELECT',        'log_accesos',  '2026-03-11 11:00:00', '203.0.113.42',  'ok');

-- -----------------------------------------------------------------------------
--  6. NUEVO PROCEDIMIENTO ALMACENADO — útil para ejercicio 5
-- -----------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS actualizar_salario(
    IN p_empleado_id INT,
    IN p_nuevo_salario DECIMAL(10,2)
)
BEGIN
    IF p_nuevo_salario <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El salario debe ser mayor que cero';
    END IF;
    UPDATE empleados
    SET    salario = p_nuevo_salario
    WHERE  id = p_empleado_id;
END$$
DELIMITER ;

-- -----------------------------------------------------------------------------
--  7. VERIFICACIÓN (descomenta para comprobar la ampliación)
-- -----------------------------------------------------------------------------
-- SELECT 'clientes',    COUNT(*) FROM clientes
-- UNION ALL
-- SELECT 'contratos',   COUNT(*) FROM contratos
-- UNION ALL
-- SELECT 'log_accesos', COUNT(*) FROM log_accesos;
