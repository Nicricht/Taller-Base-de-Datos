# QA de la Evaluación Parcial 1

Este directorio contiene un control automático para reducir el riesgo de dejar requisitos de la pauta fuera del informe o del repositorio.

## Qué valida automáticamente

El script `validate_ep1.py` comprueba, entre otras cosas:

- que el proyecto se identifique como EDUBIO360;
- que el informe tenga las secciones requeridas;
- que existan al menos 10 tablas;
- que la normalización 1FN, 2FN y 3FN esté documentada;
- que RECORD y VARRAY estén implementados;
- que exista cursor explícito con parámetros;
- que exista cursor sin parámetros;
- que haya más de un LOOP;
- que existan excepción Oracle y excepción de usuario;
- que Procedure, Function, Package y Trigger sean evaluados como estrategia futura, incluyendo limitaciones;
- que el volumen de datos sea mayor a 1.000;
- que existan anexos;
- que se guarde evidencia de ejecución Oracle.

## Qué NO puede validar el CI

Un CI no puede reemplazar la revisión académica ni demostrar que Oracle fue ejecutado correctamente solo leyendo archivos. Antes de entregar se debe revisar manualmente:

1. que cada explicación corresponda realmente al código;
2. que los scripts se ejecuten en Oracle;
3. que las capturas y salidas sean reales y legibles;
4. que la redacción responda a la pauta;
5. que la portada esté completa;
6. que el documento final Word/PDF tenga buen formato.

## Semáforo

- **Verde:** todos los controles estáticos pasan.
- **Rojo:** todavía existe al menos un requisito detectable pendiente.

Mientras el informe se encuentre en desarrollo es normal que el workflow permanezca rojo. El objetivo es que quede verde antes de generar la versión final de entrega.
