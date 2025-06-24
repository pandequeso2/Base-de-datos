set serveroutput on;
create table EMPLEADO(
    id_empleado number(5) primary key,
    nombre varchar2(150),
    salario number
);
INSERT INTO EMPLEADO VALUES(100,'ALAN GAJARDO',1300000);
INSERT INTO EMPLEADO VALUES(200,'ADAM CATRIL',750000);
INSERT INTO EMPLEADO VALUES(300,'PEDRO PASCAL',2300000);


--1- Variable de Enlace (BIND): variables que se crean fuera de los bloques anonimos, 
--estas variables permiten sacar datos de los bloques
VARIABLE v_resultado number;
--Bloque anonimo
begin 
    :v_resultado :=(600000 *1.10);
end;
/
--MOSTRAR RESULTADOS
print v_resultado;


--2- OBTEBER EL SUELDO DE ALAN GAJARDO EN UNA VARIABLE
variable salario number;
begin 
    select salario 
    into :salario
    from empleado where id_empleado=100;
end;
/
--Mostrar salaio de alan
print salario;

/*CURSORES: variables que permiten guardar la respuesta de las consultas */

declare
    --Cear cursos
    cursor c_empleados is select id_empleado, nombre,salario from empleado;
    v_id empleado.id_empleado%type;
    v_nombre empleado.nombre%type;
    v_salario empleado.salario%type;
begin
    open c_empleados; --Para usar el cursor se debe abrir
    loop 
        FETCH c_empleados into v_id,v_nombre,v_salario;
        exit when c_empleados%NOTFOUND;
        
        dbms_output.put_line('ID: '||v_id||' NOMBRE'||v_nombre||' SALARO: $'||v_salario);
    end loop;
    
    close c_empleados; --luego de acceder se debe cerrar
end;
/

--GUARDAR EN UNA VARIABLE DE ENLACE EL TOTAL DE EMPLEADOS QUE TIENEN UN SEULDO MAYOR AL SUELDO MINIMO

variable v_cantidad number;
declare
    cursor c_empleados is
        select salario from empleado;
    v_salario empleado.salario%type;
    v_total     number:=0;
    v_sueldo_minimo number:=529000;
begin
    open c_empleados;
        loop
            FETCH c_empleados into v_salario;
            exit when c_empleados%NOTFOUND;
            if v_salario > v_sueldo_minimo then
                v_total := v_total +1;            
            end if;
        end loop;
        
        :v_cantidad:=v_total; --Guardamos en resultado en la variable de enlace
    close c_empleados;

end;
/
print v_cantidad;

/*UTILIZANDO LA VARIABE DE ENLACE Y CURSOR IDENTIFICAR QUIEN ES EL EMPLEADO QUE GANA 
EL SALARIO MAXIMO*/
variable nombre_max varchar2(150);
declare
    cursor c_empleado is
        select nombre from empleado;
    v_nombre Empleado.nombre%type;
    v_salario empleado.salario%type;
    v_sueldo_maximo number;
    v_total number:=0;
begin
    select 
        max(salario)
    into v_sueldo_maximo
    from empleado;
    
    open c_empleado;
        loop
            fetch c_empleado into v_nombre;
            exit when c_empleado%NOTFOUND;
            if v_salario = v_sueldo_maximo then 
                v_total:=v_total+1;
            end if;
        end loop;
    close c_empleado;
    
    :nombre_max:=v_nombre;
end;
/
print nombre_max;






