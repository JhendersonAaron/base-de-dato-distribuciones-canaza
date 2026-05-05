
  create view "canaza_dw"."staging"."stg_producto__dbt_tmp"
    
    
  as (
    with productos as (
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
),
categorias as (
    select
        id_categoria,
        cod_categoria,
        desc_categoria
    from raw.categoria
)

select
    p.id_producto,
    p.cod_interno,
    trim(p.descripcion) as descripcion,
    p.cod_unidad_med,
    p.costo_compra,
    p.precio_venta,
    p.precio_venta_igv,
    p.stock_actual,
    c.id_categoria,
    c.cod_categoria,
    c.desc_categoria
from productos p
left join categorias c
    on p.id_categoria = c.id_categoria
  );