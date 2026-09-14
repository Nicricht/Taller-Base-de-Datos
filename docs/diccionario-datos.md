# Diccionario de Datos - EduBio 360

## REGION

- `id_region`: PK tecnica de la region.
- `nombre`: nombre unico de la region.

## PROVINCIA

- `id_provincia`: PK tecnica.
- `id_region`: FK a REGION.
- `nombre`: nombre de la provincia, unico dentro de una region.

## COMUNA

- `id_comuna`: PK tecnica.
- `id_provincia`: FK a PROVINCIA.
- `nombre`: nombre de la comuna, unico dentro de una provincia.

## TIPO_INSTITUCION

- `id_tipo_institucion`: PK tecnica.
- `nombre`: tipo institucional controlado.

## INSTITUCION

- `id_institucion`: PK tecnica.
- `id_tipo_institucion`: FK a TIPO_INSTITUCION.
- `nombre`: nombre unico de la institucion.

## ACREDITACION_INSTITUCION

- `id_acreditacion`: PK tecnica.
- `id_institucion`: FK a INSTITUCION.
- `anio_referencia`: ano del snapshot de acreditacion.
- `estado`: ACREDITADA o NO ACREDITADA.
- `periodo`: periodo textual de acreditacion cuando existe.
- `anios_acreditacion`: cantidad de anos cuando existe.

## AREA_CONOCIMIENTO

- `id_area`: PK tecnica.
- `nombre`: nombre unico del area.

## DENOMINACION_CARRERA

- `id_denominacion`: PK tecnica.
- `id_area`: FK a AREA_CONOCIMIENTO.
- `nombre`: denominacion academica unica de la carrera, por ejemplo TRABAJO SOCIAL o INGENIERIA EN INFORMATICA.
- Dependencia funcional representada: `nombre -> id_area`.

## NIVEL_ESTUDIO

- `id_nivel_estudio`: PK tecnica.
- `nombre`: nivel de estudio general.

## NIVEL_CARRERA

- `id_nivel_carrera`: PK tecnica.
- `id_nivel_estudio`: FK a NIVEL_ESTUDIO.
- `nombre`: nivel especifico de carrera.
- Dependencia funcional representada: `nombre -> id_nivel_estudio`.

## MODALIDAD

- `id_modalidad`: PK tecnica.
- `nombre`: Presencial, Semipresencial o No Presencial.

## JORNADA

- `id_jornada`: PK tecnica.
- `nombre`: jornada de la oferta.

## CARRERA

- `id_carrera`: PK tecnica.
- `id_denominacion`: FK a DENOMINACION_CARRERA.
- `id_nivel_carrera`: FK a NIVEL_CARRERA.
- Clave candidata: `(id_denominacion, id_nivel_carrera)`.
- Representa una denominacion academica en un nivel concreto. El nombre y el area no se repiten en esta tabla.

## OFERTA_ACADEMICA

- `id_oferta`: PK tecnica.
- `id_institucion`: FK a INSTITUCION.
- `id_carrera`: FK a CARRERA.
- `id_comuna`: FK a COMUNA.
- `id_modalidad`: FK a MODALIDAD.
- `id_jornada`: FK a JORNADA.
- Clave candidata: `(id_institucion, id_carrera, id_comuna, id_modalidad, id_jornada)`.

## TIPO_PLAN

- `id_tipo_plan`: PK tecnica.
- `nombre`: tipo de plan de carrera.

## PLAN_OFERTA

- `id_plan_oferta`: PK tecnica.
- `id_oferta`: FK a OFERTA_ACADEMICA.
- `id_tipo_plan`: FK a TIPO_PLAN.
- `duracion_plan`: semestres de plan de estudio.
- `duracion_titulacion`: semestres del proceso de titulacion.
- `duracion_total`: duracion total informada por la fuente.
- `valor_matricula`: valor de matricula en pesos, puede ser cero.
- `valor_arancel`: valor de arancel en pesos, puede ser cero.

## REQUISITO_INGRESO

- `id_requisito_ingreso`: PK tecnica.
- `nombre`: requisito de ingreso normalizado.

## VIA_INGRESO

- `id_via_ingreso`: PK tecnica.
- `nombre`: via de ingreso normalizada.

## MATRICULA_HISTORICA

- `id_matricula`: PK tecnica.
- `id_registro_fuente`: ID unico proveniente del dataset.
- `id_plan_oferta`: FK a PLAN_OFERTA.
- `id_requisito_ingreso`: FK a REQUISITO_INGRESO.
- `id_via_ingreso`: FK a VIA_INGRESO.
- `genero`: Femenino o Masculino.
- `edad`: edad informada por el registro.
- `anio_ingreso`: ano de ingreso.
- `semestre_ingreso`: Primer semestre o Segundo semestre.

## STAGING_MATRICULA

Tabla tecnica de recepcion de la fuente plana. No forma parte del DER normalizado ni de las 19 tablas de negocio. Sus 28 columnas se mantienen como texto para validar el contenido antes de aplicar conversiones y restricciones del modelo final.
