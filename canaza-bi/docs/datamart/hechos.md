# Tabla de Hechos: fact_ventas

`fact_ventas` es el hecho central del esquema estrella. Su grano es **una
fila por línea de comprobante**, identificada por `id_detalle`, y cubre el
período 2023–2026 con datos reales de Distribuciones Canaza E.I.R.L.

## Métricas calculadas

| Métrica | Cálculo | Descripción |
|---------|---------|-------------|
| cantidad | comprobante_detalle.cantidad | Unidades vendidas en la línea |
| venta_bruta | precio_unit_sinigv × cantidad | Venta antes de ajustes |
| venta_neta | subtotal_sinigv | Venta neta de la línea (campo origen) |
| costo_total | costo_unit × cantidad | Costo total de la línea |
| margen_bruto | venta_neta − costo_total | Ganancia bruta de la línea |
| pct_margen_bruto | margen_bruto / venta_neta | % de margen sobre la venta |
| comprobante_count | constante = 1 | Auxiliar para contar líneas/comprobantes |

## Conexiones con dimensiones

| Clave foránea | Dimensión |
|----------------|-----------|
| fecha_key | dim_fecha |
| entidad_key | dim_entidad |
| producto_key | dim_producto |
| tipo_cpe_key | dim_tipo_cpe |

## Por qué el grano es id_detalle

Durante la validación con `dbt test` se detectaron 11 combinaciones de
`id_comprobante` + `id_producto` duplicadas. Se confirmó que en Canaza es
válido que un mismo comprobante tenga el mismo producto dos veces con precios
distintos (por ejemplo, descuentos o presentaciones distintas en la misma
venta). Por eso el grano correcto es `id_detalle`, que es único en el OLTP —
ver el hallazgo completo en [Tests dbt](../dbt/tests.md#hallazgo-de-calidad-grano-de-fact_ventas).

## Validación

```sql
-- Total de filas
SELECT COUNT(*) FROM marts.fact_ventas;

-- Ventas netas totales
SELECT ROUND(SUM(venta_neta)::numeric, 2) FROM marts.fact_ventas;
-- Resultado: S/ 1,369,313.54

-- Margen bruto global
SELECT ROUND(SUM(margen_bruto)::numeric / NULLIF(SUM(venta_neta)::numeric, 0) * 100, 1)
FROM marts.fact_ventas;
-- Resultado: 31.8%
```

La conciliación completa de estos valores contra MySQL y Power BI está en
[Validación SQL vs Power BI](../validacion/sql_vs_pbi.md).
