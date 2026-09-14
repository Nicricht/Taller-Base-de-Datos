SELECT COUNT(*) AS total_staging
FROM STAGING_MATRICULA;

SELECT id_fuente, COUNT(*) AS cantidad
FROM STAGING_MATRICULA
GROUP BY id_fuente
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS filas_con_nulos_criticos
FROM STAGING_MATRICULA
WHERE id_fuente IS NULL
   OR nombre_institucion IS NULL
   OR nombre_carrera IS NULL
   OR nivel_carrera IS NULL
   OR modalidad IS NULL
   OR jornada IS NULL
   OR tipo_plan_carrera IS NULL
   OR comuna_sede IS NULL;

SELECT COUNT(*) AS ids_no_numericos
FROM STAGING_MATRICULA
WHERE NOT REGEXP_LIKE(TRIM(id_fuente), '^\d+$');

SELECT COUNT(*) AS edades_no_numericas
FROM STAGING_MATRICULA
WHERE NOT REGEXP_LIKE(TRIM(edad), '^\d+$');

SELECT COUNT(*) AS anios_no_numericos
FROM STAGING_MATRICULA
WHERE NOT REGEXP_LIKE(TRIM(anio_ingreso), '^\d+$');

SELECT COUNT(*) AS costos_no_numericos
FROM STAGING_MATRICULA
WHERE NOT REGEXP_LIKE(TRIM(valor_matricula), '^\d+$')
   OR NOT REGEXP_LIKE(TRIM(valor_arancel), '^\d+$');

SELECT COUNT(*) AS costos_negativos
FROM STAGING_MATRICULA
WHERE TO_NUMBER(TRIM(valor_matricula)) < 0
   OR TO_NUMBER(TRIM(valor_arancel)) < 0;

SELECT comuna_sede
FROM STAGING_MATRICULA
GROUP BY comuna_sede
HAVING COUNT(DISTINCT provincia_sede) > 1;

SELECT provincia_sede
FROM STAGING_MATRICULA
GROUP BY provincia_sede
HAVING COUNT(DISTINCT region_sede) > 1;

SELECT nombre_institucion
FROM STAGING_MATRICULA
GROUP BY nombre_institucion
HAVING COUNT(DISTINCT tipo_institucion) > 1;

SELECT nivel_carrera
FROM STAGING_MATRICULA
GROUP BY nivel_carrera
HAVING COUNT(DISTINCT nivel_estudio_carrera) > 1;

SELECT nombre_carrera
FROM STAGING_MATRICULA
GROUP BY nombre_carrera
HAVING COUNT(DISTINCT area_conocimiento) > 1;

-- Esta consulta es diagnostica: se espera que devuelva los nombres de carrera
-- que aparecen asociados a mas de un nivel. Es la evidencia que justifica
-- separar DENOMINACION_CARRERA de CARRERA.
SELECT nombre_carrera,
       COUNT(DISTINCT nivel_carrera) AS niveles_distintos
FROM STAGING_MATRICULA
GROUP BY nombre_carrera
HAVING COUNT(DISTINCT nivel_carrera) > 1
ORDER BY nombre_carrera;
