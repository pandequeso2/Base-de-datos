alter session set "_oracle_script"=true;

create user MDY2131_P13_1 identified by "MdYp12_13112"
default tablespace users temporary tablespace temp
quota unlimited on users;

create user MDY2131_P13_2 identified by "MdYp12_13112"
default tablespace users temporary tablespace temp
quota 100M on users;

create user MDY2131_P13_3 identified by "MdYp12_13112"
default tablespace users temporary tablespace temp
quota 100M on users;

create user MDY2131_P13_4 identified by "MdYp12_13112"
default tablespace users temporary tablespace temp
quota 100M on users;

create user MDY2131_P13_5 identified by "MdYp12_13112"
default tablespace users temporary tablespace temp
quota 100M on users;

create user MDY2131_P13_6 identified by "MdYp12_13112"
default tablespace users temporary tablespace temp
quota 100M on users;

--Privilegios 
grant create session, 
    create table,
    create sequence,
    create synonym,
    create indextype
    to MDY2131_P13_1;

grant create session, 
    create procedure,
    create trigger,
    create view,
    create materialized view 
    to MDY2131_P13_2;
grant create session, 
    create procedure,
    create trigger,
    create view,
    create materialized view 
    to MDY2131_P13_3;

--Creacion de roles 
create role r_verde;
grant create session,
    create view,
    create synonym to r_verde;
    
create role r_rojo;
grant create session to r_rojo;

--Asignar roles verde:
grant rol_verde to MDY2131_P13_2,MDY2131_P13_3;
alter user MDY2131_P13_2 default role r_verde;
alter user MDY2131_P13_3 default role r_verde;
--asignar roles rojos
grant rol_rojo to MDY2131_P13_4,MDY2131_P13_5,MDY2131_P13_6;
alter user MDY2131_P13_4 default role r_rojo;
alter user MDY2131_P13_5 default role r_rojo;
alter user MDY2131_P13_6 default role r_rojo;
--Creacion de perfiles 
create profile perf_MDY2131_P13_1 limit
    connect_time unlimited
    FAILED_LOGIN_ATTEMPTS 10
    PASSWORD_LIFE_TIME 120;
    
create profile perf_MDY2131_P13_2_3 limit 
    connect_time 4
    INACTIVE_ACCOUNT_TIME 60 --60 minutos de inctividad se cerrara la session
    failed_login_attempts 5
    password_lock_time 1
    password_life_time 90;
    
create profile perf_MDY2131_P13_4_5_6 limit 
    connect_time 2
    INACTIVE_ACCOUNT_TIME 20
    FAILED_LOGIN_ATTEMPTS 2
    PASSWORD_LOCK_TIME 1
    PASSWORD_LIFE_TIME 90
    PASSWORD_GRACE_TIME 1;
    
--Asignar perfiles:
alter user MDY2131_P13_1 profile perf_MDY2131_P13_1;
alter user MDY2131_P13_2 profile perf_MDY2131_P13_2_3;
alter user MDY2131_P13_3 profile perf_MDY2131_P13_2_3;
alter user MDY2131_P13_4 profile perf_MDY2131_P13_4_5_6;
alter user MDY2131_P13_5 profile perf_MDY2131_P13_4_5_6;
alter user MDY2131_P13_6 profile perf_MDY2131_P13_4_5_6;

--Permisos´para utilizar objetos de otro usuaerio
grant select on MDY2131_P13_1.aporte_a_sbif to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.cliente to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.comuna to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.credito to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.credito_cliente to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.cuota_credito_cliente to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.forma_pago to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.movimiento to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.producto_inversion to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.producto_inversion_cliente to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.profesion_oficio to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.provincia to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.region to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.sucursal to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.tipo_contrato to MDY2131_P13_2,MDY2131_P13_3 with grant option;
grant select on MDY2131_P13_1.tipo_movimiento to MDY2131_P13_2,MDY2131_P13_3 with grant option;

grant insert,update,delete on MDY2131_P13_1.credito_cliente to MDY2131_P13_2,MDY2131_P13_3;
grant insert,update,delete on MDY2131_P13_1.producto_inversion_cliente to MDY2131_P13_2,MDY2131_P13_3;
grant insert,update,delete on MDY2131_P13_1.cuota_credito_cliente to MDY2131_P13_2,MDY2131_P13_3;

grant select on MDY2131_P13_1.tipo_movimiento to MDY2131_P13_4 with grant option;
grant select on MDY2131_P13_1.sucursal to MDY2131_P13_4 with grant option;
grant select on MDY2131_P13_1.tipo_contrato to MDY2131_P13_4 with grant option;
grant select on MDY2131_P13_1.cliente to MDY2131_P13_4 with grant option;
grant select on MDY2131_P13_1.region to MDY2131_P13_4 with grant option;
grant select on MDY2131_P13_1.provincia to MDY2131_P13_4 with grant option;
grant select on MDY2131_P13_1.comuna to MDY2131_P13_4 with grant option;

grant select on MDY2131_P13_1.cliente to MDY2131_P13_5,MDY2131_P13_6 with grant option;
grant select on MDY2131_P13_1.region to MDY2131_P13_5,MDY2131_P13_6 with grant option;
grant select on MDY2131_P13_1.provincia to MDY2131_P13_5,MDY2131_P13_6 with grant option;
grant select on MDY2131_P13_1.comuna to MDY2131_P13_5,MDY2131_P13_6 with grant option;

--Synonimos
--Por terminar
