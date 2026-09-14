# Taller Base de Datos — EduBio 360

Proyecto de Base de Datos relacionado con **EduBio 360**. Su proposito es construir y documentar el nucleo de datos academicos en **Oracle Database**, a partir del dataset de matricula de Educacion Superior del Biobio.

## Rol de este repositorio

Este repositorio se concentra exclusivamente en la capa de datos:

- perfilamiento del dataset fuente;
- modelo entidad-relacion;
- normalizacion hasta 3FN;
- DDL Oracle, claves, restricciones e indices;
- staging y proceso ETL;
- carga de mas de 1.000 registros reales;
- validaciones de integridad y calidad;
- PL/SQL exigido por la evaluacion;
- evidencias y documentacion para la defensa.

## Relacion con EduBio 360

La base almacena y organiza datos academicos como instituciones, denominaciones de carrera, niveles, ofertas, planes, costos y matriculas historicas.

El flujo previsto es:

`Excel -> STAGING_MATRICULA -> ETL -> Oracle normalizado -> servicios backend/API -> EduBio 360`

El frontend no debe acceder directamente a Oracle.

## Fuente analizada

- Registros: **106.555**
- Columnas: **28**
- IDs fuente distintos: **106.555**
- Instituciones: **30**
- Denominaciones de carrera: **824**
- Combinaciones denominacion + nivel: **830**
- Ofertas conceptuales: **1.544**
- Combinaciones oferta + plan: **1.634**

## Modelo final

El modelo contiene **19 tablas de negocio en 3FN**. La tabla tecnica `STAGING_MATRICULA` se mantiene fuera del DER normalizado porque conserva intencionalmente la estructura plana de la fuente para el proceso ETL.

El detalle y la justificacion se encuentran en:

- `docs/modelo-datos-final.md`
- `docs/normalizacion-3fn.md`
- `docs/diagrama-er.dbml`
- `docs/diagrama-etl.md`
- `docs/evidencias/01_dependencias_funcionales.md`

## Scripts Oracle

Orden recomendado:

1. `database/01_create_tables.sql`
2. `database/02_constraints.sql`
3. `database/03_indexes.sql`
4. `database/04_create_staging.sql`
5. cargar CSV a staging con `database/sqlldr/staging_matricula.ctl`
6. `database/05_preload_validation.sql`
7. `database/06_transform_load.sql`
8. `database/07_validation.sql`
9. `database/08_sample_queries.sql`

La guia de carga esta en `docs/carga-staging.md`.

## PL/SQL obligatorio

- `plsql/01_record.sql`
- `plsql/02_varray.sql`
- `plsql/03_cursor_loops.sql`
- `plsql/04_excepciones.sql`

La explicacion para la defensa esta en `docs/plsql-guia-defensa.md`.

La estrategia futura para Procedure, Function, Package y Trigger esta en `docs/stored-objects-futuro.md`.

## Requisitos

Los requisitos funcionales y no funcionales estan documentados en:

- `docs/requisitos-base-datos.md`

## Objetivo academico

La solucion debe demostrar una base relacional Oracle normalizada y trazable, con al menos 10 tablas relacionadas, 3FN, mas de 1.000 registros cargados y los elementos PL/SQL exigidos por la evaluacion.

## Estado actual

### Preparado en repositorio

- modelo definitivo basado en datos reales;
- dependencias funcionales documentadas;
- 1FN, 2FN y 3FN justificadas;
- separacion `DENOMINACION_CARRERA` / `CARRERA` para eliminar la dependencia parcial detectada;
- DER DBML actualizado;
- staging separado del DER normalizado;
- DDL Oracle;
- constraints;
- indices;
- staging;
- validaciones pre-ETL;
- transformacion y carga al modelo normalizado;
- validaciones posteriores;
- ejemplos PL/SQL obligatorios;
- guia de defensa.

### Pendiente de evidencia de ejecucion

Los scripts deben ejecutarse en una instancia Oracle para obtener las evidencias reales: conteos, salidas de PL/SQL, errores controlados y capturas. El codigo preparado no se considera evidencia hasta que haya sido ejecutado y verificado en Oracle.
