PROMPT =====================================================
PROMPT EduBio 360 - Verificacion final bloqueante
PROMPT =====================================================

SET SERVEROUTPUT ON

DECLARE
    v_total NUMBER;

    PROCEDURE verificar(
        p_nombre   VARCHAR2,
        p_actual   NUMBER,
        p_esperado NUMBER
    ) IS
    BEGIN
        IF p_actual <> p_esperado THEN
            RAISE_APPLICATION_ERROR(
                -20090,
                p_nombre || ': se esperaban ' || p_esperado ||
                ' filas y se obtuvieron ' || p_actual
            );
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(p_nombre, 28) || TO_CHAR(p_actual) || ' OK'
        );
    END;
BEGIN
    SELECT COUNT(*) INTO v_total FROM STAGING_MATRICULA;
    verificar('STAGING_MATRICULA', v_total, 106555);

    SELECT COUNT(*) INTO v_total FROM REGION;
    verificar('REGION', v_total, 1);

    SELECT COUNT(*) INTO v_total FROM PROVINCIA;
    verificar('PROVINCIA', v_total, 3);

    SELECT COUNT(*) INTO v_total FROM COMUNA;
    verificar('COMUNA', v_total, 9);

    SELECT COUNT(*) INTO v_total FROM TIPO_INSTITUCION;
    verificar('TIPO_INSTITUCION', v_total, 5);

    SELECT COUNT(*) INTO v_total FROM INSTITUCION;
    verificar('INSTITUCION', v_total, 30);

    SELECT COUNT(*) INTO v_total FROM ACREDITACION_INSTITUCION;
    verificar('ACREDITACION_INSTITUCION', v_total, 30);

    SELECT COUNT(*) INTO v_total FROM AREA_CONOCIMIENTO;
    verificar('AREA_CONOCIMIENTO', v_total, 10);

    SELECT COUNT(*) INTO v_total FROM DENOMINACION_CARRERA;
    verificar('DENOMINACION_CARRERA', v_total, 824);

    SELECT COUNT(*) INTO v_total FROM NIVEL_ESTUDIO;
    verificar('NIVEL_ESTUDIO', v_total, 3);

    SELECT COUNT(*) INTO v_total FROM NIVEL_CARRERA;
    verificar('NIVEL_CARRERA', v_total, 5);

    SELECT COUNT(*) INTO v_total FROM MODALIDAD;
    verificar('MODALIDAD', v_total, 3);

    SELECT COUNT(*) INTO v_total FROM JORNADA;
    verificar('JORNADA', v_total, 5);

    SELECT COUNT(*) INTO v_total FROM CARRERA;
    verificar('CARRERA', v_total, 830);

    SELECT COUNT(*) INTO v_total FROM OFERTA_ACADEMICA;
    verificar('OFERTA_ACADEMICA', v_total, 1544);

    SELECT COUNT(*) INTO v_total FROM TIPO_PLAN;
    verificar('TIPO_PLAN', v_total, 3);

    SELECT COUNT(*) INTO v_total FROM PLAN_OFERTA;
    verificar('PLAN_OFERTA', v_total, 1634);

    SELECT COUNT(*) INTO v_total FROM REQUISITO_INGRESO;
    verificar('REQUISITO_INGRESO', v_total, 5);

    SELECT COUNT(*) INTO v_total FROM VIA_INGRESO;
    verificar('VIA_INGRESO', v_total, 11);

    SELECT COUNT(*) INTO v_total FROM MATRICULA_HISTORICA;
    verificar('MATRICULA_HISTORICA', v_total, 106555);

    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('VERIFICACION FINAL OK: EduBio 360 listo.');
END;
/
