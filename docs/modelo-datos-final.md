# Modelo de Datos Final - Taller Base de Datos / EduBio 360

## Objetivo

Construir una base Oracle relacional, normalizada y trazable para almacenar la informacion academica que sera consumida por EduBio 360 mediante servicios backend/API.

La fuente analizada contiene 106.555 registros y 28 columnas. Las decisiones del modelo se basan en dependencias funcionales y cardinalidades comprobadas sobre la fuente real.

## Grano de la fuente

Cada fila representa un registro historico de matricula asociado a una oferta/plan academico. El archivo no contiene un identificador persistente de persona, por lo que no se crea una entidad ESTUDIANTE artificial.

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

La fuente actual contiene un snapshot de acreditacion por institucion. Se mantiene una tabla separada porque EduBio 360 puede incorporar nuevas cargas anuales sin sobrescribir el historial. La carga inicial usara anio_referencia = 2021.

### Clasificacion academica

7. AREA_CONOCIMIENTO
8. NIVEL_ESTUDIO
9. NIVEL_CARRERA

Relaciones:
- NIVEL_ESTUDIO 1:N NIVEL_CARRERA

Dependencia comprobada:
- NIVEL_CARRERA -> NIVEL_ESTUDIO

### Catalogos de oferta

10. MODALIDAD
11. JORNADA

La fuente contiene 3 modalidades y 5 jornadas. Se modelan como catalogos controlados para impedir texto inconsistente en las ofertas.

### Carrera y oferta

12. CARRERA
13. OFERTA_ACADEMICA

Relaciones:
- AREA_CONOCIMIENTO 1:N CARRERA
- NIVEL_CARRERA 1:N CARRERA
- CARRERA 1:N OFERTA_ACADEMICA
- INSTITUCION 1:N OFERTA_ACADEMICA
- COMUNA 1:N OFERTA_ACADEMICA
- MODALIDAD 1:N OFERTA_ACADEMICA
- JORNADA 1:N OFERTA_ACADEMICA

Hallazgo clave:
- NOMBRE CARRERA -> AREA CONOCIMIENTO se cumple.
- NOMBRE CARRERA -> NIVEL CARRERA NO se cumple en 6 nombres.

Por lo tanto, CARRERA no usa solamente el nombre como identidad logica. Se aplica UNIQUE(nombre, id_nivel_carrera).

La identidad de OFERTA_ACADEMICA se controla con UNIQUE(id_institucion, id_carrera, id_comuna, id_modalidad, id_jornada).

### Plan y costos

14. TIPO_PLAN
15. PLAN_OFERTA

Relaciones:
- TIPO_PLAN 1:N PLAN_OFERTA
- OFERTA_ACADEMICA 1:N PLAN_OFERTA

Se comprobaron 1.544 ofertas conceptuales y 1.634 combinaciones oferta + plan. Existen ofertas con multiples tipos de plan, duraciones y valores economicos, por lo que PLAN_OFERTA permanece separado de OFERTA_ACADEMICA.

### Ingreso

16. REQUISITO_INGRESO
17. VIA_INGRESO

La fuente contiene 5 requisitos de ingreso y 11 vias de ingreso. Ambos pueden variar entre matriculas de una misma oferta, por lo que se relacionan con MATRICULA_HISTORICA y no con OFERTA_ACADEMICA.

### Hecho historico

18. MATRICULA_HISTORICA

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

### Tabla tecnica

19. STAGING_MATRICULA

No es una entidad normalizada de negocio. Recibe la carga cruda del archivo y permite validar y transformar antes de insertar en las tablas finales.

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
- Nombres de carrera: 824
- Combinaciones nombre carrera + nivel: 830
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

## Integracion con EduBio 360

La base no sera consumida directamente por el frontend. El flujo previsto es:

Excel fuente -> STAGING_MATRICULA -> ETL -> Oracle normalizado -> Academic/Import/Analytics Service -> API -> EduBio 360

## Regla de cierre

A partir de este documento el modelo se considera cerrado para la EP1, salvo que el profesor indique una correccion concreta. Los siguientes cambios deben concentrarse en DDL, carga, validaciones, PL/SQL, evidencias e informe, no en agregar tablas sin una necesidad demostrable.
