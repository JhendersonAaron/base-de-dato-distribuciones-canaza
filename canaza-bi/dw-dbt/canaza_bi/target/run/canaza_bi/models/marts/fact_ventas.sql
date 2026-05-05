
  
    

  create  table "canaza_dw"."marts"."fact_ventas__dbt_tmp"
  
  
    as
  
  (
    with comprobantes as (
    select
        id_comprobante,
        fecha_emision,
        cod_tipo_cpe,
        id_entidad,
        anulado
    from "canaza_dw"."staging"."stg_comprobante"
),
comprobante_detalles as (
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
    from "canaza_dw"."staging"."stg_comprobante_detalle"
),
dim_fecha as (
    select
        fecha_key,
        fecha
    from "canaza_dw"."marts"."dim_fecha"
),
dim_entidad as (
    select
        entidad_key,
        id_entidad
    from "canaza_dw"."marts"."dim_entidad"
),
dim_producto as (
    select
        producto_key,
        id_producto
    from "canaza_dw"."marts"."dim_producto"
),
dim_tipo_cpe as (
    select
        tipo_cpe_key,
        cod_tipo_cpe
    from "canaza_dw"."marts"."dim_tipo_cpe"
)

select
    df.fecha_key,
    de.entidad_key,
    dp.producto_key,
    dtc.tipo_cpe_key,
    c.id_comprobante,
    cd.id_detalle,
    cd.id_producto,
    cd.cantidad,
    cd.precio_unit_sinigv,
    cd.costo_unit,
    cd.subtotal_sinigv                                          as venta_bruta,
    cd.igv_linea,
    cd.subtotal_conigv                                          as venta_neta,
    coalesce(cd.costo_unit * cd.cantidad, 0)                    as costo_total,
    cd.subtotal_sinigv
        - coalesce(cd.costo_unit * cd.cantidad, 0)              as margen_bruto,
    case
        when cd.subtotal_sinigv = 0 then null
        else (
            cd.subtotal_sinigv
            - coalesce(cd.costo_unit * cd.cantidad, 0)
        ) / cd.subtotal_sinigv
    end                                                         as pct_margen_bruto,
    1                                                           as comprobante_count
from comprobante_detalles cd
inner join comprobantes c
    on cd.id_comprobante = c.id_comprobante
inner join dim_fecha df
    on c.fecha_emision::date = df.fecha
inner join dim_entidad de
    on c.id_entidad = de.id_entidad
inner join dim_producto dp
    on cd.id_producto = dp.id_producto
inner join dim_tipo_cpe dtc
    on c.cod_tipo_cpe = dtc.cod_tipo_cpe
  );
  