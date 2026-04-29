-- ====================================================
-- SCRIPT 01: CREAR BASE DE DATOS OLTP
-- Distribuciones Canaza — MySQL Workbench
-- ====================================================
CREATE DATABASE IF NOT EXISTS canaza_oltp
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE canaza_oltp;

-- 1. tipo_documento
CREATE TABLE IF NOT EXISTS tipo_documento (
  cod_tipo_doc  CHAR(1)     PRIMARY KEY,
  desc_tipo_doc VARCHAR(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT IGNORE INTO tipo_documento VALUES
  ('6','RUC'),('1','DNI'),('-','VARIOS / VENTAS MENORES'),
  ('4','CARNET DE EXTRANJERIA'),('7','PASAPORTE'),
  ('A','CEDULA DIPLOMATICA'),('0','NO DOMICILIADO SIN RUC');

-- 2. tipo_comprobante
CREATE TABLE IF NOT EXISTS tipo_comprobante (
  cod_tipo_cpe  CHAR(2)     PRIMARY KEY,
  desc_tipo_cpe VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT IGNORE INTO tipo_comprobante VALUES
  ('01','FACTURA'),('03','BOLETA DE VENTA'),
  ('07','NOTA DE CREDITO'),('08','NOTA DE DEBITO');

-- 3. categoria
CREATE TABLE IF NOT EXISTS categoria (
  id_categoria   INT AUTO_INCREMENT PRIMARY KEY,
  cod_categoria  VARCHAR(20)  NOT NULL,
  desc_categoria VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. entidad
CREATE TABLE IF NOT EXISTS entidad (
  id_entidad      INT AUTO_INCREMENT PRIMARY KEY,
  cod_tipo_doc    CHAR(1)      NOT NULL,
  nro_documento   VARCHAR(20)  NOT NULL,
  denominacion    VARCHAR(200) NOT NULL,
  razon_comercial VARCHAR(200),
  direccion       VARCHAR(300),
  email           VARCHAR(100),
  telefono        VARCHAR(30),
  UNIQUE KEY uq_ent(cod_tipo_doc,nro_documento),
  FOREIGN KEY(cod_tipo_doc) REFERENCES tipo_documento(cod_tipo_doc)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. producto
CREATE TABLE IF NOT EXISTS producto (
  id_producto       INT AUTO_INCREMENT PRIMARY KEY,
  cod_interno       VARCHAR(30)   NOT NULL,
  descripcion       VARCHAR(300)  NOT NULL,
  cod_unidad_med    VARCHAR(10)   DEFAULT 'NIU',
  costo_compra      DECIMAL(12,4),
  precio_venta      DECIMAL(12,4),
  precio_venta_igv  DECIMAL(12,4),
  id_categoria      INT,
  stock_actual      DECIMAL(12,3) DEFAULT 0,
  UNIQUE KEY uq_cod(cod_interno),
  FOREIGN KEY(id_categoria) REFERENCES categoria(id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. comprobante
CREATE TABLE IF NOT EXISTS comprobante (
  id_comprobante  INT AUTO_INCREMENT PRIMARY KEY,
  fecha_emision   DATE         NOT NULL,
  fecha_vcto      DATE,
  cod_tipo_cpe    CHAR(2)      NOT NULL,
  serie           VARCHAR(10)  NOT NULL,
  numero          VARCHAR(20)  NOT NULL,
  id_entidad      INT          NOT NULL,
  ruc_dni         VARCHAR(20),
  denominacion    VARCHAR(200),
  moneda          VARCHAR(3)   DEFAULT 'PEN',
  mto_gravada     DECIMAL(12,2) DEFAULT 0,
  mto_igv         DECIMAL(12,2) DEFAULT 0,
  mto_descuento   DECIMAL(12,2) DEFAULT 0,
  mto_total       DECIMAL(12,2) NOT NULL DEFAULT 0,
  pagado          TINYINT(1)   DEFAULT 0,
  forma_pago      VARCHAR(50),
  detalle_items   TEXT,
  anulado         TINYINT(1)   DEFAULT 0,
  UNIQUE KEY uq_cpe(cod_tipo_cpe,serie,numero),
  FOREIGN KEY(cod_tipo_cpe) REFERENCES tipo_comprobante(cod_tipo_cpe),
  FOREIGN KEY(id_entidad)   REFERENCES entidad(id_entidad),
  INDEX idx_fecha(fecha_emision)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. comprobante_detalle
CREATE TABLE IF NOT EXISTS comprobante_detalle (
  id_detalle         INT AUTO_INCREMENT PRIMARY KEY,
  id_comprobante     INT           NOT NULL,
  id_producto        INT           NOT NULL,
  cantidad           DECIMAL(12,3) NOT NULL DEFAULT 1,
  precio_unit_sinigv DECIMAL(12,4) NOT NULL,
  costo_unit         DECIMAL(12,4) DEFAULT 0,
  subtotal_sinigv    DECIMAL(12,2) NOT NULL,
  igv_linea          DECIMAL(12,2) DEFAULT 0,
  subtotal_conigv    DECIMAL(12,2) NOT NULL,
  FOREIGN KEY(id_comprobante) REFERENCES comprobante(id_comprobante),
  FOREIGN KEY(id_producto)    REFERENCES producto(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT table_name AS tablas_creadas FROM information_schema.tables
WHERE table_schema='canaza_oltp' ORDER BY table_name;