--------------------------------------------------
-- Creación de un tabla a partir de una consulta
--------------------------------------------------

--------------------------------------------------
-- a) Con los nombres de campo de la consulta
--------------------------------------------------

DROP TABLE EMPLE_DEPART;
--------------------------------------------------
CREATE TABLE EMPLE_DEPART
AS 
SELECT APELLIDO, DNOMBRE
FROM EMPLE, DEPART
WHERE EMPLE.DEPT_NO = DEPART.DEPT_NO;
--------------------------------------------------

SELECT * FROM EMPLE_DEPART;
-- Con DESC podemos ver el tipo de dato de cada campo
DESC EMPLE_DEPART 

--------------------------------------------------
-- b) Con los nombres de campo especificados en CREATE
--------------------------------------------------

DROP TABLE EMPLE_DEPART;

--------------------------------------------------
CREATE TABLE EMPLE_DEPART (EMPLEADO, DEPARTAMENTO)
AS 
SELECT APELLIDO, DNOMBRE
FROM EMPLE, DEPART
WHERE EMPLE.DEPT_NO = DEPART.DEPT_NO;
--------------------------------------------------

SELECT * FROM EMPLE_DEPART;