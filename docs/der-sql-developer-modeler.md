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

## Convención correcta de relaciones en el modelo relacional

Para reproducir el aspecto de `Relational_1` de Oracle SQL Developer Data Modeler no se deben inventar símbolos de cardinalidad sobre las líneas. En el modelo relacional, cada enlace representa una clave foránea real entre una tabla hija y una tabla padre.

La dirección de la punta de flecha es una preferencia visual configurable en Data Modeler. Para que coincida con los ejemplos utilizados como referencia, se debe configurar:

`Tools > Preferences > Data Modeler > Diagram > Relational Model > Foreign Key Arrow Direction > Primary Key`

Con esta configuración la flecha apunta hacia la tabla padre, es decir, desde la FK de la tabla hija hacia la PK o UK referenciada. La flecha por sí sola no significa 1:1 ni 1:N.

Los marcadores de columna se interpretan así:

- `P`: columna perteneciente a la clave primaria.
- `F`: columna perteneciente a una clave foránea.
- `U`: columna perteneciente a una restricción unique.
- `PF`: columna que participa simultáneamente en PK y FK.
- `*`: columna obligatoria, equivalente a NOT NULL.

En los diagramas relacionales, las FKs obligatorias se muestran con línea continua y las FKs opcionales con línea discontinua. En EDUBIO360 las FKs del modelo de negocio son NOT NULL, por lo que deben aparecer como relaciones obligatorias desde el lado hijo.

Los pequeños símbolos adicionales de la línea tampoco deben interpretarse como cardinalidad. Oracle utiliza marcas en la relación para representar propiedades de la FK, por ejemplo la regla de borrado. `NO ACTION` o `RESTRICT` se representan mediante una línea transversal, `CASCADE` mediante una X y `SET NULL` mediante un pequeño círculo.

## Cardinalidad real de EDUBIO360

Aunque la punta de flecha del modelo relacional no expresa por sí sola la cardinalidad, las restricciones reales del esquema permiten determinarla. Todas las FKs principales de EDUBIO360 son no únicas y NOT NULL. Por lo tanto, cada fila hija debe referenciar exactamente un padre, mientras que un padre puede estar relacionado con cero, una o muchas filas hijas.

Las relaciones del modelo son:

- REGION 1:N PROVINCIA, mediante `PROVINCIA.id_region`.
- PROVINCIA 1:N COMUNA, mediante `COMUNA.id_provincia`.
- TIPO_INSTITUCION 1:N INSTITUCION, mediante `INSTITUCION.id_tipo_institucion`.
- INSTITUCION 1:N ACREDITACION_INSTITUCION, mediante `ACREDITACION_INSTITUCION.id_institucion`.
- AREA_CONOCIMIENTO 1:N DENOMINACION_CARRERA, mediante `DENOMINACION_CARRERA.id_area`.
- NIVEL_ESTUDIO 1:N NIVEL_CARRERA, mediante `NIVEL_CARRERA.id_nivel_estudio`.
- DENOMINACION_CARRERA 1:N CARRERA, mediante `CARRERA.id_denominacion`.
- NIVEL_CARRERA 1:N CARRERA, mediante `CARRERA.id_nivel_carrera`.
- INSTITUCION 1:N OFERTA_ACADEMICA, mediante `OFERTA_ACADEMICA.id_institucion`.
- CARRERA 1:N OFERTA_ACADEMICA, mediante `OFERTA_ACADEMICA.id_carrera`.
- COMUNA 1:N OFERTA_ACADEMICA, mediante `OFERTA_ACADEMICA.id_comuna`.
- MODALIDAD 1:N OFERTA_ACADEMICA, mediante `OFERTA_ACADEMICA.id_modalidad`.
- JORNADA 1:N OFERTA_ACADEMICA, mediante `OFERTA_ACADEMICA.id_jornada`.
- OFERTA_ACADEMICA 1:N PLAN_OFERTA, mediante `PLAN_OFERTA.id_oferta`.
- TIPO_PLAN 1:N PLAN_OFERTA, mediante `PLAN_OFERTA.id_tipo_plan`.
- PLAN_OFERTA 1:N MATRICULA_HISTORICA, mediante `MATRICULA_HISTORICA.id_plan_oferta`.
- REQUISITO_INGRESO 1:N MATRICULA_HISTORICA, mediante `MATRICULA_HISTORICA.id_requisito_ingreso`.
- VIA_INGRESO 1:N MATRICULA_HISTORICA, mediante `MATRICULA_HISTORICA.id_via_ingreso`.

No existe ninguna relación 1:1 en las restricciones actuales del esquema.

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
PROVINCIA.id_region → REGION.id_region
COMUNA.id_provincia → PROVINCIA.id_provincia
OFERTA_ACADEMICA.id_comuna → COMUNA.id_comuna
```

### Bloque institucional, parte superior izquierda

```text
INSTITUCION.id_tipo_institucion → TIPO_INSTITUCION.id_tipo_institucion
OFERTA_ACADEMICA.id_institucion → INSTITUCION.id_institucion
ACREDITACION_INSTITUCION.id_institucion → INSTITUCION.id_institucion
```

### Bloque académico, parte superior y centro

```text
DENOMINACION_CARRERA.id_area → AREA_CONOCIMIENTO.id_area
CARRERA.id_denominacion → DENOMINACION_CARRERA.id_denominacion
CARRERA.id_nivel_carrera → NIVEL_CARRERA.id_nivel_carrera
NIVEL_CARRERA.id_nivel_estudio → NIVEL_ESTUDIO.id_nivel_estudio
OFERTA_ACADEMICA.id_carrera → CARRERA.id_carrera
```

### Catálogos de la oferta, lado derecho

```text
OFERTA_ACADEMICA.id_modalidad → MODALIDAD.id_modalidad
OFERTA_ACADEMICA.id_jornada → JORNADA.id_jornada
```

### Planes y matrícula histórica, parte inferior

```text
PLAN_OFERTA.id_tipo_plan → TIPO_PLAN.id_tipo_plan
PLAN_OFERTA.id_oferta → OFERTA_ACADEMICA.id_oferta
MATRICULA_HISTORICA.id_plan_oferta → PLAN_OFERTA.id_plan_oferta
MATRICULA_HISTORICA.id_requisito_ingreso → REQUISITO_INGRESO.id_requisito_ingreso
MATRICULA_HISTORICA.id_via_ingreso → VIA_INGRESO.id_via_ingreso
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
