PROMPT =====================================================
PROMPT EduBio 360 - Construccion de estructura Oracle
PROMPT =====================================================

PROMPT [1/5] Reiniciando tablas del proyecto...
@@00_reset.sql

PROMPT [2/5] Creando tablas de negocio...
@@01_create_tables.sql

PROMPT [3/5] Aplicando PK, FK, UNIQUE y CHECK...
@@02_constraints.sql

PROMPT [4/5] Creando indices...
@@03_indexes.sql

PROMPT [5/5] Creando tabla tecnica de staging...
@@04_create_staging.sql

PROMPT =====================================================
PROMPT Estructura terminada. Ejecutando verificacion...
PROMPT =====================================================
@@09_verify_structure.sql
