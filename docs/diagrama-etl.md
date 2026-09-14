# Flujo ETL - EduBio 360

`STAGING_MATRICULA` es una tabla tecnica y no forma parte del DER normalizado en 3FN.

## Flujo

```text
Excel de matriculas
        |
        v
STAGING_MATRICULA
28 columnas recibidas como texto
        |
        v
Validaciones previas
- IDs duplicados
- nulos criticos
- formatos numericos
- dependencias funcionales
- costos negativos
        |
        v
Transformacion ETL
        |
        +--> catalogos territoriales
        +--> instituciones
        +--> clasificacion academica
        +--> DENOMINACION_CARRERA
        +--> CARRERA
        +--> OFERTA_ACADEMICA
        +--> PLAN_OFERTA
        v
MATRICULA_HISTORICA
        |
        v
Validaciones posteriores
```

## Regla de presentacion

En la defensa se muestran dos elementos separados:

1. El DER normalizado, compuesto por las 19 tablas de negocio.
2. El flujo de carga, donde aparece `STAGING_MATRICULA` como tabla tecnica de entrada.

Frase sugerida:

> STAGING_MATRICULA conserva deliberadamente la estructura plana de la fuente para validar y transformar los datos. No la usamos para demostrar 3FN; la 3FN corresponde al modelo relacional de negocio que recibe los datos despues del ETL.
