# Modelo de Datos Final - Taller Base de Datos / EduBio 360

## Objetivo

Construir una base Oracle relacional, normalizada y trazable para almacenar la informacion academica que sera consumida por EduBio 360 mediante servicios backend/API.

La fuente analizada contiene 106.555 registros y 28 columnas. Las decisiones del modelo se basan en dependencias funcionales y cardinalidades comprobadas sobre la fuente real.

## Grano de la fuente

Cada fila representa un registro historico de matricula asociado a una oferta y a un plan academico. El archivo no contiene un identificador persistente de persona, por lo que no se crea una entidad ESTUDIANTE artificial.

## Modelo definitivo

### Territorio

1. REGION
2. PROVINCIA
3. COMUNA

Relaciones:
- REGION 1:N PROVINCIA
- PROVINCIA 1:N COMUNA

Dependencias comprobadas:
- COMUNA -> PROVINCIA
- PROVINCIA -> REGION

### Instituciones

4. TIPO_INSTITUCION
5. INSTITUCION
6. ACREDITACION_INSTITUCION

Relaciones:
- TIPO_INSTITUCION 1:N INSTITUCION
- INSTITUCION 1:N ACREDITACION_INSTITUCION

La fuente actual contiene un snapshot de acreditacion por institucion. Se mantiene una tabla separada porque EduBio 360 puede incorporar nuevas cargas anuales sin sobrescribir el historial. La carga inicial usa anio_referencia = 2021.

### Clasificacion academica

7. AREA_CONOCIMIENTO
8. DENOMINACION_CARRERA
9. NIVEL_ESTUDIO
10. NIVEL_CARRERA

Relaciones:
- AREA_CONOCIMIENTO 1:N DENOMINACION_CARRERA
- NIVEL_ESTUDIO 1:N NIVEL_CARRERA

Dependencias comprobadas:
- NOMBRE_CARRERA -> AREA_CONOCIMIENTO
- NIVEL_CARRERA -> NIVEL_ESTUDIO

La separacion DENOMINACION_CARRERA resuelve una dependencia parcial que existia en el modelo anterior. El nombre de la carrera determina el area, pero no determina siempre el nivel de carrera.

### Catalogos de oferta

11. MODALIDAD
12. JORNADA

La fuente contiene 3 modalidades y 5 jornadas. Se modelan como catalogos controlados para impedir texto inconsistente en las ofertas.

### Carrera y oferta

13. CARRERA
14. OFERTA_ACADEMICA

Relaciones:
- DENOMINACION_CARRERA 1:N CARRERA
- NIVEL_CARRERA 1:N CARRERA
- CARRERA 1:N OFERTA_ACADEMICA
- INSTITUCION 1:N OFERTA_ACADEMICA
- COMUNA 1:N OFERTA_ACADEMICA
- MODALIDAD 1:N OFERTA_ACADEMICA
- JORNADA 1:N OFERTA_ACADEMICA

Hallazgo clave:
- NOMBRE CARRERA -> AREA CONOCIMIENTO se cumple.
- NOMBRE CARRERA -> NIVEL CARRERA NO se cumple en 6 nombres.

Por eso el nombre se almacena una sola vez en DENOMINACION_CARRERA y CARRERA representa la combinacion de una denominacion con un nivel concreto.

Clave candidata de CARRERA:

`(id_denominacion, id_nivel_carrera)`

La identidad de OFERTA_ACADEMICA se controla con:

`UNIQUE(id_institucion, id_carrera, id_comuna, id_modalidad, id_jornada)`

### Plan y costos

15. TIPO_PLAN
16. PLAN_OFERTA

Relaciones:
- TIPO_PLAN 1:N PLAN_OFERTA
- OFERTA_ACADEMICA 1:N PLAN_OFERTA

Se comprobaron 1.544 ofertas conceptuales y 1.634 combinaciones oferta + plan. Existen ofertas con multiples tipos de plan, duraciones y valores economicos, por lo que PLAN_OFERTA permanece separado de OFERTA_ACADEMICA.

### Ingreso

17. REQUISITO_INGRESO
18. VIA_INGRESO

La fuente contiene 5 requisitos de ingreso y 11 vias de ingreso. Ambos pueden variar entre matriculas de una misma oferta, por lo que se relacionan con MATRICULA_HISTORICA y no con OFERTA_ACADEMICA.

### Hecho historico

19. MATRICULA_HISTORICA

Relaciones:
- PLAN_OFERTA 1:N MATRICULA_HISTORICA
- REQUISITO_INGRESO 1:N MATRICULA_HISTORICA
- VIA_INGRESO 1:N MATRICULA_HISTORICA

Atributos principales:
- id_registro_fuente
- genero
- edad
- anio_ingreso
- semestre_ingreso

No se persiste RANGO_EDAD porque EDAD -> RANGO_EDAD se cumple y el rango puede derivarse cuando sea necesario.

## Tabla tecnica fuera del DER normalizado

### STAGING_MATRICULA

STAGING_MATRICULA no forma parte de las 19 tablas de negocio en 3FN. Es una tabla tecnica intencionalmente desnormalizada que recibe las 28 columnas de la fuente como texto para validar y transformar antes de cargar el modelo relacional.

Flujo:

`Excel -> STAGING_MATRICULA -> validacion -> ETL -> modelo Oracle normalizado`

## Tablas que deliberadamente no se crean

### ESTUDIANTE / MATRICULADO

No existe identificador persistente de persona en la fuente. Crear esta entidad produciria una separacion artificial 1:1 con el registro fuente.

### SEDE

La fuente entrega REGION SEDE, PROVINCIA SEDE y COMUNA SEDE, pero no entrega un identificador de sede, nombre de sede, direccion, latitud ni longitud. Para no inventar datos, la sede fisica queda fuera de esta entrega. Puede agregarse posteriormente mediante enriquecimiento con una fuente confiable para el modulo de mapas de EduBio 360.

### RANGO_EDAD

Es un dato derivable desde EDAD y no se almacena para evitar redundancia.

## Conteos reales que respaldan el modelo

- Registros: 106.555
- IDs fuente distintos: 106.555
- Tipos de institucion: 5
- Instituciones: 30
- Areas de conocimiento: 10
- Denominaciones de carrera: 824
- Combinaciones denominacion + nivel: 830
- Niveles de estudio: 3
- Niveles de carrera: 5
- Modalidades: 3
- Jornadas: 5
- Tipos de plan: 3
- Regiones: 1
- Provincias: 3
- Comunas: 9
- Requisitos de ingreso: 5
- Vias de ingreso: 11
- Ofertas conceptuales: 1.544
- Combinaciones oferta + plan: 1.634

## Cardinalidades finales

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

## Integracion con EduBio 360

La base no sera consumida directamente por el frontend. El flujo previsto es:

`Oracle normalizado -> Academic/Import/Analytics Service -> API -> EduBio 360`

## Regla de cierre

A partir de este documento el modelo se considera cerrado para la EP1, salvo que el profesor indique una correccion concreta o la ejecucion real en Oracle revele una inconsistencia demostrable. Los siguientes cambios deben concentrarse en ejecucion, carga, validaciones, PL/SQL, evidencias e informe, no en agregar tablas sin una necesidad sustentada.
