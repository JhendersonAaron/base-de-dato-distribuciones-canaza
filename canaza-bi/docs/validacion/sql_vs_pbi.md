# Validación SQL vs Power BI

## Resultados comparados

| KPI | SQL DataMart | Power BI | Diferencia |
|-----|-------------|----------|------------|
| Ventas Netas | S/ 1,369,313.54 | S/ 1,369,313.54 | S/ 0.00 |
| Margen Bruto | S/ 321,276.81 | S/ 321,276 | ~S/ 0.00 |
| % Margen Bruto | 31.8% | 31.8% | 0% |
| Volumen de Gastos | 53.0% | 53.0% | 0% |
| Comprobantes | 1498 | 1498 | 0 |

## Consultas de validación

```sql
-- Ventas netas
SELECT ROUND(SUM(venta_neta)::numeric, 2) FROM marts.fact_ventas;

-- Margen bruto
SELECT ROUND(SUM(margen_bruto)::numeric, 2) FROM marts.fact_ventas;

-- % Margen
SELECT ROUND(SUM(margen_bruto)::numeric/NULLIF(SUM(venta_neta)::numeric,0)*100,1)
FROM marts.fact_ventas;

-- Comprobantes
SELECT COUNT(DISTINCT id_comprobante) FROM marts.fact_ventas;
```