set serveroutput on;

--Caso 1

select
    p.pac_run,
    p.dv_run,
    p.pnombre||' '||p.snombre||' '||p.apaterno||' '||p.amaterno PAC_NOMBRE,
    a.ate_id,
    pa.fecha_venc_pago,
    pa.fecha_pago,
    pa.fecha_pago-pa.fecha_venc_pago DIAS_MOROSIDAD,
    e.nombre ESPECIALIDAD_ATENCION,
    CASE
        WHEN e.esp_id in(100,300) THEN 1200*(pa.fecha_pago-pa.fecha_venc_pago)
        WHEN e.esp_id in(200) THEN 1300*(pa.fecha_pago-pa.fecha_venc_pago)
        WHEN e.esp_id in(400,900) THEN 1700*(pa.fecha_pago-pa.fecha_venc_pago)
        WHEN e.esp_id in(500,600) THEN 1900*(pa.fecha_pago-pa.fecha_venc_paghahao)
        WHEN e.esp_id in(700) THEN 1100*(pa.fecha_pago-pa.fecha_venc_pago)
        WHEN e.esp_id in(1100) THEN 2000*(pa.fecha_pago-pa.fecha_venc_pago)
        WHEN e.esp_id in(1400,1800) THEN 2300*(pa.fecha_pago-pa.fecha_venc_pago)
    END MONTO_MULTA,
    NVL(porc.porcentaje_descto,0)/100 DESCUENTO
from paciente p join atencion a on p.pac_run = a.pac_run
    join pago_atencion pa on pa.ate_id = a.ate_id
    join especialidad e on e.esp_id = a.esp_id
    full join porc_descto_3ra_edad porc on
    TRUNC(months_between(sysdate,p.fecha_nacimiento)/12)
    between porc.anno_ini and porc.anno_ter
where e.esp_id in (100,200,300,400,500,600,700,900,1100,1400,1800) and
    extract(year from pa.fecha_venc_pago)=extract(year from sysdate)-1 and
(pa.fecha_pago-pa.fecha_venc_pago)>0
ORDER BY pa.fecha_venc_pago, p.apaterno;
DECLARE 
    cursor c_caso1 is
    select
        p.pac_run,
        p.dv_run,
        p.pnombre||' '||p.snombre||' '||p.apaterno||' '||p.amaterno PAC_NOMBRE,
        a.ate_id,
        pa.fecha_venc_pago,
        pa.fecha_pago,
        pa.fecha_pago-pa.fecha_venc_pago DIAS_MOROSIDAD,
        e.nombre ESPECIALIDAD_ATENCION,
        CASE
            WHEN e.esp_id in(100,300) THEN 1200*(pa.fecha_pago-pa.fecha_venc_pago)
            WHEN e.esp_id in(200) THEN 1300*(pa.fecha_pago-pa.fecha_venc_pago)
            WHEN e.esp_id in(400,900) THEN 1700*(pa.fecha_pago-pa.fecha_venc_pago)
            WHEN e.esp_id in(500,600) THEN 1900*(pa.fecha_pago-pa.fecha_venc_pago)
            WHEN e.esp_id in(700) THEN 1100*(pa.fecha_pago-pa.fecha_venc_pago)
            WHEN e.esp_id in(1100) THEN 2000*(pa.fecha_pago-pa.fecha_venc_pago)
            WHEN e.esp_id in(1400,1800) THEN 2300*(pa.fecha_pago-pa.fecha_venc_pago)
    END MONTO_MULTA,
    NVL(porc.porcentaje_descto,0)/100 DESCUENTO
    from paciente p join atencion a on p.pac_run = a.pac_run
    join pago_atencion pa on pa.ate_id = a.ate_id
    join especialidad e on e.esp_id = a.esp_id
    full join porc_descto_3ra_edad porc on
    TRUNC(months_between(sysdate,p.fecha_nacimiento)/12)
    between porc.anno_ini and porc.anno_ter
    where e.esp_id in (100,200,300,400,500,600,700,900,1100,1400,1800) and
    extract(year from pa.fecha_venc_pago)=extract(year from sysdate)-1 and
    (pa.fecha_pago-pa.fecha_venc_pago)>0
    ORDER BY pa.fecha_venc_pago, p.apaterno;
    --Variables 
    run paciente.pac_run%type;
    dv paciente.dv_run%type;
    v_nombre varchar2(150);
    ateid atencion.ate_id%type;
    fechavenc pago_Atencion.fecha_venc_pago%type;
    fechapago pago_Atencion.fecha_pago%type;
    dias  number;
    especialidad especialidad.nombre%type;
    monto number;
    descuento number;
    montofinal number;
BEGIN
    open c_caso1;
    loop 
        fetch c_Caso1 into run,dv,nombre,ateid, fechavenc,fechapago,dias,especialidad,monto,descuento;
    exit when c_caso1%notfound;
    montofinal := monto - round(monto*descuento);
    dbms_output.put_line(run||' '||nombre||' '||montofinal);
    insert into pago_moroso values(pacrun,dv,nombre,ateid,fechavenc,fechapago,dias,especialidad,montofinal);
    end loop;
    close c_caso1;
END;
/

--Caso 2
--Modificar Tabla
ALTER TABLE medico_servicio_comunidad MODIFY (
    ID_MED_SCOMUN NUMBER(6),         
    TOTAL_ATEN_MEDICAS NUMBER(4)     
);
--Bloque
DECLARE
    CURSOR c_medicos IS
        SELECT m.med_run, m.dv_run,
               m.pnombre, m.snombre, m.apaterno, m.amaterno,
               m.pnombre || ' ' || m.snombre || ' ' || m.apaterno || ' ' || m.amaterno AS med_nombre,
               u.nombre AS unidad,
               COUNT(DISTINCT a.ate_id) AS total_atenciones
          FROM medico m
          JOIN unidad u ON m.uni_id = u.uni_id
          LEFT JOIN atencion a ON m.med_run = a.med_run
          LEFT JOIN pago_atencion pa ON a.ate_id = pa.ate_id
           AND EXTRACT(YEAR FROM pa.fecha_pago) = EXTRACT(YEAR FROM SYSDATE) - 1
         GROUP BY m.med_run, m.dv_run, m.pnombre, m.snombre, m.apaterno, m.amaterno, u.nombre;
    v_med c_medicos%ROWTYPE;
    v_destino VARCHAR2(50);
    v_correo VARCHAR2(50);
BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM medico_servicio_comunidad';
    OPEN c_medicos;
    LOOP
        FETCH c_medicos INTO v_med;
        EXIT WHEN c_medicos%NOTFOUND;
        IF v_med.unidad IN ('ATENCIÓN ADULTO', 'ATENCIÓN AMBULATORIA') THEN
            v_destino := 'SAPU';
        ELSIF v_med.unidad = 'ATENCIÓN URGENCIA' THEN
            IF v_med.total_atenciones <= 3 THEN
                v_destino := 'SAPU';
            ELSE
                v_destino := 'HOSPITAL PUBLICO';
            END IF;
        ELSIF v_med.unidad IN ('CARDIOLOGÍA', 'ONCOLÓGICA', 'PACIENTE CRÍTICO') THEN
            v_destino := 'HOSPITAL PUBLICO';
        ELSIF v_med.unidad IN ('CIRUGÍA', 'CIRUGÍA PLÁSTICA') THEN
            IF v_med.total_atenciones <= 3 THEN
                v_destino := 'SAPU';
            ELSE
                v_destino := 'HOSPITAL PUBLICO';
            END IF;
        ELSIF v_med.unidad = 'PSIQUIATRÍA Y SALUD MENTAL' THEN
            v_destino := 'CESFAM';
        ELSE
            v_destino := 'SIN DESTINO';
        END IF;

        v_correo := LOWER(SUBSTR(REPLACE(v_med.unidad, ' ', ''),1,2)) ||
                    LOWER(SUBSTR(v_med.apaterno, GREATEST(LENGTH(v_med.apaterno)-2,1), 2)) ||
                    SUBSTR(TO_CHAR(v_med.med_run), -3) ||
                    '@ketekura.cl';

        -- Insertar en tabla destino
        INSERT INTO medico_servicio_comunidad (
            unidad,
            run_medico,
            nombre_medico,
            correo_institucional,
            total_aten_medicas,
            destinacion
        )
        VALUES (
            v_med.unidad,
            TO_CHAR(v_med.med_run) || '-' || v_med.dv_run,
            v_med.med_nombre,
            v_correo,
            v_med.total_atenciones,
            v_destino
        );

        DBMS_OUTPUT.PUT_LINE('Médico ' || v_med.med_run || ' asignado a ' || v_destino);
    END LOOP;
    CLOSE c_medicos;
END;
/
/*para probar el bloque :p */
SELECT * FROM medico_servicio_comunidad
ORDER BY unidad, nombre_medico;
DROP TABLE pago_atencion_2023;

-- Paso 2: Crea la tabla con los tipos claros
CREATE TABLE pago_atencion_2023 (
    ate_id            NUMBER(3),
    fecha_venc_pago   DATE,
    fecha_pago        DATE,
    monto_atencion    NUMBER(8),
    monto_a_cancelar  NUMBER(8),
    obs_pago          VARCHAR2(100)
);

-- Paso 3: Llena la tabla con el descuento del 23%
INSERT INTO pago_atencion_2023
SELECT
    a.ate_id,
    a.fecha_atencion + 30,
    NULL,
    a.costo,
    ROUND(a.costo * 0.77),
    'DESCUENTO ESTANDAR 23%'
FROM
    atencion a
WHERE
    EXTRACT(YEAR FROM a.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE) - 1;

/*parte 2*/
DROP TABLE pago_atencion_fase2;

CREATE TABLE pago_atencion_fase2 (
    ate_id            NUMBER(3),
    fecha_venc_pago   DATE,
    fecha_pago        DATE,
    monto_atencion    NUMBER(8),
    monto_a_cancelar  NUMBER(8),
    obs_pago          VARCHAR2(100)
);

INSERT INTO pago_atencion_fase2
SELECT
    a.ate_id,
    a.fecha_atencion + 30,
    NULL,
    a.costo,
    ROUND(a.costo * 0.90), -- Aplica un único descuento (10% por ejemplo)
    'DESCUENTO FONASA 10% APLICADO (MODELO SIN TRAMO)'
FROM
    atencion a
WHERE
    EXTRACT(YEAR FROM a.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE) - 1
    AND a.esp_id IN (
        100, 200, 300, 400, 500, 600, 700, 800, 900,
        1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700,
        1800, 1900
    );
/*para ver la tabla :p */
SELECT * FROM pago_atencion_fase2;


/*CASO 4*/
TRUNCATE TABLE info_medico_sii;

DECLARE
    CURSOR c_medicos IS
        SELECT med_run, dv_run, pnombre, snombre, apaterno, amaterno, sueldo_base
        FROM medico;

    v_med c_medicos%ROWTYPE;
    v_sueldo_anual NUMBER(15);
    v_bonificacion NUMBER(15);
    v_sueldo_bruto NUMBER(15);
    v_renta_imponible NUMBER(10);
BEGIN
    OPEN c_medicos;
    LOOP
        FETCH c_medicos INTO v_med;
        EXIT WHEN c_medicos%NOTFOUND;
        v_sueldo_anual := v_med.sueldo_base * 12;
        v_bonificacion := ROUND(v_sueldo_anual * 0.20);
        v_sueldo_bruto := v_sueldo_anual + v_bonificacion;
        v_renta_imponible := ROUND(v_sueldo_bruto * 0.90);
        INSERT INTO info_medico_sii (
            anno_tributario,
            numrun,
            dv_run,
            nombre_completo,
            cargo,
            meses_trabajados,
            sueldo_base_mensual,
            sueldo_base_anual,
            bonif_especial,
            sueldo_bruto_anual,
            renta_imponible_anual
        ) VALUES (
            EXTRACT(YEAR FROM SYSDATE), -- o el año que corresponda
            v_med.med_run,
            v_med.dv_run,
            v_med.pnombre || ' ' || v_med.snombre || ' ' || v_med.apaterno || ' ' || v_med.amaterno,
            'MÉDICO',
            12,
            v_med.sueldo_base,
            v_sueldo_anual,
            v_bonificacion,
            v_sueldo_bruto,
            v_renta_imponible
        );

        DBMS_OUTPUT.PUT_LINE('Insertado médico ' || v_med.med_run || ' con renta ' || v_renta_imponible);
    END LOOP;
    CLOSE c_medicos;

    DBMS_OUTPUT.PUT_LINE('Proceso CASO 4 finalizado correctamente.');
END;
/
