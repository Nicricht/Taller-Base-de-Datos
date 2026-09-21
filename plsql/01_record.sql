SET SERVEROUTPUT ON;

DECLARE
    TYPE t_oferta IS RECORD (
        nombre_carrera      DENOMINACION_CARRERA.nombre%TYPE,
        nombre_nivel        NIVEL_CARRERA.nombre%TYPE,
        nombre_institucion  INSTITUCION.nombre%TYPE,
        nombre_comuna       COMUNA.nombre%TYPE,
        nombre_modalidad    MODALIDAD.nombre%TYPE,
        nombre_jornada      JORNADA.nombre%TYPE,
        valor_matricula     PLAN_OFERTA.valor_matricula%TYPE,
        valor_arancel       PLAN_OFERTA.valor_arancel%TYPE
    );

    v_oferta t_oferta;
    v_id_oferta OFERTA_ACADEMICA.id_oferta%TYPE := 1;
BEGIN
    SELECT
        dc.nombre,
        nc.nombre,
        i.nombre,
        co.nombre,
        m.nombre,
        j.nombre,
        po.valor_matricula,
        po.valor_arancel
    INTO
        v_oferta.nombre_carrera,
        v_oferta.nombre_nivel,
        v_oferta.nombre_institucion,
        v_oferta.nombre_comuna,
        v_oferta.nombre_modalidad,
        v_oferta.nombre_jornada,
        v_oferta.valor_matricula,
        v_oferta.valor_arancel
    FROM OFERTA_ACADEMICA o
    JOIN CARRERA c ON c.id_carrera = o.id_carrera
    JOIN DENOMINACION_CARRERA dc ON dc.id_denominacion = c.id_denominacion
    JOIN NIVEL_CARRERA nc ON nc.id_nivel_carrera = c.id_nivel_carrera
    JOIN INSTITUCION i ON i.id_institucion = o.id_institucion
    JOIN COMUNA co ON co.id_comuna = o.id_comuna
    JOIN MODALIDAD m ON m.id_modalidad = o.id_modalidad
    JOIN JORNADA j ON j.id_jornada = o.id_jornada
    JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
    WHERE o.id_oferta = v_id_oferta
      AND ROWNUM = 1;

    DBMS_OUTPUT.PUT_LINE('Carrera: ' || v_oferta.nombre_carrera);
    DBMS_OUTPUT.PUT_LINE('Nivel: ' || v_oferta.nombre_nivel);
    DBMS_OUTPUT.PUT_LINE('Institucion: ' || v_oferta.nombre_institucion);
    DBMS_OUTPUT.PUT_LINE('Comuna: ' || v_oferta.nombre_comuna);
    DBMS_OUTPUT.PUT_LINE('Modalidad: ' || v_oferta.nombre_modalidad);
    DBMS_OUTPUT.PUT_LINE('Jornada: ' || v_oferta.nombre_jornada);
    DBMS_OUTPUT.PUT_LINE('Matricula: $' || v_oferta.valor_matricula);
    DBMS_OUTPUT.PUT_LINE('Arancel: $' || v_oferta.valor_arancel);
END;
/
