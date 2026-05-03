-- =========================================
-- 3_poblar.sql
-- ETL manual del DataMart - Canaza
-- Bloques:
-- 1. Configuracion
-- 2. Carga de dimensiones
-- 3. Construccion de vw_g_ventas
-- 4. Carga de fact_ventas
-- 5. Validaciones finales
-- =========================================

-- =========================================
-- 1. CONFIGURACION
-- =========================================

USE canaza_oltp;
SET lc_time_names = 'es_ES';
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- =========================================
-- 2. CARGA DE DIMENSIONES
-- =========================================

-- Si necesitas recargar, limpia primero:
-- DELETE FROM fact_ventas;
-- DELETE FROM dim_tipo_cpe;
-- DELETE FROM dim_fecha;
-- DELETE FROM dim_producto;
-- DELETE FROM dim_entidad;

-- 2.1 dim_entidad
INSERT INTO dim_entidad (
    id_entidad, nro_documento, denominacion, desc_tipo_doc, es_empresa
)
SELECT
    e.id_entidad,
    e.nro_documento,
    e.denominacion,
    td.desc_tipo_doc,
    IF(e.cod_tipo_doc = '6', 1, 0)
FROM entidad e
JOIN tipo_documento td ON e.cod_tipo_doc = td.cod_tipo_doc;

SELECT * FROM dim_entidad LIMIT 10;

-- 2.2 dim_producto
INSERT INTO dim_producto (
    id_producto, cod_interno, descripcion, cod_unidad_med,
    costo_compra, precio_venta,
    id_categoria, cod_categoria, desc_categoria
)
SELECT
    p.id_producto,
    p.cod_interno,
    p.descripcion,
    p.cod_unidad_med,
    p.costo_compra,
    p.precio_venta,
    c.id_categoria,
    c.cod_categoria,
    c.desc_categoria
FROM producto p
LEFT JOIN categoria c ON p.id_categoria = c.id_categoria;

SELECT * FROM dim_producto LIMIT 20;

-- 2.3 dim_fecha
INSERT INTO dim_fecha (
    fecha_key, fecha, dia, dia_semana_desc,
    mes, mes_desc, trimestre, anio
)
SELECT
    CAST(DATE_FORMAT(c.fecha_emision, '%Y%m%d') AS UNSIGNED),
    DATE(c.fecha_emision),
    DAY(c.fecha_emision),
    DAYNAME(c.fecha_emision),
    MONTH(c.fecha_emision),
    MONTHNAME(c.fecha_emision),
    QUARTER(c.fecha_emision),
    YEAR(c.fecha_emision)
FROM comprobante c
GROUP BY DATE(c.fecha_emision)
ORDER BY DATE(c.fecha_emision);

SELECT * FROM dim_fecha;

-- 2.4 dim_tipo_cpe
INSERT INTO dim_tipo_cpe (cod_tipo_cpe, desc_tipo_cpe)
SELECT cod_tipo_cpe, desc_tipo_cpe
FROM tipo_comprobante;

SELECT * FROM dim_tipo_cpe;

-- =========================================
-- 3. CONSTRUCCION DE VW_G_VENTAS
-- =========================================
-- La vista G integra: comprobante + detalle + producto + categoria
-- Es la fuente inmediata para cargar fact_ventas

CREATE OR REPLACE VIEW vw_g_ventas AS
SELECT
    c.id_comprobante,
    cd.id_producto,
    c.id_entidad,
    c.cod_tipo_cpe,
    DATE(c.fecha_emision)                          AS fecha,
    c.anulado,
    p.cod_interno,
    p.descripcion                                  AS nombre_producto,
    cat.desc_categoria                             AS nombre_categoria,
    cd.cantidad,
    cd.precio_unit_sinigv,
    cd.costo_unit,
    cd.subtotal_sinigv                             AS venta_bruta,
    cd.igv_linea,
    cd.subtotal_conigv                             AS venta_neta,
    COALESCE(cd.costo_unit * cd.cantidad, 0)       AS costo_total,
    cd.subtotal_sinigv
        - COALESCE(cd.costo_unit * cd.cantidad, 0) AS margen_bruto,
    CASE
        WHEN cd.subtotal_sinigv = 0 THEN 0
        ELSE (cd.subtotal_sinigv
              - COALESCE(cd.costo_unit * cd.cantidad, 0))
             / cd.subtotal_sinigv
    END                                            AS pct_margen_bruto
FROM comprobante c
JOIN comprobante_detalle cd ON c.id_comprobante = cd.id_comprobante
JOIN producto p             ON cd.id_producto   = p.id_producto
LEFT JOIN categoria cat     ON p.id_categoria   = cat.id_categoria
WHERE c.anulado = 0;

-- =========================================
-- 4. CARGA DE FACT_VENTAS
-- =========================================

INSERT INTO fact_ventas (
    id_comprobante,
    fecha_key,
    entidad_key,
    producto_key,
    tipo_cpe_key,
    cantidad,
    precio_unit_sinigv,
    costo_unit,
    venta_bruta,
    igv_linea,
    venta_neta,
    costo_total,
    margen_bruto,
    pct_margen_bruto,
    comprobante_count
)
SELECT
    g.id_comprobante,
    df.fecha_key,
    de.entidad_key,
    dp.producto_key,
    dtc.tipo_cpe_key,
    g.cantidad,
    g.precio_unit_sinigv,
    g.costo_unit,
    g.venta_bruta,
    g.igv_linea,
    g.venta_neta,
    g.costo_total,
    g.margen_bruto,
    g.pct_margen_bruto,
    1 AS comprobante_count
FROM vw_g_ventas g
JOIN dim_fecha    df  ON g.fecha        = df.fecha
JOIN dim_entidad  de  ON g.id_entidad   = de.id_entidad
JOIN dim_producto dp  ON g.id_producto  = dp.id_producto
JOIN dim_tipo_cpe dtc ON g.cod_tipo_cpe = dtc.cod_tipo_cpe;

-- =========================================
-- 5. VALIDACIONES FINALES
-- =========================================

-- 5.1 Ver la vista G
SELECT * FROM vw_g_ventas LIMIT 20;

-- 5.2 Contar filas G vs detalle OLTP
SELECT
    (SELECT COUNT(*) FROM vw_g_ventas)    AS total_g,
    (SELECT COUNT(*) FROM comprobante_detalle
     WHERE id_comprobante IN (
         SELECT id_comprobante FROM comprobante WHERE anulado = 0
     ))                                    AS total_detalle;

-- 5.3 Ver fact_ventas
SELECT * FROM fact_ventas LIMIT 10;

-- 5.4 Contar filas fact vs detalle
SELECT
    (SELECT COUNT(*) FROM fact_ventas)    AS total_fact,
    (SELECT COUNT(*) FROM comprobante_detalle
     WHERE id_comprobante IN (
         SELECT id_comprobante FROM comprobante WHERE anulado = 0
     ))                                    AS total_detalle;

-- 5.5 KPI: Ventas netas desde el DataMart
SELECT ROUND(SUM(venta_neta), 2) AS ventas_netas_dm
FROM fact_ventas;

-- 5.6 KPI: Ventas netas desde el OLTP (deben coincidir)
SELECT ROUND(SUM(cd.subtotal_sinigv), 2) AS ventas_netas_oltp
FROM comprobante_detalle cd
JOIN comprobante c ON cd.id_comprobante = c.id_comprobante
WHERE c.anulado = 0;

-- 5.7 Validar que coinciden
SELECT
    g.venta_neta_g,
    f.venta_neta_fact,
    g.venta_neta_g - f.venta_neta_fact AS diferencia
FROM (
    SELECT ROUND(SUM(venta_neta), 2) AS venta_neta_g FROM vw_g_ventas
) AS g
CROSS JOIN (
    SELECT ROUND(SUM(venta_neta), 2) AS venta_neta_fact FROM fact_ventas
) AS f;

-- 5.8 Top productos por ventas (KPI de Canaza)
SELECT
    dp.descripcion,
    ROUND(SUM(fv.venta_neta), 2) AS ventas_netas
FROM fact_ventas fv
JOIN dim_producto dp ON fv.producto_key = dp.producto_key
GROUP BY dp.descripcion
ORDER BY ventas_netas DESC
LIMIT 10;

-- 5.9 Empresa (RUC) vs Persona (DNI) - KPI del brief de Canaza
SELECT
    IF(de.es_empresa = 1, 'CLIENTE VIP (RUC)', 'CLIENTE REGULAR (DNI)') AS tipo_cliente,
    COUNT(DISTINCT fv.id_comprobante) AS n_comprobantes,
    ROUND(SUM(fv.venta_neta), 2)      AS ventas_netas
FROM fact_ventas fv
JOIN dim_entidad de ON fv.entidad_key = de.entidad_key
GROUP BY de.es_empresa;

-- 5.10 Margen por categoria (KPI del brief de Canaza)
SELECT
    dp.desc_categoria,
    ROUND(SUM(fv.venta_neta), 2)   AS ventas_netas,
    ROUND(SUM(fv.margen_bruto), 2) AS margen_bruto,
    CONCAT(ROUND(
        SUM(fv.margen_bruto) / NULLIF(SUM(fv.venta_neta), 0) * 100, 1
    ), '%')                         AS pct_margen
FROM fact_ventas fv
JOIN dim_producto dp ON fv.producto_key = dp.producto_key
GROUP BY dp.desc_categoria
ORDER BY margen_bruto DESC;