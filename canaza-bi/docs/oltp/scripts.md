# Scripts SQL del DataMart Manual (Sesión 6)

## Orden de ejecución

1. `1_dm.sql` — Crea las tablas dim_* y fact_ventas
2. `2_G_pasos.sql` — Vista pedagógica G paso a paso
3. `3_poblar.sql` — ETL manual: carga dimensiones y fact_ventas

## Script principal: 1_dm.sql

Crea las siguientes tablas dentro de `canaza_oltp`:

- `dim_entidad` — clientes con flag es_empresa
- `dim_producto` — productos con categoría denormalizada
- `dim_fecha` — fechas con atributos de calendario
- `dim_tipo_cpe` — tipos de comprobante
- `fact_ventas` — grano: una fila por id_detalle

## Vista integradora: vw_g_ventas

Integra comprobante + comprobante_detalle + producto + categoria.
Filtra `WHERE anulado = 0` (MySQL).
Calcula venta_bruta, venta_neta, costo_total, margen_bruto, pct_margen_bruto.

## Validación

```sql
SELECT COUNT(*) FROM fact_ventas;
-- Resultado esperado: 1,523+

SELECT ROUND(SUM(venta_neta), 2) FROM fact_ventas;
-- Resultado esperado: S/ 1,369,313.54
```