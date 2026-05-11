# Sesión U2 S3 P2: Medidas DAX y agregaciones BI
## Caso: Distribuciones Canaza E.I.R.L.

## Medidas base

Ventas Brutas = SUM(fact_ventas[venta_bruta])
Ventas Netas = SUM(fact_ventas[venta_neta])
Costo Total = SUM(fact_ventas[costo_total])
Margen Bruto = SUM(fact_ventas[margen_bruto])
Unidades Vendidas = SUM(fact_ventas[cantidad])
Líneas de Venta = COUNTROWS(fact_ventas)

## Medidas derivadas

Comprobantes = DISTINCTCOUNT(fact_ventas[id_comprobante])
% Margen Bruto = DIVIDE([Margen Bruto], [Ventas Netas])
Ticket Promedio = DIVIDE([Ventas Netas], [Comprobantes])
Precio Promedio Neto = DIVIDE([Ventas Netas], [Unidades Vendidas])

## Validación contra SQL

SELECT ROUND(SUM(venta_neta)::numeric, 2) FROM marts.fact_ventas;
-- debe coincidir con [Ventas Netas] = 1,031,490.02

SELECT ROUND(SUM(margen_bruto)::numeric, 2) FROM marts.fact_ventas;
-- debe coincidir con [Margen Bruto]