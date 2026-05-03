-- =========================================
-- 1_dm.sql
-- Implementacion fisica del DataMart
-- Distribuciones Canaza E.I.R.L.
-- dentro de la misma base canaza_oltp
-- =========================================

USE canaza_oltp;
SET lc_time_names = 'es_ES';

-- dim_entidad (clientes de Canaza: empresas con RUC y personas con DNI)
CREATE TABLE IF NOT EXISTS dim_entidad (
    entidad_key     INT AUTO_INCREMENT,
    id_entidad      INT NOT NULL,
    nro_documento   VARCHAR(20) NOT NULL,
    denominacion    VARCHAR(200) NOT NULL,
    desc_tipo_doc   VARCHAR(80),
    es_empresa      TINYINT(1) DEFAULT 0,
    PRIMARY KEY (entidad_key),
    UNIQUE KEY uk_dim_entidad_id (id_entidad)
);

-- dim_producto (productos de utiles de oficina y escolares)
CREATE TABLE IF NOT EXISTS dim_producto (
    producto_key    INT AUTO_INCREMENT,
    id_producto     INT NOT NULL,
    cod_interno     VARCHAR(30),
    descripcion     VARCHAR(300) NOT NULL,
    cod_unidad_med  VARCHAR(10),
    costo_compra    DECIMAL(12,4),
    precio_venta    DECIMAL(12,4),
    id_categoria    INT,
    cod_categoria   VARCHAR(20),
    desc_categoria  VARCHAR(100),
    PRIMARY KEY (producto_key),
    UNIQUE KEY uk_dim_producto_id (id_producto)
);

-- dim_fecha (fechas de emision de comprobantes)
CREATE TABLE IF NOT EXISTS dim_fecha (
    fecha_key       INT NOT NULL,
    fecha           DATE NOT NULL,
    dia             INT NOT NULL,
    dia_semana_desc VARCHAR(20) NOT NULL,
    mes             INT NOT NULL,
    mes_desc        VARCHAR(20) NOT NULL,
    trimestre       INT NOT NULL,
    anio            INT NOT NULL,
    PRIMARY KEY (fecha_key)
);

-- dim_tipo_cpe (tipo de comprobante: factura, boleta, etc.)
CREATE TABLE IF NOT EXISTS dim_tipo_cpe (
    tipo_cpe_key    INT AUTO_INCREMENT,
    cod_tipo_cpe    CHAR(2) NOT NULL,
    desc_tipo_cpe   VARCHAR(60) NOT NULL,
    PRIMARY KEY (tipo_cpe_key),
    UNIQUE KEY uk_dim_tipo_cpe (cod_tipo_cpe)
);

-- fact_ventas (tabla de hechos central de Canaza)
-- Grano: una fila por linea de comprobante por producto
CREATE TABLE IF NOT EXISTS fact_ventas (
    fact_venta_key      BIGINT AUTO_INCREMENT,
    id_comprobante      INT NOT NULL,
    fecha_key           INT NOT NULL,
    entidad_key         INT NOT NULL,
    producto_key        INT NOT NULL,
    tipo_cpe_key        INT NOT NULL,
    cantidad            DECIMAL(12,3) NOT NULL,
    precio_unit_sinigv  DECIMAL(12,4),
    costo_unit          DECIMAL(12,4),
    venta_bruta         DECIMAL(12,2) NOT NULL,
    igv_linea           DECIMAL(12,2) DEFAULT 0,
    venta_neta          DECIMAL(12,2) NOT NULL,
    costo_total         DECIMAL(12,2),
    margen_bruto        DECIMAL(12,2),
    pct_margen_bruto    DECIMAL(9,4),
    comprobante_count   INT NOT NULL DEFAULT 1,
    PRIMARY KEY (fact_venta_key),
    KEY idx_fact_fecha    (fecha_key),
    KEY idx_fact_entidad  (entidad_key),
    KEY idx_fact_producto (producto_key),
    KEY idx_fact_tipo     (tipo_cpe_key)
);

-- Validar
SHOW TABLES LIKE 'dim_%';
SHOW TABLES LIKE 'fact_%';
DESCRIBE dim_producto;
DESCRIBE fact_ventas;