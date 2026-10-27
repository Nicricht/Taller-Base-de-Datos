-- Trigger POR FILA: audita cambios reales de valor (OLD vs NEW).
CREATE OR REPLACE TRIGGER TRG_EP2_ARANCEL_FILA
AFTER UPDATE OF valor_arancel ON PLAN_OFERTA
FOR EACH ROW
WHEN (OLD.valor_arancel <> NEW.valor_arancel)
BEGIN
  INSERT INTO EP2_AUDITORIA_ARANCEL
    (id_plan_oferta,arancel_anterior,arancel_nuevo,usuario_bd)
  VALUES
    (:OLD.id_plan_oferta,:OLD.valor_arancel,:NEW.valor_arancel,
     SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
-- Trigger POR SENTENCIA: un registro por UPDATE, incluso si afecta cero filas.
CREATE OR REPLACE TRIGGER TRG_EP2_ARANCEL_SENTENCIA
AFTER UPDATE OF valor_arancel ON PLAN_OFERTA
BEGIN
  INSERT INTO EP2_AUDITORIA_SENTENCIA(operacion,usuario_bd)
  VALUES('UPDATE PLAN_OFERTA.VALOR_ARANCEL',SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
