set SERVEROUTPUT on;
--Caso 1

select 
    em.numrun_emp||'-'||em.dvrun_emp,
    em.pnombre_emp||' '||em.snombre_emp||' '||em.appaterno_emp||' '||em.apmaterno_emp
    ,em.SUELDO_BASE, 
    trunc(em.SUELDO_BASE/100000)
    ,round(trunc(em.SUELDO_BASE/100000)/100*em.sueldo_base),
    c.id_comuna
from Empleado em 
join comuna c on c.id_comuna = em.id_comuna;

DECLARE
    anno_tributario NUMBER(4) := EXTRACT(YEAR FROM SYSDATE);
    numrut Empleado.numrun_emp%TYPE := &Ingrese_rut;
    dvrun Empleado.dvrun_emp%TYPE;
    nombre varchar2(50);
    nombre_completo VARCHAR2(200); -- To store the concatenated name
    sueldo_base Empleado.sueldo_base%TYPE;
    id_comuna NUMBER;
    porc_mov NUMBER;
    valor_movil NUMBER;
    valor_movil_adic NUMBER;
    valor_totalmovil NUMBER;
BEGIN
    -- Enable DBMS_OUTPUT for seeing the results
    -- This line is typically run once per session in your SQL client, not within the PL/SQL block
    -- DBMS_OUTPUT.ENABLE;

    SELECT
        em.dvrun_emp,
        em.pnombre_emp,
        em.snombre_emp,
        em.appaterno_emp,
        em.apmaterno_emp,
        em.SUELDO_BASE,
        TRUNC(em.SUELDO_BASE / 100000), -- This is porc_mov
        ROUND(TRUNC(em.SUELDO_BASE / 100000) / 100 * em.sueldo_base), -- This is valor_movil
        em.id_comuna
    INTO
        dvrun,
        nombre,
        sueldo_base,
        porc_mov,
        valor_movil,
        id_comuna
    FROM
        Empleado em
    WHERE
        em.numrun_emp = numrut; -- Corrected variable name

    nombre_completo := p_nombre || ' ' || s_nombre || ' ' || ap_paterno || ' ' || ap_materno;

    valor_movil_adic := CASE id_comuna
                            WHEN 117 THEN 20000
                            WHEN 118 THEN 20000
                            WHEN 119 THEN 20000
                            WHEN 120 THEN 20000
                            WHEN 121 THEN 20000
                            ELSE 0
                        END;

    valor_totalmovil := valor_movil + valor_movil_adic;

    DBMS_OUTPUT.PUT_LINE('BONO DE MOVILIZACION PARA');
    DBMS_OUTPUT.PUT_LINE('Nombre:    ' || nombre_completo);
    DBMS_OUTPUT.PUT_LINE('Bono Final:    ' || valor_totalmovil);


    INSERT INTO proy_movilizacion VALUES(anno_tributario, numrut, dvrun, p_nombre, s_nombre, ap_paterno, ap_materno, sueldo_base, porc_mov, valor_movil, valor_movil_adic, valor_totalmovil);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Employee with RUT ' || numrut || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR, VERIFIQUE: ' || SQLERRM);
END;
/

--Caso 2
select  
    to_char(sysdate,'MMYYYY') ,
    e.numrun_emp,
    e.dvrun_emp,
    e.pnombre_emp||' '||e.snombre_emp||' '||e.appaterno_emp||' '||e.apmaterno_emp,
    substr(pnombre_emp,1,3)||length(e.pnombre_emp)||'*'||
    substr(to_char(e.sueldo_base),-1)||
    dvrun_emp||trunc(months_between(sysdate,fecha_contrato)/12)||
    case when trunc(months_between(sysdate,fecha_contrato)/12)<10 then 'X' 
    else'' 
    end "USUARO",
    substr(numrun_emp,3,1)||extract(year from fecha_nac)+2||substr(sueldo_base,-3)-1||
    case 
        when id_estado_civil in(10,60)then substr(appaterno_emp,1,2)
        when id_estado_civil in (20,30) then substr(appaterno_emp,1,1)||substr(appaterno_emp,-1)
        when id_estado_civil in(40) then substr(appaterno_emp,-3,2)
        when id_estado_civil in(50) then substr(appaterno_emp,-2)
    end||to_char(sysdate,'MMYYYY')||substr(c.nombre_comuna,1,1)
from empleado e
join comuna c on e.id_comuna=c.id_comuna;



declare
    anno varchar2(10):= to_char(sysdate,'MMYYYY');
    rut Empleado.numrun_emp%type:= 12648200;
    dvut Empleado.dvrun_emp%type;
    nombre varchar2(50);
    nombre_usuario VARCHAR2(30);
    clave_usuario varchar2(50);
begin
    select  
        to_char(sysdate,'MMYYYY') ,
        e.numrun_emp,
        e.dvrun_emp,
        e.pnombre_emp||' '||e.snombre_emp||' '||e.appaterno_emp||' '||e.apmaterno_emp,
        substr(pnombre_emp,1,3)||length(e.pnombre_emp)||'*'||
        substr(to_char(e.sueldo_base),-1)||
        dvrun_emp||round(months_between(sysdate,fecha_contrato)/12)||
        case when trunc(months_between(sysdate,fecha_contrato)/12)<10 then 'X' 
        else'' 
        end "USUARO",
        substr(numrun_emp,3,1)||extract(year from fecha_nac)+2||substr(sueldo_base,-3)-1||
        case 
            when id_estado_civil in(10,60)then substr(appaterno_emp,1,2)
            when id_estado_civil in (20,30) then substr(appaterno_emp,1,1)||substr(appaterno_emp,-1)
            when id_estado_civil in(40) then substr(appaterno_emp,-3,2)
            when id_estado_civil in(50) then substr(appaterno_emp,-2)
        end||to_char(sysdate,'MMYYYY')||substr(c.nombre_comuna,1,1)
    into dvut,nombre,nombre_usuario,clave_usuario
    from empleado e
    join comuna c on e.id_comuna=c.id_comuna
    where e.numrun_emp=rut;
    
    dbms_output.put_line('USUARIOS Y CONTRASEÑAS');
    dbms_output.put_line('USUARIO   : '||nombre_usuario);
    dbms_output.put_line('CONTRASEÑA    : '||clave_usuario);
    --Insert into usuario_clave values(anno, rut, dvut,nombre,nombre_usuario,clave_usuario)

exception
    when others then 
        dbms_output.put_line('ERROR, VERIFIQUE SU RUT');
end;
/


