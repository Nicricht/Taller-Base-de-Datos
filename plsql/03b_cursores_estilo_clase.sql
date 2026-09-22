SET SERVEROUTPUT ON;

PROMPT =====================================================
PROMPT EDUBIO360 - Cursor parametrizado con OPEN/FETCH/CLOSE
PROMPT =====================================================

DECLARE
    CURSOR c_ofertas_por_area (
        p_id_area AREA_CONOCIMIENTO.id_area%TYPE
    ) IS
        SELECT
            dc.nombre AS carrera,
            nc.nombre AS nivel_carrera,
            i.nombre AS institucion,
            po.valor_arancel
        FROM DENOMINACION_CARRERA dc
        JOIN CARRERA c
            ON c.id_denominacion = dc.id_denominacion
        JOIN NIVEL_CARRERA nc
            ON nc.id_nivel_carrera = c.id_nivel_carrera
        JOIN OFERTA_ACADEMICA o
            ON o.id_carrera = c.id_carrera
        JOIN INSTITUCION i
            ON i.id_institucion = o.id_institucion
        JOIN PLAN_OFERTA po
            ON po.id_oferta = o.id_oferta
        WHERE dc.id_area = p_id_area
        ORDER BY dc.nombre, nc.nombre, i.nombre;

    v_id_area       AREA_CONOCIMIENTO.id_area%TYPE := 1;
    v_carrera       DENOMINACION_CARRERA.nombre%TYPE;
    v_nivel         NIVEL_CARRERA.nombre%TYPE;
    v_institucion   INSTITUCION.nombre%TYPE;
    v_arancel       PLAN_OFERTA.valor_arancel%TYPE;
    v_contador      PLS_INTEGER := 0;
BEGIN
    OPEN c_ofertas_por_area(v_id_area);

    LOOP
        FETCH c_ofertas_por_area
        INTO v_carrera, v_nivel, v_institucion, v_arancel;

        EXIT WHEN c_ofertas_por_area%NOTFOUND;

        v_contador := v_contador + 1;

        DBMS_OUTPUT.PUT_LINE(
            v_contador || '. ' ||
            v_carrera || ' (' || v_nivel || ')' ||
            ' | ' || v_institucion ||
            ' | Arancel: $' || v_arancel
        );

        EXIT WHEN v_contador = 5;
    END LOOP;

    CLOSE c_ofertas_por_area;

    IF v_contador = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'No se encontraron ofertas para el area ' || v_id_area
        );
    END IF;
END;
/

PROMPT =====================================================
PROMPT EDUBIO360 - Cursores anidados
PROMPT =====================================================

DECLARE
    CURSOR c_areas IS
        SELECT id_area, nombre
        FROM AREA_CONOCIMIENTO
        ORDER BY nombre;

    CURSOR c_ofertas_por_area (
        p_id_area AREA_CONOCIMIENTO.id_area%TYPE
    ) IS
        SELECT
            dc.nombre AS carrera,
            nc.nombre AS nivel_carrera,
            i.nombre AS institucion,
            po.valor_arancel
        FROM DENOMINACION_CARRERA dc
        JOIN CARRERA c
            ON c.id_denominacion = dc.id_denominacion
        JOIN NIVEL_CARRERA nc
            ON nc.id_nivel_carrera = c.id_nivel_carrera
        JOIN OFERTA_ACADEMICA o
            ON o.id_carrera = c.id_carrera
        JOIN INSTITUCION i
            ON i.id_institucion = o.id_institucion
        JOIN PLAN_OFERTA po
            ON po.id_oferta = o.id_oferta
        WHERE dc.id_area = p_id_area
        ORDER BY dc.nombre, nc.nombre, i.nombre;

    v_contador PLS_INTEGER;
BEGIN
    FOR a IN c_areas LOOP
        DBMS_OUTPUT.PUT_LINE('====================================');
        DBMS_OUTPUT.PUT_LINE('AREA: ' || a.nombre);

        v_contador := 0;

        FOR o IN c_ofertas_por_area(a.id_area) LOOP
            v_contador := v_contador + 1;

            DBMS_OUTPUT.PUT_LINE(
                v_contador || '. ' ||
                o.carrera || ' (' || o.nivel_carrera || ')' ||
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
