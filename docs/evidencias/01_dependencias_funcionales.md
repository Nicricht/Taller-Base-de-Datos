# Evidencia 01 - Dependencias funcionales

## Fuente analizada

Archivo: `11_MATRICULAS_ED_SUPERIOR_BIOBIO_2021.xlsx`

Hoja: `BASE DE DATOS`

Registros analizados: **106.555**

Columnas analizadas: **28**

IDs fuente distintos: **106.555**

## Metodo

Para cada dependencia funcional se agruparon los registros por el atributo determinante y se conto cuantos valores distintos aparecen en el atributo dependiente. La dependencia se considera valida cuando ningun valor del determinante produce mas de un valor dependiente.

## Resultados principales

| Dependencia | Valores distintos del determinante | Conflictos | Resultado |
|---|---:|---:|---|
| COMUNA SEDE determina PROVINCIA SEDE | 9 | 0 | CUMPLE |
| PROVINCIA SEDE determina REGION SEDE | 3 | 0 | CUMPLE |
| NOMBRE DE INSTITUCION determina TIPO DE INSTITUCION | 30 | 0 | CUMPLE |
| NIVEL CARRERA determina NIVEL DE ESTUDIO CARRERA | 5 | 0 | CUMPLE |
| NOMBRE CARRERA determina AREA CONOCIMIENTO | 824 | 0 | CUMPLE |
| EDAD determina RANGO EDAD | 58 | 0 | CUMPLE |

## Hallazgo clave de carrera

El nombre de carrera **no determina siempre el nivel de carrera**.

Se detectaron 6 nombres asociados a mas de un nivel:

1. EDUCACION DIFERENCIAL
2. GASTRONOMIA INTERNACIONAL
3. TRABAJO SOCIAL
4. ADMINISTRACION PUBLICA
5. DISENO GRAFICO
6. EDUCACION DE PARVULOS

Al mismo tiempo, el nombre de carrera si determina el area de conocimiento.

### Consecuencia de diseno

El modelo final separa:

- `DENOMINACION_CARRERA`, que almacena el nombre y el area de conocimiento.
- `CARRERA`, que relaciona una denominacion con un nivel de carrera.

La clave candidata de `CARRERA` es:

`(id_denominacion, id_nivel_carrera)`

La fuente contiene **824 denominaciones distintas** y **830 combinaciones distintas de denominacion + nivel**.

Esta separacion evita que el area dependa solo de una parte de una clave candidata compuesta y fortalece la demostracion de 2FN y 3FN.

## Evidencia para OFERTA_ACADEMICA y PLAN_OFERTA

Se evaluo como identidad conceptual de una oferta la combinacion de institucion, carrera, comuna, modalidad y jornada. Se obtuvieron **1.544 ofertas distintas**.

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

`REQUISITO INGRESO` presenta 5 valores distintos y `VIA DE INGRESO` presenta 11. Ambos pueden variar entre registros de una misma oferta, por lo que se modelan como catalogos relacionados con `MATRICULA_HISTORICA`.

## Costos y duraciones

La fuente presenta valores de matricula y arancel iguales a cero, por lo que la regla de integridad elegida es `>= 0` y no `> 0`.

No se impone que la duracion total sea siempre la suma de plan y titulacion, porque esa igualdad no se cumple de manera general en la fuente.

## Uso en la defensa

Estas pruebas permiten explicar que las decisiones del DER fueron tomadas a partir de la fuente real y de dependencias funcionales comprobadas, no solamente por intuicion ni para aumentar artificialmente la cantidad de tablas.
