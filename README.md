# Taller Base de Datos — EduBio 360

Proyecto de Base de Datos relacionado con **EduBio 360**. Su propósito es construir y documentar el núcleo de datos académicos en **Oracle Database**, a partir del dataset de matrícula de Educación Superior del Biobío.

## Rol de este repositorio

Este repositorio se concentra exclusivamente en la capa de datos:

- perfilamiento del dataset fuente;
- modelo entidad-relación;
- normalización hasta 3FN;
- DDL Oracle, claves, restricciones e índices;
- staging y proceso ETL;
- carga de más de 1.000 registros reales;
- validaciones de integridad y calidad;
- PL/SQL exigido por la evaluación;
- evidencias y documentación para la defensa.

## Relación con EduBio 360

La base almacena y organiza datos académicos como instituciones, denominaciones de carrera, niveles, ofertas, planes, costos y matrículas históricas.

Flujo previsto:

`Excel -> STAGING_MATRICULA -> validación -> ETL -> Oracle normalizado -> servicios backend/API -> EduBio 360`

El frontend no debe acceder directamente a Oracle.

## Fuente analizada

- Registros: **106.555**
- Columnas: **28**
- IDs fuente distintos: **106.555**
- Instituciones: **30**
- Denominaciones de carrera: **824**
- Combinaciones denominación + nivel: **830**
- Ofertas conceptuales: **1.544**
- Combinaciones oferta + plan: **1.634**

## Modelo final

El modelo contiene **19 tablas de negocio en 3FN**. La tabla técnica `STAGING_MATRICULA` se mantiene fuera del DER normalizado porque conserva intencionalmente la estructura plana de la fuente para el proceso ETL.

Documentación principal:

- `docs/modelo-datos-final.md`
- `docs/normalizacion-3fn.md`
- `docs/diagrama-er.dbml`
- `docs/diagrama-etl.md`
- `docs/diccionario-datos.md`
- `docs/evidencias/01_dependencias_funcionales.md`

## Ejecución Oracle recomendada

### 0. Crear usuario del proyecto

Solo si `EDUBIO360` todavía no existe, ejecutar como `SYSTEM_XEPDB1`:

- `database/00_setup_edubio360.sql`

Nunca guardar una contraseña real en Git.

### 1. Construir toda la estructura

Conectado como `EDUBIO360`, abrir y ejecutar con **F5**:

- `database/00_run_structure.sql`

Este script ejecuta:

1. `database/00_reset.sql`
2. `database/01_create_tables.sql`
3. `database/02_constraints.sql`
4. `database/03_indexes.sql`
5. `database/04_create_staging.sql`
6. `database/09_verify_structure.sql`

La verificación debe mostrar **20 tablas del proyecto**: 19 de negocio + `STAGING_MATRICULA`.

### 2. Cargar la fuente en staging

1. Exportar la hoja `BASE DE DATOS` a CSV UTF-8.
2. Cargarla con `database/sqlldr/staging_matricula.ctl`.
3. Verificar que `STAGING_MATRICULA` contenga más de 1.000 filas, idealmente las **106.555** filas de la fuente completa.

La guía detallada está en `docs/carga-staging.md`.

### 3. Validar antes del ETL

Ejecutar:

1. `database/05_preload_validation.sql`
2. `database/05b_assert_staging.sql`

El primer script entrega el diagnóstico detallado. El segundo bloquea el avance cuando detecta duplicados, nulos críticos, campos numéricos inválidos o conflictos en dependencias funcionales obligatorias.

### 4. Transformar y cargar el modelo normalizado

Ejecutar:

1. `database/06_transform_load.sql`
2. `database/07_validation.sql`
3. `database/08_sample_queries.sql`

## Instalación rápida opcional

El flujo manual anterior se mantiene completo para aprendizaje, trazabilidad y defensa. Como alternativa, el repositorio incluye ahora un instalador rápido para Windows que automatiza la construcción, carga, ETL y verificación sin reemplazar los scripts originales.

Archivo principal:

- `INSTALAR_EDUBIO360.bat`

Preparación:

1. Tener una instancia Oracle accesible y un usuario/esquema con permisos para crear los objetos del proyecto.
2. Tener `sqlplus` y `sqlldr` disponibles en el `PATH` de Windows.
3. Copiar `matriculas_biobio_2021.csv` dentro de la carpeta `data/`.
4. Ejecutar `INSTALAR_EDUBIO360.bat`.
5. Confirmar una sola vez la reconstrucción de las tablas del proyecto e ingresar usuario, conexión y contraseña Oracle.

El instalador ejecuta automáticamente:

1. prueba de conexión;
2. `database/00_run_structure.sql`;
3. carga del CSV con `database/sqlldr/staging_matricula.ctl`;
4. `database/00_run_data_pipeline.sql`;
5. validaciones pre-ETL;
6. ETL;
7. validaciones posteriores;
8. `database/10_assert_final.sql` para confirmar los conteos esperados.

Para el dataset oficial, la verificación final exige **106.555** filas en `STAGING_MATRICULA` y **106.555** filas en `MATRICULA_HISTORICA`, además de los conteos esperados de las tablas normalizadas.

Si `sqlldr` no está disponible, se conserva el método manual de `docs/carga-staging.md`. Después de cargar el CSV manualmente, puede ejecutarse `database/00_run_data_pipeline.sql` con F5 para automatizar toda la parte restante.

El CSV, los logs de SQL*Loader y las credenciales locales siguen fuera de Git mediante `.gitignore`.

## PL/SQL obligatorio

- `plsql/01_record.sql`
- `plsql/02_varray.sql`
- `plsql/03_cursor_loops.sql`
- `plsql/04_excepciones.sql`

La explicación para la defensa está en `docs/plsql-guia-defensa.md`.

La estrategia futura para Procedure, Function, Package y Trigger está en `docs/stored-objects-futuro.md`.

## Requisitos

Los requisitos funcionales y no funcionales están documentados en:

- `docs/requisitos-base-datos.md`

## Objetivo académico

La solución debe demostrar una base relacional Oracle normalizada y trazable, con al menos 10 tablas relacionadas, 3FN, más de 1.000 registros cargados y los elementos PL/SQL exigidos por la evaluación.

## Estado actual

### Preparado en repositorio

- modelo definitivo basado en datos reales;
- dependencias funcionales documentadas;
- 1FN, 2FN y 3FN justificadas;
- separación `DENOMINACION_CARRERA` / `CARRERA` para eliminar la dependencia parcial detectada;
- DER DBML actualizado;
- staging separado del DER normalizado;
- DDL Oracle;
- constraints;
- índices;
- script maestro de construcción y verificación;
- staging;
- validaciones pre-ETL robustecidas;
- control bloqueante previo al ETL;
- transformación y carga al modelo normalizado;
- validaciones posteriores;
- instalación rápida opcional para Windows;
- pipeline automático de staging a modelo final;
- verificación final bloqueante de conteos esperados;
- ejemplos PL/SQL obligatorios;
- guía de defensa;
- `.gitignore` para impedir subir por accidente datasets, CSV, logs o credenciales locales.

### Pendiente de evidencia de ejecución

Los scripts deben ejecutarse en una instancia Oracle para obtener evidencias reales: conteos, salidas de PL/SQL, errores controlados y capturas. El código preparado no se considera evidencia hasta que haya sido ejecutado y verificado en Oracle.
