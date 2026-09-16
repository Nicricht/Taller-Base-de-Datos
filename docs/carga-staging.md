# Carga del dataset a STAGING_MATRICULA

## Objetivo

Cargar la fuente plana en una tabla técnica antes de poblar el modelo normalizado.

Flujo:

`Excel -> CSV UTF-8 -> STAGING_MATRICULA -> validaciones -> ETL -> tablas finales`

`STAGING_MATRICULA` conserva las 28 columnas de la fuente y no forma parte del DER normalizado.

## Antes de comenzar

La estructura debe estar creada con `database/00_run_structure.sql` usando la conexión `EDUBIO360`.

El dataset y el CSV son archivos locales de trabajo. No se deben subir al repositorio; `.gitignore` excluye `*.xlsx`, `*.xls` y `*.csv`.

## 1. Exportar el Excel

Abrir el archivo fuente y exportar la hoja `BASE DE DATOS` como CSV UTF-8 con encabezados.

Nombre recomendado del archivo:

`matriculas_biobio_2021.csv`

El archivo debe conservar las 28 columnas y su primera fila debe contener los encabezados.

## 2. Revisar el delimitador

El control `database/sqlldr/staging_matricula.ctl` está configurado para CSV separado por coma:

`FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'`

Antes de cargar, abrir el CSV con un editor de texto y comprobar la primera línea.

Ejemplo esperado con coma:

`ID,GENERO,EDAD,...`

Si Excel generó punto y coma:

`ID;GENERO;EDAD;...`

se debe cambiar temporalmente el control a:

`FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'`

## 3. Ubicar los archivos

Para simplificar la ejecución, colocar temporalmente `matriculas_biobio_2021.csv` dentro de:

`database/sqlldr/`

El archivo de control ya se encuentra allí:

`database/sqlldr/staging_matricula.ctl`

## 4. Ejecutar SQL*Loader

Abrir CMD dentro de `database/sqlldr/` y ejecutar:

```text
sqlldr EDUBIO360@XEPDB1 control=staging_matricula.ctl log=staging_matricula.log bad=staging_matricula.bad
```

SQL*Loader solicitará la contraseña. No escribir la contraseña dentro del comando ni guardarla en Git.

El archivo de control usa `SKIP=1`, por lo que omite automáticamente la fila de encabezados.

## 5. Verificar la carga en Oracle

Conectado como `EDUBIO360` ejecutar:

```sql
SELECT COUNT(*) AS total_staging
FROM STAGING_MATRICULA;
```

Para la fuente completa se esperan **106.555** filas.

La evaluación exige más de 1.000 registros, pero para la entrega final se busca reproducir la fuente completa.

## 6. Validaciones previas al ETL

Ejecutar en este orden:

1. `database/05_preload_validation.sql`
2. `database/05b_assert_staging.sql`

El primero muestra el diagnóstico detallado. El segundo detiene conceptualmente el proceso cuando existen:

- 1.000 filas o menos;
- IDs fuente duplicados;
- nulos en campos requeridos por el modelo final;
- identificadores, edades, años, duraciones o costos no numéricos;
- conflictos en dependencias funcionales obligatorias.

El mensaje esperado al finalizar el segundo script es:

`CONTROL PRE-ETL OK. Filas staging: 106555`

## 7. Ejecutar el ETL

Solo después de superar las validaciones ejecutar:

1. `database/06_transform_load.sql`
2. `database/07_validation.sql`
3. `database/08_sample_queries.sql`

## Validaciones esperadas

Antes y después del ETL se revisan:

- cantidad total de filas;
- IDs fuente duplicados;
- campos críticos nulos;
- formatos numéricos inválidos;
- costos negativos;
- COMUNA determina PROVINCIA;
- PROVINCIA determina REGION;
- INSTITUCION determina TIPO_INSTITUCION;
- NIVEL_CARRERA determina NIVEL_ESTUDIO;
- NOMBRE_CARRERA determina AREA_CONOCIMIENTO;
- nombres de carrera asociados a más de un nivel;
- claves foráneas huérfanas;
- ofertas, carreras y denominaciones duplicadas.

## Conteos de referencia de la fuente completa

- STAGING_MATRICULA: 106.555
- REGION: 1
- PROVINCIA: 3
- COMUNA: 9
- TIPO_INSTITUCION: 5
- INSTITUCION: 30
- AREA_CONOCIMIENTO: 10
- DENOMINACION_CARRERA: 824
- NIVEL_ESTUDIO: 3
- NIVEL_CARRERA: 5
- MODALIDAD: 3
- JORNADA: 5
- TIPO_PLAN: 3
- REQUISITO_INGRESO: 5
- VIA_INGRESO: 11
- CARRERA: 830
- OFERTA_ACADEMICA: 1.544
- PLAN_OFERTA: 1.634
- MATRICULA_HISTORICA: 106.555

## Evidencia a guardar

Guardar capturas o salidas de:

1. `COUNT(*)` de staging.
2. `05_preload_validation.sql`.
3. mensaje `CONTROL PRE-ETL OK`.
4. ejecución de `06_transform_load.sql`.
5. conteos y controles de `07_validation.sql`.
6. consultas funcionales de `08_sample_queries.sql`.

Esas salidas son evidencia de ejecución. El código del repositorio por sí solo no demuestra que la carga haya funcionado en la instancia Oracle.
