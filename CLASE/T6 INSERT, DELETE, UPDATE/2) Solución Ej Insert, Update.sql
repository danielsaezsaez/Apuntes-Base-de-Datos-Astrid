------------------------------------------------------------
-- Ejercicios sencillos de INSERT
------------------------------------------------------------
1.- Un nuevo registro mediante una orden INSERT rellenando todos los campos.

INSERT INTO ALUMNOS4 
	VALUES (80,'Antonio','Medina Parra', SYSDATE, '12345678', 'L');
	
------------------------------------------------------------
2.- Un nuevo registro mediante una orden INSERT rellenando sólo algunos campos.

INSERT INTO ALUMNOS4 (COD_AL, NOMBRE_AL, APELLIDO_AL)
	VALUES (90,'Santiago','Garcia Garcia');

------------------------------------------------------------
3.- Todos los datos de la tablas ALUMNOS a partir de una SELECT modificando los campos adecuadamente.

INSERT INTO ALUMNOS4
SELECT COD_AL,
	SUBSTR(NOMBRE_AL,INSTR(NOMBRE_AL,',')+2),
	SUBSTR(NOMBRE_AL,1, INSTR(NOMBRE_AL,',')-1),
	FECNAC_AL,
	SUBSTR(DNI_AL,1,8),
	SUBSTR(DNI_AL,9,1)
	FROM ALUMNOS;
	
------------------------------------------------------------
-- Ejercicios sencillos de UPDATE
------------------------------------------------------------
1.- Cambiar la fecha de ingreso de Amador al día de hoy.

UPDATE ALUMNOS
	SET FECINC_AL = SYSDATE
	WHERE NOMBRE_AL LIKE '%Amador%';

------------------------------------------------------------
2.- Poner la fecha de ingreso y la ciudad de Carlos a los alumnos de Sevilla.

UPDATE ALUMNOS
	SET (FECINC_AL, CIUDAD_AL) = (SELECT FECINC_AL, CIUDAD_AL
									FROM ALUMNOS
									WHERE NOMBRE_AL LIKE '%Carlos%')
	WHERE CIUDAD_AL LIKE '%Sevilla%';

------------------------------------------------------------
3.- Poner a Ismael: la fecha de ingreso de Javier, el tutor de Juan y el delegado de Daniel.

UPDATE ALUMNOS
	SET FECINC_AL = (SELECT FECINC_AL
						FROM ALUMNOS
						WHERE NOMBRE_AL LIKE '%Javier%'),
		DELEGADO_AL = (SELECT DELEGADO_AL
						FROM ALUMNOS
						WHERE NOMBRE_AL LIKE '%Daniel%')
	WHERE NOMBRE_AL LIKE '%Ismael%';
	