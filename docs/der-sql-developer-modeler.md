# DER de EDUBIO360 en Oracle SQL Developer Data Modeler

Este documento define cómo debe generarse y organizarse el diagrama entidad-relación que se incorporará al informe de EDUBIO360.

## Origen del diagrama

El diagrama debe generarse desde el esquema real de Oracle mediante SQL Developer Data Modeler. Oracle permite crear un modelo relacional a partir del diccionario de datos de una base existente usando:

`File > Import > Data Dictionary`

Como alternativa, si se trabaja desde los scripts del repositorio, Data Modeler también permite importar el DDL mediante:

`File > Import > DDL File`

Para el informe se debe utilizar el modelo relacional generado desde las tablas reales y no una imagen dibujada manualmente.

## Tablas que deben aparecer

El DER debe mostrar las 19 tablas de negocio:

1. REGION
2. PROVINCIA
3. COMUNA
4. TIPO_INSTITUCION
5. INSTITUCION
6. ACREDITACION_INSTITUCION
7. AREA_CONOCIMIENTO
8. DENOMINACION_CARRERA
9. NIVEL_ESTUDIO
10. NIVEL_CARRERA
11. MODALIDAD
12. JORNADA
13. CARRERA
14. OFERTA_ACADEMICA
15. TIPO_PLAN
16. PLAN_OFERTA
17. REQUISITO_INGRESO
18. VIA_INGRESO
19. MATRICULA_HISTORICA

`STAGING_MATRICULA` no debe formar parte del DER principal porque corresponde a una tabla temporal de carga y no al modelo normalizado de negocio.

## Relaciones que deben verse

- REGION 1:N PROVINCIA
- PROVINCIA 1:N COMUNA
- TIPO_INSTITUCION 1:N INSTITUCION
- INSTITUCION 1:N ACREDITACION_INSTITUCION
- AREA_CONOCIMIENTO 1:N DENOMINACION_CARRERA
- NIVEL_ESTUDIO 1:N NIVEL_CARRERA
- DENOMINACION_CARRERA 1:N CARRERA
- NIVEL_CARRERA 1:N CARRERA
- CARRERA 1:N OFERTA_ACADEMICA
- INSTITUCION 1:N OFERTA_ACADEMICA
- COMUNA 1:N OFERTA_ACADEMICA
- MODALIDAD 1:N OFERTA_ACADEMICA
- JORNADA 1:N OFERTA_ACADEMICA
- OFERTA_ACADEMICA 1:N PLAN_OFERTA
- TIPO_PLAN 1:N PLAN_OFERTA
- PLAN_OFERTA 1:N MATRICULA_HISTORICA
- REQUISITO_INGRESO 1:N MATRICULA_HISTORICA
- VIA_INGRESO 1:N MATRICULA_HISTORICA

## Distribución recomendada

Para evitar cruces innecesarios, `OFERTA_ACADEMICA` debe quedar en la zona central del diagrama.

### Bloque territorial, lado izquierdo

```text
REGION
  ↓
PROVINCIA
  ↓
COMUNA
  ↓
OFERTA_ACADEMICA
```

### Bloque institucional, parte superior izquierda

```text
TIPO_INSTITUCION
        ↓
INSTITUCION ───────→ OFERTA_ACADEMICA
        ↓
ACREDITACION_INSTITUCION
```

### Bloque académico, parte superior y centro

```text
AREA_CONOCIMIENTO
        ↓
DENOMINACION_CARRERA
        ↓
      CARRERA ──────→ OFERTA_ACADEMICA
        ↑
NIVEL_CARRERA
        ↑
NIVEL_ESTUDIO
```

### Catálogos de la oferta, lado derecho

```text
MODALIDAD ──────→
                  OFERTA_ACADEMICA
JORNADA ────────→
```

### Planes y matrícula histórica, parte inferior

```text
TIPO_PLAN ─────→ PLAN_OFERTA
                     ↑
              OFERTA_ACADEMICA
                     ↓
              MATRICULA_HISTORICA
                 ↑             ↑
REQUISITO_INGRESO               VIA_INGRESO
```

## Orden visual sugerido

Fila superior:
`TIPO_INSTITUCION | INSTITUCION | ACREDITACION_INSTITUCION | AREA_CONOCIMIENTO | DENOMINACION_CARRERA | NIVEL_ESTUDIO | NIVEL_CARRERA`

Zona central:
`REGION | PROVINCIA | COMUNA | CARRERA | OFERTA_ACADEMICA | MODALIDAD | JORNADA`

Zona inferior:
`TIPO_PLAN | PLAN_OFERTA | MATRICULA_HISTORICA | REQUISITO_INGRESO | VIA_INGRESO`

La posición exacta puede ajustarse manualmente para evitar cruces, pero `OFERTA_ACADEMICA`, `CARRERA`, `PLAN_OFERTA` y `MATRICULA_HISTORICA` deben mantenerse cerca entre sí porque forman el eje principal del modelo.

## Qué debe verse en cada tabla

Para el informe conviene mostrar:

- nombre de la tabla;
- clave primaria;
- claves foráneas;
- columnas principales;
- líneas de relación entre PK y FK.

No es necesario mostrar índices técnicos, secuencias, triggers u otros objetos que hagan el diagrama difícil de leer.

## Exportación para el informe

Una vez ordenado el modelo en Data Modeler:

1. ajustar el zoom para que las 19 tablas sean legibles;
2. evitar líneas cruzadas en lo posible;
3. mantener visibles PK y FK;
4. exportar el diagrama en PNG, SVG o PDF desde Data Modeler;
5. insertar la imagen en los anexos del informe.

Pie recomendado:

**Figura X. Modelo relacional de EDUBIO360 generado desde Oracle SQL Developer Data Modeler.**
