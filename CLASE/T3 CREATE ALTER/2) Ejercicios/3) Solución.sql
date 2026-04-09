create database if not exists Ejercicio7;
use Ejercicio7;


/*ALTER TABLE curso DROP CONSTRAINT delegado_FK;   /**/
drop table if exists VENTAS;
drop table if exists PEDIDOS;
drop table if exists FABRICANTES;
drop table if exists ARTICULOS;
drop table if exists TIENDAS;


create table FABRICANTES (
	COD_FABRICANTE decimal(3) not null,
    NOMBRE 	varchar(15) check (NOMBRE = upper(NOMBRE)),
	PAIS varchar(15) check (PAIS = upper(PAIS)),
    primary key(COD_FABRICANTE)
);

create table ARTICULOS (
	ARTICULO varchar(20) not null,
    COD_FABRICANTE decimal(3) not null,
    PESO decimal(3) not null,
    CATEGORIA enum('Primera', 'Segunda', 'Tercera') not null,
    PRECIO_VENTA decimal(4) check(PRECIO_VENTA > 0),
    PRECIO_COSTO decimal(4) check(PRECIO_COSTO > 0),
    EXISTENCIAS	 decimal(5) check(EXISTENCIAS > 0),
    primary key(ARTICULO, COD_FABRICANTE, PESO, CATEGORIA)
);

create table TIENDAS ( 
	NIF varchar(10) not null,
    NOMBRE varchar(20),
    DIRECCION varchar(20),
    POBLACION varchar(20),
    PROVINCIA varchar(20) check (PROVINCIA = upper(PROVINCIA)),
    CODPOSTAL decimal(5),
    primary key (NIF)
);

create table PEDIDOS (
	NIF varchar(10) not null,
    ARTICULO varchar(20) not null,
    COD_FABRICANTE decimal(3) not null,
    PESO decimal(3) not null,
    CATEGORIA enum('Primera', 'Segunda', 'Tercera') not null,
    FECHA_PEDIDO date not null,
    UNIDADES_PEDIDAS decimal(4) check(UNIDADES_PEDIDAS >0),
    primary key(NIF, ARTICULO, COD_FABRICANTE, PESO, CATEGORIA, FECHA_PEDIDO),
    foreign key(COD_FABRICANTE) references FABRICANTES(COD_FABRICANTE),
    foreign key(ARTICULO, COD_FABRICANTE, PESO, CATEGORIA)
		references ARTICULOS(ARTICULO, COD_FABRICANTE, PESO, CATEGORIA),
	foreign key(NIF) references TIENDAS(NIF)
);

create table VENTAS (
	NIF varchar(10) not null,
    ARTICULO varchar(20) not null,
    COD_FABRICANTE decimal(3) not null,
    PESO decimal(3) not null,
	CATEGORIA varchar(10) not null,
    FECHA_VENTA date not null,
    UNIDADES_VENDIDAS decimal(4)
);

alter table VENTAS add primary key (NIF, ARTICULO, COD_FABRICANTE, PESO, CATEGORIA, FECHA_VENTA);
alter table VENTAS add foreign key (COD_FABRICANTE) references FABRICANTES(COD_FABRICANTE);
alter table VENTAS modify UNIDADES_VENDIDAS decimal(4) check(UNIDADES_VENDIDAS>0);
alter table VENTAS modify CATEGORIA enum('Primera', 'Segunda', 'Tercera') not null;
alter table VENTAS add foreign key (ARTICULO, COD_FABRICANTE, PESO, CATEGORIA) references ARTICULOS(ARTICULO, COD_FABRICANTE, PESO, CATEGORIA);
alter table VENTAS add foreign key (NIF) references TIENDAS(NIF);