SELECT c.nombre AS carrera,
       i.nombre AS institucion,
       co.nombre AS comuna,
       m.nombre AS modalidad,
       j.nombre AS jornada,
       po.valor_matricula,
       po.valor_arancel
FROM OFERTA_ACADEMICA o
JOIN CARRERA c ON c.id_carrera = o.id_carrera
JOIN INSTITUCION i ON i.id_institucion = o.id_institucion
JOIN COMUNA co ON co.id_comuna = o.id_comuna
JOIN MODALIDAD m ON m.id_modalidad = o.id_modalidad
JOIN JORNADA j ON j.id_jornada = o.id_jornada
JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
ORDER BY c.nombre, po.valor_arancel;

SELECT a.nombre AS area,
       COUNT(DISTINCT c.id_carrera) AS carreras,
       COUNT(DISTINCT o.id_oferta) AS ofertas,
       ROUND(AVG(po.valor_arancel), 0) AS arancel_promedio
FROM AREA_CONOCIMIENTO a
JOIN CARRERA c ON c.id_area = a.id_area
JOIN OFERTA_ACADEMICA o ON o.id_carrera = c.id_carrera
JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
GROUP BY a.nombre
ORDER BY ofertas DESC;

SELECT i.nombre AS institucion,
       COUNT(DISTINCT o.id_oferta) AS ofertas,
       ROUND(AVG(po.valor_arancel), 0) AS arancel_promedio
FROM INSTITUCION i
JOIN OFERTA_ACADEMICA o ON o.id_institucion = i.id_institucion
JOIN PLAN_OFERTA po ON po.id_oferta = o.id_oferta
GROUP BY i.nombre
ORDER BY ofertas DESC;
