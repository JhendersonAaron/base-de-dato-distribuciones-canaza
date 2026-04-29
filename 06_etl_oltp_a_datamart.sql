	-- ============================================================
-- SCRIPT 6: ETL - POBLAR EL DATAMART DESDE LA OLTP
-- Ejecutar en MySQL Workbench
-- Primero ejecutar los scripts 1-5 y verificar datos en OLTP
-- ============================================================

USE canaza_datamart;

-- ── PASO 1: POBLAR D_TIPO_CPE ─────────────────────────────
TRUNCATE TABLE hventa;
TRUNCATE TABLE d_tipo_cpe;

INSERT INTO d_tipo_cpe (cod_tipo_cpe, desc_tipo_cpe)
SELECT cod_tipo_cpe, desc_tipo_cpe
FROM canaza_oltp.tipo_comprobante;

SELECT 'D_TIPO_CPE' AS dimension, COUNT(*) AS filas FROM d_tipo_cpe;

-- ── PASO 2: POBLAR D_TIEMPO (2024-2027) ──────────────────
TRUNCATE TABLE d_tiempo;

-- Generar serie de fechas con procedimiento almacenado
DROP PROCEDURE IF EXISTS sp_poblar_tiempo;

DELIMITER $$
CREATE PROCEDURE sp_poblar_tiempo()
BEGIN
    DECLARE v_fecha DATE DEFAULT '2024-01-01';
    DECLARE v_fin   DATE DEFAULT '2027-12-31';
    DECLARE v_dsem  INT;
    DECLARE v_nombres_mes VARCHAR(15);
    DECLARE v_nombres_dia VARCHAR(15);

    WHILE v_fecha <= v_fin DO
        SET v_dsem = DAYOFWEEK(v_fecha);  -- 1=Dom, 2=Lun...7=Sab en MySQL

        SET v_nombres_mes = ELT(MONTH(v_fecha),
            'Enero','Febrero','Marzo','Abril','Mayo','Junio',
            'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');

        SET v_nombres_dia = ELT(v_dsem,
            'Domingo','Lunes','Martes','Miercoles',
            'Jueves','Viernes','Sabado');

        INSERT IGNORE INTO d_tiempo (
            id_tiempo, fecha, dia, dia_semana, nombre_dia,
            semana_anio, mes, nombre_mes, trimestre, semestre,
            anio, es_finde
        ) VALUES (
            DATE_FORMAT(v_fecha, '%Y%m%d') + 0,
            v_fecha,
            DAY(v_fecha),
            v_dsem,
            v_nombres_dia,
            WEEK(v_fecha, 1),
            MONTH(v_fecha),
            v_nombres_mes,
            QUARTER(v_fecha),
            IF(MONTH(v_fecha) <= 6, 1, 2),
            YEAR(v_fecha),
            IF(v_dsem IN (1, 7), 1, 0)
        );

        SET v_fecha = DATE_ADD(v_fecha, INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

CALL sp_poblar_tiempo();
SELECT 'D_TIEMPO' AS dimension, COUNT(*) AS filas FROM d_tiempo;

-- ── PASO 3: POBLAR D_PRODUCTO ─────────────────────────────
TRUNCATE TABLE d_producto;

INSERT INTO d_producto (
    id_producto_oltp, cod_interno, descripcion, cod_unidad_med,
    precio_venta, costo_compra,
    id_categoria, cod_categoria, desc_categoria,
    fecha_inicio, es_vigente
)
SELECT
    p.id_producto,
    p.cod_interno,
    p.descripcion,
    p.cod_unidad_med,
    p.precio_venta,
    p.costo_compra,
    p.id_categoria,
    c.cod_categoria,
    c.desc_categoria,
    CURDATE(),
    1
FROM canaza_oltp.producto p
LEFT JOIN canaza_oltp.categoria c ON p.id_categoria = c.id_categoria;

SELECT 'D_PRODUCTO' AS dimension, COUNT(*) AS filas FROM d_producto;

-- ── PASO 4: POBLAR D_ENTIDAD ──────────────────────────────
TRUNCATE TABLE d_entidad;

INSERT INTO d_entidad (
    id_entidad_oltp, nro_documento, denominacion,
    desc_tipo_doc, es_empresa, direccion,
    fecha_inicio, es_vigente
)
SELECT
    e.id_entidad,
    e.nro_documento,
    e.denominacion,
    td.desc_tipo_doc,
    IF(e.cod_tipo_doc = '6', 1, 0),  -- RUC = empresa
    e.direccion,
    CURDATE(),
    1
FROM canaza_oltp.entidad e
JOIN canaza_oltp.tipo_documento td ON e.cod_tipo_doc = td.cod_tipo_doc;

SELECT 'D_ENTIDAD' AS dimension, COUNT(*) AS filas FROM d_entidad;

-- ── PASO 5: POBLAR HVENTA (tabla de hechos) ───────────────
-- Join entre comprobante + detalle + dimensiones del DataMart

INSERT INTO hventa (
    id_tiempo,
    id_dim_producto,
    id_dim_entidad,
    id_tipo_cpe,
    id_comprobante_oltp,
    cantidad,
    precio_unit_sinigv,
    costo_unit,
    mto_subtotal,
    mto_igv,
    mto_total_linea,
    margen_bruto,
    anulado
)
SELECT
    DATE_FORMAT(c.fecha_emision, '%Y%m%d') + 0  AS id_tiempo,
    dp.id_dim_producto,
    de.id_dim_entidad,
    dtc.id_tipo_cpe,
    c.id_comprobante,
    cd.cantidad,
    cd.precio_unit_sinigv,
    cd.costo_unit,
    cd.subtotal_sinigv,
    cd.igv_linea,
    cd.subtotal_conigv,
    ROUND(cd.subtotal_sinigv - (cd.costo_unit * cd.cantidad), 2)  AS margen_bruto,
    c.anulado
FROM canaza_oltp.comprobante c
JOIN canaza_oltp.comprobante_detalle cd ON c.id_comprobante = cd.id_comprobante
JOIN d_producto dp  ON dp.id_producto_oltp = cd.id_producto  AND dp.es_vigente = 1
JOIN d_entidad  de  ON de.id_entidad_oltp  = c.id_entidad    AND de.es_vigente = 1
JOIN d_tipo_cpe dtc ON dtc.cod_tipo_cpe    = c.cod_tipo_cpe
WHERE c.anulado = 0;

-- ── PASO 6: VERIFICAR TODO ────────────────────────────────
SELECT 'd_tiempo'   AS tabla, COUNT(*) AS filas FROM d_tiempo
UNION ALL SELECT 'd_producto',  COUNT(*) FROM d_producto
UNION ALL SELECT 'd_entidad',   COUNT(*) FROM d_entidad
UNION ALL SELECT 'd_tipo_cpe',  COUNT(*) FROM d_tipo_cpe
UNION ALL SELECT 'hventa',      COUNT(*) FROM hventa;

-- ── PASO 7: VALIDAR KPIs ──────────────────────────────────

-- KPI 1: Ventas por año
SELECT t.anio,
       COUNT(DISTINCT h.id_comprobante_oltp) AS n_comprobantes,
       ROUND(SUM(h.mto_total_linea), 2)      AS ventas_total
FROM hventa h
JOIN d_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.anio ORDER BY t.anio;

-- KPI 2: Top 10 productos por ingreso
SELECT p.descripcion,
       ROUND(SUM(h.mto_total_linea), 2) AS total_vendido
FROM hventa h
JOIN d_producto p ON h.id_dim_producto = p.id_dim_producto
GROUP BY p.descripcion
ORDER BY total_vendido DESC LIMIT 10;

-- KPI 3: Empresa vs Persona Natural
SELECT IF(e.es_empresa=1,'Empresa (RUC)','Persona (DNI/Otros)') AS tipo_cliente,
       COUNT(DISTINCT h.id_comprobante_oltp) AS n_comp,
       ROUND(SUM(h.mto_total_linea), 2)      AS ventas_total
FROM hventa h
JOIN d_entidad e ON h.id_dim_entidad = e.id_dim_entidad
GROUP BY e.es_empresa;

-- KPI 4: Ventas por tipo de comprobante
SELECT tc.desc_tipo_cpe,
       COUNT(DISTINCT h.id_comprobante_oltp) AS n_comprobantes,
       ROUND(SUM(h.mto_total_linea), 2)      AS total
FROM hventa h
JOIN d_tipo_cpe tc ON h.id_tipo_cpe = tc.id_tipo_cpe
GROUP BY tc.desc_tipo_cpe;

-- KPI 5: Margen bruto total
SELECT
    ROUND(SUM(mto_subtotal), 2)  AS ventas_sin_igv,
    ROUND(SUM(mto_igv), 2)       AS total_igv,
    ROUND(SUM(mto_total_linea),2) AS ventas_con_igv,
    ROUND(SUM(margen_bruto), 2)  AS margen_bruto_total,
    CONCAT(ROUND(SUM(margen_bruto)/NULLIF(SUM(mto_subtotal),0)*100, 1),'%') AS pct_margen
FROM hventa;

