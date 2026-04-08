/* EJEMPLOS DE CONSULTAS CON JOIN EN LA BBDD HR (la del examen de select con una sola tabla)*/
use examen;

/* Ejemplo 1: mostrar una lista de todas localizaciones con el nombre del pais al que pertenecen */
select location_id, street_address, postal_code, city, state_province, 
		c.country_id, country_name
from locations l left join countries c on l.country_id = c.country_id;


/*  Ejemplo 2:  añadir a la consulta anterior el nombre de la region a la que pertenece esa localización */
select location_id, street_address, postal_code, city, state_province, 
		c.country_id, country_name, region_name
from (locations l left join countries c on l.country_id=c.country_id)
		join regions r on c.region_id= r.region_id;


select * from employees;
/*  Ejemplo 3:  datos de trabajador */
select employee_id, first_name, last_name, job_id, salary, department_id
from employees;

/*  Ejemplo 4:  añadir nombre del tipo de trabajo */
select employee_id, first_name, last_name, job_title, salary, 
		department_name
from (employees e join jobs j on e.job_id=j.job_id)
		join departments d on e.department_id = d.department_id;
        
        
/*  Ejemplo 5:  lista de todos los trabajos realizados (en job_history) mostrando
(employee_id, first_name, last_name, start_date, end_date, job_title, 
department_name) */
select e.employee_id, e.first_name, e.last_name, jh.start_date, jh.end_date,
	j.job_title, d.department_name
from ((employees e right join job_history jh on e.employee_id = jh.employee_id)
		join jobs j on j.job_id = jh.job_id)
			join departments d on d.department_id = jh.department_id;
            
            
/*  Ejemplo 6:  lista de todos los empleados (employee_id, first_name, last_name, hire_date, salary, department_name) */

select e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary, e.department_id, d.department_id, 
	d.department_name
from (employees e left join departments d on e.department_id = d.department_id);

/*  Ejemplo 7:  quiero obtener una lista de los trabajadores que ya cobran el .
salario máximo para su tipo de trabajo */

select j.job_id, j.job_title, j.max_salary, e.salary, e.employee_id, e.first_name, e.last_name
from employees e join jobs j on e.job_id = j.job_id
where e.salary = j.max_salary
order by last_name, first_name, max_salary;

/*  Ejemplo 8: quiero saber para cada trabajador una lista de los tipos de trabajo en
 los que podría ganar un salario mayor que el 
que gana actualmente */     

select j.job_id, j.job_title, j.max_salary, e.salary, e.employee_id, e.first_name, e.last_name
from employees e join jobs j on e.salary < j.max_salary
order by last_name, first_name, max_salary;
            
/*  Ejemplo 9:  para cada departamento muestra el nombre de departamento y 
el sueldo medio de sus trabajadores del departamento */
select d.department_name, avg(e.salary)
from departments d join employees e on e.department_id = d.department_id
group by d.department_id;

/*  Ejemplo 10:  quiero una lista de todas las localizaciones de la region
 'Europe' mostrando además cuantos departamentos hay en cada localización */
 
 select l.location_id, l.city, count(d.department_id), c.country_name, r.region_name
 from ((locations l join departments d on d.location_id = l.location_id)
			join countries c on l.country_id=c.country_id)
				join regions r on r.region_id=c.region_id
 where r.region_name like 'Europe'
 group by l.location_id;


/*  Ejemplo 11:  quiero ver para cada uno de los trabajos que ha tenido 
un empleado:
 (first_name, last_name, [job_title de su trabajo actual], [salary actual], 
 [job_title de trabajo anterior], [start_date trabajo anterior], [end_date
 trabajo anterior]) */
 
select e.first_name, e.last_name, e.job_id, jac.job_title, e.salary, 
	jh.job_id, jan.job_title, jh.start_date, jh.end_date
from ((employees e join job_history jh on e.employee_id=jh.employee_id)
		join jobs jac on e.job_id=jac.job_id)
			join jobs jan on jh.job_id=jan.job_id;
            
/*  Ejemplo 12:  lista de todos los empleados, su departamento y nombre 
de su jefe de departamento */

select e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary, d.department_name
	, m.employee_id as 'Manager id', m.first_name as 'Manager first_name', m.last_name as 
    'Manager last_name'
from (employees e join departments d using (department_id))
		join employees m on m.employee_id=d.manager_id;

/* ejercicio 13: mostrar una lista de empleados (nombre, apellido) con el nombre completo
de su jefe directo y de su jefe de departamento */

select e.first_name, e.last_name, d.department_name, jd.first_name as 'Nombre jefe dpt', jd.last_name as 'Apellido jefe dpt'
		, j.first_name as 'Nombre jefe', j.last_name as 'Apellido jefe'
from ((employees e join employees j on j.employee_id=e.manager_id)
			 join departments d on d.department_id=e.department_id)
				join employees jd on d.manager_id=jd.employee_id;
			
select e.employee_id, e.first_name, e.last_name, 
		m.employee_id as manager_id, m.first_name as manager_first_name, m.last_name as manager_last_name,
        dm.employee_id as dpt_man_id, dm.first_name as dpt_man_first_name, dm.last_name as dpt_man_last_name
from ((employees e  join employees m on e.manager_id=m.employee_id)  
		join departments d on e.department_id=d.department_id)
			join employees dm on dm.employee_id=d.manager_id;
            
/* Ejercicio 14: para cada tipo de trabajo (mostrar todos aunque no tengan ningún
 trabajador) mostrar cuantos empleados tienen esa categoria actualmente 
 y su salario medio */
 
 select j.job_id, j.job_title, count(e.employee_id), avg(e.salary)
 from jobs j left join employees e using (job_id)
 group by j.job_id;
 
/* Ejercicio 15: para cada pais (country_id, country_name) mostrar cuantos empleados
trabajan en ese pais y su sueldo medio */

select c.country_id, c.country_name, count(e.employee_id), avg(e.salary)
from countries c join locations l using (country_id)
		join departments d using (location_id)
			join employees e using (department_id)
group by c.country_id;

/* Ejercicio 16: quiero obtener una lista de todos los empleados que son jefe (manager) de 
alguien y mostrar de cuantos empleados es jefe cada uno */

select j.employee_id, j.first_name, j.last_name, count(e.employee_id)
from employees j join employees e on j.employee_id=e.manager_id
where j.employee_id != e.employee_id
group by j.employee_id
order by count(e.employee_id) desc;

/* Ejercicio 17: lista empleados que pertenecen a un departamento con mas de 6 empleados */

select e.employee_id, e.first_name, e.last_name, d.department_id, d.department_name
from employees e join departments d using (department_id)
where d.department_id IN (    
		select d2.department_id
		from departments d2 join employees e2 using (department_id)
		group by d2.department_id
		having count(e2.employee_id) > 6
);

select d2.department_id
from departments d2 join employees e2 using (department_id)
group by d2.department_id
having count(e2.employee_id) > 6;

/* Ejercicio 18: lista empleados que han cambiado de departamento alguna vez (nombre, apellido, 
departamento actual un cuantos departamentos ha estado) */

select e.first_name, e.last_name, d.department_name, count(distinct jh.department_id), count(distinct jh.start_date)
from (employees e join departments d on e.department_id=d.department_id)
		join job_history jh on jh.employee_id=e.employee_id
group by e.employee_id;

/* ejercicio 19: para cada ciudad cuantos departamentos hay y cuantos empleados */

select l.city, count(d.department_id), count(e.employee_id)
from locations l join departments d using (location_id)
		join employees e using(department_id)
group by l.city;