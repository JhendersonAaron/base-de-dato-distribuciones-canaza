# Medidas DAX

## Medidas base

```dax
Ventas Netas = SUM(fact_ventas[venta_neta])
Ventas Brutas = SUM(fact_ventas[venta_bruta])
Costo Total = SUM(fact_ventas[costo_total])
Margen Bruto = SUM(fact_ventas[margen_bruto])
Unidades Vendidas = SUM(fact_ventas[cantidad])
Comprobantes = DISTINCTCOUNT(fact_ventas[id_comprobante])
```

## Medidas de KPIs

```dax
% Margen Bruto = DIVIDE([Margen Bruto], [Ventas Netas])
Volumen de Gastos = DIVIDE([Costo Total], [Ventas Netas])
Ventas Proyectadas = 1500000
Cumplimiento de Ventas = DIVIDE([Ventas Netas], [Ventas Proyectadas])
```

## Medidas de comparativos

```dax
Ventas Año Anterior = CALCULATE([Ventas Netas], 
  FILTER(ALL(dim_fecha), 
    dim_fecha[anio] = MAX(dim_fecha[anio]) - 1 
    && dim_fecha[mes_numero] = MAX(dim_fecha[mes_numero])))

Variación vs Año Anterior = DIVIDE([Ventas Netas] - [Ventas Año Anterior], 
  [Ventas Año Anterior])
```