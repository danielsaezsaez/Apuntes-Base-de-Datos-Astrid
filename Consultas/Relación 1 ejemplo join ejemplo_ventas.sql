use ejemplo_ventas;

show tables;

/* para cada venta quiero saber (id_pedido, fecha_pedido, unidades, precio_unitario, 
[nombre_completo del cliente]) */
select id_pedido, fecha_pedido, unidades, precio_unitario, nombre_completo
from venta v right join clientes c on c.id = v.id_Cliente;

select id_pedido, fecha_pedido, unidades, precio_unitario, nombre_completo
from clientes c left join venta v on c.id = v.id_Cliente;
select * from venta;
select * from clientes;
select * from proveedores;

select id_pedido, fecha_pedido, unidades, precio_unitario, nombre_completo
from (venta v join clientes c on v.id_Cliente = c.id)
where v.unidades > 5000 ;

/* añadir proveedor y contacto de la tabla de proveedores a cada venta */
select id_pedido, fecha_pedido, unidades, precio_unitario, nombre_completo, 
	proveedor, contacto
from (venta v join clientes c on v.id_Cliente = c.id)
		join proveedores p on v.id_proveedor = p.id
where v.unidades > 5000 ;

/* para cada proveedor quiero saber el suma total de ventas en el año 2020,
mostrar ([suma total de importes de venta], proveedor, contacto) */
select proveedor, contacto, sum(importe_venta)
from venta v join proveedores p on v.id_proveedor = p.id
group by p.id;


