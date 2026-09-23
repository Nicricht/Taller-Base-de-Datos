# QA de Presentación - Evaluación Parcial N° 1

## Resultado

**Estado: APROBADO PARA PRESENTACIÓN.**

La presentación de EDUBIO360 fue validada contra la pauta oficial de BDY1103 para la **Situación Evaluativa 2: Presentación**, que corresponde al 60% de la Evaluación Parcial N° 1.

**Resultado automatizado de la presentación: 17/17 controles aprobados.**  
**Resultado automatizado del informe: 15/15 controles aprobados.**

El control combina tres capas:

1. **Cobertura de la pauta:** se comprueba que todos los puntos obligatorios aparezcan y estén justificados.
2. **QA automatizado:** `qa/validate_presentacion_ep1.py` inspecciona directamente el archivo PPTX y falla si falta un indicador esencial.
3. **QA visual/técnico:** la presentación fue revisada para evitar desbordes y mantener una extensión ejecutiva de 10 diapositivas.

## Matriz de cumplimiento

| Requisito de la pauta | Evidencia en la presentación | Estado |
|---|---|---|
| Problema, relevancia y contexto | Diapositiva 2 explica la estructura plana, repetición de datos y objetivo de EDUBIO360 | ✅ |
| Datos a procesar e información a generar | Diapositiva 2 identifica 106.555 registros, 28 columnas y la información usada para comparar ofertas | ✅ |
| IE1.1.2 RECORD | Diapositiva 4 justifica RECORD para agrupar los atributos de una oferta académica | ✅ |
| IE1.1.2 VARRAY | Diapositiva 5 justifica VARRAY(5), límite conocido y uso de BULK COLLECT | ✅ |
| IE1.2.2 cursores con/sin parámetros | Diapositiva 6 presenta `c_areas` y `c_ofertas_por_area(p_id_area)` | ✅ |
| IE1.2.2 más de un LOOP simultáneo | Diapositiva 6 muestra LOOP externo por área y LOOP interno por ofertas | ✅ |
| Cursores y múltiples fuentes | Diapositiva 6 explica que el cursor integra denominación, carrera, nivel, oferta, institución y plan | ✅ |
| IE1.3.2 excepciones Oracle | Diapositiva 7 explica `NO_DATA_FOUND` y `TOO_MANY_ROWS` | ✅ |
| IE1.3.2 excepción del usuario | Diapositiva 7 explica `e_arancel_invalido` y su condición | ✅ |
| IE1.4.2 Procedure | Diapositiva 8 propone `pr_generar_reporte_ofertas(p_id_area)` | ✅ |
| IE1.4.2 Function | Diapositiva 8 propone `fn_clasificar_arancel(p_valor_arancel)` | ✅ |
| IE1.4.2 Package | Diapositiva 8 propone `pkg_academico` | ✅ |
| IE1.4.2 Trigger | Diapositiva 8 propone un trigger de auditoría de arancel | ✅ |
| Interacción, mantenimiento, rendimiento y seguridad | Diapositiva 9 explica integración y riesgos | ✅ |
| Conclusión | Diapositiva 10 resume datos, PL/SQL y crecimiento futuro | ✅ |

## Revisión técnica

- Archivo PPTX válido: **PASS**.
- Total de diapositivas: **10**.
- Notas del presentador: **10/10 diapositivas**.
- Revisión visual local de desbordamiento: **PASS, sin overflow**.
- Carga textual controlada: **PASS**; máximo detectado de 837 caracteres en una diapositiva.
- Apoyo visual: **PASS**; tres diapositivas incorporan evidencias gráficas reales.
- Se reutilizan evidencias reales de ejecución de VARRAY, cursores y excepciones almacenadas en el proyecto.
- No se detectaron placeholders ni textos de relleno.

## Proceso reproducible

La presentación se genera desde el repositorio con:

```bash
python qa/build_presentacion_ep1.py
```

Luego se valida con:

```bash
python qa/validate_presentacion_ep1.py
```

El workflow `.github/workflows/ep1-rubric-qa.yml` genera el PPTX, ejecuta el QA del informe, ejecuta el QA de la presentación y, si todos los controles pasan en `main`, versiona automáticamente el archivo generado.

## Archivo versionado

- `docs/presentacion/EDUBIO360_EP1_PRESENTACION_FINAL.pptx`

La versión PDF puede exportarse desde PowerPoint para entrega o respaldo, pero el artefacto fuente versionado en GitHub es el PPTX.

## Criterio de cierre

La presentación se considera lista porque el workflow completó correctamente la generación, las validaciones del informe y de la presentación, y el versionado del PPTX. Si se modifica la presentación y desaparece un requisito obligatorio de la pauta, el workflow fallará.
