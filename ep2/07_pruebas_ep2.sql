-- Pruebas transaccionales, ejecutables en SQL Developer con F5.
-- Las escrituras a resumen y auditorias se revierten con ROLLBACK.
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
PROMPT Funcion sin parametros en SQL
SELECT FN_EP2_TOTAL_MATRICULAS() total_matriculas FROM dual;
PROMPT Funcion con parametros en SQL
SELECT FN_EP2_CLASIFICAR_ARANCEL(valor_arancel) tramo,COUNT(*) planes
FROM PLAN_OFERTA GROUP BY FN_EP2_CLASIFICAR_ARANCEL(valor_arancel);
PROMPT Package en SQL (funcion publica)
SELECT a.nombre,PKG_EP2_ACADEMICO.FN_PROMEDIO_AREA(a.id_area) promedio
FROM AREA_CONOCIMIENTO a ORDER BY a.nombre;
PROMPT Prueba con rollback: procedimientos, package y dos tipos de trigger
DECLARE
  v_id_area NUMBER; v_areas NUMBER;
  v_id_plan NUMBER; v_precio NUMBER;
  v_total NUMBER; v_resumen NUMBER;
  v_fila_ini NUMBER; v_sent_ini NUMBER;
  v_fila_fin NUMBER; v_sent_fin NUMBER;
  v_actual NUMBER; v_coinciden NUMBER;
  v_clasificacion VARCHAR2(40);
BEGIN
  SELECT MIN(id_area),COUNT(*) INTO v_id_area,v_areas FROM AREA_CONOCIMIENTO;
  SELECT MIN(id_plan_oferta) INTO v_id_plan FROM PLAN_OFERTA;
  IF v_id_area IS NULL OR v_id_plan IS NULL THEN
    RAISE_APPLICATION_ERROR(-20220,'Debe cargar primero los datos EP1');
  END IF;
  SAVEPOINT ep2_demo;
  BEGIN
    PR_EP2_REPORTE_AREA(v_id_area,v_total);
    PKG_EP2_ACADEMICO.PR_MOSTRAR_AREA(v_id_area);
    PKG_EP2_ACADEMICO.PR_REFRESCAR_RESUMEN;
    SELECT COUNT(*) INTO v_resumen FROM EP2_RESUMEN_AREA;
    IF v_resumen<>v_areas THEN
      RAISE_APPLICATION_ERROR(-20221,'Resumen por area incompleto');
    END IF;
    SELECT COUNT(*) INTO v_fila_ini FROM EP2_AUDITORIA_ARANCEL;
    SELECT COUNT(*) INTO v_sent_ini FROM EP2_AUDITORIA_SENTENCIA;
    SELECT valor_arancel INTO v_precio FROM PLAN_OFERTA WHERE id_plan_oferta=v_id_plan;

    UPDATE PLAN_OFERTA SET valor_arancel=valor_arancel+1
    WHERE id_plan_oferta=v_id_plan;
    IF SQL%ROWCOUNT<>1 THEN
      RAISE_APPLICATION_ERROR(-20222,'Update debio afectar una fila');
    END IF;
    SELECT COUNT(*) INTO v_fila_fin FROM EP2_AUDITORIA_ARANCEL;
    SELECT COUNT(*) INTO v_sent_fin FROM EP2_AUDITORIA_SENTENCIA;
    IF v_fila_fin<>v_fila_ini+1 OR v_sent_fin<>v_sent_ini+1 THEN
      RAISE_APPLICATION_ERROR(-20223,'No se activaron ambos triggers');
    END IF;
    SELECT COUNT(*) INTO v_coinciden FROM EP2_AUDITORIA_ARANCEL
    WHERE id_plan_oferta=v_id_plan
      AND arancel_anterior=v_precio AND arancel_nuevo=v_precio+1;
    IF v_coinciden<1 THEN
      RAISE_APPLICATION_ERROR(-20224,'OLD/NEW no coinciden');
    END IF;

    UPDATE PLAN_OFERTA SET valor_arancel=valor_arancel
    WHERE id_plan_oferta=-1;
    SELECT COUNT(*) INTO v_fila_fin FROM EP2_AUDITORIA_ARANCEL;
    SELECT COUNT(*) INTO v_sent_fin FROM EP2_AUDITORIA_SENTENCIA;
    IF v_fila_fin<>v_fila_ini+1 OR v_sent_fin<>v_sent_ini+2 THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al diferenciar fila de sentencia');
    END IF;

    BEGIN
      v_clasificacion:=FN_EP2_CLASIFICAR_ARANCEL(-1);
      RAISE_APPLICATION_ERROR(-20226,'No se rechazo el arancel negativo');
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE<>-20101 THEN RAISE; END IF;
    END;
    ROLLBACK TO SAVEPOINT ep2_demo;
  EXCEPTION WHEN OTHERS THEN
    ROLLBACK TO SAVEPOINT ep2_demo;
    RAISE;
  END;
  SELECT COUNT(*) INTO v_fila_fin FROM EP2_AUDITORIA_ARANCEL;
  SELECT COUNT(*) INTO v_sent_fin FROM EP2_AUDITORIA_SENTENCIA;
  SELECT valor_arancel INTO v_actual FROM PLAN_OFERTA WHERE id_plan_oferta=v_id_plan;
  IF v_fila_fin<>v_fila_ini OR v_sent_fin<>v_sent_ini OR v_actual<>v_precio THEN
    RAISE_APPLICATION_ERROR(-20227,'Rollback no restituyo el estado original');
  END IF;
  DBMS_OUTPUT.PUT_LINE('OK: pruebas de funciones, procedures, package, triggers y rollback.');
END;
/
