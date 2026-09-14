# Carga del dataset a STAGING_MATRICULA

## Objetivo

Cargar la fuente plana en una tabla tecnica antes de poblar el modelo normalizado.

El flujo es:

`Excel -> CSV UTF-8 -> STAGING_MATRICULA -> validaciones -> transformacion -> tablas finales`

## 1. Exportar el Excel a CSV

Abrir la hoja `BASE DE DATOS` y guardarla como CSV UTF-8 con encabezados.

Nombre esperado por el archivo de control:

`matriculas_biobio_2021.csv`

La tabla staging conserva 28 columnas equivalentes a las 28 columnas de la fuente.

## 2. Crear la tabla staging

Ejecutar:

`database/04_create_staging.sql`

## 3. Cargar mediante SQL*Loader

Archivo de control:

`database/sqlldr/staging_matricula.ctl`

Ejemplo de comando:

```bash
sqlldr usuario/clave@servicio control=database/sqlldr/staging_matricula.ctl log=staging_matricula.log bad=staging_matricula.bad skip=1
```

`skip=1` evita cargar la fila de encabezados del CSV.

## 4. Validar staging

Ejecutar:

`database/05_preload_validation.sql`

Antes del ETL deben revisarse como minimo:

- cantidad total de filas;
- IDs fuente duplicados;
- campos criticos nulos;
- IDs, edades, anos y costos no numericos;
- costos negativos;
- dependencias COMUNA -> PROVINCIA;
- PROVINCIA -> REGION;
- INSTITUCION -> TIPO_INSTITUCION;
- NIVEL_CARRERA -> NIVEL_ESTUDIO;
- NOMBRE_CARRERA -> AREA_CONOCIMIENTO.

Para la fuente actual se espera aproximadamente:

- 106.555 filas;
- 106.555 IDs fuente distintos;
- 0 costos negativos;
- 0 conflictos en las dependencias funcionales anteriores.

## 5. Transformar al modelo normalizado

Cuando staging sea valido, ejecutar:

`database/06_transform_load.sql`

El script carga primero catalogos y entidades padre y luego OFERTA_ACADEMICA, PLAN_OFERTA y MATRICULA_HISTORICA.

## 6. Validacion final

Ejecutar:

`database/07_validation.sql`

La evidencia minima para la evaluacion debe mostrar:

- mas de 1.000 matriculas cargadas;
- 0 foreign keys huerfanas;
- 0 costos negativos;
- 0 IDs fuente duplicados;
- 0 ofertas duplicadas segun su clave candidata.
