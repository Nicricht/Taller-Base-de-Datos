PROMPT =====================================================
PROMPT EduBio 360 - Pipeline automatico de datos
PROMPT =====================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT [1/5] Diagnostico previo del staging...
@@05_preload_validation.sql

PROMPT [2/5] Control bloqueante antes del ETL...
@@05b_assert_staging.sql

PROMPT [3/5] Transformando y cargando modelo normalizado...
@@06_transform_load.sql

PROMPT [4/5] Ejecutando validaciones posteriores...
@@07_validation.sql

PROMPT [5/5] Verificando conteos finales esperados...
@@10_assert_final.sql

PROMPT =====================================================
PROMPT Pipeline EduBio 360 terminado correctamente.
PROMPT =====================================================
