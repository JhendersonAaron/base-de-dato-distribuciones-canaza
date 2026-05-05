-- Validar grano: raw vs fact
SELECT COUNT(*) AS total_raw_detalle
FROM raw.comprobante_detalle
WHERE id_comprobante IN (
    SELECT id_comprobante FROM raw.comprobante WHERE anulado = 0
);

SELECT COUNT(*) AS total_fact
FROM marts.fact_ventas;

-- Validar ventas netas
SELECT ROUND(SUM(venta_neta)::numeric, 2) AS ventas_netas_dm
FROM marts.fact_ventas;

SELECT ROUND(SUM(cd.subtotal_sinigv)::numeric, 2) AS ventas_netas_raw
FROM raw.comprobante_detalle cd
JOIN raw.comprobante c ON cd.id_comprobante = c.id_comprobante
WHERE c.anulado = 0;