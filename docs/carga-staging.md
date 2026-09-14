# Carga del dataset a STAGING_MATRICULA

## Objetivo

Cargar la fuente plana en una tabla tecnica antes de poblar el modelo normalizado.

Flujo:

`Excel -> CSV UTF-8 -> STAGING_MATRICULA -> validaciones -> ETL -> tablas finales`

`STAGING_MATRICULA` conserva las 28 columnas de la fuente y no forma parte del DER normalizado.

## Pasos

1. Exportar la hoja `BASE DE DATOS` a CSV UTF-8 con encabezados.
2. Ejecutar `database/04_create_staging.sql`.
3. Cargar el CSV usando el archivo `database/sqlldr/staging_matricula.ctl`.
4. Ejecutar `database/05_preload_validation.sql`.
5. Corregir cualquier conflicto antes de continuar.
6. Ejecutar `database/06_transform_load.sql`.
7. Ejecutar `database/07_validation.sql`.

## Validaciones previas

Antes del ETL se revisan:

- cantidad total de filas;
- IDs fuente duplicados;
- campos criticos nulos;
- campos numericos invalidos;
- costos negativos;
- COMUNA determina PROVINCIA;
- PROVINCIA determina REGION;
- INSTITUCION determina TIPO_INSTITUCION;
- NIVEL_CARRERA determina NIVEL_ESTUDIO;
- NOMBRE_CARRERA determina AREA_CONOCIMIENTO;
- nombres de carrera asociados a mas de un nivel.

Para la fuente actual se esperan 106.555 filas y 0 conflictos en las dependencias que deben cumplirse. La ultima consulta diagnostica debe mostrar los nombres que aparecen en mas de un nivel y que justifican separar `DENOMINACION_CARRERA` de `CARRERA`.

## Orden conceptual del ETL

1. REGION, PROVINCIA y COMUNA.
2. TIPO_INSTITUCION, INSTITUCION y ACREDITACION_INSTITUCION.
3. AREA_CONOCIMIENTO.
4. DENOMINACION_CARRERA.
5. NIVEL_ESTUDIO y NIVEL_CARRERA.
6. MODALIDAD, JORNADA, TIPO_PLAN, REQUISITO_INGRESO y VIA_INGRESO.
7. CARRERA.
8. OFERTA_ACADEMICA.
9. PLAN_OFERTA.
10. MATRICULA_HISTORICA.

## Evidencia final esperada

- mas de 1.000 registros en MATRICULA_HISTORICA;
- idealmente 106.555 al cargar la fuente completa;
- 0 claves foraneas huerfanas;
- 0 costos negativos;
- 0 IDs fuente duplicados;
- 0 denominaciones duplicadas;
- 0 carreras duplicadas segun `(id_denominacion, id_nivel_carrera)`;
- 0 ofertas duplicadas segun su clave candidata.
