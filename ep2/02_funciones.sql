-- Funcion sin parametros, utilizable desde SELECT y desde PL/SQL.
CREATE OR REPLACE FUNCTION FN_EP2_TOTAL_MATRICULAS
RETURN NUMBER AUTHID DEFINER IS
  v_total NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_total FROM MATRICULA_HISTORICA;
  RETURN v_total;
END;
/
-- Funcion con parametros: umbrales pedagogicos, no categorias oficiales.
CREATE OR REPLACE FUNCTION FN_EP2_CLASIFICAR_ARANCEL(
  p_arancel IN NUMBER
) RETURN VARCHAR2 AUTHID DEFINER IS
BEGIN
  IF p_arancel IS NULL OR p_arancel < 0 THEN
    RAISE_APPLICATION_ERROR(-20101,'El arancel debe ser un numero no negativo');
  ELSIF p_arancel=0 THEN
    RETURN 'CERO / SIN INTERPRETAR';
  ELSIF p_arancel<1000000 THEN
    RETURN 'TRAMO 1';
  ELSIF p_arancel<3000000 THEN
    RETURN 'TRAMO 2';
  ELSE
    RETURN 'TRAMO 3';
  END IF;
END;
/
