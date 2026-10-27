# Informe y defensa EP2 BDY1103

**Estado:** borrador tecnico. Adjuntar evidencias reales despues de ejecutar en SQL Developer. El codigo en Git no demuestra compilacion.

## Introduccion y negocio
El catalogo de Educacion Superior del Biobio se construye a partir de las matriculas 2021 y permite consultar carreras, instituciones, ofertas, planes y aranceles. El alcance de esta EP2 es solo la capa Oracle en Taller-Base-de-Datos; no toca frontend ni microservicios. Tecnologias: Oracle Database, SQL Developer, SQL, PL/SQL y GitHub.

## Procedimientos
Un procedimiento centraliza procesamiento o acciones y admite IN, OUT e IN OUT. `PR_EP2_ACTUALIZAR_RESUMEN` agrega las ofertas y planes por area de conocimiento sin parametros. `PR_EP2_REPORTE_AREA` recibe el ID del area (IN) y devuelve conteo (OUT), ademas de imprimir una muestra. Ventajas: modularidad, reutilizacion, mantenimiento. Riesgos: acoplamiento a Oracle y manejo transaccional. Demostrar ejecucion con areas reales.

## Funciones
Devuelven un valor usando RETURN y pueden invocarse en SQL si respetan sus restricciones. `FN_EP2_TOTAL_MATRICULAS()` cuenta registros; `FN_EP2_CLASIFICAR_ARANCEL(p_arancel)` aplica categorias de ejemplo. Ventaja: evita duplicacion de reglas en consultas; desventaja: costo por fila y dependencia del motor. Cero no necesariamente significa gratuito; tramos son ilustrativos.

## Packages
`PKG_EP2_ACADEMICO` separa interfaz (spec) de implementacion (body). Sus metodos publicos invocan `PR_EP2_REPORTE_AREA`, `PR_EP2_ACTUALIZAR_RESUMEN` y una funcion privada `FN_NOMBRE_AREA`. Facilita encapsulacion; evita objetos aislados sin relacion. Mostrar funcion publica en SELECT y explicar que la privada no es accesible externamente.

## Triggers
`TRG_EP2_ARANCEL_FILA` registra antes/despues por fila modificada. `TRG_EP2_ARANCEL_SENTENCIA` registra una vez por sentencia UPDATE de arancel aunque afecte 0 filas. Ventajas: auditoria automatica; desventajas: efectos implicitos, costo y depuracion. Ambas auditorias participan de la misma transaccion de la modificacion y desaparecen con ROLLBACK.

## Conclusion y recomendaciones
Los stored objects permiten organizar consultas, producir resumenes y detectar cambios sensibles de arancel. Revisar permisos finos, volumen de auditoria, versionado de tramos de precio y politica transaccional en evoluciones posteriores. No confundir un resumen de planes con uno de estudiantes.

## Anexos obligatorios
1. Codigo completo: archivos `ep2/*.sql`.
2. Modelo existente: `docs/diagrama-er.dbml` y `docs/modelo-datos-final.md`.
3. Evidencia real: captura de objetos VALID, SELECT de funciones, DBMS_OUTPUT de procedimientos y package, trigger por fila y por sentencia, errores controlados y rollback.

## Guion de presentacion (defensa individual)
1. Problema y datos usados.
2. Alcance Oracle, estructura EP1 conservada.
3. Justificacion de procedimientos y funciones con/sin parametros.
4. Especificacion publica, cuerpo y privado del package.
5. Triggers de sentencia y fila con auditorias.
6. Pruebas ejecutadas, limitaciones y conclusion.

**Pauta:** informe/encargo 40% y presentacion 60% de la EP2. Explicar las decisiones tecnicas, no solo exhibir capturas.
