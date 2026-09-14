# Guia de defensa PL/SQL - EduBio 360

## RECORD

Un RECORD es una estructura PL/SQL que permite agrupar varios campos relacionados dentro de una sola variable.

En `plsql/01_record.sql` se usa para reunir en una sola estructura los datos principales de una oferta: carrera, institucion, comuna, modalidad, jornada, matricula y arancel.

Frase de defensa:

"Usamos RECORD porque necesitabamos trabajar con varios atributos relacionados de una oferta como una sola unidad logica."

## VARRAY

Un VARRAY es una coleccion de tamano maximo definido. Permite guardar temporalmente varios valores del mismo tipo en memoria PL/SQL.

En `plsql/02_varray.sql` se utilizan dos VARRAY con capacidad maxima de 5 elementos para mostrar cinco ofertas y sus aranceles.

Frase de defensa:

"Usamos VARRAY porque queriamos manejar una coleccion pequena y acotada de resultados dentro del bloque PL/SQL."

## Cursor parametrizado

Un cursor permite recorrer varias filas devueltas por una consulta. Un cursor parametrizado recibe un valor que modifica la consulta que ejecuta.

En `plsql/03_cursor_loops.sql`, el cursor recibe `id_area` y devuelve las ofertas correspondientes a esa area.

Frase de defensa:

"El parametro permite reutilizar el mismo cursor para distintas areas de conocimiento sin escribir una consulta diferente para cada area."

## Loops

Un loop repite instrucciones.

El script de cursor usa dos niveles de recorrido:

1. Loop exterior: recorre las areas de conocimiento.
2. Loop interior: abre el cursor parametrizado para el area actual y recorre sus ofertas.

Frase de defensa:

"Los loops nos permiten construir un reporte jerarquico area por area y oferta por oferta."

## Excepcion predefinida

Oracle incorpora excepciones listas para usar. `NO_DATA_FOUND` ocurre cuando un `SELECT ... INTO` no encuentra ninguna fila.

En `plsql/04_excepciones.sql` se busca deliberadamente una carrera inexistente y se captura `NO_DATA_FOUND` para entregar una salida controlada.

Frase de defensa:

"En vez de dejar que el bloque termine abruptamente, capturamos el error esperado y entregamos un mensaje comprensible."

## Excepcion de usuario

Una excepcion de usuario representa una condicion de negocio definida por nosotros.

En `plsql/04_excepciones.sql` se crea `e_arancel_invalido`. Si un arancel es negativo se lanza esa excepcion.

Frase de defensa:

"La excepcion de usuario permite representar una regla propia del dominio que Oracle no conoce por si solo."

## Diferencia SQL y PL/SQL

SQL se utiliza principalmente para definir, consultar y modificar datos. PL/SQL agrega programacion procedural a Oracle: variables, estructuras, condiciones, loops, cursores y manejo de excepciones.

## Evidencia que debemos guardar

Para cada script:

1. Codigo ejecutado.
2. Captura o salida de ejecucion.
3. Explicacion de la funcion utilizada.
4. Problema de EduBio 360 que resuelve.
5. Explicacion oral de cualquier linea que el profesor pueda preguntar.
