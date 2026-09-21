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
