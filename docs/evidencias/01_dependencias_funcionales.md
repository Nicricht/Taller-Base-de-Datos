# Evidencia 01 - Dependencias funcionales

## Fuente analizada

Archivo: `11_MATRICULAS_ED_SUPERIOR_BIOBIO_2021.xlsx`

Hoja: `BASE DE DATOS`

Registros analizados: **106.555**

Columnas analizadas: **28**

IDs fuente distintos: **106.555**

## Metodo

Para cada dependencia `X -> Y` se agruparon los registros por `X` y se conto cuantos valores distintos de `Y` aparecen para cada valor de `X`.

La dependencia se considera valida en la fuente cuando ningun valor de `X` produce mas de un valor distinto de `Y`.

## Resultados principales

| Dependencia | Valores distintos de X | Conflictos | Resultado |
|---|---:|---:|---|
| COMUNA SEDE -> PROVINCIA SEDE | 9 | 0 | CUMPLE |
| PROVINCIA SEDE -> REGION SEDE | 3 | 0 | CUMPLE |
| NOMBRE DE INSTITUCION -> TIPO DE INSTITUCION | 30 | 0 | CUMPLE |
| NOMBRE DE INSTITUCION -> ACREDITACION INSTITUCIONAL | 30 | 0 | CUMPLE |
| NOMBRE DE INSTITUCION -> PERIODO DE ACREDITACION | 30 | 0 | CUMPLE |
| NOMBRE DE INSTITUCION -> AÑOS DE ACREDITACION | 30 | 0 | CUMPLE |
| NIVEL CARRERA -> NIVEL DE ESTUDIO CARRERA | 5 | 0 | CUMPLE |
| NOMBRE CARRERA -> AREA CONOCIMIENTO | 824 | 0 | CUMPLE |
| EDAD -> RANGO EDAD | 58 | 0 | CUMPLE |

## Hallazgo adicional importante

La dependencia:

`NOMBRE CARRERA -> NIVEL CARRERA`

**NO se cumple**.

Se detectaron 6 nombres de carrera asociados a mas de un nivel de carrera:

1. EDUCACION DIFERENCIAL
2. GASTRONOMIA INTERNACIONAL
3. TRABAJO SOCIAL
4. ADMINISTRACION PUBLICA
5. DISENO GRAFICO
6. EDUCACION DE PARVULOS

En estos casos aparecen variantes tecnicas y profesionales.

### Consecuencia de diseno

No se utiliza el nombre de carrera como clave natural unica.

La identidad logica de `CARRERA` utiliza:

`(nombre, id_nivel_carrera)`

Esto produce **830 combinaciones distintas de nombre + nivel**, frente a 824 nombres simples.

## Evidencia para OFERTA_ACADEMICA y PLAN_OFERTA

Se evaluo como identidad conceptual de una oferta:

`institucion + carrera + nivel de carrera + comuna + modalidad + jornada`

Se obtuvieron **1.544 ofertas distintas**.

Dentro de estas ofertas existen variaciones que justifican separar `PLAN_OFERTA`:

| Atributo | Ofertas con mas de un valor |
|---|---:|
| TIPO PLAN CARRERA | 13 |
| DURACION PLAN DE ESTUDIO | 77 |
| DURACION PROCESO TITULACION | 9 |
| DURACION TOTAL CARRERA | 76 |
| VALOR MATRICULA | 6 |
| VALOR ARANCEL | 46 |

Se observaron **1.634 combinaciones unicas de oferta + plan**.

## Requisito y via de ingreso

`REQUISITO INGRESO` presenta 5 valores distintos y `VIA DE INGRESO` presenta 11.

Al analizar la misma identidad conceptual de oferta:

- 12 ofertas presentan mas de un requisito de ingreso entre sus registros historicos.
- 714 ofertas presentan mas de una via de ingreso entre sus registros historicos.

Por esta razon no se consideran propiedades estables de `OFERTA_ACADEMICA`.

En el modelo final se crean los catalogos `REQUISITO_INGRESO` y `VIA_INGRESO`, y `MATRICULA_HISTORICA` conserva las foreign keys correspondientes.

## Cardinalidades y dominios relevantes

- TIPO DE INSTITUCION: 5 valores
- INSTITUCION: 30 valores
- AREA CONOCIMIENTO: 10 valores
- NIVEL DE ESTUDIO CARRERA: 3 valores
- NIVEL CARRERA: 5 valores
- MODALIDAD: 3 valores
- JORNADA: 5 valores
- TIPO PLAN CARRERA: 3 valores
- REGION SEDE: 1 valor
- PROVINCIA SEDE: 3 valores
- COMUNA SEDE: 9 valores
- REQUISITO INGRESO: 5 valores
- VIA DE INGRESO: 11 valores

## Costos y duraciones

La fuente presenta valores de matricula y arancel iguales a cero, por lo que la regla de integridad elegida es `>= 0` y no `> 0`.

No se impone que `duracion_total = duracion_plan + duracion_titulacion`, porque esa igualdad no se cumple de manera general en la fuente.

## Uso en la defensa

Estas pruebas permiten explicar al docente que las decisiones del DER no fueron tomadas solamente por intuicion. El modelo fue ajustado despues de analizar la fuente real y comprobar las dependencias funcionales, cardinalidades y variaciones de granularidad que sustentan la normalizacion.
