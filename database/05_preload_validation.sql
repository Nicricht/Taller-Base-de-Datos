PROMPT =====================================================
PROMPT EduBio 360 - Validaciones previas al ETL
PROMPT =====================================================

PROMPT Total de filas cargadas en staging:
SELECT COUNT(*) AS total_staging
FROM STAGING_MATRICULA;

PROMPT IDs fuente duplicados. Debe devolver 0 filas:
SELECT id_fuente, COUNT(*) AS cantidad
FROM STAGING_MATRICULA
GROUP BY id_fuente
HAVING COUNT(*) > 1;

PROMPT Filas con nulos criticos:
SELECT COUNT(*) AS filas_con_nulos_criticos
FROM STAGING_MATRICULA
WHERE id_fuente IS NULL
   OR nombre_institucion IS NULL
   OR nombre_carrera IS NULL
   OR nivel_carrera IS NULL
   OR modalidad IS NULL
   OR jornada IS NULL
   OR tipo_plan_carrera IS NULL
   OR comuna_sede IS NULL
   OR duracion_plan IS NULL
   OR duracion_titulacion IS NULL
   OR duracion_total IS NULL
   OR valor_matricula IS NULL
   OR valor_arancel IS NULL;

PROMPT IDs no numericos. Debe devolver 0:
SELECT COUNT(*) AS ids_no_numericos
FROM STAGING_MATRICULA
WHERE id_fuente IS NOT NULL
  AND NOT REGEXP_LIKE(TRIM(id_fuente), '^\d+$');

PROMPT Edades no numericas. Debe devolver 0:
SELECT COUNT(*) AS edades_no_numericas
FROM STAGING_MATRICULA
WHERE edad IS NOT NULL
  AND NOT REGEXP_LIKE(TRIM(edad), '^\d+$');

PROMPT Anios de ingreso no numericos. Debe devolver 0:
SELECT COUNT(*) AS anios_no_numericos
FROM STAGING_MATRICULA
WHERE anio_ingreso IS NOT NULL
  AND NOT REGEXP_LIKE(TRIM(anio_ingreso), '^\d+$');

PROMPT Duraciones no numericas. Debe devolver 0:
SELECT COUNT(*) AS duraciones_no_numericas
FROM STAGING_MATRICULA
WHERE (duracion_plan IS NOT NULL AND NOT REGEXP_LIKE(TRIM(duracion_plan), '^\d+$'))
   OR (duracion_titulacion IS NOT NULL AND NOT REGEXP_LIKE(TRIM(duracion_titulacion), '^\d+$'))
   OR (duracion_total IS NOT NULL AND NOT REGEXP_LIKE(TRIM(duracion_total), '^\d+$'));

PROMPT Costos no numericos. Debe devolver 0:
SELECT COUNT(*) AS costos_no_numericos
FROM STAGING_MATRICULA
WHERE (valor_matricula IS NOT NULL AND NOT REGEXP_LIKE(TRIM(valor_matricula), '^\d+$'))
   OR (valor_arancel IS NOT NULL AND NOT REGEXP_LIKE(TRIM(valor_arancel), '^\d+$'));

PROMPT Anios de acreditacion no numericos, ignorando nulos. Debe devolver 0:
SELECT COUNT(*) AS acreditacion_anios_no_numericos
FROM STAGING_MATRICULA
WHERE anios_acreditacion IS NOT NULL
  AND NOT REGEXP_LIKE(TRIM(anios_acreditacion), '^\d+$');

PROMPT Costos negativos. Esta consulta evita TO_NUMBER sobre texto invalido:
SELECT COUNT(*) AS costos_negativos
FROM STAGING_MATRICULA
WHERE CASE
          WHEN REGEXP_LIKE(TRIM(valor_matricula), '^\d+$')
          THEN TO_NUMBER(TRIM(valor_matricula))
      END < 0
   OR CASE
          WHEN REGEXP_LIKE(TRIM(valor_arancel), '^\d+$')
          THEN TO_NUMBER(TRIM(valor_arancel))
      END < 0;

PROMPT Dependencia COMUNA -> PROVINCIA. Debe devolver 0 filas:
SELECT comuna_sede
FROM STAGING_MATRICULA
GROUP BY comuna_sede
HAVING COUNT(DISTINCT provincia_sede) > 1;

PROMPT Dependencia PROVINCIA -> REGION. Debe devolver 0 filas:
SELECT provincia_sede
FROM STAGING_MATRICULA
GROUP BY provincia_sede
HAVING COUNT(DISTINCT region_sede) > 1;

PROMPT Dependencia INSTITUCION -> TIPO_INSTITUCION. Debe devolver 0 filas:
SELECT nombre_institucion
FROM STAGING_MATRICULA
GROUP BY nombre_institucion
HAVING COUNT(DISTINCT tipo_institucion) > 1;

PROMPT Dependencia NIVEL_CARRERA -> NIVEL_ESTUDIO. Debe devolver 0 filas:
SELECT nivel_carrera
FROM STAGING_MATRICULA
GROUP BY nivel_carrera
HAVING COUNT(DISTINCT nivel_estudio_carrera) > 1;

PROMPT Dependencia NOMBRE_CARRERA -> AREA_CONOCIMIENTO. Debe devolver 0 filas:
SELECT nombre_carrera
FROM STAGING_MATRICULA
GROUP BY nombre_carrera
HAVING COUNT(DISTINCT area_conocimiento) > 1;

PROMPT Diagnostico NOMBRE_CARRERA -> NIVEL_CARRERA.
PROMPT Aqui SI se esperan las carreras que aparecen asociadas a mas de un nivel:
SELECT nombre_carrera,
       COUNT(DISTINCT nivel_carrera) AS niveles_distintos
FROM STAGING_MATRICULA
GROUP BY nombre_carrera
HAVING COUNT(DISTINCT nivel_carrera) > 1
ORDER BY nombre_carrera;
