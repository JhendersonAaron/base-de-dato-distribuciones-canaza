
  create view "canaza_dw"."marts_staging"."stg_producto__dbt_tmp"
    
    
  as (
    select
    id_producto,
    cod_interno,
    descripcion,
    cod_unidad_med,
    costo_compra,
    precio_venta,
    precio_venta_igv,
    id_categoria,
    stock_actual
from raw.producto
  );