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

/* modificamos los códigos de cliente de la tabla venta */

SET SQL_SAFE_UPDATES = 0;
UPDATE venta
	SET id_cliente = right(id_cliente,4)  ;
 select id_cliente 
	from venta;
SET SQL_SAFE_UPDATES = 0;    
UPDATE venta
	SET id_cliente = id_cliente%1000  ;
 select id_cliente 
	from venta;
UPDATE venta
	SET id_cliente = CONCAT('C',LPAD(id_cliente, 4, '0'));
 select id_cliente 
	from venta;
    
delete from venta
where id_Cliente like 'C0000';
SET SQL_SAFE_UPDATES = 1;

/* ahora ya si puedo modificar la tabla venta para que tenga FK a cliente  */
ALTER TABLE venta ADD foreign key (id_Cliente) REFERENCES clientes(id) on update cascade;

ALTER TABLE venta ADD COLUMN id_proveedor VARCHAR(10);

select * from venta;
select * from proveedores;
SET SQL_SAFE_UPDATES = 0;
UPDATE venta
SET id_proveedor = CONCAT('P', RIGHT(id_Cliente,4) );
SET SQL_SAFE_UPDATES = 1;
SELECT id_Cliente, id_proveedor FROM venta 
	where id_proveedor = 'P1000' OR id_proveedor = 'P0000';
    
SET SQL_SAFE_UPDATES = 0;
DELETE FROM venta WHERE id_proveedor = 'P0000';
SET SQL_SAFE_UPDATES = 1;
ALTER TABLE venta ADD foreign key (id_proveedor)
	REFERENCES proveedores(id) ON UPDATE CASCADE;
ALTER TABLE venta ADD foreign key (id_Cliente)
	REFERENCES clientes(id) ON UPDATE CASCADE;
SET SQL_SAFE_UPDATES = 1;

