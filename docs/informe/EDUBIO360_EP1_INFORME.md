# EDUBIO360

## Evaluación Parcial N° 1
**Asignatura:** Taller de Base de Datos - BDY1103  
**Proyecto:** EDUBIO360  
**Integrantes:** Javier Pérez y Nicolás Vega  
**Docente:** Cristian Vega  
**Fecha de entrega:** 22 de septiembre de 2026  

---

# 1. Introducción

## 1.1 Descripción del proyecto

EDUBIO360 es un proyecto que busca ordenar información de educación superior para que una persona pueda revisar y comparar alternativas de estudio de una forma más clara. Para desarrollar el proyecto se utiliza un archivo de matrículas de educación superior de la Región del Biobío. Ese archivo contiene información de instituciones, carreras, comunas, modalidades, jornadas, valores de matrícula, aranceles y otros datos relacionados con cada oferta académica.

El archivo original contiene 106.555 registros y 28 columnas. El problema es que todos esos datos vienen juntos en una estructura plana. Esto significa que en una misma tabla se repiten muchas veces nombres de instituciones, carreras, comunas y otros valores. Por esta razón, la información se separa en tablas relacionadas dentro de Oracle.

La idea principal es que la información no dependa siempre del archivo original. Una vez organizada en Oracle, es posible consultar, por ejemplo, qué institución imparte una carrera, dónde se ofrece y cuánto cuesta. También se utiliza PL/SQL para realizar procesos sobre esos datos mediante RECORD, VARRAY, cursores, loops y excepciones. Cada uno de estos elementos se relaciona con necesidades concretas de procesamiento dentro de EDUBIO360.

## 1.2 Alcance

El trabajo se concentra en la capa de base de datos de EDUBIO360. La interfaz completa del sistema queda fuera del alcance de este informe. El objetivo es organizar la información académica en Oracle y establecer una base estructurada para su procesamiento mediante SQL y PL/SQL.

El alcance incluye el modelo de datos en Oracle, la normalización, las claves primarias y foráneas, la carga de los datos y los bloques PL/SQL. Primero la información original se recibe en una tabla de staging, que funciona como una zona temporal. Desde ahí los datos se revisan y se transforman antes de llevarlos a las tablas finales.

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

Estas herramientas permiten mantener un flujo reproducible desde la carga inicial de los datos hasta las consultas y bloques PL/SQL utilizados para procesar la información.

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

Estas necesidades de procesamiento se resuelven con distintos elementos de PL/SQL. RECORD permite reunir varios datos relacionados de una oferta en una sola estructura, VARRAY permite manejar una cantidad limitada de resultados, los cursores permiten recorrer conjuntos de filas y las excepciones permiten controlar situaciones que podrían producir errores durante el procesamiento.

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


# 4. Tipos de datos compuestos

EDUBIO360 utiliza los tipos compuestos RECORD y VARRAY dentro de bloques PL/SQL anónimos para organizar y procesar información académica. Ambos se aplican sobre datos reales del proyecto y cumplen funciones distintas dentro del procesamiento.

Los scripts utilizados para esta sección son:

- `plsql/01_record.sql`
- `plsql/02_varray.sql`

## 4.1 RECORD

Un RECORD permite guardar varios datos diferentes dentro de una sola variable. En EDUBIO360 se utiliza para representar una oferta académica completa. En vez de trabajar con una variable para la carrera, otra para la institución, otra para la comuna y así sucesivamente, todos esos datos se agrupan dentro de `v_oferta`. De esta forma queda más claro que pertenecen a la misma oferta.

El tipo creado en el bloque PL/SQL es:

```sql
TYPE t_oferta IS RECORD (
    nombre_carrera      DENOMINACION_CARRERA.nombre%TYPE,
    nombre_nivel        NIVEL_CARRERA.nombre%TYPE,
    nombre_institucion  INSTITUCION.nombre%TYPE,
    nombre_comuna       COMUNA.nombre%TYPE,
    nombre_modalidad    MODALIDAD.nombre%TYPE,
    nombre_jornada      JORNADA.nombre%TYPE,
    valor_matricula PLAN_OFERTA.valor_matricula%TYPE,
    valor_arancel   PLAN_OFERTA.valor_arancel%TYPE
);
```

Luego se declara una variable de ese tipo:

```sql
v_oferta t_oferta;
```

La consulta obtiene los datos desde varias tablas relacionadas y los guarda dentro del mismo RECORD mediante `SELECT INTO`.

En este caso el RECORD contiene:

- nombre de la carrera;
- nivel de la carrera;
- institución;
- comuna;
- modalidad;
- jornada;
- valor de matrícula;
- valor de arancel.

Para realizar la búsqueda se utiliza un identificador de oferta:

```sql
v_id_oferta OFERTA_ACADEMICA.id_oferta%TYPE := 1;
```

Después, el bloque consulta las tablas relacionadas y guarda el resultado dentro de `v_oferta`.

Un fragmento de esa parte es:

```sql
SELECT
    dc.nombre,
    nc.nombre,
    i.nombre,
    co.nombre,
    m.nombre,
    j.nombre,
    po.valor_matricula,
    po.valor_arancel
INTO
    v_oferta.nombre_carrera,
    v_oferta.nombre_nivel,
    v_oferta.nombre_institucion,
    v_oferta.nombre_comuna,
    v_oferta.nombre_modalidad,
    v_oferta.nombre_jornada,
    v_oferta.valor_matricula,
    v_oferta.valor_arancel
...
WHERE o.id_oferta = v_id_oferta
  AND ROWNUM = 1;
```

Finalmente, los datos se muestran utilizando `DBMS_OUTPUT.PUT_LINE`.

En EDUBIO360 esto es útil porque una oferta no se entiende solamente por el nombre de la carrera. Para mostrar una alternativa académica también se necesita saber qué institución la ofrece, dónde se encuentra, la modalidad, la jornada y sus valores. El RECORD permite tratar esos datos relacionados como una sola estructura en vez de trabajar con muchas variables separadas.

También se utiliza `%TYPE`. Con esto no se escribe manualmente el tipo de dato de cada campo, sino que se indica a Oracle que use el mismo tipo que tiene la columna original. Por ejemplo, `nombre_carrera` toma el tipo de `DENOMINACION_CARRERA.nombre`. Esto ayuda a mantener el bloque relacionado con la estructura real de la base.

## 4.2 VARRAY

El segundo tipo compuesto utilizado es VARRAY. Un VARRAY funciona como una lista con un límite máximo definido. En EDUBIO360 se configuró con capacidad para cinco ofertas, ya que el procesamiento requiere conservar un grupo pequeño y controlado de alternativas antes de recorrerlas.

El script declara dos arreglos con capacidad máxima de cinco elementos:

```sql
TYPE t_nombres IS VARRAY(5) OF VARCHAR2(400);
TYPE t_aranceles IS VARRAY(5) OF NUMBER;
```

Luego se crean las variables:

```sql
v_nombres t_nombres;
v_aranceles t_aranceles;
```

La consulta obtiene cinco ofertas junto con sus aranceles. Se utiliza `BULK COLLECT` para cargar varias filas de la consulta de una sola vez dentro de los VARRAY. Después esas posiciones se recorren con un LOOP para mostrar cada alternativa:

```sql
SELECT nombre_oferta, valor_arancel
BULK COLLECT INTO v_nombres, v_aranceles
FROM (
    SELECT
        dc.nombre || ' (' || nc.nombre || ') - ' || i.nombre AS nombre_oferta,
        po.valor_arancel
    FROM OFERTA_ACADEMICA o
    JOIN CARRERA c ON c.id_carrera = o.id_carrera
    JOIN DENOMINACION_CARRERA dc ON dc.id_denominacion = c.id_denominacion
    JOIN NIVEL_CARRERA nc ON nc.id_nivel_carrera = c.id_nivel_carrera
    JOIN INSTITUCION i ON i.id_institucion = o.id_institucion
    JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
    WHERE po.valor_arancel > 0
    ORDER BY po.valor_arancel ASC
)
WHERE ROWNUM <= 5;
```

Después se recorren los elementos con un LOOP:

```sql
FOR i IN 1 .. v_nombres.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(
        i || '. ' || v_nombres(i) ||
        ' | Arancel: $' || v_aranceles(i)
    );
END LOOP;
```

El VARRAY resulta adecuado porque la cantidad de resultados que se desea conservar está previamente limitada a cinco. El bloque mantiene los nombres de las ofertas y sus aranceles en posiciones relacionadas para después recorrerlos y mostrarlos.

Esta estructura responde a una necesidad concreta de EDUBIO360: trabajar con un conjunto reducido de alternativas que puedan revisarse o compararse. La consulta selecciona las cinco ofertas con menor arancel positivo y excluye valores iguales a cero para que la comparación considere costos informados.

## 4.3 Aporte de RECORD y VARRAY al proyecto

Los dos tipos compuestos resuelven necesidades distintas.

En palabras simples, RECORD se utiliza cuando se necesita reunir varios datos distintos de una sola oferta académica.

VARRAY se utiliza cuando se necesita guardar una lista de tamaño limitado, en este caso cinco alternativas, para después recorrerla dentro del bloque PL/SQL.

En este proyecto también aportan a la eficiencia del procesamiento, pero cada uno de una forma distinta. Con RECORD se pueden manejar todos los datos de una oferta mediante una sola variable estructurada, en vez de crear y controlar muchas variables independientes. Esto hace que el bloque sea más claro y reduce la posibilidad de confundir datos que pertenecen a ofertas diferentes.

Con VARRAY se pueden guardar varios valores relacionados dentro de una colección con un límite conocido. El bloque utiliza `BULK COLLECT` para traer varias filas de la consulta en una sola operación y almacenarlas directamente en las colecciones. Después, esos resultados se recorren con un LOOP. Para EDUBIO360 esto resulta útil cuando se necesita trabajar con un grupo pequeño y controlado de alternativas, como las cinco ofertas seleccionadas por la consulta.

Los bloques fueron ejecutados y verificados en Oracle SQL Developer. Las evidencias obtenidas se almacenan en `docs/evidencias/ejecucion-oracle/` junto con el resto del proyecto.


# 5. Cursores y loops

El procesamiento de ofertas por área se implementa en `plsql/03_cursor_loops.sql` mediante un cursor explícito sin parámetros, un cursor explícito con parámetro y loops anidados. Esta combinación permite recorrer las áreas de conocimiento y consultar, dentro de cada una, sus ofertas académicas.

## 5.1 Qué es un cursor explícito

Un cursor explícito sirve cuando una consulta devuelve varias filas y se necesita trabajarlas una por una. La diferencia con `SELECT INTO` es que `SELECT INTO` se usa normalmente cuando se espera una sola fila. Con un cursor es posible recorrer cada resultado y ejecutar una acción para cada uno.

En EDUBIO360 esto es útil porque muchas consultas no entregan un solo resultado. Por ejemplo, un área de conocimiento puede tener varias carreras y cada carrera puede tener distintas ofertas académicas.

## 5.2 Cursor sin parámetros

El cursor `c_areas` obtiene las áreas de conocimiento registradas:

```sql
CURSOR c_areas IS
    SELECT id_area, nombre
    FROM AREA_CONOCIMIENTO
    ORDER BY nombre;
```

Este cursor no recibe ningún parámetro. Siempre ejecuta la misma consulta y obtiene las áreas de conocimiento existentes en la tabla `AREA_CONOCIMIENTO`.

`c_areas` corresponde al caso más simple porque la consulta no cambia según un valor externo. En cambio, `c_ofertas_por_area` recibe `p_id_area`, utiliza ese valor dentro del `WHERE` y se ejecuta con un área distinta durante el recorrido. De esta manera, una sola definición de cursor sirve para Salud, Tecnología, Educación y las demás áreas, sin tener que escribir una consulta diferente para cada una.

Después se recorre con:

```sql
FOR a IN c_areas LOOP
    DBMS_OUTPUT.PUT_LINE(
        a.id_area || ' - ' || a.nombre
    );
END LOOP;
```

El cursor mantiene una consulta definida sobre `AREA_CONOCIMIENTO` y el LOOP permite recorrer todos los registros obtenidos. Al no recibir parámetros, su conjunto de resultados depende únicamente de la consulta declarada.

## 5.3 Cursor explícito con parámetro

El segundo cursor recibe un parámetro. Ese parámetro es el identificador del área que se desea consultar. Gracias a esto, el mismo cursor puede reutilizarse para Salud, Tecnología, Educación u otra área, sin escribir una consulta distinta para cada caso:

```sql
CURSOR c_ofertas_por_area (
    p_id_area AREA_CONOCIMIENTO.id_area%TYPE
) IS
    SELECT
        dc.nombre AS carrera,
        nc.nombre AS nivel_carrera,
        i.nombre AS institucion,
        po.valor_arancel
    FROM DENOMINACION_CARRERA dc
    JOIN CARRERA c
        ON c.id_denominacion = dc.id_denominacion
    JOIN NIVEL_CARRERA nc
        ON nc.id_nivel_carrera = c.id_nivel_carrera
    JOIN OFERTA_ACADEMICA o
        ON o.id_carrera = c.id_carrera
    JOIN INSTITUCION i
        ON i.id_institucion = o.id_institucion
    JOIN PLAN_OFERTA po
        ON po.id_oferta = o.id_oferta
    WHERE dc.id_area = p_id_area
    ORDER BY dc.nombre, nc.nombre, i.nombre;
```

El parámetro `p_id_area` permite ejecutar el mismo cursor para distintas áreas. En vez de crear una consulta distinta para cada área, el identificador se entrega cuando se llama al cursor.

También se utiliza `%TYPE`:

```sql
p_id_area AREA_CONOCIMIENTO.id_area%TYPE
```

De esta forma el parámetro utiliza el mismo tipo de dato que la columna `id_area` de la tabla.

La diferencia principal entre los dos cursores utilizados es que `c_areas` siempre ejecuta la misma consulta, mientras que `c_ofertas_por_area` cambia los resultados según el identificador de área que recibe.

## 5.4 Loops anidados

El bloque utiliza más de un LOOP de forma simultánea.

En `plsql/03b_cursores_estilo_clase.sql` ambos cursores se declaran dentro del mismo bloque. `c_areas` funciona como cursor principal y `c_ofertas_por_area(p_id_area)` como cursor dependiente de cada área recorrida.

El recorrido exterior utiliza directamente el cursor principal:

```sql
FOR a IN c_areas LOOP
```

Dentro de ese recorrido se utiliza el cursor parametrizado:

```sql
FOR o IN c_ofertas_por_area(a.id_area) LOOP
```

El valor `a.id_area` del LOOP exterior se envía como parámetro al cursor del LOOP interior.

El funcionamiento puede representarse así:

```text
Área 1
  ├─ Oferta 1
  ├─ Oferta 2
  ├─ Oferta 3
  └─ ...

Área 2
  ├─ Oferta 1
  ├─ Oferta 2
  └─ ...

Área 3
  └─ ...
```

Dentro de cada área se muestran hasta cinco ofertas. Para controlar esa cantidad se utiliza `v_contador` y:

```sql
EXIT WHEN v_contador = 5;
```

Si un área no tiene resultados, el bloque muestra:

```sql
IF v_contador = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Sin ofertas para esta area.');
END IF;
```

## 5.5 Aplicación al proyecto

Este bloque resuelve una necesidad concreta de EDUBIO360: organizar ofertas académicas según su área de conocimiento.

La consulta no obtiene los datos desde una sola tabla. Para formar cada resultado necesita relacionar `DENOMINACION_CARRERA`, `CARRERA`, `NIVEL_CARRERA`, `OFERTA_ACADEMICA`, `INSTITUCION` y `PLAN_OFERTA`.

De esta forma se puede mostrar información como:

```text
Área
  Carrera
  Nivel
  Institución
  Arancel
```

El cursor con parámetro permite reutilizar la misma lógica para cualquier área existente y los loops anidados permiten mantener una salida ordenada por grupo.

## 5.6 Ventajas y consideración de uso

En este caso los cursores son útiles porque se necesita recorrer varias filas y ejecutar una lógica por cada resultado. También permiten controlar cuántas ofertas se muestran por área y mantener separado el recorrido de las áreas del recorrido de sus ofertas.

El cursor parametrizado evita repetir una consulta distinta para cada área y permite reutilizar el mismo bloque cambiando solamente el parámetro.

Para operaciones masivas simples, una consulta SQL directa puede ser más eficiente que procesar cada fila con un cursor. En EDUBIO360 el cursor se utiliza porque se necesita un procesamiento controlado y anidado de los resultados, con una relación directa entre cada área de conocimiento y sus respectivas ofertas.

El bloque fue ejecutado y verificado en Oracle SQL Developer. La evidencia correspondiente se encuentra en `docs/evidencias/ejecucion-oracle/03_cursores_loops.png`.


# 6. Control de excepciones

El control de excepciones de EDUBIO360 se encuentra en `plsql/04_excepciones.sql`. El script contempla dos excepciones predefinidas por Oracle (`NO_DATA_FOUND` y `TOO_MANY_ROWS`) y una excepción definida por el usuario para representar una regla propia del proyecto.

## 6.1 Excepciones predefinidas por Oracle

### 6.1.1 NO_DATA_FOUND

Oracle tiene excepciones que ya vienen definidas y que se producen cuando ocurre una situación conocida durante la ejecución de un bloque PL/SQL.

Para controlar una consulta sin resultados se utiliza:

```sql
NO_DATA_FOUND
```

El bloque busca una carrera utilizando un identificador que no existe:

```sql
v_id_carrera NUMBER := -999;
```

Después se ejecuta la consulta:

```sql
SELECT dc.nombre, nc.nombre
INTO v_nombre, v_nivel
FROM CARRERA c
JOIN DENOMINACION_CARRERA dc
    ON dc.id_denominacion = c.id_denominacion
JOIN NIVEL_CARRERA nc
    ON nc.id_nivel_carrera = c.id_nivel_carrera
WHERE c.id_carrera = v_id_carrera;
```

Como la consulta no encuentra ninguna fila, Oracle genera la excepción `NO_DATA_FOUND`.

La excepción se controla de esta forma:

```sql
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'NO_DATA_FOUND: no existe una carrera con el ID ' || v_id_carrera
        );
```

Con esto el bloque no termina mostrando solamente un error técnico de Oracle, sino que entrega un mensaje entendible indicando que la carrera buscada no existe.

En EDUBIO360 este tipo de excepción puede ser útil cuando se intenta consultar una carrera, institución u oferta mediante un identificador que no se encuentra en la base de datos.

### 6.1.2 TOO_MANY_ROWS

La segunda excepción predefinida utilizada es `TOO_MANY_ROWS`. Esta excepción se produce cuando una instrucción `SELECT INTO` espera obtener una sola fila, pero la consulta devuelve más de una.

Para representar una consulta que devuelve más filas de las esperadas se utiliza el área con identificador 1:

```sql
v_id_area AREA_CONOCIMIENTO.id_area%TYPE := 1;
```

Después se ejecuta una consulta que intenta guardar en una sola variable el nombre de una carrera perteneciente a esa área:

```sql
SELECT dc.nombre
INTO v_nombre
FROM DENOMINACION_CARRERA dc
WHERE dc.id_area = v_id_area;
```

Como el área contiene más de una carrera, la consulta devuelve varias filas y Oracle genera `TOO_MANY_ROWS`. El bloque controla esa situación de la siguiente forma:

```sql
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(
            'TOO_MANY_ROWS: el area ' || v_id_area ||
            ' contiene mas de una carrera.'
        );
```

Este caso permite mostrar una situación distinta a `NO_DATA_FOUND`: en una se obtiene cero filas y en la otra se obtienen más filas de las que `SELECT INTO` puede almacenar.

## 6.2 Excepción definida por el usuario

Para controlar una condición propia del negocio se declara una excepción dentro del bloque:

```sql
e_arancel_invalido EXCEPTION;
```

La condición se representa mediante un arancel negativo:

```sql
v_arancel NUMBER := -1;
```

Luego se revisa la condición:

```sql
IF v_arancel < 0 THEN
    RAISE e_arancel_invalido;
END IF;
```

Si se cumple la condición, la excepción se lanza utilizando `RAISE`.

Después se controla con:

```sql
EXCEPTION
    WHEN e_arancel_invalido THEN
        DBMS_OUTPUT.PUT_LINE(
            'EXCEPCION DE USUARIO: el arancel no puede ser negativo.'
        );
```

En este caso Oracle no puede determinar por sí solo que un arancel negativo representa un problema para EDUBIO360. Esa condición corresponde a una regla que debe controlarse dentro del procesamiento.

## 6.3 Diferencia entre ambos tipos de excepción

La diferencia principal es que una excepción predefinida ya forma parte de Oracle, mientras que una excepción definida por el usuario se crea para representar una condición específica que necesita ser controlada.

En EDUBIO360:

```text
NO_DATA_FOUND
→ Oracle detecta que una consulta no devolvió filas.

TOO_MANY_ROWS
→ Oracle detecta que SELECT INTO devolvió más de una fila cuando se esperaba solo una.

e_arancel_invalido
→ En EDUBIO360 se define que un arancel negativo no debe continuar como un valor válido.
```

Por lo tanto, las excepciones predefinidas se utilizan cuando Oracle ya reconoce el tipo de error. Las excepciones personalizadas se utilizan cuando se necesita controlar una situación propia de la lógica del proyecto.

## 6.4 Integración en EDUBIO360

Una excepción permite controlar lo que ocurre cuando un bloque encuentra un problema. En vez de dejar que el programa termine solamente con un mensaje técnico de Oracle, la situación puede detectarse y responderse de una forma más clara.

Por ejemplo, si se intenta consultar una oferta que ya no existe, se puede controlar `NO_DATA_FOUND` y entregar un mensaje claro. Si una consulta `SELECT INTO` devuelve varias filas cuando se esperaba solo una, se puede controlar `TOO_MANY_ROWS`.

También se pueden definir excepciones propias para validar reglas antes de continuar con una operación. En EDUBIO360, el control de un arancel negativo representa una validación propia de la lógica del sistema.

Esto ayuda a evitar que un bloque continúe trabajando con información inválida y permite identificar con mayor claridad qué problema ocurrió.

En una implementación posterior también se podrían controlar otras situaciones, como valores inválidos durante una carga o errores relacionados con reglas específicas de actualización de datos.

## 6.5 Aporte a la integridad de los datos

El control de excepciones no reemplaza restricciones como `CHECK`, `NOT NULL`, claves primarias o claves foráneas. Esas restricciones siguen siendo parte importante de la integridad de la base de datos.

Las excepciones sirven como una capa adicional dentro de la lógica PL/SQL. Permiten detectar un problema durante el procesamiento, detener o cambiar el flujo y entregar una respuesta más clara.

En EDUBIO360 se combinan las restricciones del modelo con el manejo de excepciones para evitar trabajar silenciosamente con datos incorrectos.

Los tres casos (`NO_DATA_FOUND`, `TOO_MANY_ROWS` y `e_arancel_invalido`) fueron ejecutados y verificados en Oracle SQL Developer. La salida real se encuentra documentada en `docs/evidencias/ejecucion-oracle/04_excepciones.txt` y también se guardaron capturas visuales individuales de cada ejecución.


# 7. Procedimientos, funciones, packages y triggers

Los procedimientos, funciones, packages y triggers representan alternativas para incorporar lógica reutilizable, cálculos, organización y automatización dentro de la base de datos. En EDUBIO360 su uso se plantea a partir de necesidades concretas del proyecto, considerando qué responsabilidad tendría cada objeto y en qué momento sería conveniente incorporarlo.

## 7.1 Procedimiento almacenado

Un procedimiento almacenado es un bloque PL/SQL que queda guardado en la base de datos y puede ejecutarse cada vez que se necesite realizar una tarea determinada.

Para EDUBIO360 se propone como uso futuro:

```text
pr_generar_reporte_ofertas(p_id_area)
```

La idea sería recibir un identificador de área y ejecutar una consulta que reúna las ofertas relacionadas con esa área.

Este procedimiento podría servir cuando el sistema necesite generar el mismo tipo de reporte varias veces sin repetir toda la lógica en distintos lugares.

Por ejemplo:

```text
Usuario solicita ofertas de un área
        ↓
Backend envía id_area
        ↓
pr_generar_reporte_ofertas
        ↓
Consulta información académica
        ↓
Genera el resultado
```

La principal ventaja sería reutilizar una misma operación y mantenerla centralizada.

Como posible limitación, si el procedimiento concentra demasiadas consultas o lógica, puede volverse difícil de mantener. Por eso se debería mantener una responsabilidad clara y evitar convertir un solo procedimiento en un bloque demasiado grande.

## 7.2 Función almacenada

Una función almacenada también queda guardada en Oracle, pero se diferencia porque devuelve un valor.

Para EDUBIO360 se propone:

```text
fn_clasificar_arancel(p_valor_arancel)
```

Su objetivo podría ser recibir un arancel y devolver una clasificación que después pueda utilizarse en comparaciones o reportes.

Por ejemplo:

```text
Arancel recibido
     ↓
fn_clasificar_arancel
     ↓
Clasificación
```

Dependiendo de las reglas que se definan más adelante, la función podría devolver valores como una categoría de costo.

La ventaja sería tener una sola regla de clasificación reutilizable. Si esa regla cambia, se podría modificar en un solo lugar.

Una limitación sería usar la función demasiadas veces sobre una gran cantidad de filas si su lógica fuera pesada, ya que podría afectar el rendimiento. Por eso su uso tendría que evaluarse según la consulta y el volumen de datos.

## 7.3 Package

Un Package permite agrupar elementos PL/SQL relacionados, como procedimientos, funciones, tipos y otras definiciones.

Para EDUBIO360 se propone como idea futura:

```text
pkg_academico
```

Dentro de ese paquete podrían quedar agrupadas operaciones relacionadas con la información académica.

Por ejemplo:

```text
PKG_ACADEMICO
│
├── pr_generar_reporte_ofertas
├── fn_clasificar_arancel
└── otras operaciones académicas
```

Esto ayudaría a mantener organizadas las funciones y procedimientos del mismo dominio en vez de tenerlos todos separados.

También podría facilitar el mantenimiento porque las operaciones académicas quedarían agrupadas bajo un mismo módulo. Además, el package ayuda a manejar dependencias de una forma más ordenada. Por ejemplo, si `pr_generar_reporte_ofertas` utiliza `fn_clasificar_arancel`, ambas operaciones pueden mantenerse dentro de `pkg_academico` y queda más claro que pertenecen al mismo conjunto de lógica. Si cambia una tabla o una columna de la que dependen estos objetos, será necesario revisar esas dependencias y, si corresponde, recompilar los objetos afectados.

Como posible dificultad, un Package demasiado grande puede terminar mezclando responsabilidades diferentes. Por eso sería necesario separar los objetos según su función y evitar agrupar todo solo por comodidad.

## 7.4 Trigger

Un Trigger es un objeto que se ejecuta automáticamente cuando ocurre un evento en la base de datos, como `INSERT`, `UPDATE` o `DELETE`.

En EDUBIO360 se propone utilizar un Trigger en una fase futura para auditar cambios sensibles, especialmente modificaciones relacionadas con los valores de arancel.

El funcionamiento podría ser:

```text
UPDATE de un arancel
        ↓
Trigger
        ↓
Registrar el cambio
        ↓
Tabla de historial o auditoría
```

En esa tabla se podrían guardar datos como el valor anterior, el nuevo valor, la fecha de modificación y algún identificador del usuario o proceso que realizó el cambio.

Actualmente EDUBIO360 no cuenta con una operación transaccional de mantenimiento de aranceles. Por esta razón, la tabla de auditoría y el Trigger se mantienen como parte del diseño futuro hasta que exista un proceso real de actualización que justifique su incorporación.

La ventaja del Trigger es que la auditoría podría ejecutarse automáticamente sin depender de que cada operación recuerde registrar el cambio de forma manual.

Una posible desventaja es que la lógica se ejecuta de forma automática y puede ser menos visible para quien realiza una modificación. También podría afectar el rendimiento si se agregan demasiados Triggers o si realizan operaciones muy pesadas.

## 7.5 Estrategia de interacción futura

Los cuatro objetos pueden trabajar en conjunto, pero cada uno tendría una responsabilidad distinta.

Una posible organización futura sería:

```text
Backend / API
      ↓
PKG_ACADEMICO
      ↓
Procedures y Functions
      ↓
Tablas Oracle

UPDATE de datos sensibles
      ↓
Trigger
      ↓
Auditoría
```

La idea sería repartir las responsabilidades. Un procedimiento podría ejecutar una tarea completa, como generar un reporte de ofertas. Una función recibiría datos y devolvería un resultado, por ejemplo una clasificación de arancel. El package serviría para mantener agrupados los procedimientos y funciones relacionados con la información académica. El trigger quedaría para acciones que deban ejecutarse automáticamente, como registrar un cambio de arancel en una tabla de auditoría.

## 7.6 Reutilización y mantenimiento

El principal aporte de Procedures y Functions sería evitar repetir la misma lógica en varios lugares. Si una consulta o regla se utiliza desde distintos procesos, resulta más fácil mantener una sola versión que tener varias copias.

Por ejemplo, si varias partes de EDUBIO360 necesitan generar ofertas por área, conviene mantener esa lógica en un procedimiento como `pr_generar_reporte_ofertas` en vez de copiar la misma consulta en distintos procesos. Lo mismo ocurre con una función de clasificación de arancel: si cambia la regla, bastaría con modificarla en un solo lugar.

Los Packages ayudarían a ordenar estos objetos según su propósito y a dejar visibles sus relaciones. Esto facilita el mantenimiento, pero también obliga a revisar las dependencias. Si un procedimiento depende de una tabla y esa tabla cambia de estructura, el objeto puede quedar inválido o necesitar una recompilación. Por eso, antes de modificar tablas utilizadas por el package, sería necesario revisar qué procedimientos y funciones dependen de ellas.

## 7.7 Riesgos y limitaciones

Aunque estos objetos pueden ser útiles, no conviene utilizarlos sin una necesidad concreta.

Entre los aspectos que habría que revisar antes de implementarlos se encuentran:

- **Rendimiento:** un procedimiento o una función con consultas muy pesadas puede tardar más de lo esperado. Un trigger también agrega trabajo cada vez que ocurre el evento que lo activa, por lo que no conviene colocar lógica pesada dentro de él.
- **Mantenimiento:** si demasiadas reglas quedan dentro de Oracle, puede ser difícil saber si una operación se está resolviendo en la base de datos o en el backend. Por eso cada objeto debería tener una responsabilidad clara.
- **Complejidad:** un Package demasiado grande o varios Triggers sobre una misma tabla pueden hacer más difícil seguir el flujo de una operación.
- **Seguridad:** no todos los usuarios deberían poder ejecutar o modificar estos objetos. Los permisos tendrían que entregarse solamente a los usuarios o procesos que realmente los necesiten.
- **Dependencias:** Procedures, Functions y Packages pueden depender de tablas, columnas u otros objetos. Si uno de esos elementos cambia, hay que revisar los objetos dependientes y, si corresponde, recompilarlos.
- **Integridad y auditoría:** los triggers pueden ayudar a registrar cambios o reforzar ciertas reglas, pero no deben reemplazar restricciones como claves primarias, claves foráneas, `CHECK` o `NOT NULL`. En EDUBIO360 se utilizarían como apoyo, por ejemplo para dejar un historial de modificaciones de arancel.

Por estas razones, en EDUBIO360 estos objetos se incorporarían cuando exista una operación real que justifique su uso. La estrategia definida permite mantener una separación clara entre la lógica ya implementada en PL/SQL y los objetos almacenados previstos para futuras necesidades de procesamiento, reutilización y auditoría.


# 8. Conclusión

EDUBIO360 parte de un archivo real de 106.555 registros y 28 columnas. La información, que originalmente se encontraba concentrada en una estructura plana, fue organizada en una base de datos Oracle compuesta por tablas relacionadas. La normalización permitió reducir repeticiones y separar cada concepto dentro del modelo de datos.

También se utilizaron distintos elementos de PL/SQL relacionados directamente con las necesidades del proyecto. RECORD permitió reunir en una sola estructura los datos principales de una oferta académica. VARRAY permitió manejar un grupo limitado de resultados. Los cursores permitieron recorrer varias filas y, mediante loops anidados, organizar las ofertas según su área de conocimiento. Finalmente, el manejo de excepciones permitió controlar situaciones como búsquedas sin resultados y valores inválidos definidos por la lógica del proyecto.

También se definió cómo podrían incorporarse en el futuro procedimientos almacenados, funciones, packages y triggers. Cada objeto quedó asociado a una necesidad concreta del proyecto, como la generación de reportes, la clasificación de aranceles, la organización de lógica académica y la auditoría de cambios.

## 8.1 Impacto del proyecto

El principal aporte es que EDUBIO360 ya no necesita trabajar directamente sobre una planilla plana para consultar la información. Al tener tablas relacionadas mediante claves, es posible buscar carreras, instituciones, comunas, modalidades, jornadas y costos de una forma más ordenada y con menos repetición de datos.

El uso de PL/SQL también permite incorporar lógica dentro de la base de datos cuando sea necesario. Esto puede servir para generar información más estructurada, controlar errores durante el procesamiento y reutilizar operaciones en futuras etapas del proyecto.

La base de datos queda preparada para ser utilizada posteriormente por otros componentes de EDUBIO360, como servicios backend o una API, sin que el frontend tenga que conectarse directamente a Oracle.

## 8.2 Recomendaciones y trabajo futuro

Los scripts principales fueron ejecutados en Oracle SQL Developer y se conservaron evidencias reales de su funcionamiento. Las verificaciones incluyen RECORD, VARRAY, cursores, loops, excepciones y los conteos finales de las tablas.

Los objetos almacenados propuestos podrían incorporarse cuando el proyecto disponga de operaciones reales que los necesiten. Entre ellos se consideran un procedimiento para generar reportes, una función para clasificar aranceles, un package para organizar lógica académica y un trigger de auditoría para futuras actualizaciones de información sensible.

Finalmente, cualquier cambio futuro en el modelo debería mantener el mismo criterio de diseño: incorporar tablas, reglas u objetos solamente cuando respondan a una necesidad concreta y comprobable dentro de EDUBIO360.


# 9. Anexos

## 9.1 Código completo utilizado en los bloques PL/SQL

Los siguientes scripts corresponden al código PL/SQL utilizado en EDUBIO360. Cada archivo también se encuentra disponible de forma independiente dentro de la carpeta `plsql/` del repositorio.

### Anexo A - RECORD

Archivo: `plsql/01_record.sql`

```sql
SET SERVEROUTPUT ON;

DECLARE
    TYPE t_oferta IS RECORD (
        nombre_carrera      DENOMINACION_CARRERA.nombre%TYPE,
        nombre_nivel        NIVEL_CARRERA.nombre%TYPE,
        nombre_institucion  INSTITUCION.nombre%TYPE,
        nombre_comuna       COMUNA.nombre%TYPE,
        nombre_modalidad    MODALIDAD.nombre%TYPE,
        nombre_jornada      JORNADA.nombre%TYPE,
        valor_matricula PLAN_OFERTA.valor_matricula%TYPE,
        valor_arancel   PLAN_OFERTA.valor_arancel%TYPE
    );

    v_oferta t_oferta;
    v_id_oferta OFERTA_ACADEMICA.id_oferta%TYPE := 1;
BEGIN
    SELECT
        dc.nombre,
        nc.nombre,
        i.nombre,
        co.nombre,
        m.nombre,
        j.nombre,
        po.valor_matricula,
        po.valor_arancel
    INTO
        v_oferta.nombre_carrera,
        v_oferta.nombre_nivel,
        v_oferta.nombre_institucion,
        v_oferta.nombre_comuna,
        v_oferta.nombre_modalidad,
        v_oferta.nombre_jornada,
        v_oferta.valor_matricula,
        v_oferta.valor_arancel
    FROM OFERTA_ACADEMICA o
    JOIN CARRERA c ON c.id_carrera = o.id_carrera
    JOIN DENOMINACION_CARRERA dc ON dc.id_denominacion = c.id_denominacion
    JOIN NIVEL_CARRERA nc ON nc.id_nivel_carrera = c.id_nivel_carrera
    JOIN INSTITUCION i ON i.id_institucion = o.id_institucion
    JOIN COMUNA co ON co.id_comuna = o.id_comuna
    JOIN MODALIDAD m ON m.id_modalidad = o.id_modalidad
    JOIN JORNADA j ON j.id_jornada = o.id_jornada
    JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
    WHERE o.id_oferta = v_id_oferta
      AND ROWNUM = 1;

    DBMS_OUTPUT.PUT_LINE('Carrera: ' || v_oferta.nombre_carrera);
    DBMS_OUTPUT.PUT_LINE('Nivel: ' || v_oferta.nombre_nivel);
    DBMS_OUTPUT.PUT_LINE('Institucion: ' || v_oferta.nombre_institucion);
    DBMS_OUTPUT.PUT_LINE('Comuna: ' || v_oferta.nombre_comuna);
    DBMS_OUTPUT.PUT_LINE('Modalidad: ' || v_oferta.nombre_modalidad);
    DBMS_OUTPUT.PUT_LINE('Jornada: ' || v_oferta.nombre_jornada);
    DBMS_OUTPUT.PUT_LINE('Matricula: $' || v_oferta.valor_matricula);
    DBMS_OUTPUT.PUT_LINE('Arancel: $' || v_oferta.valor_arancel);
END;
/
```

### Anexo B - VARRAY

Archivo: `plsql/02_varray.sql`

```sql
SET SERVEROUTPUT ON;

DECLARE
    TYPE t_nombres IS VARRAY(5) OF VARCHAR2(400);
    TYPE t_aranceles IS VARRAY(5) OF NUMBER;

    v_nombres t_nombres;
    v_aranceles t_aranceles;
BEGIN
    SELECT nombre_oferta, valor_arancel
    BULK COLLECT INTO v_nombres, v_aranceles
    FROM (
        SELECT
            dc.nombre || ' (' || nc.nombre || ') - ' || i.nombre AS nombre_oferta,
            po.valor_arancel
        FROM OFERTA_ACADEMICA o
        JOIN CARRERA c ON c.id_carrera = o.id_carrera
        JOIN DENOMINACION_CARRERA dc ON dc.id_denominacion = c.id_denominacion
        JOIN NIVEL_CARRERA nc ON nc.id_nivel_carrera = c.id_nivel_carrera
        JOIN INSTITUCION i ON i.id_institucion = o.id_institucion
        JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
        WHERE po.valor_arancel > 0
        ORDER BY po.valor_arancel ASC
    )
    WHERE ROWNUM <= 5;

    FOR i IN 1 .. v_nombres.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            i || '. ' || v_nombres(i) || ' | Arancel: $' || v_aranceles(i)
        );
    END LOOP;
END;
/
```

### Anexo C - Cursores y loops

Archivo: `plsql/03_cursor_loops.sql`

```sql
SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_areas IS
        SELECT id_area, nombre
        FROM AREA_CONOCIMIENTO
        ORDER BY nombre;
BEGIN
    DBMS_OUTPUT.PUT_LINE('AREAS DE CONOCIMIENTO');

    FOR a IN c_areas LOOP
        DBMS_OUTPUT.PUT_LINE(
            a.id_area || ' - ' || a.nombre
        );
    END LOOP;
END;
/

DECLARE
    CURSOR c_ofertas_por_area (p_id_area AREA_CONOCIMIENTO.id_area%TYPE) IS
        SELECT
            dc.nombre AS carrera,
            nc.nombre AS nivel_carrera,
            i.nombre AS institucion,
            po.valor_arancel
        FROM DENOMINACION_CARRERA dc
        JOIN CARRERA c ON c.id_denominacion = dc.id_denominacion
        JOIN NIVEL_CARRERA nc ON nc.id_nivel_carrera = c.id_nivel_carrera
        JOIN OFERTA_ACADEMICA o ON o.id_carrera = c.id_carrera
        JOIN INSTITUCION i ON i.id_institucion = o.id_institucion
        JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
        WHERE dc.id_area = p_id_area
        ORDER BY dc.nombre, nc.nombre, i.nombre;

    v_contador NUMBER;
BEGIN
    FOR a IN (
        SELECT id_area, nombre
        FROM AREA_CONOCIMIENTO
        ORDER BY nombre
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('====================================');
        DBMS_OUTPUT.PUT_LINE('AREA: ' || a.nombre);

        v_contador := 0;

        FOR o IN c_ofertas_por_area(a.id_area) LOOP
            v_contador := v_contador + 1;

            DBMS_OUTPUT.PUT_LINE(
                v_contador || '. ' || o.carrera ||
                ' (' || o.nivel_carrera || ')' ||
                ' | ' || o.institucion ||
                ' | Arancel: $' || o.valor_arancel
            );

            EXIT WHEN v_contador = 5;
        END LOOP;

        IF v_contador = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Sin ofertas para esta area.');
        END IF;
    END LOOP;
END;
/
```

### Anexo C.1 - Cursor parametrizado, recorrido manual y cursores anidados

Archivo: `plsql/03b_cursores_estilo_clase.sql`

Este archivo reúne dos implementaciones complementarias del procesamiento con cursores. La primera recorre manualmente un cursor con parámetro mediante `OPEN`, `FETCH`, `%NOTFOUND` y `CLOSE`. La segunda declara un cursor principal de áreas y un cursor parametrizado de ofertas dentro del mismo bloque, utilizando loops anidados.

```sql
SET SERVEROUTPUT ON;

PROMPT =====================================================
PROMPT EDUBIO360 - Cursor parametrizado con OPEN/FETCH/CLOSE
PROMPT =====================================================

DECLARE
    CURSOR c_ofertas_por_area (
        p_id_area AREA_CONOCIMIENTO.id_area%TYPE
    ) IS
        SELECT
            dc.nombre AS carrera,
            nc.nombre AS nivel_carrera,
            i.nombre AS institucion,
            po.valor_arancel
        FROM DENOMINACION_CARRERA dc
        JOIN CARRERA c
            ON c.id_denominacion = dc.id_denominacion
        JOIN NIVEL_CARRERA nc
            ON nc.id_nivel_carrera = c.id_nivel_carrera
        JOIN OFERTA_ACADEMICA o
            ON o.id_carrera = c.id_carrera
        JOIN INSTITUCION i
            ON i.id_institucion = o.id_institucion
        JOIN PLAN_OFERTA po
            ON po.id_oferta = o.id_oferta
        WHERE dc.id_area = p_id_area
        ORDER BY dc.nombre, nc.nombre, i.nombre;

    v_id_area       AREA_CONOCIMIENTO.id_area%TYPE := 1;
    v_carrera       DENOMINACION_CARRERA.nombre%TYPE;
    v_nivel         NIVEL_CARRERA.nombre%TYPE;
    v_institucion   INSTITUCION.nombre%TYPE;
    v_arancel       PLAN_OFERTA.valor_arancel%TYPE;
    v_contador      PLS_INTEGER := 0;
BEGIN
    OPEN c_ofertas_por_area(v_id_area);

    LOOP
        FETCH c_ofertas_por_area
        INTO v_carrera, v_nivel, v_institucion, v_arancel;

        EXIT WHEN c_ofertas_por_area%NOTFOUND;

        v_contador := v_contador + 1;

        DBMS_OUTPUT.PUT_LINE(
            v_contador || '. ' ||
            v_carrera || ' (' || v_nivel || ')' ||
            ' | ' || v_institucion ||
            ' | Arancel: $' || v_arancel
        );

        EXIT WHEN v_contador = 5;
    END LOOP;

    CLOSE c_ofertas_por_area;

    IF v_contador = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'No se encontraron ofertas para el area ' || v_id_area
        );
    END IF;
END;
/

PROMPT =====================================================
PROMPT EDUBIO360 - Cursores anidados
PROMPT =====================================================

DECLARE
    CURSOR c_areas IS
        SELECT id_area, nombre
        FROM AREA_CONOCIMIENTO
        ORDER BY nombre;

    CURSOR c_ofertas_por_area (
        p_id_area AREA_CONOCIMIENTO.id_area%TYPE
    ) IS
        SELECT
            dc.nombre AS carrera,
            nc.nombre AS nivel_carrera,
            i.nombre AS institucion,
            po.valor_arancel
        FROM DENOMINACION_CARRERA dc
        JOIN CARRERA c
            ON c.id_denominacion = dc.id_denominacion
        JOIN NIVEL_CARRERA nc
            ON nc.id_nivel_carrera = c.id_nivel_carrera
        JOIN OFERTA_ACADEMICA o
            ON o.id_carrera = c.id_carrera
        JOIN INSTITUCION i
            ON i.id_institucion = o.id_institucion
        JOIN PLAN_OFERTA po
            ON po.id_oferta = o.id_oferta
        WHERE dc.id_area = p_id_area
        ORDER BY dc.nombre, nc.nombre, i.nombre;

    v_contador PLS_INTEGER;
BEGIN
    FOR a IN c_areas LOOP
        DBMS_OUTPUT.PUT_LINE('====================================');
        DBMS_OUTPUT.PUT_LINE('AREA: ' || a.nombre);

        v_contador := 0;

        FOR o IN c_ofertas_por_area(a.id_area) LOOP
            v_contador := v_contador + 1;

            DBMS_OUTPUT.PUT_LINE(
                v_contador || '. ' ||
                o.carrera || ' (' || o.nivel_carrera || ')' ||
                ' | ' || o.institucion ||
                ' | Arancel: $' || o.valor_arancel
            );

            EXIT WHEN v_contador = 5;
        END LOOP;

        IF v_contador = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Sin ofertas para esta area.');
        END IF;
    END LOOP;
END;
/
```

### Anexo D - Excepciones

Archivo: `plsql/04_excepciones.sql`

```sql
SET SERVEROUTPUT ON;

PROMPT ==========================================
PROMPT EDUBIO360 - Excepcion NO_DATA_FOUND
PROMPT ==========================================

DECLARE
    v_nombre DENOMINACION_CARRERA.nombre%TYPE;
    v_nivel NIVEL_CARRERA.nombre%TYPE;
    v_id_carrera NUMBER := -999;
BEGIN
    SELECT dc.nombre, nc.nombre
    INTO v_nombre, v_nivel
    FROM CARRERA c
    JOIN DENOMINACION_CARRERA dc
        ON dc.id_denominacion = c.id_denominacion
    JOIN NIVEL_CARRERA nc
        ON nc.id_nivel_carrera = c.id_nivel_carrera
    WHERE c.id_carrera = v_id_carrera;

    DBMS_OUTPUT.PUT_LINE(
        'Carrera encontrada: ' || v_nombre || ' (' || v_nivel || ')'
    );
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'NO_DATA_FOUND: no existe una carrera con el ID ' || v_id_carrera
        );
END;
/

PROMPT ==========================================
PROMPT EDUBIO360 - Excepcion TOO_MANY_ROWS
PROMPT ==========================================

DECLARE
    v_nombre  DENOMINACION_CARRERA.nombre%TYPE;
    v_id_area AREA_CONOCIMIENTO.id_area%TYPE := 1;
BEGIN
    SELECT dc.nombre
    INTO v_nombre
    FROM DENOMINACION_CARRERA dc
    WHERE dc.id_area = v_id_area;

    DBMS_OUTPUT.PUT_LINE(
        'Carrera encontrada: ' || v_nombre
    );
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(
            'TOO_MANY_ROWS: el area ' || v_id_area ||
            ' contiene mas de una carrera.'
        );
END;
/

PROMPT ==========================================
PROMPT EDUBIO360 - Excepcion definida por usuario
PROMPT ==========================================

DECLARE
    e_arancel_invalido EXCEPTION;
    v_arancel NUMBER := -1;
BEGIN
    IF v_arancel < 0 THEN
        RAISE e_arancel_invalido;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Arancel valido: $' || v_arancel);
EXCEPTION
    WHEN e_arancel_invalido THEN
        DBMS_OUTPUT.PUT_LINE(
            'EXCEPCION DE USUARIO: el arancel no puede ser negativo.'
        );
END;
/
```

## 9.2 Diagramas y modelos

El modelo de datos utilizado en el proyecto se encuentra documentado en los siguientes archivos del repositorio:

- `docs/diagrama-er.dbml`: definición del diagrama entidad-relación.
- `docs/modelo-datos-final.md`: explicación del modelo final, entidades, relaciones y decisiones.
- `docs/normalizacion-3fn.md`: justificación del proceso de normalización hasta 3FN.
- `database/01_create_tables.sql`: creación física de las tablas y relaciones en Oracle.
- `database/10_assert_final.sql`: validación de conteos esperados después de la carga.

La tabla `STAGING_MATRICULA` se mantiene fuera del DER normalizado porque corresponde a una tabla técnica de recepción y transformación de los datos originales.

## 9.3 Evidencias de ejecución

Los bloques PL/SQL desarrollados para EDUBIO360 fueron ejecutados y verificados en Oracle SQL Developer. Las evidencias permiten comprobar el funcionamiento de RECORD, VARRAY, cursores parametrizados, loops anidados y manejo de excepciones, además de la validación final de los registros almacenados en la base de datos.

Las capturas y salidas obtenidas durante las ejecuciones se mantienen junto con la documentación técnica del proyecto como respaldo de los resultados presentados.
