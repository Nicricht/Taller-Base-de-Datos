SET SERVEROUTPUT ON;

DECLARE
    v_nombre CARRERA.nombre%TYPE;
    v_id_carrera NUMBER := -999;
BEGIN
    SELECT nombre
    INTO v_nombre
    FROM CARRERA
    WHERE id_carrera = v_id_carrera;

    DBMS_OUTPUT.PUT_LINE('Carrera encontrada: ' || v_nombre);
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
