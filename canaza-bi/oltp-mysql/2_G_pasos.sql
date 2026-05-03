-- =========================================
-- 2_G_pasos.sql
-- Construccion pedagogica de la vista G
-- Distribuciones Canaza E.I.R.L.
-- =========================================
-- Este archivo es pedagogico. Su objetivo es
-- mostrar paso a paso como se construye la
-- logica de integracion que termina en vw_g_ventas.
-- Para el ETL completo usa 3_poblar.sql

USE canaza_oltp;
SET lc_time_names = 'es_ES';
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ==========================================================
-- PASO 1. Ver las fuentes del negocio
-- ==========================================================
SELECT * FROM comprobante LIMIT 5;
SELECT * FROM comprobante_detalle LIMIT 5;
SELECT * FROM entidad LIMIT 5;
SELECT * FROM producto LIMIT 5;
SELECT * FROM categoria;

-- ==========================================================
-- PASO 2. METRICA BASE: venta_neta por linea
-- ==========================================================
-- El grano es: una linea de comprobante por producto
-- Cada fila de comprobante_detalle = 1 fila en el hecho

SELECT
    c.id_comprobante,
    cd.id_producto,
    c.id_entidad,
    c.cod_tipo_cpe,
    DATE(c.fecha_emision)   AS fecha,
    cd.cantidad,
    cd.subtotal_sinigv      AS venta_bruta,
    cd.igv_linea,
    cd.subtotal_conigv      AS venta_neta
FROM comprobante c
JOIN comprobante_detalle cd ON c.id_comprobante = cd.id_comprobante
WHERE c.anulado = 0
LIMIT 10;

-- ==========================================================
-- PASO 3. Agregar costo y margen bruto
-- ==========================================================
-- margen_bruto = venta_bruta - costo_total
-- costo_total  = costo_unit * cantidad

SELECT
    c.id_comprobante,
    cd.id_producto,
    c.id_entidad,
    c.cod_tipo_cpe,
    DATE(c.fecha_emision)                          AS fecha,
    cd.cantidad,
    cd.subtotal_sinigv                             AS venta_bruta,
    cd.igv_linea,
    cd.subtotal_conigv                             AS venta_neta,
    COALESCE(cd.costo_unit * cd.cantidad, 0)       AS costo_total,
    cd.subtotal_sinigv
        - COALESCE(cd.costo_unit * cd.cantidad, 0) AS margen_bruto
FROM comprobante c
JOIN comprobante_detalle cd ON c.id_comprobante = cd.id_comprobante
WHERE c.anulado = 0
LIMIT 10;

-- ==========================================================
-- PASO 4. Agregar contexto de producto y categoria
-- ==========================================================

SELECT
    c.id_comprobante,
    cd.id_producto,
    p.descripcion                                  AS nombre_producto,
    cat.desc_categoria                             AS nombre_categoria,
    c.id_entidad,
    c.cod_tipo_cpe,
    DATE(c.fecha_emision)                          AS fecha,
    cd.cantidad,
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
WHERE c.anulado = 0
LIMIT 10;

-- ==========================================================
-- PASO 5. Esa consulta completa ES la vista G
-- Ahora la creamos oficialmente
-- ==========================================================

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

-- Validar la vista G
SELECT * FROM vw_g_ventas LIMIT 20;

-- La cantidad de filas de G debe coincidir con
-- comprobante_detalle (solo comprobantes no anulados)
SELECT
    (SELECT COUNT(*) FROM vw_g_ventas)          AS total_g,
    (SELECT COUNT(*) FROM comprobante_detalle
     WHERE id_comprobante IN (
         SELECT id_comprobante FROM comprobante WHERE anulado = 0
     ))                                          AS total_detalle;