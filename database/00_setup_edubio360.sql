-- Ejecutar una sola vez conectado como SYSTEM_XEPDB1.
-- IMPORTANTE: reemplazar TU_CLAVE_LOCAL antes de ejecutar y NO subir la clave real a Git.
-- Si el usuario EDUBIO360 ya existe, no volver a ejecutar CREATE USER.

CREATE USER EDUBIO360
IDENTIFIED BY "TU_CLAVE_LOCAL"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;

-- Privilegios minimos necesarios para reconstruir la estructura actual del proyecto.
GRANT CREATE SESSION TO EDUBIO360;
GRANT CREATE TABLE TO EDUBIO360;

-- Verificacion del usuario creado. Esta consulta se ejecuta como SYSTEM.
SELECT username, account_status, default_tablespace
FROM dba_users
WHERE username = 'EDUBIO360';
