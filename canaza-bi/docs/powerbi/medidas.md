# Medidas DAX

La tabla `_Medidas` contiene las 13 medidas DAX del modelo, agrupadas en tres
categorías: medidas base, medidas de KPIs y medidas de comparativos.

## Tabla de referencia completa

| Medida | Fórmula DAX | Formato | KPI asociado |
|--------|--------------|---------|------------------|
| Ventas Netas | `SUM(fact_ventas[venta_neta])` | Moneda | KPI 1, KPI 2 |
| Ventas Brutas | `SUM(fact_ventas[venta_bruta])` | Moneda | General |
| Costo Total | `SUM(fact_ventas[costo_total])` | Moneda | KPI 3, KPI 4 |
| Margen Bruto | `SUM(fact_ventas[margen_bruto])` | Moneda | KPI 3 |
| Unidades Vendidas | `SUM(fact_ventas[cantidad])` | Entero | General |
| Comprobantes | `DISTINCTCOUNT(fact_ventas[id_comprobante])` | Entero | General |
| % Margen Bruto | `DIVIDE([Margen Bruto], [Ventas Netas])` | Porcentaje | KPI 3 |
| Volumen de Gastos | `DIVIDE([Costo Total], [Ventas Netas])` | Porcentaje | KPI 4 |
| Ventas Proyectadas | `1500000` | Moneda | KPI 1 |
| Cumplimiento de Ventas | `DIVIDE([Ventas Netas], [Ventas Proyectadas])` | Porcentaje | KPI 1 |
| Ventas Año Anterior | `CALCULATE([Ventas Netas], FILTER(ALL(dim_fecha), dim_fecha[anio] = MAX(dim_fecha[anio]) - 1 && dim_fecha[mes_numero] = MAX(dim_fecha[mes_numero])))` | Moneda | Comparativos |
| Variación vs Año Anterior | `DIVIDE([Ventas Netas] - [Ventas Año Anterior], [Ventas Año Anterior])` | Porcentaje | Comparativos |
| Variación de Ventas Último Mes | Cálculo dinámico con VAR/FILTER sobre fechas disponibles (mes actual vs mes anterior real en los datos) | Porcentaje | KPI 2 |

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

`Variación de Ventas Último Mes` se calcula con una variable que ubica el mes
más reciente con datos y el mes inmediatamente anterior dentro del propio
conjunto de fechas disponibles (no asume un calendario fijo), y aplica la
misma lógica de `DIVIDE` que `Variación vs Año Anterior`.

Estas medidas alimentan directamente las 7 páginas del
[dashboard interactivo](dashboard.md).
