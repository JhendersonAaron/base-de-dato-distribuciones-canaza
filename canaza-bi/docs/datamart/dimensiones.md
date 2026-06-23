# Dimensiones del DataMart

## dim_entidad

- **Clave:** entidad_key
- **es_empresa:** true si cod_tipo_doc = '6' (RUC)
- **Registros:** 2,200

## dim_producto

- **Clave:** producto_key
- **Categoría denormalizada:** desc_categoria incluida directamente
- **Registros:** 1,660

## dim_fecha

- **Clave:** fecha_key (formato YYYYMMDD)
- **Atributos:** dia, mes_numero, mes_desc, trimestre, anio
- **Registros:** 219+ fechas únicas

## dim_tipo_cpe

- **Clave:** tipo_cpe_key
- **Tipos:** Factura (01), Boleta (03), Nota Crédito (07), Nota Débito (08)
- **Registros:** 4