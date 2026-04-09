use ejemplo_ventas;
 select * from clientes;
 
 /* modificar la localidad de la clienta C0001 por 'Bengerfield, NJ 07621'
    y su direccion por '7943 San Fernanado ST.' */
 UPDATE clientes
	SET localidad_cp = 'Bengerfield, NJ 07621', direccion= '7943 San Fernanado ST.'
    WHERE id='C0001';
 select * 
	from clientes
    WHERE id='C0001';
    
/* corregimos los id_cliente de la tabla venta, para que correspondan a clientes que
existen en la tabla cliente */
 select id_cliente 
	from venta;
    
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
    
SET SQL_SAFE_UPDATES = 1;

 select * 
	from venta
	where id_cliente='C0000';

/*  añado un cliente con id 'C0000', me invento los datos */
select * from clientes;
insert into clientes(id,nombre_completo,fecha_nacimiento,fecha_alta,grupo)
	values ('C0000', 'Fulanito de los palotes', '1973-05-20', now(), 'A');
    
/* si yo no quiero escribir la lista completa de atributos a insertar entonces tengo que 
poner todos y en el mismo orden... rellendo con null los datos que no tenga  
insert into clientes
	values ('C0000', 'Fulanito de los palotes', '1973-05-20', null,null,null,null, now(), 'A');
*/
select * from clientes where id='C0000';

/* ahora ya si puedo modificar la tabla venta para que tenga FK a cliente  */
ALTER TABLE venta ADD foreign key (id_Cliente) REFERENCES clientes(id) on update cascade;


/* añadir una venta de un 'Ratón inalambrico' por 20€ al cliente id C1000 que se llama 
Juan Perez  (el resto de datos a null o nos lo inventamos)*/
select * from venta;
INSERT INTO clientes(id, nombre_completo)
  VALUES ('C1000', 'Juan Perez');
INSERT INTO 
	venta(id_pedido,id_cliente, tipo_producto, fecha_pedido, unidades, precio_unitario,importe_venta)
    VALUES('999999999','C1000','Ratón inalambrico', now(), '1', '20.00', unidades*precio_unitario);
 /*   
update venta 
	set id_pedido = '999999999'
    where id_pedido = '';  */
    
select * from venta where id_Cliente='C1000';

/* borramos el cliente C0000 y todas sus ventas  */
SET SQL_SAFE_UPDATES = 0;
delete from venta
  where id_Cliente='C0000';
SET SQL_SAFE_UPDATES = 1;
select * from venta where id_Cliente='C0000';
delete from clientes
	where id='C0000';