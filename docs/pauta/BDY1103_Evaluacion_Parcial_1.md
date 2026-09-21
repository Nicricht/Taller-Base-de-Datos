# Pauta oficial - Evaluación Parcial N° 1

> **Fuente:** documento oficial entregado por la asignatura BDY1103 Taller de Base de Datos.  
> **Archivo original:** `BDY1103 Evaluación Parcial 1_EE_EP_Estudiante(2).pdf`  
> **Extensión del original:** 10 páginas.  
> **SHA-256 del PDF recibido:** `7db1a5821d964be62cb00ce0ca547aac1cf69eb36043170bdccc4ca2b1484f53`

Este archivo deja la pauta en formato Markdown para poder compararla directamente con el código, el informe y el QA del repositorio. No reemplaza al PDF original.

## Datos generales

- Evaluación: Evaluación Parcial N° 1.
- Tipo: Caso de análisis semestral.
- Asignatura: BDY1103 - Taller de Base de Datos.
- Tiempo asignado: 1 semana.
- Ponderación de la evaluación parcial: 30%.
- Trabajo en equipos de máximo 3 estudiantes.
- La evaluación de cada situación evaluativa es individual.

## Distribución de la evaluación

- Situación evaluativa 1: Entrega de encargo / informe: 40%.
- Situación evaluativa 2: Presentación: 60%.

# Situación evaluativa 1: Informe

En el informe los estudiantes deben:

1. Describir el contexto de negocio.
2. Identificar los datos a procesar y la información relevante que se necesita generar.
3. Demostrar la utilización de tipos de datos compuestos RECORD y VARRAY en el desarrollo de la solución.
4. Demostrar el uso de cursores con y sin parámetros y la utilización de loops anidados para generar la información necesaria.
5. Demostrar el uso de excepciones y explicar cuándo utilizar excepciones predefinidas por Oracle y excepciones definidas por el usuario.
6. Evaluar la implementación de Procedimientos Almacenados, Funciones Almacenadas, Packages y Triggers para construir una solución integral de procesamiento y generación de información.

## Apartados obligatorios del informe

### Introducción

- Descripción del proyecto: breve descripción, objetivo y forma en que PL/SQL se utilizará para cumplir el objetivo.
- Alcance: definir el alcance del proyecto y los componentes del negocio afectados o mejorados mediante PL/SQL.
- Tecnologías utilizadas.

### Tipos de datos compuestos

- Describir cómo RECORD y VARRAY se integran en el proyecto.
- Incluir diagramas si son necesarios.
- Explicar cómo RECORD y VARRAY mejoran la eficiencia del procesamiento de datos dentro del proyecto.

### Desarrollo de bloques PL/SQL con cursores explícitos complejos

- Explicar qué es un cursor explícito y cuándo se utiliza.
- Describir la diferencia entre cursores simples y complejos.
- Detallar cómo se definen y utilizan cursores explícitos con parámetros.
- Explicar la utilidad de los cursores en el manejo de bucles anidados.
- Describir cómo los cursores explícitos complejos resuelven problemas concretos del proyecto.
- Explicar ventajas de estos cursores para procesar grandes volúmenes de datos u obtener datos desde múltiples fuentes.

### Integración de control de excepciones

- Describir excepciones predefinidas por Oracle y cómo se utilizan.
- Explicar cómo definir excepciones personalizadas.
- Describir cómo se integra el control de excepciones en los bloques PL/SQL del proyecto.
- Explicar cómo el manejo de excepciones ayuda a prevenir errores y conservar la integridad de los datos.

### Evaluación de Procedimientos, Funciones, Packages y Triggers

- Explicar qué es un procedimiento almacenado y su uso para tareas repetitivas y automatizadas.
- Describir qué es una función almacenada y cómo puede realizar cálculos y devolver un valor.
- Explicar qué es un Package en PL/SQL y cómo agrupa procedimientos, funciones y otros elementos.
- Explicar qué es un Trigger y cómo responde automáticamente a eventos como INSERT, UPDATE o DELETE.
- Proponer una estrategia clara de cómo se implementarían Procedures, Functions, Packages y Triggers en el proyecto.
- Explicar cómo interactuarían y cómo aportarían a una solución integral.
- Explicar reutilización y mantenimiento mediante procedimientos y funciones.
- Explicar cómo los Packages pueden organizar lógica relacionada y dependencias.
- Explicar cómo los Triggers pueden apoyar auditoría, integridad y respuestas automáticas.
- Discutir posibles problemas o limitaciones, incluyendo rendimiento, mantenimiento y seguridad.

### Conclusión

- Resumen de los puntos principales del informe.
- Impacto del proyecto: cómo las soluciones PL/SQL contribuyen al negocio.
- Recomendaciones y posibles extensiones futuras de PL/SQL.

### Anexos

- Código completo utilizado en el proyecto.
- Diagramas, modelos o esquemas utilizados.

# Situación evaluativa 2: Presentación

Durante la presentación cada estudiante debe:

1. Explicar el problema del proyecto, su relevancia y contexto.
2. Identificar los datos a procesar y la información que se necesita generar.
3. Justificar el uso de RECORD y VARRAY.
4. Justificar el uso de cursores con y sin parámetros y loops anidados.
5. Justificar el uso de excepciones Oracle y definidas por el usuario.
6. Evaluar la implementación de Procedures, Functions, Packages y Triggers.
7. Finalizar con una conclusión.

## Consejos de presentación

- Cada diapositiva debe transmitir un mensaje claro y conciso.
- Evitar sobrecargar con texto.
- Utilizar diagramas, gráficos y ejemplos de código relevantes y legibles.
- Practicar la presentación para respetar el tiempo.
- Prepararse para responder preguntas sobre el código y las decisiones del proyecto.

# Rúbrica

## Niveles de logro

- Muy buen desempeño: 100%.
- Buen desempeño: 80%.
- Desempeño aceptable: 60%.
- Desempeño incipiente: 30%.
- Desempeño no logrado: 0%.

## Situación evaluativa 1: Encargo / informe

### IE1.1.1 - RECORD y VARRAY - 5%

Utiliza tipos de datos compuestos RECORD y VARRAY en bloques PL/SQL anónimos para procesar datos y generar información relevante para el negocio.

### IE1.2.1 - Cursores y loops - 10%

Desarrolla bloques PL/SQL anónimos para procesar datos y generar información relevante para el negocio, utilizando cursores explícitos complejos con parámetros para trabajar con más de un LOOP de forma simultánea.

### IE1.3.1 - Excepciones - 10%

Integra control de excepciones predefinidas por Oracle y definidas por el usuario en bloques PL/SQL anónimos para procesar datos y generar información relevante para el negocio.

### IE1.4.1 - Procedures, Functions, Packages y Triggers - 15%

Evalúa la implementación de Procedimientos Almacenados, Funciones Almacenadas, Packages y Triggers para construir una solución integral de procesamiento y generación de información.

**Total informe: 40%.**

## Situación evaluativa 2: Presentación

### IE1.1.2 - RECORD y VARRAY - 15%

Explica la utilización de RECORD y VARRAY en bloques PL/SQL para procesar datos y generar información relevante para el negocio.

### IE1.2.2 - Cursores y loops - 15%

Justifica bloques PL/SQL que utilizan cursores explícitos complejos con parámetros para trabajar con más de un LOOP simultáneamente.

### IE1.3.2 - Excepciones - 15%

Explica el uso del control de excepciones predefinidas por Oracle y definidas por el usuario en bloques PL/SQL.

### IE1.4.2 - Uso futuro de stored objects - 15%

Explica la utilización futura de Procedimientos Almacenados, Funciones Almacenadas, Packages y Triggers para construir una solución integral de procesamiento y generación de información.

**Total presentación: 60%.**

# Lista de control derivada de la pauta

El trabajo no debe considerarse terminado hasta comprobar, como mínimo:

- [ ] Contexto de negocio explicado.
- [ ] Datos a procesar identificados.
- [ ] Información relevante a generar identificada.
- [ ] RECORD implementado, explicado y relacionado con una necesidad del negocio.
- [ ] VARRAY implementado, explicado y relacionado con una necesidad del negocio.
- [ ] Cursor sin parámetros demostrado.
- [ ] Cursor explícito complejo con parámetros demostrado.
- [ ] Más de un LOOP utilizado de forma simultánea.
- [ ] Excepción predefinida por Oracle implementada y explicada.
- [ ] Excepción definida por el usuario implementada y explicada.
- [ ] Procedure evaluado para uso futuro.
- [ ] Function evaluada para uso futuro.
- [ ] Package evaluado para uso futuro.
- [ ] Trigger evaluado para uso futuro.
- [ ] Estrategia de interacción entre stored objects explicada.
- [ ] Ventajas, mantenimiento, rendimiento y seguridad discutidos.
- [ ] Conclusión con resumen, impacto y recomendaciones.
- [ ] Código completo agregado en anexos.
- [ ] Diagramas/modelos agregados en anexos.
- [ ] Evidencias de ejecución revisadas.
- [ ] Informe final comparado contra los cuatro indicadores de la Situación Evaluativa 1.
