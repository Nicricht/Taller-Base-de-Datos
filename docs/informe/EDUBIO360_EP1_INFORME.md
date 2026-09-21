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

# 3. Modelo de base de datos

## 3.1 Modelo relacional

El modelo final de EDUBIO360 está formado por 19 tablas de negocio relacionadas entre sí. Además existe la tabla técnica `STAGING_MATRICULA`, que se utiliza solamente para recibir los datos originales antes de validarlos y transformarlos.

Las tablas principales se pueden agrupar de la siguiente forma:

- **Territorio:** REGION, PROVINCIA y COMUNA.
- **Instituciones:** TIPO_INSTITUCION, INSTITUCION y ACREDITACION_INSTITUCION.
- **Clasificación académica:** AREA_CONOCIMIENTO, DENOMINACION_CARRERA, NIVEL_ESTUDIO y NIVEL_CARRERA.
- **Oferta académica:** MODALIDAD, JORNADA, CARRERA y OFERTA_ACADEMICA.
- **Planes y costos:** TIPO_PLAN y PLAN_OFERTA.
- **Ingreso:** REQUISITO_INGRESO y VIA_INGRESO.
- **Información histórica:** MATRICULA_HISTORICA.

Cada tabla representa un concepto específico. Por ejemplo, `CARRERA` representa una denominación asociada a un nivel académico, mientras que `OFERTA_ACADEMICA` representa dónde y cómo se ofrece esa carrera. Esta separación evita guardar todos los datos repetidos en una sola tabla.

## 3.2 Relaciones principales

La mayoría de las relaciones del modelo son de uno a muchos. Esto significa que un registro de una tabla puede estar relacionado con varios registros de otra tabla.

Algunos ejemplos del modelo son:

```text
REGION 1:N PROVINCIA
PROVINCIA 1:N COMUNA

TIPO_INSTITUCION 1:N INSTITUCION
INSTITUCION 1:N ACREDITACION_INSTITUCION

AREA_CONOCIMIENTO 1:N DENOMINACION_CARRERA
NIVEL_ESTUDIO 1:N NIVEL_CARRERA

DENOMINACION_CARRERA 1:N CARRERA
NIVEL_CARRERA 1:N CARRERA

CARRERA 1:N OFERTA_ACADEMICA
INSTITUCION 1:N OFERTA_ACADEMICA
COMUNA 1:N OFERTA_ACADEMICA
MODALIDAD 1:N OFERTA_ACADEMICA
JORNADA 1:N OFERTA_ACADEMICA

OFERTA_ACADEMICA 1:N PLAN_OFERTA
TIPO_PLAN 1:N PLAN_OFERTA

PLAN_OFERTA 1:N MATRICULA_HISTORICA
REQUISITO_INGRESO 1:N MATRICULA_HISTORICA
VIA_INGRESO 1:N MATRICULA_HISTORICA
```

Estas relaciones se controlan mediante claves primarias y claves foráneas. También se utilizan restricciones `UNIQUE` para evitar duplicados donde corresponde.

Un ejemplo importante es `OFERTA_ACADEMICA`. Una oferta queda identificada por la combinación de institución, carrera, comuna, modalidad y jornada. De esta forma se evita registrar dos veces exactamente la misma oferta.

## 3.3 Normalización

La fuente original tiene 106.555 filas y 28 columnas en una estructura plana. En esa estructura se repiten datos como institución, comuna, provincia, región, carrera y nivel. Para ordenar la información se aplicó normalización hasta Tercera Forma Normal.

### Primera Forma Normal (1FN)

La Primera Forma Normal busca que cada columna tenga un valor único y que cada fila pueda identificarse.

En el modelo de EDUBIO360 cada tabla tiene una clave primaria y no se guardan listas dentro de una sola columna. Por ejemplo, las vías de ingreso no se guardan juntas en un texto, sino que cada vía se almacena como un registro de `VIA_INGRESO` y luego se referencia desde `MATRICULA_HISTORICA`.

### Segunda Forma Normal (2FN)

Durante el análisis apareció un problema con la carrera. En un modelo anterior se pensaba guardar en una misma tabla el nombre de la carrera, el nivel y el área de conocimiento.

Sin embargo, al revisar los datos se comprobó que el nombre de la carrera determina el área de conocimiento, pero no siempre determina el nivel de carrera. Se encontraron nombres de carrera que aparecen asociados a más de un nivel.

Por eso se separaron dos conceptos:

```text
DENOMINACION_CARRERA
- id_denominacion
- id_area
- nombre

CARRERA
- id_carrera
- id_denominacion
- id_nivel_carrera
```

Con esta separación, `DENOMINACION_CARRERA` guarda el nombre y su área, mientras que `CARRERA` representa la combinación entre esa denominación y un nivel específico. Esto evita que el área dependa solamente de una parte de la clave candidata de carrera.

## 3.4 Tercera Forma Normal (3FN)

Para llegar a 3FN también fue necesario eliminar dependencias transitivas. Un ejemplo claro está en los datos territoriales.

En el archivo original se cumple:

```text
COMUNA -> PROVINCIA -> REGION
```

Si provincia y región se guardaran repetidas cada vez que aparece una comuna, existiría información duplicada. Por eso el modelo utiliza:

```text
REGION
   ↓
PROVINCIA
   ↓
COMUNA
```

Otro caso es el nivel académico:

```text
NIVEL_CARRERA -> NIVEL_ESTUDIO
```

Por esta razón, `NIVEL_ESTUDIO` se almacena en su propia tabla y `NIVEL_CARRERA` lo referencia mediante una clave foránea.

También se comprobó:

```text
NOMBRE_CARRERA -> AREA_CONOCIMIENTO
```

pero no se cumple siempre:

```text
NOMBRE_CARRERA -> NIVEL_CARRERA
```

Esta diferencia fue una de las razones principales para separar `DENOMINACION_CARRERA` de `CARRERA`.

Otro dato que no se almacena directamente es el rango de edad. Como el rango puede obtenerse a partir de la edad, se puede calcular cuando sea necesario y así no se guarda información derivada de forma repetida.

Finalmente, `OFERTA_ACADEMICA` y `PLAN_OFERTA` están separadas porque una misma oferta puede presentar diferentes tipos de plan, duraciones o valores. La oferta identifica la carrera, institución, ubicación, modalidad y jornada, mientras que el plan guarda las características y costos que pueden variar.

## 3.5 Tabla de staging

`STAGING_MATRICULA` no se considera parte de las 19 tablas normalizadas. Su función es recibir las 28 columnas del archivo original como una etapa temporal de carga.

El flujo es:

```text
Archivo original
      ↓
STAGING_MATRICULA
      ↓
Validaciones
      ↓
Transformación
      ↓
Tablas normalizadas
```

Por esta razón, la tabla de staging puede conservar datos repetidos. Su objetivo no es cumplir 3FN, sino servir como punto intermedio para revisar y transformar la información antes de llevarla al modelo final.
