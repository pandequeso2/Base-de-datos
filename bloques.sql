create table Empleado(
    id_empleado number(5) primary key,
    nombre varchar2(100),
    salario number(10,2)
);
insert into empleado values(10,'Pedro Pascal', 2000);
insert into empleado values(20,'Alan gajardo', 1450);
insert into empleado values(30,'Juan Pablo Ramos', 1500);
insert into empleado values(40,'Camila Lara', 3500);
insert into empleado values(50,'Alejandra Flores', 1300);


set SERVEROUTPUT on;

--1 Bloque anidado
declare
    v_numero number :=10;
begin
    
    <<Bloque_interno>>
    declare
        v_numero number :=5;
    begin
        dbms_output.put_line('numero '||v_numero);
    end Bloque_interno;
    dbms_output.put_line('numero '||v_numero);
end;
/

--2. Bloques anidados controlando una exception

<<bloque_principal>>
declare 
    resultado number :=0;
begin
        --Bloque interno
        <<division_segura>>
        declare
            numerador number :=10;
            denominador number :=5;
        begin
            resultado:= numerador/denominador;
        exception
            when ZERO_DIVIDE THEN 
                dbms_output.put_line('ERROR INTERNO: Divicsion por 0');
        
        end division_segura;
        dbms_output.put_line('El resultado es: '||resultado);
exception
    when others then
        dbms_output.put_line('Error externo inesperado');
end bloque_principal;
/

--3. Recordar el comando if

<<bloque_principal>>
declare
    v_edad number := &INRESE_SU_EDAD;
begin
    if v_edad>17 then 
        dbms_output.put_line('Es Mayor de edad');
    elsif v_edad <=17 and v_edad>=0 then
        dbms_output.put_line('Es Menor de edad');
    else
        dbms_output.put_line('La Edad no puede ser negativa');
    end if;
end;
/

--4. Ejemplo utilizando if y DML: 
--Si el emppelado gana menos de un valor se le ahumentara el sueldo

DECLARE
    v_id empleado.id_empleado%type :=30;
    v_salario Empleado.salario%type ;
BEGIN
    select salario into v_salario from empleado where id_empleado = v_id;
    
    if v_salario <1800 then 
        update empleado set salario = salario * 1.10 where id_empleado=v_id;
        dbms_output.put_line('El Sueldo a sido aumentado en un 10%');
    else
        dbms_output.put_line('No hay aumento');
    end if;
EXCEPTION
    when NO_DATA_FOUND THEN 
        dbms_output.put_line('NO HAY DATOS RELACIONADOS CON LA ID '||v_id);
END;
/

--5. Comando Case
declare
    v_dia number:=2;
    nombre_dia varchar2(20);
begin
    nombre_dia:= case v_dia
                    WHEN  1 THEN 'LUNES'
                    WHEN  2 THEN 'MARTES'
                    WHEN  3 THEN 'MIERCOLES'
                    WHEN  4 THEN 'JUEVES'
                    WHEN  5 THEN 'VIERNES'
                    WHEN  6 THEN 'SABADO'
                    WHEN  7 THEN 'DOMINGO'
                    ELSE 'valor no valido'
                end;
    dbms_output.put_line('EL DIA ES '||nombre_dia);
end;
/

-- 6. Uilizar Case con DML
--Bajas el sueldo dl empleado con el sueldo mas alto
--Eliinar el empleado con el sueldo mas alto
commit;
savepoint a1;
rollback;
DECLARE
    v_operacion varchar2(10):='&INGRESE_OPCION';
BEGIN
    CASE v_operacion
        when 'borrar' then 
            delete from empleado where salario = (select max(salario)from empleado);
            dbms_output.put_line('BORRAR EL EMPLEADO CON EL SUELDO MAS ALTO');
        WHEN 'actualizar' then 
            update empleado set salario=round(salario*0.95) 
            where salario = (select max(salario) from empleado);
            dbms_output.put_line('ACTUALIZAR EL EMPLEADO CON EL SUELDO MAS ALTO');
        else
            dbms_output.put_line('Operacion no valida');
        end case;
END;
/

--7. Ciclo loop
declare
    contador_l number :=1;  -- <-- LOOP
    contador_w number :=1;  -- <-- WHILE
begin
--Ciclo loop
    loop
        dbms_output.put_line('CONTADOR LOOP: '||contador_l);
        contador_l:=contador_l+1;
        exit when contador_l >3;
    end loop;
    --Ciclo FOR    
    for i in 1..3 loop
        dbms_output.put_line('CONTADOR FOR: '||i);        
    end loop;
    --Ciclo WHILE
    while contador_w <= 3 loop
        dbms_output.put_line('CONTADOR WHILE: '||contador_w);
        contador_w :=contador_w +1;
    end loop;
end;
/
