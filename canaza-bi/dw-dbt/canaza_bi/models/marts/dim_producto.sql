select
    row_number() over (order by p.id_producto) as producto_key,
    p.id_producto,
    p.cod_interno,
    p.descripcion,
    p.cod_unidad_med,
    p.costo_compra,
    p.precio_venta,
    c.id_categoria,
    c.cod_categoria,
    c.desc_categoria
from {{ ref('stg_producto') }} p
left join {{ ref('stg_categoria') }} c
    on p.id_categoria = c.id_categoria