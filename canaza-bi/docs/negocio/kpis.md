# KPIs Principales

Los 4 KPIs del proyecto fueron definidos en el brief de la Unidad 1 con
fórmulas, escalas de interpretación y usuarios aprobados, y se mantuvieron sin
cambios durante todo el desarrollo del pipeline BI.

## Definición y fórmula

| KPI                    | Definición                           | Fórmula de negocio                                  | Fuente                          | Frecuencia | Usuario     |
| ---------------------- | ------------------------------------- | ---------------------------------------------------- | ------------------------------- | ---------- | ----------- |
| Cumplimiento de Ventas | % ventas reales vs meta proyectada    | Ventas Netas / Ventas Proyectadas                    | `fact_ventas`                 | Mensual    | Gerente     |
| Variación de Ventas   | % cambio entre períodos consecutivos | (Ventas actual − Ventas anterior) / Ventas anterior | `fact_ventas` + `dim_fecha` | Mensual    | Gerente     |
| Margen Bruto           | Rentabilidad real sobre ventas        | (Ventas Netas − Costo Total) / Ventas Netas         | `fact_ventas`                 | Mensual    | Ventas/Adm. |
| Volumen de Gastos      | Relación % costo/venta por período  | Costo Total / Ventas Netas                           | `fact_ventas`                 | Mensual    | Ventas/Adm. |

## Criterios de interpretación

| KPI                    | Bajo         | Esperado          | Alto / Cumplido   | Acción sugerida                                 |
| ---------------------- | ------------ | ----------------- | ----------------- | ------------------------------------------------ |
| Cumplimiento de Ventas | < 80%        | 80% – 90%        | > 90%             | Revisar estrategia comercial mensual             |
| Variación de Ventas   | Caída > 20% | Entre -20% y +20% | Crecimiento > 20% | Analizar causas de caída y planificar campañas |
| Margen Bruto           | < 15%        | 15% – 30%        | > 30%             | Revisar precios o renegociar con proveedores     |
| Volumen de Gastos      | > 80%        | 60% – 80%        | < 60% (Eficiente) | Optimizar compras si supera el 80%               |

## Resultados obtenidos

| KPI                    | Resultado                                    | Zona             |
| ---------------------- | -------------------------------------------- | ---------------- |
| Cumplimiento de Ventas | **91.3%**                              | Buena (>90%)     |
| Margen Bruto           | **31.8%**                              | Buena (>30%)     |
| Volumen de Gastos      | **53.0%**                              | Eficiente (<60%) |
| Variación de Ventas   | **-95.8%** (último mes, dato parcial) | —               |

Sobre la meta de S/ 1,500,000 proyectados, las ventas netas reales alcanzaron
S/ 1,369,313.54 — un cumplimiento del 91.3%, equivalente a una brecha de
S/ 130,687 respecto a la meta. La caída de -95.8% en variación del último mes
corresponde a un mes con datos parciales (en curso), no a una caída real del
negocio; el detalle mes a mes se observa en la página KPI 2 del dashboard.

Estos resultados se validaron en tres niveles —tests automáticos de dbt,
conciliación SQL vs Power BI y validación visual— documentados en
[Validación de KPIs](../validacion/sql_vs_pbi.md).

La interpretación de negocio de estos resultados (estacionalidad, segmento de
clientes, categoría con menor margen) está en
[Hallazgos y decisión recomendada](hallazgos.md).
