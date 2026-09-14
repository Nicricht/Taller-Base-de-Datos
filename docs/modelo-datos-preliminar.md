# Modelo de Datos Preliminar - EduBio 360

## Objetivo

Definir la base relacional Oracle que almacenará la información académica utilizada por EduBio 360 y que servirá como base para la evaluación de Taller de Base de Datos / PL/SQL.

La fuente actual es el archivo `11_MATRICULAS_ED_SUPERIOR_BIOBIO_2021.xlsx`, cuya hoja principal contiene 106.555 registros y 28 columnas.

## Grano de la fuente

Cada fila del Excel representa un registro histórico de matrícula asociado a una carrera/oferta académica. El archivo no entrega un identificador persistente de persona, por lo que no se crea una entidad ESTUDIANTE artificial.

## Entidades preliminares

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

## Relaciones propuestas

- REGION 1:N PROVINCIA
- PROVINCIA 1:N COMUNA
- TIPO_INSTITUCION 1:N INSTITUCION
- INSTITUCION 1:N ACREDITACION_INSTITUCION
- NIVEL_ESTUDIO 1:N NIVEL_CARRERA
- INSTITUCION 1:N OFERTA_ACADEMICA
- CARRERA 1:N OFERTA_ACADEMICA
- COMUNA 1:N OFERTA_ACADEMICA
- AREA_CONOCIMIENTO 1:N OFERTA_ACADEMICA
- NIVEL_CARRERA 1:N OFERTA_ACADEMICA
- OFERTA_ACADEMICA 1:N PLAN_OFERTA
- PLAN_OFERTA 1:N MATRICULA_HISTORICA

## Dependencias funcionales a demostrar

- COMUNA -> PROVINCIA
- PROVINCIA -> REGION
- NOMBRE_INSTITUCION -> TIPO_INSTITUCION
- NIVEL_CARRERA -> NIVEL_ESTUDIO

Estas dependencias se deben validar contra el dataset antes de declarar el modelo definitivo en 3FN.

## Decisiones importantes

### CARRERA vs OFERTA_ACADEMICA

CARRERA representa la identidad académica del programa. OFERTA_ACADEMICA representa esa carrera ofrecida por una institución, en una comuna, modalidad y jornada determinadas.

### OFERTA_ACADEMICA vs PLAN_OFERTA

PLAN_OFERTA concentra los atributos que pueden variar para una oferta, como tipo de plan, duración, matrícula y arancel. Esta separación debe validarse definitivamente con el profesor y los datos.

### MATRICULA_HISTORICA

Representa el hecho histórico proveniente del Excel. Conserva `id_registro_fuente`, género, edad, año de ingreso y semestre de ingreso, además de la referencia al plan/oferta correspondiente.

### ACREDITACION_INSTITUCION

Se modela separada de INSTITUCION para permitir conservar cambios históricos de acreditación en futuras cargas. Esta es una decisión de diseño que debe validarse con el profesor.

## Alcance para hoy

1. Validar entidades y cardinalidades.
2. Demostrar dependencias funcionales principales.
3. Justificar 1FN, 2FN y 3FN.
4. Cerrar el modelo definitivo.
5. Convertirlo a DDL Oracle.
6. Crear constraints.
7. Preparar staging y ETL.
8. Cargar una muestra y luego más de 1.000 registros.
9. Ejecutar validaciones de conteos, huérfanos, negativos y duplicados.

## Integración con EduBio 360

Este repositorio contiene la capa de persistencia académica. La aplicación EduBio 360 deberá consumir estos datos mediante servicios backend/API. El frontend no debe conectarse directamente a Oracle.
