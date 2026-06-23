# Sistema BI — Distribuciones Canaza E.I.R.L.

## Descripción del proyecto

Solución de Business Intelligence end-to-end para el análisis de ventas e inventario 
de Distribuciones Canaza E.I.R.L., empresa distribuidora de útiles de oficina y 
materiales escolares de Juliaca, Puno.

## Equipo

- **Apaza Hilasaca, Celia Patricia**
- **Machaca Mamani, Jhenderson Aaron**

Curso: Inteligencia de Negocios — Ciclo VIII — UPeU 2026

## Arquitectura del pipeline

MySQL canaza_oltp

→ Airbyte
→ PostgreSQL canaza_dw (raw)
→ dbt staging
→ dbt marts
→ Power BI

## KPIs implementados

| KPI | Resultado | Estado |
|-----|-----------|--------|
| Cumplimiento de Ventas | 91.3% | Zona Buena (>90%) |
| Variación de Ventas | -95.8% último mes (dato parcial) | — |
| Margen Bruto | 31.8% | Zona Buena (>30%) |
| Volumen de Gastos | 53.0% | Zona Eficiente (<60%) |

## Repositorio

[https://github.com/JhendersonAaron/base-de-dato-distribuciones-canaza](https://github.com/JhendersonAaron/base-de-dato-distribuciones-canaza)