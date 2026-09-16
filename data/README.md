# Carpeta local de datos

Para usar el instalador rápido, coloca aquí el archivo:

`matriculas_biobio_2021.csv`

El CSV no se versiona en GitHub porque `*.csv` está incluido en `.gitignore`.

El instalador espera el CSV UTF-8 con cabecera y las 28 columnas de `STAGING_MATRICULA`. Para el dataset oficial del proyecto se esperan **106.555 filas de datos**.

Si no dispones de `sqlldr`, utiliza el procedimiento manual de `docs/carga-staging.md` y después ejecuta `database/00_run_data_pipeline.sql` con F5.
