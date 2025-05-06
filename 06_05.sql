--DMl: Lenguaje de manipulacion de datos

--Creacion de tablas a partit de una consulta
--AS

drop table emp_menos_1m;
Create table emp_menos_1m as 
select
    e.numrun_emp||'-'||dvrun_emp "RUT",
    e.pnombre_emp||' '||e.appaterno_emp "EMPLEADO",
    e.sueldo_base "SUELDO"
from empleado e 
where e.sueldo_base <1000000
order by 3 asc;
--Savepoint 
savepoint a1;

--Update : 

Update empleado set sueldo_base=round(sueldo_base *1.10) where numrun_emp||'-'||dvrun_emp in(select rut from emp_menos_1m);

rollback;

--Delete: Borrar Datos de una tabla
delete from emp_menos_1m where Rut='12648200-3';

--Insert: Guardar datos
insert into emp_menos_1m (RUT,EMPLEADO,SUELDO) -- <-- Aqi se introducen las personas que tengan el rut 12648200 osea luis
select 
    e.numrun_emp||'-'||e.dvrun_emp "RUT",
    e.pnombre_emp||' '||e.appaterno_emp "EMPLEADO",
    e.sueldo_base "SUELDO"
from empleado e where e.numrun_emp = 12648200;

--Guardar Datos en tablas diferente
Create table Camion_con_Arriendo(
    nr_patente varchar2(6)  Unique,
    cantiad_arriendos number not null
);
Create table Camion_sin_Arriendo(
    nr_patente varchar2(6)  Unique,
    cantiad_arriendos number not null
);
--Consulta para identificar Camiones y cantidad de Arriendos
--Debemos considerar a los camiones sin ariendos

insert all when CANTIDAD =0 
                then into CAMION_SIN_ARRIENDO(nr_PATENTE,CANTIAD_ARRIENDOS) values (PATENTE,CANTIDAD)
            else 
                into camion_con_arriendo(nr_PATENTE,CANTIAD_ARRIENDOS) values (PATENTE,CANTIDAD)
select
    c.nro_patente "PATENTE",
    count(ac.id_arriendo) "CANTIDAD"
from Camion c
left JOIN ARRIENDO_CAMION AC ON c.nro_patente=ac.nro_patente
group by c.nro_patente;



