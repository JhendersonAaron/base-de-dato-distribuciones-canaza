# Modelos Marts

Los modelos marts materializan tablas físicas en el schema `marts`.

## Ejecutar

```bash
dbt run --select +marts
```

## Modelos

| Tabla | Filas | Descripción |
|-------|-------|-------------|
| dim_entidad | 2,200 | Clientes con flag es_empresa |
| dim_producto | 1,660 | Productos con categoría denormalizada |
| dim_fecha | 219+ | Fechas únicas con atributos de calendario |
| dim_tipo_cpe | 4 | Tipos de comprobante |
| fact_ventas | 1,523+ | Hecho con métricas por línea de detalle |

## Grano de fact_ventas

**Una fila por id_detalle** (no por id_comprobante + id_producto).
Esto es porque en Canaza el mismo producto puede aparecer dos veces 
en un comprobante con precios distintos.