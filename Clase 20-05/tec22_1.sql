select * from admin22.cliente;
select * from admin22.producto_inversion;
select * from admin22.producto_inversion_cliente;

--Parte 1: 
INSERT INTO DATOS 
select
    extract(year from sysdate) ANNO_TRIBUTARIO,
    to_char(c.numrun,'00g000g000')||'-'||c.dvrun RUN_CLIENTE,
    initcap(c.pnombre||' '||substr(c.snombre,1,1)||'. '||c.appaterno||' '||c.apmaterno) NOMBRE_CLIENTE,
    TO_CHAR(count(*)) TOTAL_PROD_INV,
    TO_CHAR(sum(p.monto_total_ahorrado+p.ahorro_minimo_mensual)) MONTO_TOTAL_AHORRADO
from admin22.cliente c
    JOIN admin22.producto_inversion_cliente p on p.nro_cliente=c.nro_cliente and p.cod_prod_inv in(30,35,40,45,50,55)
    GROUP BY c.numrun, c.dvrun,c.pnombre,c.snombre,c.appaterno,c.apmaterno
order by c.appaterno;

--Parte 2: ENCRIPTAR

create table Datos(
    ANNO_TRIBUTARIO INTEGER NOT NULL,
    RUN_CLIENTE VARCHAR2(30) NOT NULL,
    NOMBRE_CLIENTE VARCHAR2(150) NOT NULL,
    TOTAL_PROD_INV VARCHAR2(10) NOT NULL,
    MONTO_TOTAL_AHORRADO VARCHAR2(20) NOT NULL
);

--secuencias para la ecriptación
create sequence seq_encr start with 10 increment by 2;
update Datos set run_cliente= seq_encr.nextval||' '||run_cliente;

--Create sequence 2 
create sequence seq_encr2 start with 1 increment by 3;
update datos set run_cliente=substr(run_cliente,1,lenght(run_cliente,-1))||seq_encr2.nextval||substr(run_cliente,-1)



