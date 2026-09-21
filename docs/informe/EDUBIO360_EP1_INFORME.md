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


# 4. Tipos de datos compuestos

Para esta parte de la evaluación se trabajó con los tipos compuestos RECORD y VARRAY dentro de bloques PL/SQL anónimos. La idea no fue usarlos solamente porque aparecen en la pauta, sino relacionarlos con información que realmente existe en EDUBIO360.

Los scripts utilizados para esta sección son:

- `plsql/01_record.sql`
- `plsql/02_varray.sql`

## 4.1 RECORD

Un RECORD permite reunir varios datos relacionados dentro de una sola variable. En EDUBIO360 se utilizó para representar una oferta académica completa.

El tipo creado en el bloque PL/SQL es:

```sql
TYPE t_oferta IS RECORD (
    carrera         DENOMINACION_CARRERA.nombre%TYPE,
    nivel_carrera   NIVEL_CARRERA.nombre%TYPE,
    institucion     INSTITUCION.nombre%TYPE,
    comuna          COMUNA.nombre%TYPE,
    modalidad       MODALIDAD.nombre%TYPE,
    jornada         JORNADA.nombre%TYPE,
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
    v_oferta.carrera,
    v_oferta.nivel_carrera,
    v_oferta.institucion,
    v_oferta.comuna,
    v_oferta.modalidad,
    v_oferta.jornada,
    v_oferta.valor_matricula,
    v_oferta.valor_arancel
...
WHERE o.id_oferta = v_id_oferta
  AND ROWNUM = 1;
```

Finalmente, los datos se muestran utilizando `DBMS_OUTPUT.PUT_LINE`.

En EDUBIO360 esto es útil porque una oferta no se entiende solamente por el nombre de la carrera. Para mostrar una alternativa académica también necesitamos saber qué institución la ofrece, dónde se encuentra, la modalidad, jornada y sus valores. El RECORD permite tratar esos datos relacionados como una sola estructura en vez de trabajar con muchas variables separadas.

También se utilizó `%TYPE` para que los campos del RECORD tomen el mismo tipo de dato que las columnas reales de las tablas. De esta forma, el bloque queda relacionado directamente con la estructura de la base.

## 4.2 VARRAY

El segundo tipo compuesto utilizado fue VARRAY. En este caso se necesitaba trabajar con un grupo pequeño y limitado de resultados.

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

La consulta obtiene cinco ofertas junto con sus aranceles. Los resultados se cargan utilizando `BULK COLLECT`:

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

En este ejemplo el VARRAY sirve porque se decidió trabajar con un máximo conocido de cinco resultados. El bloque conserva los nombres de las ofertas y sus aranceles para después recorrerlos y mostrarlos.

Esto se puede relacionar con una necesidad de EDUBIO360, ya que el sistema puede requerir mostrar un conjunto reducido de alternativas para revisar o comparar. En este ejercicio se usan las cinco ofertas con menor arancel según la consulta del script.

## 4.3 Aporte de RECORD y VARRAY al proyecto

Los dos tipos compuestos resuelven necesidades distintas.

El RECORD se utiliza cuando necesitamos representar en una sola estructura diferentes datos que pertenecen a una misma oferta académica.

El VARRAY se utiliza cuando necesitamos mantener un grupo limitado de valores y recorrerlos dentro del bloque PL/SQL.

En este proyecto ayudan a que el procesamiento quede más ordenado. En vez de declarar una gran cantidad de variables independientes para una oferta, el RECORD agrupa sus datos. En el caso del VARRAY, los resultados quedan almacenados como una colección con un límite definido y luego pueden recorrerse con un LOOP.

La evidencia de ejecución de ambos bloques se incorporará cuando los scripts sean ejecutados y verificados en Oracle. En el repositorio ya se encuentra el código que será utilizado para esa ejecución.


# 5. Cursores explícitos y loops

Para esta parte se utiliza el archivo `plsql/03_cursor_loops.sql`. En el script se trabajan dos casos: un cursor explícito sin parámetros y un cursor explícito con parámetro. También se utilizan loops anidados para recorrer áreas de conocimiento y, dentro de cada área, sus ofertas académicas.

## 5.1 Qué es un cursor explícito

Un cursor explícito permite recorrer el resultado de una consulta que puede devolver varias filas. A diferencia de un `SELECT INTO`, que normalmente se utiliza cuando esperamos obtener una sola fila, el cursor permite procesar los registros uno por uno.

En EDUBIO360 esto es útil porque muchas consultas no entregan un solo resultado. Por ejemplo, un área de conocimiento puede tener varias carreras y cada carrera puede tener distintas ofertas académicas.

## 5.2 Cursor sin parámetros

Primero se agregó un cursor simple llamado `c_areas`:

```sql
CURSOR c_areas IS
    SELECT id_area, nombre
    FROM AREA_CONOCIMIENTO
    ORDER BY nombre;
```

Este cursor no recibe ningún parámetro. Siempre ejecuta la misma consulta y obtiene las áreas de conocimiento existentes en la tabla `AREA_CONOCIMIENTO`.

Después se recorre con:

```sql
FOR a IN c_areas LOOP
    DBMS_OUTPUT.PUT_LINE(
        a.id_area || ' - ' || a.nombre
    );
END LOOP;
```

Este ejemplo sirve para demostrar el funcionamiento básico de un cursor explícito sin parámetros. El cursor mantiene una consulta definida y el LOOP permite recorrer todos los registros que devuelve.

## 5.3 Cursor explícito con parámetro

El segundo cursor es más completo porque recibe un parámetro:

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

Primero se recorren las áreas:

```sql
FOR a IN (
    SELECT id_area, nombre
    FROM AREA_CONOCIMIENTO
    ORDER BY nombre
) LOOP
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

En este caso los cursores son útiles porque necesitamos recorrer varias filas y ejecutar una lógica por cada resultado. También permiten controlar cuántas ofertas se muestran por área y mantener separado el recorrido de las áreas del recorrido de sus ofertas.

El cursor parametrizado evita repetir una consulta distinta para cada área y permite reutilizar el mismo bloque cambiando solamente el parámetro.

Para operaciones masivas simples, una consulta SQL directa puede ser más eficiente que procesar cada fila con un cursor. En este proyecto el cursor se utiliza porque necesitamos un procesamiento controlado y anidado de los resultados, que es precisamente el caso trabajado en la evaluación.

La evidencia de ejecución de este bloque se agregará después de ejecutarlo y verificarlo en Oracle.
