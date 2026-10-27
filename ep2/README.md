# EP2 BDY1103 - Taller Base de Datos

Ampliacion **exclusivamente de Oracle y PL/SQL** del repositorio `Nicricht/Taller-Base-de-Datos`. Conservar EP1: `database/` y `plsql/`.

## Instalacion

1. Instalar y cargar previamente el modelo EP1; comprobar que `PLAN_OFERTA` y `MATRICULA_HISTORICA` contienen datos.
2. Si faltan privilegios al usuario EDUBIO360, ejecutar `00_permisos_ep2.sql` como SYSTEM/DBA. Nunca subir contrasenas.
3. Conectado como **EDUBIO360**, ejecutar `00_instalar_ep2.sql` con **F5** en SQL Developer.
4. Ejecutar `07_pruebas_ep2.sql` con **F5** y guardar capturas de `DBMS_OUTPUT`, consultas, `USER_OBJECTS` y `USER_ERRORS`.

No ejecutar el reset/reinstalador EP1 encima de EP2 sin revisar dependencias. El instalador crea solo las tres tablas auxiliares que faltan; los stored objects se reemplazan. No hace COMMIT dentro de los procedimientos ni triggers.

## Objetos

| Requisito | Objeto | Funcionalidad |
|---|---|---|
| Funcion sin parametros | `FN_EP2_TOTAL_MATRICULAS` | Cuenta matriculas historicas |
| Funcion con parametros | `FN_EP2_CLASIFICAR_ARANCEL` | Clasifica precio en tramos de ejemplo |
| Procedimiento sin parametros | `PR_EP2_ACTUALIZAR_RESUMEN` | Resume planes/ofertas por area |
| Procedimiento IN/OUT | `PR_EP2_REPORTE_AREA` | Cuenta planes y muestra muestra por area |
| Package publico/privado | `PKG_EP2_ACADEMICO` | API de consulta y resumen con `FN_NOMBRE_AREA` privado |
| Trigger fila | `TRG_EP2_ARANCEL_FILA` | Audita OLD/NEW por fila cambiada |
| Trigger sentencia | `TRG_EP2_ARANCEL_SENTENCIA` | Audita cada UPDATE OF arancel, incluso de 0 filas |

Las funciones pueden aparecer dentro de `SELECT`. Los procedimientos se invocan mediante `EXEC`, `CALL` o PL/SQL, **no como expresiones de SELECT**. La funcion de clasificacion usa umbrales didacticos y no presume que arancel cero signifique gratuidad. `EP2_RESUMEN_AREA` es una foto, actualizable mediante el procedimiento o package, no una vista automatica.

La prueba modifica temporalmente un arancel e inspecciona ambas auditorias dentro de una transaccion; **ROLLBACK restaura los datos**. Las columnas de auditoria no usan transacciones autonomas. Si el cambio es rechazado o revertido, no deja evidencia persistente. Esto es deseado para la prueba.

Ver `docs/ep2/INFORME_GUIA.md`. Quedan pendientes la compilacion/ejecucion en Oracle real y las capturas exigibles para la defensa.
