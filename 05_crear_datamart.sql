-- ============================================================
-- SCRIPT 5: CREAR DATAMART - ESQUEMA ESTRELLA
-- Base de datos: canaza_datamart
-- ============================================================

CREATE DATABASE IF NOT EXISTS canaza_datamart
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE canaza_datamart;

-- ── DIMENSIÓN TIEMPO ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS d_tiempo (
    id_tiempo      INT          NOT NULL,  -- formato YYYYMMDD
    fecha          DATE         NOT NULL,
    dia            TINYINT      NOT NULL,
    dia_semana     TINYINT      NOT NULL,  -- 1=Lun 7=Dom
    nombre_dia     VARCHAR(15)  NOT NULL,
    semana_anio    TINYINT      NOT NULL,
    mes            TINYINT      NOT NULL,
    nombre_mes     VARCHAR(15)  NOT NULL,
    trimestre      TINYINT      NOT NULL,
    semestre       TINYINT      NOT NULL,
    anio           SMALLINT     NOT NULL,
    es_finde       TINYINT(1)   NOT NULL DEFAULT 0,
    PRIMARY KEY (id_tiempo),
    INDEX idx_fecha (fecha),
    INDEX idx_anio_mes (anio, mes)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── DIMENSIÓN PRODUCTO ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS d_producto (
    id_dim_producto  INT           NOT NULL AUTO_INCREMENT,
    id_producto_oltp INT           NOT NULL,
    cod_interno      VARCHAR(30),
    descripcion      VARCHAR(300)  NOT NULL,
    cod_unidad_med   VARCHAR(10),
    precio_venta     DECIMAL(12,4),
    costo_compra     DECIMAL(12,4),
    id_categoria     INT,
    cod_categoria    VARCHAR(20),
    desc_categoria   VARCHAR(100),
    -- SCD Tipo 2 (historial de cambios de precio)
    fecha_inicio     DATE         NOT NULL DEFAULT (CURRENT_DATE),
    fecha_fin        DATE,
    es_vigente       TINYINT(1)   NOT NULL DEFAULT 1,
    PRIMARY KEY (id_dim_producto),
    INDEX idx_oltp (id_producto_oltp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── DIMENSIÓN ENTIDAD (Clientes) ────────────────────────────
CREATE TABLE IF NOT EXISTS d_entidad (
    id_dim_entidad   INT           NOT NULL AUTO_INCREMENT,
    id_entidad_oltp  INT           NOT NULL,
    nro_documento    VARCHAR(20),
    denominacion     VARCHAR(200)  NOT NULL,
    desc_tipo_doc    VARCHAR(80),
    es_empresa       TINYINT(1)    DEFAULT 0,  -- 1=RUC(empresa) 0=DNI/otros
    direccion        VARCHAR(300),
    -- SCD Tipo 2
    fecha_inicio     DATE          NOT NULL DEFAULT (CURRENT_DATE),
    fecha_fin        DATE,
    es_vigente       TINYINT(1)    NOT NULL DEFAULT 1,
    PRIMARY KEY (id_dim_entidad),
    INDEX idx_oltp (id_entidad_oltp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── DIMENSIÓN TIPO COMPROBANTE ──────────────────────────────
CREATE TABLE IF NOT EXISTS d_tipo_cpe (
    id_tipo_cpe    INT          NOT NULL AUTO_INCREMENT,
    cod_tipo_cpe   CHAR(2)      NOT NULL,
    desc_tipo_cpe  VARCHAR(60)  NOT NULL,
    PRIMARY KEY (id_tipo_cpe),
    UNIQUE KEY uq_cod (cod_tipo_cpe)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── TABLA DE HECHOS: HVENTA ──────────────────────────────────
CREATE TABLE IF NOT EXISTS hventa (
    id_hecho           BIGINT        NOT NULL AUTO_INCREMENT,
    -- Claves foráneas a dimensiones
    id_tiempo          INT           NOT NULL,
    id_dim_producto    INT           NOT NULL,
    id_dim_entidad     INT           NOT NULL,
    id_tipo_cpe        INT           NOT NULL,
    -- Dimensión degenerada (número de comprobante)
    id_comprobante_oltp INT          NOT NULL,
    -- Medidas (facts)
    cantidad           DECIMAL(12,3) NOT NULL,
    precio_unit_sinigv DECIMAL(12,4),
    costo_unit         DECIMAL(12,4),
    mto_subtotal       DECIMAL(12,2) NOT NULL,
    mto_igv            DECIMAL(12,2) DEFAULT 0,
    mto_total_linea    DECIMAL(12,2) NOT NULL,
    margen_bruto       DECIMAL(12,2),  -- mto_subtotal - (costo_unit * cantidad)
    anulado            TINYINT(1)    DEFAULT 0,
    PRIMARY KEY (id_hecho),
    FOREIGN KEY (id_tiempo)       REFERENCES d_tiempo(id_tiempo),
    FOREIGN KEY (id_dim_producto) REFERENCES d_producto(id_dim_producto),
    FOREIGN KEY (id_dim_entidad)  REFERENCES d_entidad(id_dim_entidad),
    FOREIGN KEY (id_tipo_cpe)     REFERENCES d_tipo_cpe(id_tipo_cpe),
    INDEX idx_tiempo   (id_tiempo),
    INDEX idx_producto (id_dim_producto),
    INDEX idx_entidad  (id_dim_entidad),
    INDEX idx_tipo     (id_tipo_cpe)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── VERIFICAR ────────────────────────────────────────────────
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'canaza_datamart';