SET SERVEROUTPUT ON;

DECLARE
    v_nombre DENOMINACION_CARRERA.nombre%TYPE;
    v_nivel NIVEL_CARRERA.nombre%TYPE;
    v_id_carrera NUMBER := -999;
BEGIN
    SELECT dc.nombre, nc.nombre
    INTO v_nombre, v_nivel
    FROM CARRERA c
    JOIN DENOMINACION_CARRERA dc ON dc.id_denominacion = c.id_denominacion
    JOIN NIVEL_CARRERA nc ON nc.id_nivel_carrera = c.id_nivel_carrera
    WHERE c.id_carrera = v_id_carrera;

    DBMS_OUTPUT.PUT_LINE('Carrera encontrada: ' || v_nombre || ' (' || v_nivel || ')');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'NO_DATA_FOUND: no existe una carrera con el ID ' || v_id_carrera
        );
END;
/

DECLARE
    e_arancel_invalido EXCEPTION;
    v_arancel NUMBER := -1;
BEGIN
    IF v_arancel < 0 THEN
        RAISE e_arancel_invalido;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Arancel valido: $' || v_arancel);
EXCEPTION
    WHEN e_arancel_invalido THEN
        DBMS_OUTPUT.PUT_LINE(
            'EXCEPCION DE USUARIO: el arancel no puede ser negativo.'
        );
END;
/
