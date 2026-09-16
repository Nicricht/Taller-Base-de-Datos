@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul

set "ROOT=%~dp0"
cd /d "%ROOT%"

set "CSV_NAME=matriculas_biobio_2021.csv"
set "CSV_PATH=%ROOT%data\%CSV_NAME%"
set "LOG_DIR=%ROOT%logs"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

echo ============================================================
echo            EduBio 360 - Instalacion rapida Oracle
echo ============================================================
echo.
echo Este instalador NO reemplaza ni borra archivos del repositorio.
echo Ejecuta automaticamente los scripts existentes en el orden correcto.
echo.
echo IMPORTANTE: la estructura Oracle del usuario indicado se reconstruira.
echo Las tablas de EduBio 360 se reiniciaran antes de cargar los datos.
echo.
set /p "CONFIRMAR=Escribe S para continuar: "
if /I not "%CONFIRMAR%"=="S" goto :cancelled

where sqlplus >nul 2>&1
if errorlevel 1 goto :missing_sqlplus

where sqlldr >nul 2>&1
if errorlevel 1 goto :missing_sqlldr

if not exist "%CSV_PATH%" goto :missing_csv

set "DB_USER=EDUBIO360"
set /p "DB_USER_INPUT=Usuario Oracle [EDUBIO360]: "
if not "%DB_USER_INPUT%"=="" set "DB_USER=%DB_USER_INPUT%"

set "DB_CONNECT=localhost:1521/XEPDB1"
set /p "DB_CONNECT_INPUT=Conexion Oracle [localhost:1521/XEPDB1]: "
if not "%DB_CONNECT_INPUT%"=="" set "DB_CONNECT=%DB_CONNECT_INPUT%"

for /f "usebackq delims=" %%P in (`powershell -NoProfile -Command "$p=Read-Host 'Contrasena Oracle' -AsSecureString; $b=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($p); try {[Runtime.InteropServices.Marshal]::PtrToStringBSTR($b)} finally {[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($b)}"`) do set "DB_PASS=%%P"
if not defined DB_PASS goto :missing_password

echo.
echo [1/4] Probando conexion Oracle...
call :test_connection
if errorlevel 1 goto :connection_error

echo.
echo [2/4] Reconstruyendo estructura...
call :run_sql "database\00_run_structure.sql"
if errorlevel 1 goto :sql_error

echo.
echo [3/4] Cargando %CSV_NAME% en STAGING_MATRICULA...
pushd "%ROOT%data"
sqlldr userid="%DB_USER%/%DB_PASS%@%DB_CONNECT%" control="..\database\sqlldr\staging_matricula.ctl" log="%LOG_DIR%\staging_matricula.log" bad="%LOG_DIR%\staging_matricula.bad" direct=false
set "LOAD_RC=%ERRORLEVEL%"
popd
if not "%LOAD_RC%"=="0" goto :loader_error

echo.
echo [4/4] Validando staging, ejecutando ETL y verificando resultado...
call :run_sql "database\00_run_data_pipeline.sql"
if errorlevel 1 goto :sql_error

echo.
echo ============================================================
echo             EDUBIO360 INSTALADO CORRECTAMENTE
echo ============================================================
echo Usuario:         %DB_USER%
echo Conexion:        %DB_CONNECT%
echo Dataset:         %CSV_NAME%
echo Matriculas:      106555 esperadas y verificadas
echo Logs SQL*Loader: %LOG_DIR%
echo ============================================================
echo.
echo La base ya esta lista para consultas y ejercicios PL/SQL.
echo.
set "DB_PASS="
pause
exit /b 0

:test_connection
(
  echo WHENEVER OSERROR EXIT FAILURE
  echo WHENEVER SQLERROR EXIT SQL.SQLCODE
  echo CONNECT %DB_USER%/"%DB_PASS%"@%DB_CONNECT%
  echo SELECT 'CONEXION_OK' AS ESTADO FROM dual;
  echo EXIT SUCCESS
) | sqlplus -L -S /nolog
exit /b %ERRORLEVEL%

:run_sql
(
  echo WHENEVER OSERROR EXIT FAILURE
  echo WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
  echo SET ECHO OFF
  echo SET FEEDBACK ON
  echo SET SERVEROUTPUT ON SIZE UNLIMITED
  echo CONNECT %DB_USER%/"%DB_PASS%"@%DB_CONNECT%
  echo @"%~1"
  echo EXIT SUCCESS COMMIT
) | sqlplus -L -S /nolog
exit /b %ERRORLEVEL%

:missing_sqlplus
echo.
echo ERROR: no se encontro SQL*Plus ^(sqlplus^) en el PATH.
echo Instala o activa las herramientas cliente de Oracle antes de usar el modo rapido.
goto :fail

:missing_sqlldr
echo.
echo ERROR: no se encontro SQL*Loader ^(sqlldr^) en el PATH.
echo Puedes seguir usando el metodo manual documentado en docs\carga-staging.md.
goto :fail

:missing_csv
echo.
echo ERROR: falta el archivo:
echo %CSV_PATH%
echo.
echo Copia matriculas_biobio_2021.csv dentro de la carpeta data y vuelve a ejecutar.
goto :fail

:missing_password
echo.
echo ERROR: no se ingreso una contrasena Oracle.
goto :fail

:connection_error
echo.
echo ERROR: no fue posible conectar a Oracle con los datos ingresados.
echo Revisa usuario, contrasena y conexion. Ejemplo local: localhost:1521/XEPDB1
goto :fail

:loader_error
echo.
echo ERROR: SQL*Loader termino con codigo %LOAD_RC%.
echo Revisa:
echo   %LOG_DIR%\staging_matricula.log
echo   %LOG_DIR%\staging_matricula.bad
goto :fail

:sql_error
echo.
echo ERROR: un script SQL detuvo la instalacion.
echo La base NO se marca como lista. Revisa el mensaje ORA mostrado arriba.
goto :fail

:cancelled
echo.
echo Instalacion cancelada. No se modifico la base.
set "DB_PASS="
pause
exit /b 0

:fail
set "DB_PASS="
echo.
echo Instalacion detenida sin ocultar el error.
echo.
pause
exit /b 1
