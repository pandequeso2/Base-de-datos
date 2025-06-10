/*BLOQUES ANONIMOS

Es una unidad de codigos SQL qu se ejecuta de manera annima, eto quiere decir 
qu a diferencia de los procedimientos, funciones, trigger, los bloques anonios no se guardan.
Una vez que se ejecutan estos terminan y desaparece de la memoria

Estructura:

DECKARE
    --Seccon opcional donde declaramos variabbles
BEGIN
    --Seccion obligatoria donde colocamos el codigo a ejecutar
EXCEPTION
    Seccion obligatoria, controlar errores
END
    --Seccion obligatoria para terminar el bloque
*/

--COmando para actvar mensajes por DBMS_OUTPUT

set SERVEROUTPUT on;

--Mostrar mensajes por bloque anonimo
--Ejemplo 1
begin
    dbms_output.put_line('Hola mundo'); --Print en SQL
end;
--EJemplo 2: Trabajo de variables en bloques anonimos
/*
nombre_variable tipo_dato {: = valor_inicial}
*/
declare 
    v_nombre varchar2(50) := 'Pepe';
    v_edad number(3) := 70;
    v_salario number(10,2);
    v_fecha_hoy date := sysdate;
    v_activo boolean := false;
begin
    --Agignamos el valor en el begin
    v_salario :=5500.27;
    dbms_output.put_line('NOMBRE : '||v_nombre);
    dbms_output.put_line('EDAD: '||v_edad);
    dbms_output.put_line('Salario : '||v_salario);
    dbms_output.put_line('FECHA : '||to_char(v_fecha_hoy,'DD/MM/YYYY hh24:MI:SS'));
    
    --validar la variable booleana
    if v_activo then 
        dbms_output.put_line('ESTADO    :INACTIVO');
    ELSE
        dbms_output.put_line('ESTADO    : ACIVO');
    end if;
end;
--Ejemplo 3: Tomar los tipos de datos de una tabla

--Tabla para el ejemplo

create table EMPLEADO(
    ID_EMP NUMBER(5) PRIMARY KEY,
    NOMBRE VARCHAR2(50),
    SALARIO NUMBER(10,2)
);

INSERT INTO EMPLEADO VALUES(1, 'Ana lopez', 6000.50);
INSERT INTO EMPLEADO VALUES(2, 'Alan gajardo', 10000.42);
INSERT INTO EMPLEADO VALUES(3, 'Catalina Jara', 8500.30);
commit;

declare
    v_id_empleado EMPLEADO.id_emp%type := 1;
    v_nombre_emp EMPLEADO.nombre%type := 'Ana lopez';
    v_salario EMPLEADO.salario%type := 6000.50;
begin
    dbms_output.put_line('DETALLE EMPLEADO');
    dbms_output.put_line('================');
    dbms_output.put_line('CODIGO    :'||v_id_empleado);
    dbms_output.put_line('NOMBRE    :'||v_nombre_emp);
    dbms_output.put_line('SALARIO   :$'||v_salario);

end;
--Ejemplo 4: COnsultas en un bloque anonimo

DECLARE
    v_id_emp EMPLEADO.id_emp%type :=  &Ingrese_codigo;
    v_nombre empleado.nombre%type;
    v_salario empleado.salario%type;
begin
    select nombre, salario into v_nombre,v_salario from Empleado where id_emp = v_id_emp;
    dbms_output.put_line('INFORMACIÓN EMPLEADO 😊');
    dbms_output.put_line('=======================');
    dbms_output.put_line('Codigo    : '||v_id_emp);
    dbms_output.put_line('Nombre    : '||v_nombre);
    dbms_output.put_line('Salario   : $'||v_salario);
exception
    when no_data_found then dbms_output.put_line('ERROR, No existe el codigo    :'||v_id_emp);
    when too_many_rows then dbms_output.put_line('ERROR, Demasiadas filas en id'||v_id_emp);
    when others then dbms_output.put_line('ERROR Inesperado en id'||v_id_emp);
end;

--Ejemplo 5: CIclos en bloquees anonimos
begin
    for i in 1..5 loop --CIclo for desde 1 a 5
        dbms_output.put_line('iteracion numero :'||i);
        END LOOP;
end;

--Ejemplo 6: CIClo para mostrar los empleados de una tabla

declare 
    v_total_empleados number :=0; --Variable para cantidad de empleados
begin
    dbms_output.put_line('DETALLES DE EMPLEADOS');
    dbms_output.put_line('---------------------');
    --Ciclo para recorrer la tabla
    for i in (select id_emp,nombre,salario from empleado) loop
        dbms_output.put_line('Codigo    : '||i.id_emp);
        dbms_output.put_line('Nombre    : '||i.nombre);
        dbms_output.put_line('Salario   : '||i.salario);
        v_total_empleados := v_total_empleados +1; --Contador
    end loop;
    dbms_output.put_line('Cantidad de empleados  :'||v_total_empleados);
exception
    when others then dbms_output.put_line('ERROR');
end;