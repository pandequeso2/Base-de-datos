alter session set "_oracle_script"=true;

/*DCL: Data cntrol Lanuaje*/

--Usuario admin dueño de la base de datos:
create user admin23 identified by "Duocadmin25"
default tablespace users temporary tablespace temp
quota UNLIMITED on users;
--Uusarios tecnicos que utilizaran la base de datos:

create user tec23_1 identified by "Duocadmin25"
default tablespace users
temporary tablespace temp
quota 100M on users;

create user tec23_2 identified by "Duocadmin25"
default tablespace users
temporary tablespace temp
quota 100M on users;

create user con23_1 identified by "Duocadmin25"
default tablespace users
temporary tablespace temp
quota 100M on users;

create user con23_2 identified by "Duocadmin25"
default tablespace users
temporary tablespace temp
quota 100M on users;

create user con23_3 identified by "Duocadmin25"
default tablespace users
temporary tablespace temp
quota 100M on users;

/*Privilegios admin*/
grant create session
    , create table, 
    create sequence 
    ,create synonym,
    create procedure,
    create trigger
    to admin23;
/*Creacion de roles*/

create role rol_tec;
--Permisos de el rol
grant create session, 
    create view,
    create synonym to rol_tec;
--Asignar rol a tecnicos
grant rol_tec to tec23_1,tec23_2;
alter user tec23_1 default role rol_tec;
alter user tec23_2 default role rol_tec;

--CRear y asignar rol a consultor
create role rol_cons;
grant create session to rol_cons;
grant rol_cons to con23_1,con23_2,con23_3;
alter user con23_1 default role rol_cons;
alter user con23_2 default role rol_cons;
alter user con23_3 default role rol_cons;

--Crear Perfiles
create profile perf_admin limit
    connect_time unlimited --Tiempo de conexion
    FAILED_LOGIN_ATTEMPTS 4 --Intentos fallidos
    PASSWORD_LOCK_TIME 2 --Tiempo de bloqueo (numero entero== 1 dia, 1= 1 dia)
    PASSWORD_LIFE_TIME 60 -- caducidad de la contraseña, (1==1 dia), 60=2 meses
    PASSWORD_GRACE_TIME 2; --Tiempo extra o tiempo de gracia para cambiar clave 
    
create profile perf_tec limit
    CONNECT_TIME 60
    FAILED_LOGIN_ATTEMPTS 5
    PASSWORD_LOCK_TIME 7
    PASSWORD_LIFE_TIME 30;
    
create profile perf_cons limit
    CONNECT_TIME 30
    FAILED_LOGIN_ATTEMPTS 2
    PASSWORD_LOCK_TIME 2
    PASSWORD_LIFE_TIME 14;

--Asignar perfiles
alter user admin23 profile perf_admin;
alter user tec23_1 profile perf_tec;
alter user tec23_2 profile perf_tec;
alter user con23_1 profile perf_cons;
alter user con23_2 profile perf_cons;
alter user con23_3 profile perf_cons;

--Desbloquear cuenta:
alter user con23_3 account unlock;

/*Permisos para utilizar objetos de otro usuario:*/
grant select on admin23.aporte_a_sbif to tec23_1,tec23_2 with grant option;
grant select on admin23.cliente to tec23_1,tec23_2 with grant option;
grant select on admin23.comuna to tec23_1,tec23_2 with grant option;
grant select on admin23.credito to tec23_1,tec23_2 with grant option;
grant select on admin23.credito_cliente to tec23_1,tec23_2 with grant option;
grant select on admin23.cuota_credito_cliente to tec23_1,tec23_2 with grant option;
grant select on admin23.forma_pago to tec23_1,tec23_2 with grant option;
grant select on admin23.movimiento to tec23_1,tec23_2 with grant option;
grant select on admin23.producto_inversion to tec23_1,tec23_2 with grant option;
grant select on admin23.producto_inversion_cliente to tec23_1,tec23_2 with grant option;
grant select on admin23.profesion_oficio to tec23_1,tec23_2 with grant option;
grant select on admin23.provincia to tec23_1,tec23_2 with grant option;
grant select on admin23.region to tec23_1,tec23_2 with grant option;
grant select on admin23.sucursal to tec23_1,tec23_2 with grant option;
grant select on admin23.tipo_contrato to tec23_1,tec23_2 with grant option;
grant select on admin23.tipo_movimiento to tec23_1,tec23_2 with grant option;

grant insert, update, delete on admin23.movimiento to tec23_1,tec23_2;
grant insert, update, delete on admin23.cliente to tec23_1,tec23_2;
grant insert, update, delete on admin23.sucursal to tec23_1,tec23_2;

--Dar permisos a el consultor
grant select on tec23_1.v_pega_persona to con23_1,con23_2;

grant select on tec23_1.v_persona_pic to con23_1,con23_2;



