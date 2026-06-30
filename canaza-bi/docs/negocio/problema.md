# Problema de Negocio y Objetivo Analítico

## Problema de negocio heredado de U1

| Elemento | Descripción |
|----------|-------------|
| Área o proceso involucrado | Proceso de Ventas (comprobantes FQQ1/BQQ1) y Proceso de Inventario/Productos |
| Problema identificado | La gerencia no dispone de un sistema que integre y analice datos de ventas e inventario de forma visual e interactiva. No puede responder preguntas sobre rentabilidad, tendencias, clientes de alto valor ni productos con stock negativo. |
| Usuarios principales | Gerente / Propietario de Distribuciones Canaza — Área de Ventas y Administración — Área de Almacén/Inventario |
| Decisiones que se buscan mejorar | Ajustar precios con margen menor al 10% · Priorizar reabastecimiento de productos con stock negativo · Identificar clientes de alto valor · Planificar campañas en picos estacionales |
| Impacto esperado | Reducir brechas de cumplimiento de ventas · Mejorar rentabilidad por producto · Anticipar demanda estacional · Fidelizar clientes de alto valor |

## Objetivo analítico

Desarrollar una solución de Business Intelligence end-to-end para los procesos de
ventas e inventario de Distribuciones Canaza E.I.R.L., que permita analizar el
comportamiento comercial del período 2023–2026 mediante KPIs clave, a través de
un DataMart modelado con esquema estrella (metodología Kimball), un pipeline de
ingesta y transformación automatizado, y dashboards interactivos en Power BI,
con el fin de apoyar la toma de decisiones estratégicas y operativas de la
gerencia.

## Preguntas de negocio

| Pregunta de negocio | KPI relacionado | Usuario | Visual del dashboard |
|----------------------|------------------|---------|------------------------|
| ¿En qué medida se están cumpliendo las ventas respecto a lo proyectado? | Cumplimiento de Ventas | Gerente | Medidor Gauge + barras mes a mes — KPI 1 |
| ¿Cómo varían las ventas de un período a otro? | Variación de Ventas | Gerente | Gráfico de líneas tendencia + barras variación — KPI 2 y Comparativos |
| ¿Cuál es el margen bruto real de los productos vendidos? | Margen Bruto | Ventas / Adm. | Top 10 productos + tabla detalle — KPI 3 |
| ¿Cuál es el peso de los gastos sobre las ventas totales? | Volumen de Gastos | Ventas / Adm. | Líneas por mes + tabla por categoría — KPI 4 |

Cada pregunta de negocio se resuelve con un KPI definido formalmente, con su
fórmula, fuente y criterios de interpretación — ver [KPIs principales](kpis.md).
