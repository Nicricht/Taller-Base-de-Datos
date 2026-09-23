# QA de Presentación - Evaluación Parcial N° 1

## Resultado

**Estado: APROBADO PARA PRESENTACIÓN**

La presentación de EDUBIO360 fue revisada contra la pauta oficial de BDY1103 para la **Situación Evaluativa 2: Presentación**, que corresponde al 60% de la Evaluación Parcial N° 1.

El control combina tres capas:

1. **Cobertura de la pauta:** se comprueba que todos los puntos obligatorios aparezcan y estén justificados.
2. **QA automatizado:** `qa/validate_presentacion_ep1.py` inspecciona directamente el archivo PPTX y falla si falta un indicador esencial.
3. **QA visual/técnico:** se valida que la presentación no tenga desbordes y que mantenga una extensión ejecutiva.

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

- Archivo PPTX válido: **sí**.
- Total de diapositivas: **10**.
- Notas del presentador: **10/10 diapositivas**.
- Prueba de desbordamiento con `slides_test.py`: **PASS, sin overflow**.
- La presentación incluye capturas reales de Oracle SQL Developer y el modelo relacional generado desde Oracle SQL Developer Data Modeler.
- No se detectaron placeholders ni textos de relleno.

## QA automatizado

Ejecutar desde la raíz del repositorio:

```bash
python qa/validate_presentacion_ep1.py
```

El workflow `.github/workflows/ep1-rubric-qa.yml` ejecuta automáticamente tanto el QA del informe como el QA de la presentación en cada `push`, `pull_request` y ejecución manual.

## Archivos validados

- `docs/presentacion/EDUBIO360_EP1_PRESENTACION_FINAL.pptx`
- `docs/presentacion/EDUBIO360_EP1_PRESENTACION_FINAL.pdf`

## Criterio de cierre

La presentación se considera lista mientras el QA automatizado termine con **todos los controles en PASS**. Si se modifica el PPTX y un requisito obligatorio desaparece, el workflow debe fallar para evitar entregar una versión incompleta.
