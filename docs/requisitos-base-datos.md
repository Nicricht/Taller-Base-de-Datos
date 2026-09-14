# Requisitos de Base de Datos — EduBío 360

## 1. Propósito

Construir una base de datos Oracle relacional, normalizada, trazable y reutilizable por PL/SQL y por los servicios de EduBío 360. Este proyecto de base de datos funciona como núcleo de persistencia académica y debe integrarse con el proyecto principal mediante backend/microservicios, evitando el acceso directo desde el frontend.

## 2. Requisitos funcionales

### RF-BD-01 — Importar datos académicos
La base debe permitir cargar datos provenientes del archivo fuente de matrícula de Educación Superior del Biobío mediante una etapa de staging y transformación.

### RF-BD-02 — Validar la importación
El proceso de carga debe detectar o rechazar registros inválidos, inconsistentes o que incumplan las reglas definidas antes de incorporarlos al modelo normalizado.

### RF-BD-03 — Gestionar instituciones
La base debe almacenar instituciones de Educación Superior y relacionarlas con su tipo de institución.

### RF-BD-04 — Gestionar estructura territorial
La base debe representar la jerarquía territorial necesaria para las ofertas académicas, incluyendo comuna y, cuando el modelo normalizado lo justifique, provincia y región.

### RF-BD-05 — Gestionar carreras y áreas
La base debe almacenar carreras y su clasificación académica, incluyendo área de conocimiento y niveles académicos definidos por el modelo final.

### RF-BD-06 — Gestionar ofertas académicas
La base debe almacenar las ofertas académicas relacionando la carrera con la institución, ubicación, modalidad, jornada y demás atributos que definan correctamente la granularidad de una oferta.

### RF-BD-07 — Gestionar costos y características del plan
La base debe almacenar los valores de matrícula, arancel, duración y características del plan en la entidad que corresponda según la normalización final.

### RF-BD-08 — Mantener matrícula histórica
La base debe conservar los registros históricos de matrícula y vincularlos con la oferta o plan académico correspondiente.

### RF-BD-09 — Consultar información académica
La base debe soportar consultas de instituciones, carreras, áreas, comunas, modalidades, jornadas, costos y ofertas académicas para su posterior consumo por los servicios de EduBío 360.

### RF-BD-10 — Comparar alternativas académicas
La estructura de datos debe permitir recuperar varias ofertas de una misma carrera para que el proyecto principal de EduBío 360 pueda comparar instituciones, costos, modalidad, jornada y otros atributos disponibles.

### RF-BD-11 — Ejecutar validaciones de integridad
La solución debe incluir consultas de control para detectar claves foráneas huérfanas, duplicados, valores monetarios inválidos e inconsistencias relevantes.

### RF-BD-12 — Ejecutar lógica PL/SQL de la evaluación
La base debe permitir implementar y ejecutar los elementos exigidos por la evaluación: RECORD, VARRAY, cursor explícito parametrizado, loops, excepción predefinida de Oracle y excepción definida por el usuario.

### RF-BD-13 — Mantener trazabilidad de carga
La etapa de staging y los scripts de carga deben permitir identificar el origen de los datos y reproducir el proceso de importación.

### RF-BD-14 — Proveer datos a otros componentes de EduBío 360
Los datos académicos deben quedar disponibles para el backend o microservicios responsables del catálogo, analítica e importación, respetando el ownership definido para cada dominio.

## 3. Requisitos no funcionales

### RNF-BD-01 — Motor Oracle
La solución debe implementarse sobre Oracle Database.

### RNF-BD-02 — Normalización
El modelo relacional final debe cumplir 1FN, 2FN y 3FN, con dependencias funcionales documentadas y defendibles.

### RNF-BD-03 — Cantidad mínima de tablas
La solución debe contener al menos 10 tablas relacionadas reales y justificadas por el dominio, no creadas artificialmente para cumplir el mínimo.

### RNF-BD-04 — Volumen mínimo de datos
La base debe contener más de 1.000 registros cargados y debe existir evidencia mediante consultas de conteo.

### RNF-BD-05 — Integridad referencial
Las relaciones deben protegerse mediante claves primarias y foráneas, evitando registros huérfanos.

### RNF-BD-06 — Integridad de dominio
Se deben utilizar restricciones como NOT NULL, UNIQUE y CHECK cuando correspondan a una regla real del dominio.

### RNF-BD-07 — Calidad de datos
El proceso debe controlar nulos, duplicados, valores anómalos y valores monetarios inválidos. No deben existir aranceles o matrículas negativos.

### RNF-BD-08 — Trazabilidad
La carga desde el dataset fuente hasta las tablas normalizadas debe poder explicarse y reproducirse mediante scripts y staging.

### RNF-BD-09 — Reproducibilidad
La estructura de la base debe poder reconstruirse desde cero utilizando scripts DDL, constraints, índices y scripts de carga versionados en Git.

### RNF-BD-10 — Seguridad y mínimo privilegio
Los usuarios o schemas Oracle deben diseñarse con permisos mínimos según su responsabilidad. Los servicios no deben acceder directamente a tablas de otros dominios sin una decisión de arquitectura explícita.

### RNF-BD-11 — Rendimiento
Las consultas frecuentes deben estar apoyadas por índices justificados. El diseño debe evitar duplicación innecesaria y considerar el costo de consultas de catálogo y analítica.

### RNF-BD-12 — Mantenibilidad
Los nombres de tablas, columnas, claves y scripts deben ser consistentes y comprensibles. Las decisiones de modelado deben estar documentadas.

### RNF-BD-13 — Compatibilidad con EduBío 360
La base debe poder ser consumida por los servicios del proyecto principal EduBío 360 sin que el frontend acceda directamente a Oracle.

### RNF-BD-14 — Evidencia académica
Cada requisito importante debe contar con evidencia verificable: modelo, script, consulta, salida, captura o explicación técnica según corresponda.

## 4. Reglas de negocio iniciales

- No se permiten aranceles negativos.
- No se permiten valores de matrícula negativos.
- No deben existir ofertas académicas duplicadas según la clave candidata que se defina finalmente.
- Las relaciones entre entidades deben conservar integridad referencial.
- Los atributos derivados no deben almacenarse innecesariamente cuando puedan calcularse de forma confiable.
- La granularidad de carrera, oferta académica, plan y matrícula debe quedar definida antes de cerrar el DDL definitivo.

## 5. Integración con el proyecto principal EduBío 360

Este repositorio no representa toda la aplicación EduBío 360. Representa la capa de datos académicos y PL/SQL.

Relación prevista:

```text
Dataset fuente
    ↓
STAGING / ETL
    ↓
Oracle normalizado
    ↓
Backend / microservicios EduBío 360
    ↓
API REST
    ↓
Frontend EduBío 360
```

Responsabilidades esperadas:

- Base de datos: persistencia, integridad, normalización, carga y consultas.
- Academic Service: acceso al catálogo académico mediante API.
- Import Service: validación y carga controlada de nuevas fuentes.
- Analytics Service: lectura autorizada para indicadores y análisis.
- Frontend: nunca consulta Oracle directamente.

## 6. Criterio de cierre de la base

La base se considerará lista cuando:

- El DER final esté aprobado y documentado.
- La 3FN sea demostrable.
- Existan 10 o más tablas relacionadas reales.
- Los scripts creen la estructura desde cero.
- Se hayan cargado más de 1.000 registros.
- Las validaciones de integridad pasen correctamente.
- El PL/SQL obligatorio esté implementado, ejecutado y explicado.
- Existan evidencias para la presentación y defensa.
