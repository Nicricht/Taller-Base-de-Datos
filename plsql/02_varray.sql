SET SERVEROUTPUT ON;

DECLARE
    TYPE t_nombres IS VARRAY(5) OF VARCHAR2(300);
    TYPE t_aranceles IS VARRAY(5) OF NUMBER;

    v_nombres t_nombres;
    v_aranceles t_aranceles;
BEGIN
    SELECT nombre_oferta, valor_arancel
    BULK COLLECT INTO v_nombres, v_aranceles
    FROM (
        SELECT
            c.nombre || ' - ' || i.nombre AS nombre_oferta,
            po.valor_arancel
        FROM OFERTA_ACADEMICA o
        JOIN CARRERA c ON c.id_carrera = o.id_carrera
        JOIN INSTITUCION i ON i.id_institucion = o.id_institucion
        JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
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
