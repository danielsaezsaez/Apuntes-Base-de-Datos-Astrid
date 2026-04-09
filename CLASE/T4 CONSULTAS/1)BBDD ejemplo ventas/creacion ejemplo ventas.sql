create database if not exists ejemplo_ventas;
use ejemplo_ventas;

drop table if exists venta;	
drop table if exists clientes;
drop table if exists proveedores;

CREATE TABLE clientes (
    id VARCHAR(10) PRIMARY KEY,
    nombre_completo VARCHAR(255),
    fecha_nacimiento DATE,
    direccion VARCHAR(255),
    localidad_cp VARCHAR(75),
    telefono VARCHAR(15),
    email VARCHAR(255),
    fecha_alta DATETIME,
    grupo CHAR(1)
);

CREATE TABLE proveedores (
    id VARCHAR(10) PRIMARY KEY,
    proveedor VARCHAR(255),
	contacto VARCHAR(255),
    email VARCHAR(255),
    telefono VARCHAR(15),
    saldo DECIMAL(10,2),
    fecha_ult_compra DATETIME
);


CREATE TABLE venta (
	id_Cliente VARCHAR(10),
	zona VARCHAR(30),
	pais VARCHAR(50),
	tipo_producto VARCHAR(30),
	canal_venta VARCHAR(15),
	prioridad VARCHAR(10),
	fecha_pedido DATE,
	id_pedido CHAR(9),
	fecha_envío DATE,
	unidades INT,
	precio_unitario DECIMAL(10,2), 
	coste_unitario DECIMAL(10,2), 
	importe_venta DECIMAL(12,2), 
	importe_coste DECIMAL(12,2),
    PRIMARY KEY (id_pedido) /*,
	FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON UPDATE CASCADE   /**/
);

/* COPIA LOS ARCHIVOS clientes.csv, proveedores.csv y ventas.csv a la carpeta de tu base de datos que se acaba de crear en tu servidor
	C:\xamppDAM\mysql\data\ejemplo_clientes
    a continuación ejecuta el resto del script para importar los datos de clientes y proveedores.
    */


LOAD DATA INFILE 'clientes.csv' REPLACE
INTO TABLE clientes
character SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select * from clientes;

LOAD DATA INFILE 'proveedores.csv' REPLACE
INTO TABLE proveedores
character SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select * from proveedores;

LOAD DATA INFILE 'ventas.csv' REPLACE
INTO TABLE venta
character SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select * from venta;
/**/
