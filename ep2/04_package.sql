-- SPEC: componentes publicos.
CREATE OR REPLACE PACKAGE PKG_EP2_ACADEMICO AUTHID DEFINER AS
  FUNCTION FN_PROMEDIO_AREA(p_id_area IN NUMBER) RETURN NUMBER;
  PROCEDURE PR_MOSTRAR_AREA(p_id_area IN NUMBER);
  PROCEDURE PR_REFRESCAR_RESUMEN;
END PKG_EP2_ACADEMICO;
/
-- BODY: implementacion + funcion privada FN_NOMBRE_AREA.
CREATE OR REPLACE PACKAGE BODY PKG_EP2_ACADEMICO AS
  FUNCTION FN_NOMBRE_AREA(p_id_area IN NUMBER) RETURN VARCHAR2 IS
    v_nombre AREA_CONOCIMIENTO.nombre%TYPE;
  BEGIN
    SELECT nombre INTO v_nombre FROM AREA_CONOCIMIENTO
    WHERE id_area=p_id_area;
    RETURN v_nombre;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20102,'Area inexistente: '||p_id_area);
  END FN_NOMBRE_AREA;

  FUNCTION FN_PROMEDIO_AREA(p_id_area IN NUMBER) RETURN NUMBER IS
    v_nombre VARCHAR2(150);
    v_promedio NUMBER;
  BEGIN
    v_nombre := FN_NOMBRE_AREA(p_id_area);
    SELECT ROUND(AVG(po.valor_arancel),2) INTO v_promedio
    FROM DENOMINACION_CARRERA dc
    JOIN CARRERA c ON c.id_denominacion=dc.id_denominacion
    JOIN OFERTA_ACADEMICA o ON o.id_carrera=c.id_carrera
    JOIN PLAN_OFERTA po ON po.id_oferta=o.id_oferta
    WHERE dc.id_area=p_id_area AND po.valor_arancel>0;
    RETURN v_promedio; -- NULL cuando no hay valores positivos
  END FN_PROMEDIO_AREA;

  PROCEDURE PR_MOSTRAR_AREA(p_id_area IN NUMBER) IS
    v_nombre VARCHAR2(150);
    v_total NUMBER;
  BEGIN
    v_nombre:=FN_NOMBRE_AREA(p_id_area);
    PR_EP2_REPORTE_AREA(p_id_area,v_total);
    DBMS_OUTPUT.PUT_LINE('Package: '||v_nombre||
      '; promedio arancel positivo: '||
      NVL(TO_CHAR(FN_PROMEDIO_AREA(p_id_area)),'SIN DATOS'));
  END PR_MOSTRAR_AREA;

  PROCEDURE PR_REFRESCAR_RESUMEN IS
  BEGIN
    PR_EP2_ACTUALIZAR_RESUMEN;
  END PR_REFRESCAR_RESUMEN;
END PKG_EP2_ACADEMICO;
/
