# Modelo de Datos Validado - EduBio 360

## Objetivo

Definir la base relacional Oracle que almacenará la información académica utilizada por EduBio 360 y que servirá como base para la evaluación de Taller de Base de Datos / PL/SQL.

La fuente analizada es `11_MATRICULAS_ED_SUPERIOR_BIOBIO_2021.xlsx`, con **106.555 registros y 28 columnas**.

## Grano de la fuente

Cada fila del Excel representa un **registro histórico de matrícula** asociado a una oferta académica. El archivo no entrega un identificador persistente de persona, por lo que no se crea una entidad ESTUDIANTE artificial.

El identificador `ID` del archivo es único para las 106.555 filas y se conservará como `id_registro_fuente` en `MATRICULA_HISTORICA` para trazabilidad.

## Perfil relevante de la fuente

- 106.555 registros de matrícula.
- 30 instituciones.
- 5 tipos de institución.
- 824 nombres de carrera.
- 830 combinaciones únicas de nombre de carrera + nivel de carrera.
- 10 áreas de conocimiento.
- 5 niveles de carrera.
- 3 niveles de estudio.
- 9 comunas.
- 3 provincias.
- 1 región.
- 3 modalidades.
- 5 jornadas.

## Dependencias funcionales verificadas

Se analizaron directamente los 106.555 registros de la fuente.

| Dependencia | Resultado | Evidencia |
|---|---|---|
| COMUNA SEDE -> PROVINCIA SEDE | Se cumple | 9 comunas, 0 conflictos |
| PROVINCIA SEDE -> REGION SEDE | Se cumple | 3 provincias, 0 conflictos |
| NOMBRE DE INSTITUCION -> TIPO DE INSTITUCION | Se cumple | 30 instituciones, 0 conflictos |
| NIVEL CARRERA -> NIVEL DE ESTUDIO CARRERA | Se cumple | 5 niveles de carrera, 0 conflictos |
| NOMBRE CARRERA -> AREA CONOCIMIENTO | Se cumple | 824 nombres de carrera, 0 conflictos |
| EDAD -> RANGO EDAD | Se cumple | El rango de edad es un dato derivado |

### Dependencia que NO se cumple

`NOMBRE CARRERA -> NIVEL CARRERA` **no se cumple**.

Se encontraron 6 nombres de carrera que aparecen como carrera técnica y profesional:

- EDUCACION DIFERENCIAL
- GASTRONOMIA INTERNACIONAL
- TRABAJO SOCIAL
- ADMINISTRACION PUBLICA
- DISENO GRAFICO
- EDUCACION DE PARVULOS

Por esta razón, `CARRERA` no puede identificarse solamente por el nombre. La clave candidata lógica será la combinación:

`(nombre_carrera, id_nivel_carrera)`

## Entidades del modelo

1. REGION
2. PROVINCIA
3. COMUNA
4. TIPO_INSTITUCION
5. INSTITUCION
6. ACREDITACION_INSTITUCION
7. AREA_CONOCIMIENTO
8. NIVEL_ESTUDIO
9. NIVEL_CARRERA
10. CARRERA
11. OFERTA_ACADEMICA
12. PLAN_OFERTA
13. MATRICULA_HISTORICA

## Relaciones validadas/propuestas

- REGION 1:N PROVINCIA
- PROVINCIA 1:N COMUNA
- TIPO_INSTITUCION 1:N INSTITUCION
- INSTITUCION 1:N ACREDITACION_INSTITUCION
- NIVEL_ESTUDIO 1:N NIVEL_CARRERA
- AREA_CONOCIMIENTO 1:N CARRERA
- NIVEL_CARRERA 1:N CARRERA
- INSTITUCION 1:N OFERTA_ACADEMICA
- CARRERA 1:N OFERTA_ACADEMICA
- COMUNA 1:N OFERTA_ACADEMICA
- OFERTA_ACADEMICA 1:N PLAN_OFERTA
- PLAN_OFERTA 1:N MATRICULA_HISTORICA

## Decisiones de diseño

### CARRERA

`CARRERA` representa una carrera académica en un nivel concreto. Al comprobarse que un mismo nombre puede aparecer como carrera técnica y profesional, la identidad natural de una carrera no será solo su nombre.

`CARRERA` tendrá:

- PK `id_carrera`
- FK `id_area`
- FK `id_nivel_carrera`
- `nombre`
- restricción UNIQUE `(nombre, id_nivel_carrera)`

`AREA_CONOCIMIENTO` se relaciona con `CARRERA`, ya que `NOMBRE CARRERA -> AREA CONOCIMIENTO` se cumple en los 824 nombres analizados.

`NIVEL_ESTUDIO` no se duplicará dentro de `CARRERA`, porque `NIVEL_CARRERA -> NIVEL_ESTUDIO` ya está demostrado.

### OFERTA_ACADEMICA

Representa una carrera ofrecida por una institución en una comuna, modalidad y jornada determinadas.

Clave candidata conceptual de la oferta:

`institucion + carrera + comuna + modalidad + jornada`

Se encontraron **1.544 ofertas académicas distintas** con esta granularidad.

### PLAN_OFERTA

La separación entre `OFERTA_ACADEMICA` y `PLAN_OFERTA` queda respaldada por los datos.

Dentro de una misma oferta se encontraron variaciones en:

- tipo de plan: 13 ofertas con más de un valor;
- duración del plan: 77 ofertas;
- duración de titulación: 9 ofertas;
- duración total: 76 ofertas;
- valor de matrícula: 6 ofertas;
- valor de arancel: 46 ofertas.

Se identificaron **1.634 combinaciones únicas de oferta + plan**.

Por ello, costos y duraciones no deben formar parte de la identidad básica de `OFERTA_ACADEMICA`; se almacenarán en `PLAN_OFERTA`.

### MATRICULA_HISTORICA

Representa cada fila histórica de la fuente.

Almacena:

- `id_registro_fuente`
- referencia a `PLAN_OFERTA`
- género
- edad
- año de ingreso
- semestre de ingreso
- requisito de ingreso
- vía de ingreso

`RANGO EDAD` no se almacenará como atributo persistente porque `EDAD -> RANGO EDAD` se cumple y, por tanto, es un dato derivable.

`REQUISITO INGRESO` y `VIA DE INGRESO` se mantienen en `MATRICULA_HISTORICA` porque varían entre registros de matrícula y no describen de manera estable a la oferta académica.

### ACREDITACION_INSTITUCION

En la fuente actual cada institución presenta un único conjunto de datos de acreditación. Se mantiene como entidad separada para permitir histórico en futuras cargas de EduBio 360, evitando sobrescribir períodos anteriores. Se recomienda UNIQUE `(id_institucion, periodo)`.

### Jerarquía territorial

Las dependencias `COMUNA -> PROVINCIA` y `PROVINCIA -> REGION` se cumplen sin conflictos, por lo que la jerarquía se modela en tablas separadas y no se repetirá provincia/región dentro de cada oferta.

## Estado de normalización

El modelo está encaminado a 3FN porque:

- cada entidad tendrá una PK;
- los atributos serán atómicos;
- los atributos descriptivos dependerán de la clave de su propia entidad;
- las dependencias transitivas detectadas se separan, por ejemplo `COMUNA -> PROVINCIA -> REGION` y `NIVEL_CARRERA -> NIVEL_ESTUDIO`;
- se evita almacenar `RANGO EDAD` porque depende de `EDAD`;
- `AREA_CONOCIMIENTO` y `NIVEL_CARRERA` se ubican en `CARRERA`, no se repiten en `OFERTA_ACADEMICA`.

La demostración formal de 1FN, 2FN y 3FN se documentará por separado antes de cerrar el DDL definitivo.

## Próximos pasos

1. Documentar formalmente 1FN, 2FN y 3FN.
2. Convertir el modelo validado a DDL Oracle.
3. Crear PK, FK, UNIQUE, CHECK y NOT NULL.
4. Crear `STAGING_MATRICULA`.
5. Construir ETL desde el Excel.
6. Cargar muestra controlada.
7. Cargar más de 1.000 registros.
8. Ejecutar consultas de validación.
9. Implementar RECORD, VARRAY, cursor parametrizado, loops y excepciones PL/SQL.

## Integración con EduBio 360

Este repositorio contiene la capa de persistencia académica. EduBio 360 consumirá estos datos a través de servicios backend/API. El frontend no debe conectarse directamente a Oracle.
