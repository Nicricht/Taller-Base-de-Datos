INSERT INTO REGION (nombre)
SELECT DISTINCT TRIM(s.region_sede)
FROM STAGING_MATRICULA s
WHERE TRIM(s.region_sede) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM REGION r
      WHERE r.nombre = TRIM(s.region_sede)
  );

INSERT INTO PROVINCIA (id_region, nombre)
SELECT DISTINCT r.id_region, TRIM(s.provincia_sede)
FROM STAGING_MATRICULA s
JOIN REGION r ON r.nombre = TRIM(s.region_sede)
WHERE TRIM(s.provincia_sede) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM PROVINCIA p
      WHERE p.id_region = r.id_region
        AND p.nombre = TRIM(s.provincia_sede)
  );

INSERT INTO COMUNA (id_provincia, nombre)
SELECT DISTINCT p.id_provincia, TRIM(s.comuna_sede)
FROM STAGING_MATRICULA s
JOIN REGION r ON r.nombre = TRIM(s.region_sede)
JOIN PROVINCIA p ON p.id_region = r.id_region
                AND p.nombre = TRIM(s.provincia_sede)
WHERE TRIM(s.comuna_sede) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM COMUNA c
      WHERE c.id_provincia = p.id_provincia
        AND c.nombre = TRIM(s.comuna_sede)
  );

INSERT INTO TIPO_INSTITUCION (nombre)
SELECT DISTINCT TRIM(s.tipo_institucion)
FROM STAGING_MATRICULA s
WHERE TRIM(s.tipo_institucion) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM TIPO_INSTITUCION t
      WHERE t.nombre = TRIM(s.tipo_institucion)
  );

INSERT INTO INSTITUCION (id_tipo_institucion, nombre)
SELECT DISTINCT t.id_tipo_institucion, TRIM(s.nombre_institucion)
FROM STAGING_MATRICULA s
JOIN TIPO_INSTITUCION t ON t.nombre = TRIM(s.tipo_institucion)
WHERE TRIM(s.nombre_institucion) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM INSTITUCION i
      WHERE i.nombre = TRIM(s.nombre_institucion)
  );

INSERT INTO ACREDITACION_INSTITUCION (
    id_institucion,
    anio_referencia,
    estado,
    periodo,
    anios_acreditacion
)
SELECT DISTINCT
    i.id_institucion,
    2021,
    TRIM(s.acreditacion_institucional),
    TRIM(s.periodo_acreditacion),
    CASE
        WHEN TRIM(s.anios_acreditacion) IS NULL THEN NULL
        ELSE TO_NUMBER(TRIM(s.anios_acreditacion))
    END
FROM STAGING_MATRICULA s
JOIN INSTITUCION i ON i.nombre = TRIM(s.nombre_institucion)
WHERE NOT EXISTS (
    SELECT 1
    FROM ACREDITACION_INSTITUCION a
    WHERE a.id_institucion = i.id_institucion
      AND a.anio_referencia = 2021
);

INSERT INTO AREA_CONOCIMIENTO (nombre)
SELECT DISTINCT TRIM(s.area_conocimiento)
FROM STAGING_MATRICULA s
WHERE TRIM(s.area_conocimiento) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM AREA_CONOCIMIENTO a
      WHERE a.nombre = TRIM(s.area_conocimiento)
  );

INSERT INTO DENOMINACION_CARRERA (id_area, nombre)
SELECT DISTINCT a.id_area, TRIM(s.nombre_carrera)
FROM STAGING_MATRICULA s
JOIN AREA_CONOCIMIENTO a ON a.nombre = TRIM(s.area_conocimiento)
WHERE TRIM(s.nombre_carrera) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM DENOMINACION_CARRERA dc
      WHERE dc.nombre = TRIM(s.nombre_carrera)
  );

INSERT INTO NIVEL_ESTUDIO (nombre)
SELECT DISTINCT TRIM(s.nivel_estudio_carrera)
FROM STAGING_MATRICULA s
WHERE TRIM(s.nivel_estudio_carrera) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM NIVEL_ESTUDIO n
      WHERE n.nombre = TRIM(s.nivel_estudio_carrera)
  );

INSERT INTO NIVEL_CARRERA (id_nivel_estudio, nombre)
SELECT DISTINCT ne.id_nivel_estudio, TRIM(s.nivel_carrera)
FROM STAGING_MATRICULA s
JOIN NIVEL_ESTUDIO ne ON ne.nombre = TRIM(s.nivel_estudio_carrera)
WHERE TRIM(s.nivel_carrera) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM NIVEL_CARRERA nc
      WHERE nc.nombre = TRIM(s.nivel_carrera)
  );

INSERT INTO MODALIDAD (nombre)
SELECT DISTINCT TRIM(s.modalidad)
FROM STAGING_MATRICULA s
WHERE TRIM(s.modalidad) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM MODALIDAD m
      WHERE m.nombre = TRIM(s.modalidad)
  );

INSERT INTO JORNADA (nombre)
SELECT DISTINCT TRIM(s.jornada)
FROM STAGING_MATRICULA s
WHERE TRIM(s.jornada) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM JORNADA j
      WHERE j.nombre = TRIM(s.jornada)
  );

INSERT INTO TIPO_PLAN (nombre)
SELECT DISTINCT TRIM(s.tipo_plan_carrera)
FROM STAGING_MATRICULA s
WHERE TRIM(s.tipo_plan_carrera) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM TIPO_PLAN tp
      WHERE tp.nombre = TRIM(s.tipo_plan_carrera)
  );

INSERT INTO REQUISITO_INGRESO (nombre)
SELECT DISTINCT TRIM(s.requisito_ingreso)
FROM STAGING_MATRICULA s
WHERE TRIM(s.requisito_ingreso) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM REQUISITO_INGRESO r
      WHERE r.nombre = TRIM(s.requisito_ingreso)
  );

INSERT INTO VIA_INGRESO (nombre)
SELECT DISTINCT TRIM(s.via_ingreso)
FROM STAGING_MATRICULA s
WHERE TRIM(s.via_ingreso) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM VIA_INGRESO v
      WHERE v.nombre = TRIM(s.via_ingreso)
  );

INSERT INTO CARRERA (id_denominacion, id_nivel_carrera)
SELECT DISTINCT
    dc.id_denominacion,
    nc.id_nivel_carrera
FROM STAGING_MATRICULA s
JOIN DENOMINACION_CARRERA dc ON dc.nombre = TRIM(s.nombre_carrera)
JOIN NIVEL_CARRERA nc ON nc.nombre = TRIM(s.nivel_carrera)
WHERE NOT EXISTS (
    SELECT 1
    FROM CARRERA c
    WHERE c.id_denominacion = dc.id_denominacion
      AND c.id_nivel_carrera = nc.id_nivel_carrera
);

INSERT INTO OFERTA_ACADEMICA (
    id_institucion,
    id_carrera,
    id_comuna,
    id_modalidad,
    id_jornada
)
SELECT DISTINCT
    i.id_institucion,
    c.id_carrera,
    co.id_comuna,
    m.id_modalidad,
    j.id_jornada
FROM STAGING_MATRICULA s
JOIN INSTITUCION i ON i.nombre = TRIM(s.nombre_institucion)
JOIN DENOMINACION_CARRERA dc ON dc.nombre = TRIM(s.nombre_carrera)
JOIN NIVEL_CARRERA nc ON nc.nombre = TRIM(s.nivel_carrera)
JOIN CARRERA c ON c.id_denominacion = dc.id_denominacion
              AND c.id_nivel_carrera = nc.id_nivel_carrera
JOIN REGION r ON r.nombre = TRIM(s.region_sede)
JOIN PROVINCIA p ON p.id_region = r.id_region
                AND p.nombre = TRIM(s.provincia_sede)
JOIN COMUNA co ON co.id_provincia = p.id_provincia
              AND co.nombre = TRIM(s.comuna_sede)
JOIN MODALIDAD m ON m.nombre = TRIM(s.modalidad)
JOIN JORNADA j ON j.nombre = TRIM(s.jornada)
WHERE NOT EXISTS (
    SELECT 1
    FROM OFERTA_ACADEMICA o
    WHERE o.id_institucion = i.id_institucion
      AND o.id_carrera = c.id_carrera
      AND o.id_comuna = co.id_comuna
      AND o.id_modalidad = m.id_modalidad
      AND o.id_jornada = j.id_jornada
);

INSERT INTO PLAN_OFERTA (
    id_oferta,
    id_tipo_plan,
    duracion_plan,
    duracion_titulacion,
    duracion_total,
    valor_matricula,
    valor_arancel
)
SELECT DISTINCT
    o.id_oferta,
    tp.id_tipo_plan,
    TO_NUMBER(TRIM(s.duracion_plan)),
    TO_NUMBER(TRIM(s.duracion_titulacion)),
    TO_NUMBER(TRIM(s.duracion_total)),
    TO_NUMBER(TRIM(s.valor_matricula)),
    TO_NUMBER(TRIM(s.valor_arancel))
FROM STAGING_MATRICULA s
JOIN INSTITUCION i ON i.nombre = TRIM(s.nombre_institucion)
JOIN DENOMINACION_CARRERA dc ON dc.nombre = TRIM(s.nombre_carrera)
JOIN NIVEL_CARRERA nc ON nc.nombre = TRIM(s.nivel_carrera)
JOIN CARRERA c ON c.id_denominacion = dc.id_denominacion
              AND c.id_nivel_carrera = nc.id_nivel_carrera
JOIN REGION r ON r.nombre = TRIM(s.region_sede)
JOIN PROVINCIA p ON p.id_region = r.id_region
                AND p.nombre = TRIM(s.provincia_sede)
JOIN COMUNA co ON co.id_provincia = p.id_provincia
              AND co.nombre = TRIM(s.comuna_sede)
JOIN MODALIDAD m ON m.nombre = TRIM(s.modalidad)
JOIN JORNADA j ON j.nombre = TRIM(s.jornada)
JOIN OFERTA_ACADEMICA o ON o.id_institucion = i.id_institucion
                       AND o.id_carrera = c.id_carrera
                       AND o.id_comuna = co.id_comuna
                       AND o.id_modalidad = m.id_modalidad
                       AND o.id_jornada = j.id_jornada
JOIN TIPO_PLAN tp ON tp.nombre = TRIM(s.tipo_plan_carrera)
WHERE NOT EXISTS (
    SELECT 1
    FROM PLAN_OFERTA po
    WHERE po.id_oferta = o.id_oferta
      AND po.id_tipo_plan = tp.id_tipo_plan
      AND po.duracion_plan = TO_NUMBER(TRIM(s.duracion_plan))
      AND po.duracion_titulacion = TO_NUMBER(TRIM(s.duracion_titulacion))
      AND po.duracion_total = TO_NUMBER(TRIM(s.duracion_total))
      AND po.valor_matricula = TO_NUMBER(TRIM(s.valor_matricula))
      AND po.valor_arancel = TO_NUMBER(TRIM(s.valor_arancel))
);

INSERT INTO MATRICULA_HISTORICA (
    id_registro_fuente,
    id_plan_oferta,
    id_requisito_ingreso,
    id_via_ingreso,
    genero,
    edad,
    anio_ingreso,
    semestre_ingreso
)
SELECT
    TO_NUMBER(TRIM(s.id_fuente)),
    po.id_plan_oferta,
    ri.id_requisito_ingreso,
    vi.id_via_ingreso,
    TRIM(s.genero),
    TO_NUMBER(TRIM(s.edad)),
    TO_NUMBER(TRIM(s.anio_ingreso)),
    TRIM(s.semestre_ingreso)
FROM STAGING_MATRICULA s
JOIN INSTITUCION i ON i.nombre = TRIM(s.nombre_institucion)
JOIN DENOMINACION_CARRERA dc ON dc.nombre = TRIM(s.nombre_carrera)
JOIN NIVEL_CARRERA nc ON nc.nombre = TRIM(s.nivel_carrera)
JOIN CARRERA c ON c.id_denominacion = dc.id_denominacion
              AND c.id_nivel_carrera = nc.id_nivel_carrera
JOIN REGION r ON r.nombre = TRIM(s.region_sede)
JOIN PROVINCIA p ON p.id_region = r.id_region
                AND p.nombre = TRIM(s.provincia_sede)
JOIN COMUNA co ON co.id_provincia = p.id_provincia
              AND co.nombre = TRIM(s.comuna_sede)
JOIN MODALIDAD m ON m.nombre = TRIM(s.modalidad)
JOIN JORNADA j ON j.nombre = TRIM(s.jornada)
JOIN OFERTA_ACADEMICA o ON o.id_institucion = i.id_institucion
                       AND o.id_carrera = c.id_carrera
                       AND o.id_comuna = co.id_comuna
                       AND o.id_modalidad = m.id_modalidad
                       AND o.id_jornada = j.id_jornada
JOIN TIPO_PLAN tp ON tp.nombre = TRIM(s.tipo_plan_carrera)
JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
                   AND po.id_tipo_plan = tp.id_tipo_plan
                   AND po.duracion_plan = TO_NUMBER(TRIM(s.duracion_plan))
                   AND po.duracion_titulacion = TO_NUMBER(TRIM(s.duracion_titulacion))
                   AND po.duracion_total = TO_NUMBER(TRIM(s.duracion_total))
                   AND po.valor_matricula = TO_NUMBER(TRIM(s.valor_matricula))
                   AND po.valor_arancel = TO_NUMBER(TRIM(s.valor_arancel))
JOIN REQUISITO_INGRESO ri ON ri.nombre = TRIM(s.requisito_ingreso)
JOIN VIA_INGRESO vi ON vi.nombre = TRIM(s.via_ingreso)
WHERE NOT EXISTS (
    SELECT 1
    FROM MATRICULA_HISTORICA mh
    WHERE mh.id_registro_fuente = TO_NUMBER(TRIM(s.id_fuente))
);

COMMIT;
