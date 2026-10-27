-- Sin parametros: procesamiento agregado de todo el catalogo.
-- Sin COMMIT: el llamador controla la transaccion.
CREATE OR REPLACE PROCEDURE PR_EP2_ACTUALIZAR_RESUMEN
AUTHID DEFINER IS
BEGIN
  DELETE FROM EP2_RESUMEN_AREA;
  INSERT INTO EP2_RESUMEN_AREA
    (id_area,nombre_area,total_ofertas,total_planes,arancel_promedio,fecha_calculo)
  SELECT a.id_area,a.nombre,COUNT(DISTINCT o.id_oferta),
         COUNT(po.id_plan_oferta),
         ROUND(AVG(CASE WHEN po.valor_arancel>0 THEN po.valor_arancel END),2),
         SYSTIMESTAMP
  FROM AREA_CONOCIMIENTO a
  LEFT JOIN DENOMINACION_CARRERA dc ON dc.id_area=a.id_area
  LEFT JOIN CARRERA c ON c.id_denominacion=dc.id_denominacion
  LEFT JOIN OFERTA_ACADEMICA o ON o.id_carrera=c.id_carrera
  LEFT JOIN PLAN_OFERTA po ON po.id_oferta=o.id_oferta
  GROUP BY a.id_area,a.nombre;
  DBMS_OUTPUT.PUT_LINE('Areas resumidas: '||SQL%ROWCOUNT);
END;
/
-- Con parametros IN y OUT: reporte por area y conteo de planes.
CREATE OR REPLACE PROCEDURE PR_EP2_REPORTE_AREA(
  p_id_area IN AREA_CONOCIMIENTO.id_area%TYPE,
  p_total_planes OUT NUMBER
) AUTHID DEFINER IS
  v_nombre AREA_CONOCIMIENTO.nombre%TYPE;
  v_num NUMBER := 0;
BEGIN
  SELECT nombre INTO v_nombre FROM AREA_CONOCIMIENTO
  WHERE id_area=p_id_area;
  SELECT COUNT(*) INTO p_total_planes
  FROM DENOMINACION_CARRERA dc
  JOIN CARRERA c ON c.id_denominacion=dc.id_denominacion
  JOIN OFERTA_ACADEMICA o ON o.id_carrera=c.id_carrera
  JOIN PLAN_OFERTA po ON po.id_oferta=o.id_oferta
  WHERE dc.id_area=p_id_area;
  DBMS_OUTPUT.PUT_LINE('Area '||v_nombre||': '||p_total_planes||' planes');
  FOR r IN (
    SELECT nombre_carrera,nombre_institucion,valor_arancel
    FROM (SELECT dc.nombre nombre_carrera,i.nombre nombre_institucion,
                 po.valor_arancel
          FROM DENOMINACION_CARRERA dc
          JOIN CARRERA c ON c.id_denominacion=dc.id_denominacion
          JOIN OFERTA_ACADEMICA o ON o.id_carrera=c.id_carrera
          JOIN INSTITUCION i ON i.id_institucion=o.id_institucion
          JOIN PLAN_OFERTA po ON po.id_oferta=o.id_oferta
          WHERE dc.id_area=p_id_area
          ORDER BY po.valor_arancel DESC,dc.nombre,i.nombre)
    WHERE ROWNUM <= 5
  ) LOOP
    v_num := v_num + 1;
    DBMS_OUTPUT.PUT_LINE(v_num||'. '||r.nombre_carrera||
      ' / '||r.nombre_institucion||' / $'||r.valor_arancel);
  END LOOP;
  IF v_num=0 THEN DBMS_OUTPUT.PUT_LINE('Sin planes para el area'); END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20102,'Area inexistente: '||p_id_area);
END;
/
