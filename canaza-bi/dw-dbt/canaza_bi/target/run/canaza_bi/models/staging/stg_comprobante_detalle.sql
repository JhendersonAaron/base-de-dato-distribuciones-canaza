
  create view "canaza_dw"."marts_staging"."stg_comprobante_detalle__dbt_tmp"
    
    
  as (
    select
    id_detalle,
    id_comprobante,
    id_producto,
    cantidad,
    precio_unit_sinigv,
    costo_unit,
    subtotal_sinigv,
    igv_linea,
    subtotal_conigv
from raw.comprobante_detalle
  );