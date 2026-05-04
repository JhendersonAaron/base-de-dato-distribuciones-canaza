select
    row_number() over (order by c.id_comprobante, cd.id_producto) as fact_venta_key,
    c.id_comprobante,
    df.fecha_key,
    de.entidad_key,
    dp.producto_key,
    dtc.tipo_cpe_key,
    cd.cantidad,
    cd.precio_unit_sinigv,
    cd.costo_unit,
    cd.subtotal_sinigv                                         as venta_bruta,
    cd.igv_linea,
    cd.subtotal_conigv                                         as venta_neta,
    coalesce(cd.costo_unit * cd.cantidad, 0)                   as costo_total,
    cd.subtotal_sinigv
        - coalesce(cd.costo_unit * cd.cantidad, 0)             as margen_bruto,
    case
        when cd.subtotal_sinigv = 0 then 0
        else (cd.subtotal_sinigv
              - coalesce(cd.costo_unit * cd.cantidad, 0))
             / cd.subtotal_sinigv
    end                                                        as pct_margen_bruto,
    1                                                          as comprobante_count
from "canaza_dw"."marts_staging"."stg_comprobante" c
join "canaza_dw"."marts_staging"."stg_comprobante_detalle" cd
    on c.id_comprobante = cd.id_comprobante
join "canaza_dw"."marts_marts"."dim_fecha" df
    on c.fecha_emision = df.fecha
join "canaza_dw"."marts_marts"."dim_producto" dp
    on cd.id_producto = dp.id_producto
join "canaza_dw"."marts_marts"."dim_entidad" de
    on c.id_entidad = de.id_entidad
join "canaza_dw"."marts_marts"."dim_tipo_cpe" dtc
    on c.cod_tipo_cpe = dtc.cod_tipo_cpe