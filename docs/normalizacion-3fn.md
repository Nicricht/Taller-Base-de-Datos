# Normalizacion 1FN, 2FN y 3FN - EduBio 360

## Punto de partida

La fuente original es un archivo plano con 106.555 registros y 28 columnas. Una misma fila repite informacion de institucion, territorio, carrera, modalidad, jornada, plan, costos e ingreso.

La normalizacion busca separar esos datos segun sus dependencias funcionales para reducir redundancia y evitar inconsistencias.

## Dependencias funcionales comprobadas

- COMUNA_SEDE -> PROVINCIA_SEDE
- PROVINCIA_SEDE -> REGION_SEDE
- NOMBRE_INSTITUCION -> TIPO_INSTITUCION
- NOMBRE_INSTITUCION -> ACREDITACION_INSTITUCIONAL
- NOMBRE_INSTITUCION -> PERIODO_ACREDITACION
- NOMBRE_INSTITUCION -> ANIOS_ACREDITACION
- NIVEL_CARRERA -> NIVEL_ESTUDIO
- NOMBRE_CARRERA -> AREA_CONOCIMIENTO
- EDAD -> RANGO_EDAD

Dependencia que NO se cumple:

- NOMBRE_CARRERA -> NIVEL_CARRERA

Se detectaron 6 nombres de carrera asociados a mas de un nivel. Por ello CARRERA usa como restriccion logica UNIQUE(nombre, id_nivel_carrera).

## Primera Forma Normal - 1FN

Una tabla cumple 1FN cuando cada columna contiene valores atomicos y cada fila puede identificarse de forma unica.

En el modelo final:

- Cada entidad dispone de una PK.
- No se almacenan listas dentro de una celda.
- Los catalogos contienen un valor por fila.
- MATRICULA_HISTORICA identifica cada registro fuente mediante id_registro_fuente UNIQUE.

Ejemplo:

No se guarda una columna `vias_ingreso = 'Ingreso Directo, PACE, RAP'`. VIA_INGRESO contiene una via por fila y MATRICULA_HISTORICA referencia una de ellas mediante FK.

## Segunda Forma Normal - 2FN

Una tabla cumple 2FN cuando esta en 1FN y todos los atributos no clave dependen de la clave completa.

El modelo utiliza PK sustitutas simples para implementacion, pero conserva restricciones UNIQUE que representan las claves candidatas del negocio.

Ejemplos:

### CARRERA

Clave candidata:

`(nombre, id_nivel_carrera)`

Los atributos propios de la carrera dependen de esa identidad y no de una parte aislada que sea insuficiente para identificarla.

### OFERTA_ACADEMICA

Clave candidata:

`(id_institucion, id_carrera, id_comuna, id_modalidad, id_jornada)`

La oferta representa la combinacion completa de quien imparte, que carrera, donde, modalidad y jornada.

### PLAN_OFERTA

La identidad de un plan se define por la oferta y sus caracteristicas de plan, duraciones y valores. Los costos no se almacenan en CARRERA ni en INSTITUCION porque no dependen de esas entidades por si solas.

## Tercera Forma Normal - 3FN

Una tabla cumple 3FN cuando esta en 2FN y los atributos no clave no dependen transitivamente de otros atributos no clave.

El modelo elimina las principales dependencias transitivas detectadas en la fuente.

### Territorio

En el archivo plano:

`COMUNA -> PROVINCIA -> REGION`

Si OFERTA_ACADEMICA guardara comuna, provincia y region como texto, provincia y region se repetirian miles de veces y podrian contradecirse.

Solucion:

`REGION 1:N PROVINCIA 1:N COMUNA`

OFERTA_ACADEMICA solo referencia COMUNA.

### Institucion

En el archivo plano:

`NOMBRE_INSTITUCION -> TIPO_INSTITUCION`

Solucion:

TIPO_INSTITUCION se separa como catalogo e INSTITUCION conserva su FK.

La acreditacion se separa en ACREDITACION_INSTITUCION para permitir historico por anio de referencia sin sobrescribir el estado anterior.

### Nivel academico

En el archivo plano:

`NIVEL_CARRERA -> NIVEL_ESTUDIO`

Solucion:

NIVEL_ESTUDIO se separa y NIVEL_CARRERA conserva su FK. CARRERA referencia NIVEL_CARRERA y no repite NIVEL_ESTUDIO.

### Area de conocimiento

Se comprobo:

`NOMBRE_CARRERA -> AREA_CONOCIMIENTO`

AREA_CONOCIMIENTO se modela como catalogo y CARRERA conserva su FK. OFERTA_ACADEMICA no repite el area.

### Rango de edad

Se comprobo:

`EDAD -> RANGO_EDAD`

RANGO_EDAD no se persiste en MATRICULA_HISTORICA. Se calcula en consultas cuando sea necesario.

### Oferta y plan

La fuente muestra que una misma combinacion de institucion + carrera + comuna + modalidad + jornada puede presentar mas de un tipo de plan, duracion o valor economico.

Por eso:

- OFERTA_ACADEMICA guarda la identidad de la oferta.
- PLAN_OFERTA guarda tipo de plan, duraciones, matricula y arancel.

Esto evita mezclar atributos de distinta granularidad.

## Resultado

El modelo final queda en 3FN porque:

1. Cada tabla representa un solo concepto.
2. Cada fila posee una PK.
3. Las claves candidatas se protegen con UNIQUE.
4. Los atributos no clave dependen de la identidad de su tabla.
5. Las dependencias transitivas relevantes fueron separadas en entidades propias.
6. Los datos derivados, como RANGO_EDAD, no se duplican.
7. Los atributos de plan no se almacenan en la oferta cuando pueden variar de manera independiente.

## Frase para la defensa

"No dividimos el Excel en muchas tablas solo para cumplir una cantidad. Primero analizamos las dependencias funcionales de la fuente. Por ejemplo, comuna determina provincia y provincia determina region; nivel de carrera determina nivel de estudio; y el nombre de carrera determina area, pero no siempre determina nivel. A partir de esas pruebas separamos las entidades y eliminamos dependencias transitivas hasta llegar a 3FN."
