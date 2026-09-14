SET SERVEROUTPUT ON;

DECLARE
    TYPE t_oferta IS RECORD (
        carrera         DENOMINACION_CARRERA.nombre%TYPE,
        nivel_carrera   NIVEL_CARRERA.nombre%TYPE,
        institucion     INSTITUCION.nombre%TYPE,
        comuna          COMUNA.nombre%TYPE,
        modalidad       MODALIDAD.nombre%TYPE,
        jornada         JORNADA.nombre%TYPE,
        valor_matricula PLAN_OFERTA.valor_matricula%TYPE,
        valor_arancel   PLAN_OFERTA.valor_arancel%TYPE
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
        v_oferta.carrera,
        v_oferta.nivel_carrera,
        v_oferta.institucion,
        v_oferta.comuna,
        v_oferta.modalidad,
        v_oferta.jornada,
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

    DBMS_OUTPUT.PUT_LINE('Carrera: ' || v_oferta.carrera);
    DBMS_OUTPUT.PUT_LINE('Nivel: ' || v_oferta.nivel_carrera);
    DBMS_OUTPUT.PUT_LINE('Institucion: ' || v_oferta.institucion);
    DBMS_OUTPUT.PUT_LINE('Comuna: ' || v_oferta.comuna);
    DBMS_OUTPUT.PUT_LINE('Modalidad: ' || v_oferta.modalidad);
    DBMS_OUTPUT.PUT_LINE('Jornada: ' || v_oferta.jornada);
    DBMS_OUTPUT.PUT_LINE('Matricula: $' || v_oferta.valor_matricula);
    DBMS_OUTPUT.PUT_LINE('Arancel: $' || v_oferta.valor_arancel);
END;
/
