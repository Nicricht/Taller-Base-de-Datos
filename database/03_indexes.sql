CREATE INDEX ix_inst_tipo ON INSTITUCION(id_tipo_institucion);
CREATE INDEX ix_nc_ne ON NIVEL_CARRERA(id_nivel_estudio);

CREATE INDEX ix_carrera_area ON CARRERA(id_area);
CREATE INDEX ix_carrera_nivel ON CARRERA(id_nivel_carrera);

CREATE INDEX ix_oferta_carrera ON OFERTA_ACADEMICA(id_carrera);
CREATE INDEX ix_oferta_comuna ON OFERTA_ACADEMICA(id_comuna);
CREATE INDEX ix_oferta_modalidad ON OFERTA_ACADEMICA(id_modalidad);
CREATE INDEX ix_oferta_jornada ON OFERTA_ACADEMICA(id_jornada);

CREATE INDEX ix_plan_tipo ON PLAN_OFERTA(id_tipo_plan);
CREATE INDEX ix_plan_arancel ON PLAN_OFERTA(valor_arancel);

CREATE INDEX ix_mat_plan ON MATRICULA_HISTORICA(id_plan_oferta);
CREATE INDEX ix_mat_req ON MATRICULA_HISTORICA(id_requisito_ingreso);
CREATE INDEX ix_mat_via ON MATRICULA_HISTORICA(id_via_ingreso);
CREATE INDEX ix_mat_anio ON MATRICULA_HISTORICA(anio_ingreso);
CREATE INDEX ix_mat_edad ON MATRICULA_HISTORICA(edad);
