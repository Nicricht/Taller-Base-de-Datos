OPTIONS (SKIP=1, ERRORS=1000)
LOAD DATA
CHARACTERSET AL32UTF8
INFILE 'matriculas_biobio_2021.csv'
APPEND
INTO TABLE STAGING_MATRICULA
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  id_fuente CHAR,
  genero CHAR,
  edad CHAR,
  rango_edad CHAR,
  anio_ingreso CHAR,
  semestre_ingreso CHAR,
  tipo_institucion CHAR,
  nombre_institucion CHAR,
  acreditacion_institucional CHAR,
  periodo_acreditacion CHAR,
  anios_acreditacion CHAR,
  nombre_carrera CHAR,
  requisito_ingreso CHAR,
  via_ingreso CHAR,
  modalidad CHAR,
  jornada CHAR,
  tipo_plan_carrera CHAR,
  nivel_estudio_carrera CHAR,
  nivel_carrera CHAR,
  area_conocimiento CHAR,
  duracion_plan CHAR,
  duracion_titulacion CHAR,
  duracion_total CHAR,
  valor_matricula CHAR,
  valor_arancel CHAR,
  region_sede CHAR,
  provincia_sede CHAR,
  comuna_sede CHAR
)
