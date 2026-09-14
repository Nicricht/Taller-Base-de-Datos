# Taller Base de Datos — EduBío 360

Proyecto de Base de Datos relacionado con **EduBío 360**. Su propósito es construir y documentar el núcleo de datos académicos en **Oracle Database**, a partir del dataset de matrícula de Educación Superior del Biobío.

## Rol de este repositorio

Este repositorio se concentra exclusivamente en la capa de datos:

- Perfilamiento del dataset fuente.
- Diseño del modelo entidad-relación.
- Normalización hasta 3FN.
- DDL Oracle, claves y restricciones.
- Staging y proceso ETL.
- Carga de más de 1.000 registros reales.
- Validaciones de integridad y calidad.
- PL/SQL exigido por la evaluación.
- Evidencias y documentación para la defensa.

## Relación con EduBío 360

Este proyecto será una pieza del ecosistema EduBío 360. La base almacena y organiza datos académicos como instituciones, carreras, áreas, territorio, ofertas académicas y matrículas históricas.

La aplicación principal de EduBío 360 debe consumir estos datos mediante sus servicios/backend. La base de datos no debe ser accedida directamente por el frontend.

## Requisitos

Los requisitos funcionales y no funcionales de la base están documentados en:

- `docs/requisitos-base-datos.md`

## Objetivo académico

La solución debe permitir demostrar una base relacional Oracle normalizada y trazable, con al menos 10 tablas relacionadas, 3FN, más de 1.000 registros cargados y los elementos PL/SQL exigidos por la evaluación.
