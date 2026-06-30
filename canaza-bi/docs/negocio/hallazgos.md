# Hallazgos, Interpretación y Decisión Recomendada

## Hallazgos principales

| Hallazgo | Evidencia en dashboard | Interpretación | Decisión recomendada |
|----------|--------------------------|-----------------|--------------------------|
| Pico de ventas en marzo | KPI 1 y Resumen General: marzo concentra S/ 215 mil, el doble de la meta mensual | La estacionalidad escolar es el principal driver de ventas. El negocio depende fuertemente del inicio del año escolar | Aumentar stock de productos escolares en enero-febrero para estar listos para el pico de marzo |
| Clientes empresa generan 91.7% de ventas | Análisis General: CLIENTE VIP (RUC) = S/ 946,670 vs CLIENTE REGULAR (DNI) = S/ 84,819 | El segmento B2B (empresas con RUC) es la base del negocio. Las ventas a personas naturales son secundarias | Priorizar fidelización de los top 10 clientes empresa. Revisar si es viable crecer el segmento B2C |
| Margen Bruto en zona Buena | KPI 3: 31.8% global — Archivador 28.3% es el más bajo | La categoría Archivador está por debajo del objetivo del 30%. Puede mejorar con ajuste de precios o mejor negociación de costos | Revisar precios de la categoría Archivador. Negociar con proveedores para reducir el costo de compra |
| Cumplimiento al 91.3% | KPI 1: S/ 1,369,313 vs meta S/ 1,500,000 — brecha de S/ 130,687 | La empresa está en zona Buena, cerca del 100%. Aun así, hay margen de mejora en meses puntuales como noviembre y febrero | Planificar campañas comerciales en los meses de menor venta para sostener el cumplimiento por encima del 90% |

## Decisión final propuesta

Con base en los KPIs y visuales analizados, el equipo recomienda tres acciones
concretas para Distribuciones Canaza E.I.R.L.:

- **Gestión de inventario estacional**: incrementar las órdenes de compra de
  útiles escolares en enero y febrero, específicamente los 10 productos con
  mayor margen (Papel Bon, Tinta para Tampón Layconsa, entre otros), para
  garantizar disponibilidad en el pico de marzo.
- **Programa de fidelización B2B**: implementar un programa de beneficios para
  los clientes empresa de mayor volumen (365 Innova Tech, B&S Señor de Locum,
  Industria Gráfica Comercial y similares), que en conjunto generan más del
  50% de las ventas.
- **Revisión de pricing en Archivador**: ajustar precios de venta de la
  categoría Archivador del 28.3% actual al objetivo del 30% de margen bruto,
  lo que representaría aproximadamente S/ 244 adicionales de margen sin
  cambio de volumen.

## Conclusiones del proyecto

**Valor de negocio de la solución BI.** La solución permite a Distribuciones
Canaza pasar de un registro operativo sin análisis a un dashboard interactivo
que responde los 4 KPIs estratégicos del negocio. El gerente puede ahora
identificar que marzo y diciembre concentran el 40% de las ventas anuales, que
los clientes RUC generan el 91.7% del ingreso, y que el margen del 31.8% está
en zona positiva pero con oportunidades de mejora en la categoría Archivador.

**Calidad y confiabilidad de los datos.** Los 30 tests de dbt (unicidad,
nulos, relaciones, grano) y la validación cruzada SQL vs Power BI con
diferencia de S/ 0.00 demuestran que el DataMart es confiable. Los dos
hallazgos de calidad detectados durante el desarrollo —tipo boolean vs TINYINT
y grano de `fact_ventas` por `id_detalle`— fueron documentados y corregidos,
fortaleciendo la confianza en los resultados (ver
[Calidad de datos](../validacion/calidad.md)).

**Utilidad del dashboard para la toma de decisiones.** Las 7 páginas del
dashboard cubren desde la vista ejecutiva del gerente (Resumen General) hasta
el análisis granular por producto y categoría (KPI 3 y KPI 4), incluyendo los
comparativos período a período y año a año que permiten detectar tendencias y
tomar decisiones con evidencia.

**Aprendizajes técnicos del pipeline end-to-end.** El proyecto evidenció la
complejidad real de un pipeline BI: la separación OLTP/DW con contenedores
distintos, los problemas de tipos de datos entre tecnologías (MySQL vs
PostgreSQL), la importancia de los tests automáticos en dbt, y la diferencia
entre datos transaccionales y datos analíticos. La arquitectura MySQL →
Airbyte → PostgreSQL → dbt → Power BI es una referencia válida para proyectos
BI reales.

**Mejoras futuras.** La implementación de CDC con Debezium/Kafka reduciría la
latencia de datos de días a segundos. Una tabla de presupuesto dinámica
mejoraría el KPI 1. SCD Tipo 2 en `dim_entidad` permitiría análisis histórico
de cambios en clientes. La publicación en Power BI Service daría acceso web al
gerente de Canaza sin instalar Power BI Desktop. El detalle completo de
limitaciones y mejoras está en [Sustentación técnica](../sustentacion.md).
