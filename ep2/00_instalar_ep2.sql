-- EJECUTAR F5 CONECTADO COMO EDUBIO360 DESPUES DE LA CARGA EP1.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
PROMPT Instalador EP2: validando prerrequisitos...
DECLARE
  v_faltan NUMBER;
  v_tablas NUMBER;
BEGIN
  IF USER <> 'EDUBIO360' THEN
    RAISE_APPLICATION_ERROR(-20200,'Esquema esperado EDUBIO360; actual: '||USER);
  END IF;
  SELECT COUNT(*) INTO v_faltan
  FROM (SELECT 'CREATE TABLE' privilegio FROM dual
        UNION ALL SELECT 'CREATE PROCEDURE' FROM dual
        UNION ALL SELECT 'CREATE TRIGGER' FROM dual) r
  WHERE NOT EXISTS (SELECT 1 FROM SESSION_PRIVS s WHERE s.privilege=r.privilegio);
  IF v_faltan <> 0 THEN
    RAISE_APPLICATION_ERROR(-20201,'Faltan permisos. Ver 00_permisos_ep2.sql');
  END IF;
  SELECT COUNT(*) INTO v_tablas FROM USER_TABLES
  WHERE TABLE_NAME IN ('AREA_CONOCIMIENTO','DENOMINACION_CARRERA','CARRERA',
    'OFERTA_ACADEMICA','PLAN_OFERTA','MATRICULA_HISTORICA','INSTITUCION');
  IF v_tablas <> 7 THEN
    RAISE_APPLICATION_ERROR(-20202,'Primero ejecutar el modelo de datos EP1');
  END IF;
END;
/
PROMPT Creando tablas auxiliares...
@@01_tablas_ep2.sql
PROMPT Creando funciones...
@@02_funciones.sql
PROMPT Creando procedimientos...
@@03_procedimientos.sql
PROMPT Creando package...
@@04_package.sql
PROMPT Creando triggers...
@@05_triggers.sql
PROMPT Validando compilacion...
@@06_verificar_ep2.sql
PROMPT EP2 instalada. Continuar con 07_pruebas_ep2.sql
