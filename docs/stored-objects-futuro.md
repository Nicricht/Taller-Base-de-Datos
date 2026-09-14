# Estrategia futura de stored objects

La EP1 prioriza RECORD, VARRAY, cursor parametrizado, loops y excepciones. Procedure, Function, Package y Trigger se documentan como estrategia futura para no implementar elementos decorativos sin necesidad.

## Procedure

Uso futuro propuesto: generar un reporte de ofertas por area o institucion, recibiendo parametros y centralizando una operacion reutilizable.

Ejemplo conceptual:

`pr_generar_reporte_ofertas(p_id_area)`

## Function

Uso futuro propuesto: clasificar un arancel en un rango utilizado por reportes o comparaciones.

Ejemplo conceptual:

`fn_clasificar_arancel(p_valor_arancel)`

## Package

Uso futuro propuesto: agrupar procedures y functions relacionadas con consultas academicas y validaciones del dominio.

Ejemplo conceptual:

`pkg_academico`

## Trigger

Uso futuro propuesto: auditar cambios sensibles en valores de arancel cuando EduBio 360 incorpore mantenimiento transaccional de ofertas.

No se crea una tabla de auditoria como relleno en la EP1. Si el sistema permite modificaciones reales de arancel en una fase posterior, se incorporaria una tabla de historial y un trigger asociado.

## Criterio

Un stored object se implementara cuando exista un problema concreto de reutilizacion, encapsulacion, validacion o auditoria que lo justifique. No se implementara solo para aumentar la cantidad de objetos de la base.
