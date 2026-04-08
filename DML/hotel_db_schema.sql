-- =============================================================================
--  hotel_db — Script de creación de tablas
--  Motor: MySQL 8.0+
--  Descripción: Base de datos para el taller práctico de DML SQL
--  Relaciones: 1:N · cadena 1:N · N:M (tabla pivote reservas_servicios)
-- =============================================================================

DROP DATABASE IF EXISTS hotel_db;
CREATE DATABASE hotel_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hotel_db;
-- =============================================================================
--  NIVEL 1 — Tablas sin dependencias externas
-- =============================================================================

-- -----------------------------------------------------------------------------
--  paises
--  Relaciones: 1:N con ciudades, 1:N con huespedes
-- -----------------------------------------------------------------------------
CREATE TABLE paises (
  id      INT           AUTO_INCREMENT PRIMARY KEY,
  nombre  VARCHAR(80)   NOT NULL,
  codigo  CHAR(2)       NOT NULL UNIQUE,
  CONSTRAINT chk_codigo_pais CHECK (codigo REGEXP '^[A-Z]{2}$')
);

-- -----------------------------------------------------------------------------
--  tipos_habitacion
--  Relaciones: 1:N con habitaciones
-- -----------------------------------------------------------------------------
CREATE TABLE tipos_habitacion (
  id          INT            AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(60)    NOT NULL UNIQUE,
  precio_base DECIMAL(8,2)   NOT NULL,
  capacidad   INT            NOT NULL DEFAULT 1,
  CONSTRAINT chk_precio_tipo  CHECK (precio_base > 0),
  CONSTRAINT chk_capacidad    CHECK (capacidad BETWEEN 1 AND 10)
);

-- -----------------------------------------------------------------------------
--  servicios
--  Relaciones: N:M con reservas (vía reservas_servicios)
-- -----------------------------------------------------------------------------
CREATE TABLE servicios (
  id        INT            AUTO_INCREMENT PRIMARY KEY,
  nombre    VARCHAR(100)   NOT NULL UNIQUE,
  precio    DECIMAL(8,2)   NOT NULL,
  categoria VARCHAR(60)    NOT NULL,
  CONSTRAINT chk_precio_servicio CHECK (precio >= 0)
);

-- =============================================================================
--  NIVEL 2 — Tablas con una dependencia
-- =============================================================================

-- -----------------------------------------------------------------------------
--  ciudades
--  Relaciones: N:1 con paises, 1:N con hoteles
-- -----------------------------------------------------------------------------
CREATE TABLE ciudades (
  id       INT           AUTO_INCREMENT PRIMARY KEY,
  nombre   VARCHAR(80)   NOT NULL,
  pais_id  INT           NOT NULL,
  CONSTRAINT fk_ciudad_pais
    FOREIGN KEY (pais_id) REFERENCES paises(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- -----------------------------------------------------------------------------
--  huespedes
--  Relaciones: N:1 con paises, 1:N con reservas
-- -----------------------------------------------------------------------------
CREATE TABLE huespedes (
  id         INT           AUTO_INCREMENT PRIMARY KEY,
  nombre     VARCHAR(100)  NOT NULL,
  email      VARCHAR(150)  NOT NULL UNIQUE,
  pasaporte  VARCHAR(20)   NOT NULL UNIQUE,
  pais_id    INT,
  CONSTRAINT fk_huesped_pais
    FOREIGN KEY (pais_id) REFERENCES paises(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- =============================================================================
--  NIVEL 3 — Tablas con dos o más dependencias
-- =============================================================================

-- -----------------------------------------------------------------------------
--  hoteles
--  Relaciones: N:1 con ciudades, 1:N con habitaciones
-- -----------------------------------------------------------------------------
CREATE TABLE hoteles (
  id         INT            AUTO_INCREMENT PRIMARY KEY,
  nombre     VARCHAR(150)   NOT NULL,
  ciudad_id  INT            NOT NULL,
  categoria  INT            NOT NULL DEFAULT 3,
  CONSTRAINT fk_hotel_ciudad
    FOREIGN KEY (ciudad_id) REFERENCES ciudades(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT chk_categoria CHECK (categoria BETWEEN 1 AND 5)
);

-- =============================================================================
--  NIVEL 4 — Tablas con múltiples dependencias
-- =============================================================================

-- -----------------------------------------------------------------------------
--  habitaciones
--  Relaciones: N:1 con hoteles, N:1 con tipos_habitacion, 1:N con reservas
-- -----------------------------------------------------------------------------
CREATE TABLE habitaciones (
  id        INT     AUTO_INCREMENT PRIMARY KEY,
  hotel_id  INT     NOT NULL,
  tipo_id   INT     NOT NULL,
  numero    INT     NOT NULL,
  estado    ENUM('disponible', 'ocupada', 'mantenimiento') NOT NULL DEFAULT 'disponible',
  CONSTRAINT fk_hab_hotel
    FOREIGN KEY (hotel_id) REFERENCES hoteles(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_hab_tipo
    FOREIGN KEY (tipo_id) REFERENCES tipos_habitacion(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT uq_hotel_numero UNIQUE (hotel_id, numero)
);

-- -----------------------------------------------------------------------------
--  reservas
--  Relaciones: N:1 con huespedes, N:1 con habitaciones, N:M con servicios
-- -----------------------------------------------------------------------------
CREATE TABLE reservas (
  id             INT             AUTO_INCREMENT PRIMARY KEY,
  huesped_id     INT             NOT NULL,
  habitacion_id  INT             NOT NULL,
  fecha_entrada  DATE            NOT NULL,
  fecha_salida   DATE            NOT NULL,
  estado         ENUM('confirmada', 'cancelada', 'completada') NOT NULL DEFAULT 'confirmada',
  total          DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
  created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_res_huesped
    FOREIGN KEY (huesped_id) REFERENCES huespedes(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_res_habitacion
    FOREIGN KEY (habitacion_id) REFERENCES habitaciones(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT chk_fechas      CHECK (fecha_salida > fecha_entrada),
  CONSTRAINT chk_total_res   CHECK (total >= 0)
);

-- =============================================================================
--  NIVEL 5 — Tabla pivote N:M
-- =============================================================================

-- -----------------------------------------------------------------------------
--  reservas_servicios  (N:M entre reservas y servicios)
--  Clave primaria compuesta: (reserva_id, servicio_id)
-- -----------------------------------------------------------------------------
CREATE TABLE reservas_servicios (
  reserva_id   INT   NOT NULL,
  servicio_id  INT   NOT NULL,
  cantidad     INT   NOT NULL DEFAULT 1,
  fecha        DATE  NOT NULL,
  PRIMARY KEY (reserva_id, servicio_id),
  CONSTRAINT fk_rs_reserva
    FOREIGN KEY (reserva_id) REFERENCES reservas(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_rs_servicio
    FOREIGN KEY (servicio_id) REFERENCES servicios(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT chk_cantidad CHECK (cantidad > 0)
);

-- =============================================================================
--  ÍNDICES adicionales para mejorar el rendimiento en los ejercicios
-- =============================================================================

CREATE INDEX idx_ciudad_pais      ON ciudades(pais_id);
CREATE INDEX idx_hotel_ciudad     ON hoteles(ciudad_id);
CREATE INDEX idx_hab_hotel        ON habitaciones(hotel_id);
CREATE INDEX idx_hab_tipo         ON habitaciones(tipo_id);
CREATE INDEX idx_res_huesped      ON reservas(huesped_id);
CREATE INDEX idx_res_habitacion   ON reservas(habitacion_id);
CREATE INDEX idx_res_estado_fecha ON reservas(estado, fecha_salida);
CREATE INDEX idx_huesped_email    ON huespedes(email);
CREATE INDEX idx_huesped_passport ON huespedes(pasaporte);

-- =============================================================================
--  DATOS INICIALES — Necesarios para ejecutar los ejercicios del taller
-- =============================================================================

-- Países
INSERT INTO paises (nombre, codigo) VALUES
  ('España',          'ES'),
  ('Francia',         'FR'),
  ('Alemania',        'DE'),
  ('Italia',          'IT'),
  ('Reino Unido',     'GB');



-- Tipos de habitación
INSERT INTO tipos_habitacion (nombre, precio_base, capacidad) VALUES
  ('Individual', 55.00,  1),
  ('Doble',      85.00,  2),
  ('Suite',      160.00, 2),
  ('Familiar',   120.00, 4);


-- Servicios
INSERT INTO servicios (nombre, precio, categoria) VALUES
  ('Desayuno buffet',   15.00, 'Restauración'),
  ('Cena gourmet',      45.00, 'Restauración'),
  ('Parking',           12.00, 'Transporte'),
  ('Traslado aeropuerto',35.00,'Transporte'),
  ('Spa acceso diario', 25.00, 'Bienestar'),
  ('Masaje 60 min',     60.00, 'Bienestar'),
  ('Lavandería',         8.00, 'Conserjería'),
  ('Late check-out',    20.00, 'Conserjería');

-- =============================================================================
--  VERIFICACIÓN rápida (opcional — ejecutar para comprobar la carga)
-- =============================================================================

 SELECT 'paises'            AS tabla, COUNT(*) AS filas FROM paises
 UNION ALL
 SELECT 'ciudades',           COUNT(*) FROM ciudades
 UNION ALL
 SELECT 'hoteles',            COUNT(*) FROM hoteles
 UNION ALL
 SELECT 'tipos_habitacion',   COUNT(*) FROM tipos_habitacion
 UNION ALL
 SELECT 'habitaciones',       COUNT(*) FROM habitaciones
 UNION ALL
 SELECT 'huespedes',          COUNT(*) FROM huespedes
 UNION ALL
 SELECT 'servicios',          COUNT(*) FROM servicios
 UNION ALL
 SELECT 'reservas',           COUNT(*) FROM reservas
 UNION ALL
 SELECT 'reservas_servicios', COUNT(*) FROM reservas_servicios;
