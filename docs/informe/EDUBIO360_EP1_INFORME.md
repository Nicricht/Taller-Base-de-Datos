# EDUBIO360

## Evaluación Parcial N° 1
**Asignatura:** Taller de Base de Datos - BDY1103  
**Proyecto:** EDUBIO360  
**Integrantes:** [Completar nombres]  
**Docente:** Cristian Vega  
**Fecha de entrega:** 22 de septiembre de 2026  

---

# 1. Introducción

## 1.1 Descripción del proyecto

EDUBIO360 es un proyecto que busca organizar información de educación superior para que después pueda ser consultada de una forma más clara dentro del sistema. La información utilizada proviene de un archivo de matrículas de educación superior de la Región del Biobío, el cual contiene datos de instituciones, carreras, modalidades, jornadas, comunas, valores de matrícula, aranceles y otros datos relacionados.

El archivo original contiene 106.555 registros y 28 columnas. Como la información viene en una estructura plana, varios datos se repiten muchas veces. Por esta razón, para la asignatura de Taller de Base de Datos se trabajó en organizar esos datos en una base de datos relacional Oracle.

La idea principal es que la base de datos permita almacenar la información de manera ordenada y que después pueda ser utilizada por EDUBIO360 para realizar consultas sobre carreras, instituciones y ofertas académicas. También se utilizará PL/SQL para procesar información y resolver necesidades relacionadas con los datos, utilizando elementos vistos en clases como RECORD, VARRAY, cursores, loops y manejo de excepciones.

## 1.2 Alcance

En esta evaluación el trabajo se concentra solamente en la parte de base de datos de EDUBIO360. Esto significa que no se desarrolla el frontend ni la interfaz completa del sistema dentro de este informe.

El alcance considera la creación y organización del modelo de datos en Oracle, la normalización de las tablas, las relaciones mediante claves primarias y foráneas, la carga de los datos provenientes del archivo original y el uso de PL/SQL para procesar información.

La base de datos funciona como la capa donde se almacena la información académica. Más adelante, otros componentes del proyecto pueden consultar estos datos mediante servicios o una API, pero el frontend no accede directamente a Oracle.

El flujo general utilizado en esta parte del proyecto es:

```text
Archivo Excel / CSV
        ↓
STAGING_MATRICULA
        ↓
Validación de datos
        ↓
Proceso ETL
        ↓
Base de datos Oracle normalizada
        ↓
Consultas SQL y bloques PL/SQL
```

## 1.3 Tecnologías utilizadas

Para desarrollar esta parte de EDUBIO360 se utilizaron las siguientes tecnologías y herramientas:

- **Oracle Database:** se utiliza como motor principal de la base de datos.
- **SQL:** se utiliza para crear tablas, restricciones, relaciones y realizar consultas.
- **PL/SQL:** se utiliza para trabajar con lógica dentro de Oracle, utilizando RECORD, VARRAY, cursores, loops y excepciones.
- **SQL Developer:** se utiliza para ejecutar y revisar los scripts de la base de datos.
- **SQL*Loader:** se considera para realizar la carga de los datos desde un archivo CSV hacia la tabla de staging.
- **Excel / CSV:** corresponde al formato de origen de los datos utilizados en el proyecto.
- **GitHub:** se utiliza para mantener los scripts, documentación y avances del proyecto versionados.

Estas herramientas permiten que el proceso pueda repetirse y revisarse desde la carga inicial de los datos hasta las consultas y ejercicios PL/SQL desarrollados para la evaluación.

# 2. Contexto de negocio y datos a procesar

## 2.1 Contexto de negocio

EDUBIO360 nace a partir de la necesidad de ordenar información académica que se encuentra distribuida en un archivo con una gran cantidad de registros. Para una persona que quiere revisar opciones de educación superior, no basta con conocer solamente el nombre de una carrera, ya que también necesita saber qué institución la imparte, en qué comuna se encuentra, cuál es la modalidad, la jornada y cuánto cuesta estudiar esa alternativa.

El problema es que en el archivo original estos datos vienen todos juntos en una misma estructura. Eso provoca que información como el nombre de una institución, una comuna o una carrera se repita muchas veces. Si se trabajara directamente con ese archivo para todas las consultas, sería más difícil mantener la información ordenada y controlar posibles inconsistencias.

Por esta razón, en EDUBIO360 se decidió organizar los datos en distintas tablas relacionadas. De esta forma, la información puede ser consultada de manera más clara y también se puede reutilizar para generar comparaciones entre distintas ofertas académicas.

## 2.2 Datos que se procesan

La fuente utilizada contiene 106.555 registros y 28 columnas. Entre los principales datos que se procesan se encuentran:

- tipo y nombre de la institución;
- carrera y área de conocimiento;
- nivel de estudio y nivel de carrera;
- modalidad y jornada;
- región, provincia y comuna;
- tipo y duración del plan de estudio;
- valor de matrícula y valor de arancel;
- requisito y vía de ingreso;
- género, edad, año y semestre de ingreso;
- información de acreditación institucional.

Antes de llevar estos datos al modelo final, se cargan en la tabla `STAGING_MATRICULA`. Esta tabla mantiene la estructura original de la fuente y permite revisar los datos antes de separarlos en las tablas normalizadas.

## 2.3 Información que se necesita generar

A partir de los datos almacenados se busca generar información que pueda ser útil dentro de EDUBIO360. Algunos ejemplos son consultar las carreras disponibles, conocer qué instituciones ofrecen una determinada carrera, revisar ofertas por área de conocimiento y comparar valores de matrícula y arancel.

También se necesita obtener información agrupada para poder recorrer varias ofertas y mostrar resultados mediante PL/SQL. Por ejemplo, se pueden listar ofertas pertenecientes a una determinada área de conocimiento o recuperar un grupo reducido de alternativas con sus respectivos aranceles.

Estas necesidades son las que justifican el uso de los elementos que se trabajan en la evaluación. RECORD permite reunir varios datos relacionados de una oferta, VARRAY permite manejar una cantidad limitada de resultados, los cursores permiten recorrer varias filas y las excepciones permiten controlar situaciones que podrían producir errores durante el procesamiento.
