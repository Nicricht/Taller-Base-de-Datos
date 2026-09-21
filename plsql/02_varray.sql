SET SERVEROUTPUT ON;

DECLARE
    TYPE t_nombres IS VARRAY(5) OF VARCHAR2(400);
    TYPE t_aranceles IS VARRAY(5) OF NUMBER;

    v_nombres t_nombres;
    v_aranceles t_aranceles;
BEGIN
    SELECT nombre_oferta, valor_arancel
    BULK COLLECT INTO v_nombres, v_aranceles
    FROM (
        SELECT
            dc.nombre || ' (' || nc.nombre || ') - ' || i.nombre AS nombre_oferta,
            po.valor_arancel
        FROM OFERTA_ACADEMICA o
        JOIN CARRERA c ON c.id_carrera = o.id_carrera
        JOIN DENOMINACION_CARRERA dc ON dc.id_denominacion = c.id_denominacion
        JOIN NIVEL_CARRERA nc ON nc.id_nivel_carrera = c.id_nivel_carrera
        JOIN INSTITUCION i ON i.id_institucion = o.id_institucion
        JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
        WHERE po.valor_arancel > 0
        ORDER BY po.valor_arancel ASC
    )
    WHERE ROWNUM <= 5;

    FOR i IN 1 .. v_nombres.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            i || '. ' || v_nombres(i) || ' | Arancel: $' || v_aranceles(i)
        );
    END LOOP;
END;
/
