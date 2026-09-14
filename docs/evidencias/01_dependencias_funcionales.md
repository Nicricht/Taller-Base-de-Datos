# Evidencia 01 - Dependencias funcionales

## Fuente analizada

Archivo: `11_MATRICULAS_ED_SUPERIOR_BIOBIO_2021.xlsx`

Hoja: `BASE DE DATOS`

Registros analizados: **106.555**

Columnas analizadas: **28**

## Método

Para cada dependencia `X -> Y` se agruparon los registros por `X` y se contó cuántos valores distintos de `Y` aparecen para cada valor de `X`.

La dependencia se considera válida en la fuente cuando ningún valor de `X` produce más de un valor distinto de `Y`.

## Resultados principales

| Dependencia | Valores distintos de X | Conflictos | Resultado |
|---|---:|---:|---|
| COMUNA SEDE -> PROVINCIA SEDE | 9 | 0 | CUMPLE |
| PROVINCIA SEDE -> REGION SEDE | 3 | 0 | CUMPLE |
| NOMBRE DE INSTITUCION -> TIPO DE INSTITUCION | 30 | 0 | CUMPLE |
| NIVEL CARRERA -> NIVEL DE ESTUDIO CARRERA | 5 | 0 | CUMPLE |
| NOMBRE CARRERA -> AREA CONOCIMIENTO | 824 | 0 | CUMPLE |
| EDAD -> RANGO EDAD | 58 | 0 | CUMPLE |

## Hallazgo adicional importante

La dependencia:

`NOMBRE CARRERA -> NIVEL CARRERA`

**NO se cumple**.

Se detectaron 6 nombres de carrera asociados a más de un nivel de carrera:

1. EDUCACION DIFERENCIAL
2. GASTRONOMIA INTERNACIONAL
3. TRABAJO SOCIAL
4. ADMINISTRACION PUBLICA
5. DISENO GRAFICO
6. EDUCACION DE PARVULOS

En todos estos casos aparecen variantes técnicas y profesionales.

### Consecuencia de diseño

No se utilizará el nombre de carrera como clave natural única.

La identidad lógica de `CARRERA` utilizará:

`(nombre, id_nivel_carrera)`

Esto produce **830 combinaciones distintas de nombre + nivel**, frente a 824 nombres simples.

## Evidencia para OFERTA_ACADEMICA y PLAN_OFERTA

Se evaluó como identidad conceptual de una oferta:

`institucion + carrera + nivel de carrera + comuna + modalidad + jornada`

Se obtuvieron **1.544 ofertas distintas**.

Dentro de estas ofertas existen variaciones que justifican separar `PLAN_OFERTA`:

| Atributo | Ofertas con más de un valor |
|---|---:|
| TIPO PLAN CARRERA | 13 |
| DURACION PLAN DE ESTUDIO | 77 |
| DURACION PROCESO TITULACION | 9 |
| DURACION TOTAL CARRERA | 76 |
| VALOR MATRICULA | 6 |
| VALOR ARANCEL | 46 |

Se observaron **1.634 combinaciones únicas de oferta + plan**.

## Otros hallazgos

- `NOMBRE DE INSTITUCION -> ACREDITACION INSTITUCIONAL` se cumple en la fuente actual.
- `NOMBRE DE INSTITUCION -> PERIODO DE ACREDITACION` se cumple en la fuente actual.
- `NOMBRE DE INSTITUCION -> AÑOS DE ACREDITACION` se cumple en la fuente actual.
- `REQUISITO INGRESO` presenta 5 valores distintos y puede variar dentro de una misma oferta.
- `VIA DE INGRESO` presenta 11 valores distintos y puede variar ampliamente dentro de una misma oferta.

Por esta razón, `REQUISITO INGRESO` y `VIA DE INGRESO` se modelan como atributos de `MATRICULA_HISTORICA` y no como propiedades estables de `OFERTA_ACADEMICA`.

## Uso en la defensa

Estas pruebas permiten explicar al docente que las decisiones del DER no fueron tomadas solamente por intuición. El modelo fue ajustado después de analizar la fuente real y comprobar las dependencias funcionales que sustentan la normalización.
