--Creacion de de sinonimos:
create synonym persona for admin23.cliente;
create synonym pega for admin23.profesion_oficio;
create synonym picc for admin23.producto_inversion_cliente;
--Vista para entregar a los consultores

CREATE VIEW  v_pega_persona as
select
    to_char(p.numrun,'00g000g000')||'-'||p.dvrun RUT_PERSONA,
    INITCAP(p.pnombre||' '||p.snombre||' '||p.appaterno||' '||
        p.apmaterno) NOMBRE_PERSONA,
    p.direccion DIRECCION_PERSONA,
    pe.nombre_prof_ofic TRABAJO_PERSONA
from persona p
JOIN pega pe on pe.cod_prof_ofic=p.cod_prof_ofic
order by 2;


---------------------------
Create view v_persona_pic as
select
    to_char(p.numrun,'00g000g000')||'-'||p.dvrun RUT_PERSONA,
    INITCAP(p.pnombre||' '||p.snombre||' '||p.appaterno||' '||
        p.apmaterno) NOMBRE_PERSONA,
    count(*) CANTIDAD_PRODUCTO_INVERSION_CLIENTE,
    sum(pi.monto_total_ahorrado+pi.ahorro_minimo_mensual) MONTO_TOTAL_AHORRADO 
from persona p
JOIN picc pi on pi.nro_cliente=p.nro_cliente
group by p.numrun,p.dvrun,p.pnombre,p.snombre,p.appaterno,p.apmaterno;
