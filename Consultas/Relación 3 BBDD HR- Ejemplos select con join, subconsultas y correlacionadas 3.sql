use examen;

/* Ejercicio 17: lista empleados que pertenecen a un departamento con mas de 6 empleados */
select e.employee_id, e.first_name, e.last_name, d.department_id, d.department_name
from employees e join departments d using (department_id)
where department_id IN (
				select e2.department_id
				from employees e2
				group by e2.department_id
				having count(e2.employee_id) > 6
                );
                
/* Ejercicio 20: lista empleados que pertenecen a un departamento donde hay al menos otro empleado 
con el mismo apellido */
select e.employee_id, e.first_name, e.last_name, d.department_id, d.department_name
from employees e join departments d using (department_id)
where department_id IN (
				select e2.department_id
				from employees e2
                where e2.last_name like e.last_name
                group by e2.department_id
                having count(e2.employee_id) >=2
                );

/* Ejemplo 21:  lista de empleados que tienen un jefe directo que tiene más de 5 subordinados */
select e.employee_id, e.first_name, e.last_name
from employees e 
where e.manager_id in (
		select e2.manager_id
        from employees e2
        group by e2.manager_id
        having count(e2.employee_id) > 5
);
/* Ejemplo 22:  lista de empleados, con sus jefes de departamento, donde se cumpla que 
el jefe de departamento ha trabajado alguna vez de la misma categoria que el empleado. */
select e.employee_id, e.first_name, e.last_name, e.manager_id, jd.first_name, jd.last_name,
 e.job_id, jd.job_id
from ((employees e join departments d using(department_id))
		join employees jd on jd.employee_id=d.manager_id)
			join job_history jh on jd.employee_id=jh.employee_id
where jh.job_id = e.job_id;


/* Ejemplo 23: lista de empleados que trabajan en un pais donde el salario medio es 
superior a 5000  */

select e.employee_id, e.first_name, e.last_name, l.country_id
from employees e join departments d using(department_id)
		join locations l using(location_id)
where l.country_id in (
			select country_id
            from employees e2 join departments d2 using(department_id)
				join locations l2 using(location_id)
			group by country_id
            having avg(e2.salary) > 5000
);


/* Ejemplo 24: lista de empleados que trabajan en un trabajo donde el salario mínimo sea 
superior al salario medio de su pais */

select e.employee_id, e.first_name, e.last_name, j.job_id
from employees e join jobs j using (job_id)
		join departments d using(department_id)
			join locations l using(location_id)
where j.min_salary > (select avg(e2.salary)
						from (employees e2 join departments d2 on e2.department_id =d2.department_id)
							join locations l2 on l2.location_id=d2.location_id
						where (l2.country_id = l.country_id));

/* Ejercicio 25: Realiza una consulta que obtenga los datos de empleados 
[EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_TITLE, DEPARTMENT_NAME,
 CITY, COUNTRY_NAME] pero solo que los que trabajen en paises en los que 
 estén localizados no más de 3 departamentos
*/
select e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, j.JOB_TITLE, d.DEPARTMENT_NAME,
 l.CITY, c.COUNTRY_NAME
from employees e join departments d on e.department_id=d.department_id
		join locations l on l.location_id=d.location_id
			join countries c on c.country_id=l.country_id
				join jobs j on j.job_id=e.job_id
where c.country_id in (
		select l2.country_id
        from locations l2 join departments d2 on l2.location_id=d2.location_id
        group by l2.country_id
        having count(d2.department_id) <= 3
);


select e.employee_id, e.first_name, e.last_name, j.job_title, d.department_name,
		l.city, c.country_name
from employees e join jobs j using(job_id)
		join departments d using(department_id)
			join locations l using(location_id)
				join countries c using(country_id)
where c.country_id in (
			select l2.country_id
			from countries c2 join locations l2 using (country_id)
					join departments d2 using (location_id)
			group by l2.country_id 
			having count(department_id)<=3
);

/* Ejercicio 26: Realiza una consulta que obtenga los datos de los departamentos
 [DEPARTMENT_ID, DEPARTMENT_NAME, CITY, COUNTRY_NAME, número total de empleados del departamento] 
 donde haya algún empleado que haya tenido más de un trabajo anterior al actual
   (más de 1 trabajo en job_history)
*/ 

select d.department_id, d.department_name, l.city, c.country_name, count(e.employee_id)
from departments d join locations l using(location_id)
		join countries c using(country_id)
			join employees e using(department_id)
group by department_id
having department_id in (
		select e2.department_id
		from employees e2 join job_history jh2 using (employee_id)
		group by e2.employee_id
		having count(jh2.start_date) > 1
);

/* ejercicio 27: muestra una lista de todos los contratos tanto 
actuales como antiguos de cada empleado */
select e.employee_id, first_name, last_name, jh.start_date, jh.end_date, jh.job_id, j.job_title
from employees e join job_history jh on e.employee_id=jh.employee_id
			join jobs j on jh.job_id=j.job_id
union
select employee_id, first_name, last_name, hire_date, null, e2.job_id, j2.job_title
from employees e2 join jobs j2 on j2.job_id=e2.job_id
order by last_name, first_name;


/* Ejercicio 28: lista de todos los empleados que son jefes (manager), tanto los jefes directos,
como los jefes de departamento, mostrando (employee_id, first_name, last_name, department_name, 
[número de subordinados])... el número de subordinados serán todos los miembros del departamento
para los jefes de departamento.  */

select m.employee_id, m.first_name, m.last_name, d.department_name, 
		count(e.employee_id) as 'Número subordinados'
from employees m join employees e on e.manager_id=m.employee_id
		join departments d on m.department_id=d.department_id
group by m.employee_id
UNION 
select jd.employee_id, jd.first_name, jd.last_name, d.department_name,
		count(e.employee_id)
from employees e join departments d on e.department_id=d.department_id
			join employees jd on jd.employee_id=d.manager_id
group by d.department_id;