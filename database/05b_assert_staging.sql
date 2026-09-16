PROMPT =====================================================
PROMPT EduBio 360 - Control bloqueante antes del ETL
PROMPT =====================================================

DECLARE
    v_total              NUMBER;
    v_ids_dup            NUMBER;
    v_nulos_criticos     NUMBER;
    v_numericos_invalidos NUMBER;
    v_df_conflictos      NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM STAGING_MATRICULA;

    IF v_total <= 1000 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'STAGING_MATRICULA debe contener mas de 1000 filas antes del ETL. Total actual: ' || v_total);
    END IF;

    SELECT COUNT(*) INTO v_ids_dup
    FROM (
        SELECT id_fuente
        FROM STAGING_MATRICULA
        GROUP BY id_fuente
        HAVING COUNT(*) > 1
    );

    IF v_ids_dup > 0 THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Existen IDs fuente duplicados en STAGING_MATRICULA: ' || v_ids_dup);
    END IF;

    SELECT COUNT(*) INTO v_nulos_criticos
    FROM STAGING_MATRICULA
    WHERE id_fuente IS NULL
       OR genero IS NULL
       OR edad IS NULL
       OR anio_ingreso IS NULL
       OR semestre_ingreso IS NULL
       OR tipo_institucion IS NULL
       OR nombre_institucion IS NULL
       OR acreditacion_institucional IS NULL
       OR nombre_carrera IS NULL
       OR requisito_ingreso IS NULL
       OR via_ingreso IS NULL
       OR modalidad IS NULL
       OR jornada IS NULL
       OR tipo_plan_carrera IS NULL
       OR nivel_estudio_carrera IS NULL
       OR nivel_carrera IS NULL
       OR area_conocimiento IS NULL
       OR duracion_plan IS NULL
       OR duracion_titulacion IS NULL
       OR duracion_total IS NULL
       OR valor_matricula IS NULL
       OR valor_arancel IS NULL
       OR region_sede IS NULL
       OR provincia_sede IS NULL
       OR comuna_sede IS NULL;

    IF v_nulos_criticos > 0 THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Existen filas con nulos en campos requeridos para el modelo final: ' || v_nulos_criticos);
    END IF;

    SELECT COUNT(*) INTO v_numericos_invalidos
    FROM STAGING_MATRICULA
    WHERE NOT REGEXP_LIKE(TRIM(id_fuente), '^\d+$')
       OR NOT REGEXP_LIKE(TRIM(edad), '^\d+$')
       OR NOT REGEXP_LIKE(TRIM(anio_ingreso), '^\d+$')
       OR NOT REGEXP_LIKE(TRIM(duracion_plan), '^\d+$')
       OR NOT REGEXP_LIKE(TRIM(duracion_titulacion), '^\d+$')
       OR NOT REGEXP_LIKE(TRIM(duracion_total), '^\d+$')
       OR NOT REGEXP_LIKE(TRIM(valor_matricula), '^\d+$')
       OR NOT REGEXP_LIKE(TRIM(valor_arancel), '^\d+$')
       OR (anios_acreditacion IS NOT NULL
           AND NOT REGEXP_LIKE(TRIM(anios_acreditacion), '^\d+$'));

    IF v_numericos_invalidos > 0 THEN
        RAISE_APPLICATION_ERROR(-20004,
            'Existen filas con campos numericos invalidos: ' || v_numericos_invalidos);
    END IF;

    SELECT COUNT(*) INTO v_df_conflictos
    FROM (
        SELECT comuna_sede
        FROM STAGING_MATRICULA
        GROUP BY comuna_sede
        HAVING COUNT(DISTINCT provincia_sede) > 1
        UNION ALL
        SELECT provincia_sede
        FROM STAGING_MATRICULA
        GROUP BY provincia_sede
        HAVING COUNT(DISTINCT region_sede) > 1
        UNION ALL
        SELECT nombre_institucion
        FROM STAGING_MATRICULA
        GROUP BY nombre_institucion
        HAVING COUNT(DISTINCT tipo_institucion) > 1
        UNION ALL
        SELECT nivel_carrera
        FROM STAGING_MATRICULA
        GROUP BY nivel_carrera
        HAVING COUNT(DISTINCT nivel_estudio_carrera) > 1
        UNION ALL
        SELECT nombre_carrera
        FROM STAGING_MATRICULA
        GROUP BY nombre_carrera
        HAVING COUNT(DISTINCT area_conocimiento) > 1
    );

    IF v_df_conflictos > 0 THEN
        RAISE_APPLICATION_ERROR(-20005,
            'Las dependencias funcionales obligatorias presentan conflictos: ' || v_df_conflictos);
    END IF;

    DBMS_OUTPUT.PUT_LINE('CONTROL PRE-ETL OK. Filas staging: ' || v_total);
END;
/
