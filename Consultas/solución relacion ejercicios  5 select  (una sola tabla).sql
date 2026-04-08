use ejemplo_ventas;

/* Tema 4 DML SELECT */

SELECT *
FROM clientes;

SELECT id, nombre_completo, fecha_nacimiento, now()-fecha_nacimiento AS edad
FROM clientes;

/* mostrar todos los clientes (id, nombre_completo, fecha_nacimiento, edad)
que se apelliden 'Lasa' */
SELECT id, nombre_completo, fecha_nacimiento, now()-fecha_nacimiento AS edad
FROM clientes
WHERE binary nombre_completo LIKE '%Lasa %';

/*  clientes que tengan un id entre C0100 y C0199 */
SELECT *
from clientes
where id LIKE 'C01__';

/* busca todas las ventas que no tenga un valor de canal_venta válido (Online, Offline) */
SELECT *
FROM venta
WHERE canal_venta IN ('Online', 'Offline');


select * from clientes;

/* Ejercicio 1: listado de clientes (id, nombre_completo, telefono, email) de 
todos los clientes del grupo E que se dieron de alta después del 1 de enero de 2015 */
select id, nombre_completo, telefono, email
from clientes
where grupo like 'E' and fecha_alta > '2015-01-01';

/* Ejercicio 2: listado de clientes (id, nombre_completo, localidad_cp) de los clientes
localidad de Poughkeepsie*/
select id, nombre_completo, localidad_cp
from clientes
where localidad_cp like '%Poughkeepsie%';

/* Ejercicio 3: listado de proveedores (mostrar todos los atributos) que tengan un saldo
por encima de la media  ordenados por saldo de mayor a menor */
SELECT * 
from proveedores
where saldo > (select avg(saldo) from proveedores Limit 1)
order by saldo desc;

/* Ejercicio 4: localiza la venta Online que ha obtenido mayor beneficio */
select id_pedido,importe_venta, importe_coste, (importe_venta-importe_coste) AS beneficio
 from venta
 where ((importe_venta-importe_coste) = 
	(select max(importe_venta-importe_coste) from venta)) AND canal_venta LIKE 'Online';
    
select id_pedido,importe_venta, importe_coste, (importe_venta-importe_coste) AS beneficio
 from venta
 where canal_venta LIKE 'Online'AND (importe_venta-importe_coste) is not null
 order by beneficio
 limit 1;
 
/* Ejercicio 5: quiero saber cuantos tipos de producto distintos se han vendido */
select count(distinct tipo_producto)
from venta;
select distinct tipo_producto
from venta;

select grupo, localidad_cp, count(id), MAX(fecha_alta) from clientes
WHERE grupo between 'B' and 'C' AND fecha_alta < '2025-01-01'
group by grupo, localidad_cp
having count(id) > 1 
order by count(id) desc;


select * from venta;
/* precio unitario medio de cada tipo_producto */
SELECT tipo_producto, AVG(precio_unitario)
FROM VENTA
where fecha_pedido < '2022-01-01'
GROUP BY tipo_producto
having avg(precio_unitario) > '50';

select * from venta;

/* Ejercicio 6: quiero saber el precio_unitario medio de cada tipo de producto que se vende Online 
(mostrar solo los tipos de producto que tengan más de 3 ventas) */
select tipo_producto, avg(precio_unitario)
from venta
where canal_venta LIKE 'Online'
group by tipo_producto
having count(id_pedido) > 3;

/* Ejercicio 7: para cada pais y cada tipo_producto quiero saber cuantas ventas ha habido 
de ese producto en ese pais y cual ha sido su precio máximo ordenadas de mayor a menor 
(primero el pais, producto de los cuales ha habido más ventas.... 
		Indonesia, Cuidado personal, 4, 81.73€) */
select pais, tipo_producto, count(id_pedido), max(precio_unitario)
from venta
group by pais, tipo_producto
order by max(precio_unitario);

/* Ejercicio 7: cual es el producto más caro (precio_unitario) 
de cada país */  /* requiere subconsultas correlacionadas */

select pais, tipo_producto, precio_unitario
from venta v1
where precio_unitario = (select MAX(precio_unitario) 
						from venta v2
                        group by pais
                        having v1.pais = v2.pais)
group by pais;

/* Ejercicio 8: importe total de ventas Online en cada país considerando 
solo los paises con al menos 5 clientes */ 

select pais,sum(importe_venta) 
from venta
where canal_venta like 'Online'
group by pais
having count(distinct id_Cliente) >= 5;


/* Ejercicio 9: importe_venta medio de la zona donde se encuentre el cliente 
con la venta con el importe_coste más alto  */

select zona, avg(importe_venta)
from venta
where importe_coste = (SELECT MAX(importe_coste) from venta)
group by zona;

/* Ejercicio 10: quiero saber el tiempo medio de entrega (fecha_envío-fecha_pedido [hay una función para restar 
fechas]) de cada tipo de producto en cada pais, considerar solo la zona 'Europa' */
select pais, tipo_producto, datediff(fecha_envío, fecha_pedido) as 'Tiempo medio entrega'
from venta
where zona like 'Europa'
group by pais, tipo_producto;


/* Ejercicio 11:  numero total de unidades vendidas en cada zona, en los paises que tengan la palabra 'Republic' 
en su nombre, mostrar solo las zonas con venta de más de tres tipos de producto distintos */
select zona, sum(unidades), count(distinct tipo_producto)
from venta
where pais like '%Republic%'
group by zona
having count(distinct tipo_producto) > 3;



/* Ejercicio 12: numero total de unidades vendidas en cada zona, para aquellas zonas que tengan un total de unidades
que sea al menos el 10% del total de unidades vendidas en todo el mundo */
select zona, sum(unidades)
from venta
group by zona
having sum(unidades) >= 0.1 * (select sum(unidades) from venta);



/* Ejercicio 13: paises con tiempo de entrega promedio  de mas de 10 días 
y que el importe mínimo de venta sea mayor que el importe de venta medio */
select pais, avg(datediff(fecha_envío, fecha_pedido)) as 'Entrega promedio'
from venta
group by  pais
having avg(datediff(fecha_envío, fecha_pedido)) > 10 
	and min(importe_venta) > (select avg(importe_venta) from venta);
    
/* Ejercicio 14: paises que el importe mínimo de venta del país sea mayor que el más bajo de 
los máximos por zona */
select max(importe_venta), zona
								from venta
                                group by zona
                                order by max(importe_venta)
                                limit 1;
select pais, min(importe_venta)
from venta
group by  pais
having min(importe_venta) > (select max(importe_venta)
								from venta
                                group by zona
                                order by max(importe_venta)
                                limit 1);

/* Ejercicio 15: ventas Online con fecha_pedido anterior a 2022 y con beneficio superior a la media */
select id_pedido, tipo_producto, unidades, precio_unitario, importe_venta-importe_coste as beneficio
from venta
where fecha_pedido < '2022-01-01' 
	and canal_venta like 'Online' 
		and importe_venta-importe_coste > (select avg(importe_venta-importe_coste) 
												from venta);
/* Ejercicio 16: ventas en Europa de países que tengan una total de ventas (suma importe_venta) mayor
de un millón */
select *
from venta
where zona like 'Europa' and pais in (select pais
										from venta
										group by pais
                                        having sum(importe_venta) > '1000000');
                                        
                                        
/* ejercicio 17: quiero saber los paises (pais, suma total de importes de venta) donde el precio unitario 
mínimo es mayor que el precio unitario medio para todo el mundo y que estén en una zona
donde la media de importe_venta de la zona sea mayor que la media mundial de importe_venta */
select pais, sum(importe_venta)
from venta
where zona in (select zona 
		from venta 
		group by zona 
		having avg(importe_venta) > 
			(select avg(importe_venta) from venta))
group by pais
having min(precio_unitario) > (select avg(precio_unitario) from venta);


/* Subconsultas con IN: 
Ejercicio 18 mostrar todos los pedidos (id_pedido, [tiempo de entrega], unidades, precio_unitario
importe_venta, id_Cliente) de los clientes que viven en el Bronx */
select id, localidad_cp from clientes order by localidad_cp;
select id_pedido, datediff(fecha_envío, fecha_pedido) as tiempo_entrega, unidades, precio_unitario, importe_venta, id_Cliente
from venta
where id_Cliente in (select id from clientes where localidad_cp like '%Bronx. NY%');

(select id, grupo from clientes where localidad_cp like '%Bronx. NY%');

/* Ejercicio 19 cuantos pedidos hay  por cada pais realizados por clientes del grupo 'A', mostrando solo los paises con más de 3 clientes
de ese grupo */
select count(id_pedido), pais
from venta
where id_Cliente in (select id from clientes where grupo like 'A')
group by pais
having count(id_Cliente) > 3;

/* Ejercicio 20: total de pedidos por cada pais, mostrando solo los paises con más de 3 clientes
del grupo 'A' */
select count(id_pedido), pais
from venta
group by pais
having pais in (select pais
				from venta
                where id_Cliente in (select id from clientes where grupo like 'A')
                group by pais
                having count(id_Cliente) > 3);