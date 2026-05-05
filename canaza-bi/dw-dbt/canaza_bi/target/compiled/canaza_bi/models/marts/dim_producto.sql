select
    id_producto                             as producto_key,
    id_producto,
    cod_interno,
    descripcion,
    cod_unidad_med,
    costo_compra                            as costo_compra_referencia,
    precio_venta                            as precio_venta_referencia,
    id_categoria,
    cod_categoria,
    desc_categoria
from "canaza_dw"."staging"."stg_producto"