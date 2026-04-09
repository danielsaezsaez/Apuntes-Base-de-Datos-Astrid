use ejemplo_ventas;

/* obtener una listas de clientes (id, nombre_completo) que esten entre el id C0100 y C0199 */
SELECT id, nombre_completo
FROM clientes
WHERE ID LIKE 'C01__';

SELECT id, nombre_completo
FROM clientes
WHERE ID BETWEEN 'C0100' AND 'C0199';

SELECT id, nombre_completo
FROM clientes
WHERE (id >= 'C0100') AND (id <='C0199');

/* haz un listado de todas las ventas con fecha de pedido en el 2021 */
select * 
from venta
where fecha_pedido BETWEEN '2021-01-01' AND '2021-12-31'
order by fecha_pedido ASC;
select * 
from venta
where fecha_pedido >= '2021-01-01' AND fecha_pedido <='2021-12-31'
order by fecha_pedido ASC;