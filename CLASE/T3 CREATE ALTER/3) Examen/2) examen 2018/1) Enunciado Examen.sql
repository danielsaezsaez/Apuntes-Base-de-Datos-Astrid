TIPO A

Nombre: <Pon tu nombre >

************************************************************************
	INSTRUCCIONES:
	==============

-Salva este fichero con las iniciales de tu nombre y apellidos,
 en el directorio "C:\Examen\ ":
	Ejemplo:	Tomas Coronado Garcia
			    TCG.sql

-Pon tu nombre al ejercicio y lee atentamente todas las preguntas.

-Entra en "SQL Plus" con cualquier usuario. 

-Carga el script para el examen desde el fichero "Datos2018.sql".

-Donde ponga "SQL>", copiarás las sentencias SQL que has utilizado.

-Donde ponga "Resultado:" copiarás el resultado que SQL*Plus te devuelve.

-RECUERDA: guardar, cada cierto tiempo, el contenido de este fichero. Es lo que voy a evaluar, si lo pierdes, lo siento, en la recuperación tendrás otra oportunidad.

-PUNTUACIÓN:  	0,7 puntos cada pregunta, excepto la pregunta 2 que vale 0,2 puntos. 


************************************************************************
	Descripción de las tablas:
	==========================

TABLA PROFESORES
  
# COD_PR			NUMBER(2)		Código del profesor
  DNI_PR			CHAR(9)			DNI del profesor
  NOMBRE_PR			VARCHAR2(25)	Nombre del profesor
  ESPECIALIDAD_PR	VARCHAR2(15)	Especialidad del profesor

TABLA CLASES

#*PROFESOR_CL	NUMBER(2)		Código del profesor
#*ASIGNATURA_CL	NUMBER(3)		Código de la asignatura
  AULA_CL		NUMBER(2)		Aula 
  HORASSEM_CL	NUMBER(2)		Horas semanales 

TABLA ASIGNATURAS

# COD_AS		NUMBER(3)		Código de la asignatura
  NOMBRE_AS		VARCHAR2(35)	Nombre de la asignatura
  HORAS_AS		NUMBER(3)		Horas anuales de la asignatura

TABLA ALUMNOS

# COD_AL		NUMBER(2)		Código del alumno
  FECINC_AL		DATE			Fecha de ingreso
  FECNAC_AL		DATE			Fecha de nacimiento
  DNI_AL		CHAR(9)			DNI del alumno
  NOMBRE_AL		VARCHAR2(25) 	Nombre del alumno
  CIUDAD_AL		VARCHAR2(10) 	Ciudad
* TUTOR_AL		NUMBER(2)		Código del profesor
* DELEGADO_AL	NUMBER(2)		Código del alumno delegado

TABLA NOTAS

#*ALUMNO_NO		NUMBER(2)		Código del alumno
#*ASIGNATURA_NO	NUMBER(3)		Código de la asignatura
# FECHA_NO		DATE			Fecha del examen
  NOTA_NO		NUMBER(4,2)		Nota del examen

Nota: 
	# PRIMARY KEY
	* FOREIGN KEY


***************************************************************************************************************
 1.- Crea las tablas anteriores con los nombres y tipos de campos suministrados sin ninguna restricción.

 SQL>

Resultado:

***************************************************************************************************************
 2.- Carga el script "Datos2018.sql".

 SQL>

Resultado:

***************************************************************************************************************
 3.- Añade la columna NOTAMEDIA_AL a la tabla ALUMNOS de tipo numérico con dos digitos enteros y dos decimales. Este campo debe contener valores de notas válidas.
 
SQL>

Resultado:

***************************************************************************************************************
 4.- Rellena el campo que acabas de crear con la nota media de cada alumno en sus asignaturas. Trata los valores NULL adecuadamente.
 
SQL>

Resultado:

***************************************************************************************************************
 5.- En la tabla ALUMNOS, modifica la fecha de ingreso de todos los alumnos al día de hoy menos un número de meses igual al día en que nació. Ejemplo: Si nacío el '23/10/1999', la fecha será la de hoy menos 23 meses.
 
SQL>

Resultado:

***************************************************************************************************************
 6.- Poner una nota (insertar en la tabla NOTAS) en la asignatura "Programación" a todos los alumnos en la fecha de hoy. La nota de cada uno será igual a las unidades el día que nació. Ejemplo: Si nacío el '23/10/1999', la nota será un 3.
 
SQL>

Resultado:

***************************************************************************************************************
 7.- Añade las restricciones de clave primaria y ajena a todas las tablas, y la restriccón de campos único a los DNI de profesores y alumnos.
 
SQL>

Resultado:

***************************************************************************************************************
 8.- Añade una restricción a la tabla ALUMNOS para que ningún alumno pueda ser menor de edad cuando ingresa. Si algún registro lo incumple, bórralo. Valida todas las transacciones realizadas hasta el momento.
 
SQL>

Resultado:

***************************************************************************************************************
 9.- Crea la vista NOTAS_MEDIAS, que muestre para cada asignatura, su código y nombre, el nombre del profesor que la imparte, y la nota media de todos los alumnos que la cursan. Los campos de la vista se llamarán: CODASIG, NOMBASIG, NOMBPROF y MEDIA.
 
SQL>

Resultado:

***************************************************************************************************************
10.- Inserta en la tabla ALUMNOS con la fecha de ingreso de hace una semana, los alumnnos de la tabla ALUMNOS_OLD que no estén ya en la tabla a partir de una SELECT. Las estructuras de las tablas son distintas, así que rellena con NULL los campos para los que no tienes datos. Si la inserción viola alguna restricción, modifica los valores de la SELECT para poder realizar la inserción.
 
SQL>

Resultado:

***************************************************************************************************************
11.- Los campos NULL de estos nuevos alumnos rellénalos de la siguiente manera: la ciudad "Granada", el tutor será el profesor cuyos alumnos tengan la nota media más alta y el delegado el alumno que era más joven cuando ingresó.
 
SQL>

Resultado:

***************************************************************************************************************
12.- A los nuevos alumnos, ponerle una nota en la asignaturas "Sistemas informaticos" con fecha de ayer. La nota será un 6. 
 
SQL>

Resultado:

***************************************************************************************************************
13.- Borrar las restricciones de clave ajena de todas las tablas.
 
SQL>

Resultado:

***************************************************************************************************************
14.- Deshacer todas las modificaciones hechas en los datos de las tablas desde la última validación.
 
SQL>

Resultado:

***************************************************************************************************************
15.- A partir de los datos de la tabla ALUMNOS, crea la tabla DATOS con los siguientes campos: DNI (sin la letra), NOMBRE (sin apellidos), APELLIDOS (sin nombre), DELEGADO (apellidos y nombre del delegado), EDAD (actual) y NOTA (la media de sus notas). El tipo de cada campo el adecuado para cada dato.
 
SQL>

Resultado:


 
