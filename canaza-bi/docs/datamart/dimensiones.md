# Dimensiones del DataMart

## dim_entidad

- **Clave:** entidad_key
- **Origen:** stg_entidad + stg_tipo_documento
- **es_empresa:** true si cod_tipo_doc = '6' (RUC)
- **Campos:** denominacion, desc_tipo_doc, es_empresa, nro_documento
- **Registros:** 2,200

## dim_producto

- **Clave:** producto_key
- **Origen:** stg_producto (con categoría ya enriquecida vía LEFT JOIN)
- **Categoría denormalizada:** desc_categoria incluida directamente — no existe `dim_categoria` separada
- **Campos:** descripcion, costo_compra_referencia, precio_venta_referencia, desc_categoria
- **Registros:** 1,660

## dim_fecha

- **Clave:** fecha_key (formato YYYYMMDD)
- **Origen:** fechas únicas extraídas de stg_comprobante
- **Atributos:** dia, mes_numero, mes_desc, trimestre, anio, dia_semana_desc
- **Registros:** 219+ fechas únicas

## dim_tipo_cpe

- **Clave:** tipo_cpe_key (generada con `dense_rank()`)
- **Origen:** stg_tipo_comprobante
- **Tipos:** Factura (01), Boleta (03), Nota Crédito (07), Nota Débito (08)
- **Registros:** 4

Estas 4 dimensiones se conectan a `fact_ventas` con relaciones 1:* simples en
el [modelo semántico de Power BI](../powerbi/modelo.md), y `dim_fecha` y
`dim_producto` además forman las dos jerarquías del modelo (Calendario y
Producto Comercial).
