SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_ofertas_por_area (p_id_area AREA_CONOCIMIENTO.id_area%TYPE) IS
        SELECT
            c.nombre AS carrera,
            i.nombre AS institucion,
            po.valor_arancel
        FROM CARRERA c
        JOIN OFERTA_ACADEMICA o ON o.id_carrera = c.id_carrera
        JOIN INSTITUCION i ON i.id_institucion = o.id_institucion
        JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
        WHERE c.id_area = p_id_area
        ORDER BY c.nombre, i.nombre;

    v_contador NUMBER;
BEGIN
    FOR a IN (
        SELECT id_area, nombre
        FROM AREA_CONOCIMIENTO
        ORDER BY nombre
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('====================================');
        DBMS_OUTPUT.PUT_LINE('AREA: ' || a.nombre);

        v_contador := 0;

        FOR o IN c_ofertas_por_area(a.id_area) LOOP
            v_contador := v_contador + 1;

            DBMS_OUTPUT.PUT_LINE(
                v_contador || '. ' || o.carrera ||
                ' | ' || o.institucion ||
                ' | Arancel: $' || o.valor_arancel
            );

            EXIT WHEN v_contador = 5;
        END LOOP;

        IF v_contador = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Sin ofertas para esta area.');
        END IF;
    END LOOP;
END;
/
