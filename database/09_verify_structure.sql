PROMPT =====================================================
PROMPT Verificacion de estructura - EduBio 360
PROMPT =====================================================

PROMPT Usuario Oracle actual:
SELECT USER AS usuario_actual FROM dual;

PROMPT Tablas esperadas del proyecto:
SELECT table_name
FROM user_tables
WHERE table_name IN (
    'REGION',
    'PROVINCIA',
    'COMUNA',
    'TIPO_INSTITUCION',
    'INSTITUCION',
    'ACREDITACION_INSTITUCION',
    'AREA_CONOCIMIENTO',
    'DENOMINACION_CARRERA',
    'NIVEL_ESTUDIO',
    'NIVEL_CARRERA',
    'MODALIDAD',
    'JORNADA',
    'CARRERA',
    'OFERTA_ACADEMICA',
    'TIPO_PLAN',
    'PLAN_OFERTA',
    'REQUISITO_INGRESO',
    'VIA_INGRESO',
    'MATRICULA_HISTORICA',
    'STAGING_MATRICULA'
)
ORDER BY table_name;

PROMPT Conteo de tablas del proyecto. Debe devolver 20:
SELECT COUNT(*) AS total_tablas_proyecto
FROM user_tables
WHERE table_name IN (
    'REGION',
    'PROVINCIA',
    'COMUNA',
    'TIPO_INSTITUCION',
    'INSTITUCION',
    'ACREDITACION_INSTITUCION',
    'AREA_CONOCIMIENTO',
    'DENOMINACION_CARRERA',
    'NIVEL_ESTUDIO',
    'NIVEL_CARRERA',
    'MODALIDAD',
    'JORNADA',
    'CARRERA',
    'OFERTA_ACADEMICA',
    'TIPO_PLAN',
    'PLAN_OFERTA',
    'REQUISITO_INGRESO',
    'VIA_INGRESO',
    'MATRICULA_HISTORICA',
    'STAGING_MATRICULA'
);

PROMPT Constraints deshabilitadas o invalidas. Debe devolver 0 filas:
SELECT table_name, constraint_name, constraint_type, status
FROM user_constraints
WHERE table_name IN (
    'REGION', 'PROVINCIA', 'COMUNA', 'TIPO_INSTITUCION', 'INSTITUCION',
    'ACREDITACION_INSTITUCION', 'AREA_CONOCIMIENTO', 'DENOMINACION_CARRERA',
    'NIVEL_ESTUDIO', 'NIVEL_CARRERA', 'MODALIDAD', 'JORNADA', 'CARRERA',
    'OFERTA_ACADEMICA', 'TIPO_PLAN', 'PLAN_OFERTA', 'REQUISITO_INGRESO',
    'VIA_INGRESO', 'MATRICULA_HISTORICA'
)
AND status <> 'ENABLED';

PROMPT Primary Keys creadas:
SELECT table_name, constraint_name
FROM user_constraints
WHERE constraint_type = 'P'
  AND table_name IN (
    'REGION', 'PROVINCIA', 'COMUNA', 'TIPO_INSTITUCION', 'INSTITUCION',
    'ACREDITACION_INSTITUCION', 'AREA_CONOCIMIENTO', 'DENOMINACION_CARRERA',
    'NIVEL_ESTUDIO', 'NIVEL_CARRERA', 'MODALIDAD', 'JORNADA', 'CARRERA',
    'OFERTA_ACADEMICA', 'TIPO_PLAN', 'PLAN_OFERTA', 'REQUISITO_INGRESO',
    'VIA_INGRESO', 'MATRICULA_HISTORICA'
)
ORDER BY table_name;

PROMPT Foreign Keys creadas:
SELECT table_name, constraint_name
FROM user_constraints
WHERE constraint_type = 'R'
  AND table_name IN (
    'REGION', 'PROVINCIA', 'COMUNA', 'TIPO_INSTITUCION', 'INSTITUCION',
    'ACREDITACION_INSTITUCION', 'AREA_CONOCIMIENTO', 'DENOMINACION_CARRERA',
    'NIVEL_ESTUDIO', 'NIVEL_CARRERA', 'MODALIDAD', 'JORNADA', 'CARRERA',
    'OFERTA_ACADEMICA', 'TIPO_PLAN', 'PLAN_OFERTA', 'REQUISITO_INGRESO',
    'VIA_INGRESO', 'MATRICULA_HISTORICA'
)
ORDER BY table_name, constraint_name;

PROMPT =====================================================
PROMPT Si total_tablas_proyecto = 20 y no aparecen constraints
PROMPT deshabilitadas, la estructura base quedo creada.
PROMPT =====================================================
