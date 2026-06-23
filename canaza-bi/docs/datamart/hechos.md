# Tabla de Hechos: fact_ventas

## Conexiones con dimensiones

| Clave foránea | Dimensión |
|---------------|-----------|
| fecha_key | dim_fecha |
| entidad_key | dim_entidad |
| producto_key | dim_producto |
| tipo_cpe_key | dim_tipo_cpe |

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