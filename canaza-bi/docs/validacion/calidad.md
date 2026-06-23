# Tests de Calidad de Datos

## Resultado de dbt test

**PASS=30 WARN=0 ERROR=0**

## Hallazgos detectados y corregidos

### Hallazgo 1: Boolean vs TINYINT
- **Problema:** `anulado = 0` fallaba en PostgreSQL porque el campo es boolean
- **Causa:** Airbyte convierte TINYINT de MySQL a boolean en PostgreSQL
- **Solución:** Cambiar a `WHERE anulado = false` en `stg_comprobante`

### Hallazgo 2: Grano de fact_ventas
- **Problema:** 11 duplicados por id_comprobante + id_producto
- **Causa:** En Canaza es válido tener el mismo producto dos veces en un comprobante con precios distintos
- **Solución:** Cambiar el grano del test a id_detalle (único en el OLTP)

## Comparación OLTP vs DataMart

| Métrica | OLTP MySQL | DataMart PG | ¿Coincide? |
|---------|-----------|-------------|------------|
| Ventas netas | S/ 1,369,313.54  | S/ 1,369,313.54  | Sí |
| Líneas de detalle | 1,523 | 1,523 | Sí |
| Comprobantes | 1498 | 1498 | Sí |