# Sistema BI — Distribuciones Canaza E.I.R.L.

## Descripción del proyecto

Solución de Business Intelligence end-to-end para el análisis de ventas e inventario
de Distribuciones Canaza E.I.R.L., empresa distribuidora de útiles de oficina y
materiales escolares de Juliaca, Puno. El proyecto cubre el período 2023–2026 y
cubre todo el recorrido del dato: desde los comprobantes electrónicos SUNAT
registrados en el sistema transaccional hasta un dashboard interactivo en Power BI.

## Equipo

- **Apaza Hilasaca, Celia Patricia**
- **Machaca Mamani, Jhenderson Aaron**

Curso: Inteligencia de Negocios — Ciclo VIII — UPeU 2026
Docente: Sullon Macalupu, Abel Angel

## Datos generales del proyecto

| Campo | Descripción |
|-------|-------------|
| Nombre del proyecto BI | Sistema de Inteligencia de Negocios para el Análisis de Ventas e Inventario de Distribuciones Canaza E.I.R.L. |
| Proceso de negocio analizado | Ventas e inventario de útiles de oficina y materiales escolares |
| Fuente transaccional | MySQL `canaza_oltp` — comprobantes SUNAT (facturas FQQ1 y boletas BQQ1), productos y clientes reales, período 2023–2026 |
| Repositorio GitHub | [base-de-dato-distribuciones-canaza](https://github.com/JhendersonAaron/base-de-dato-distribuciones-canaza) |

### Herramientas utilizadas

| Componente | Herramienta / Tecnología | Evidencia |
|------------|---------------------------|-----------|
| OLTP | MySQL 8.4 (Docker, puerto 13306) | Contenedor `canaza-oltp-mysql` — base `canaza_oltp` |
| Ingesta | Airbyte local (abctl, puerto 8010) | Réplica Full Refresh MySQL → PostgreSQL schema `raw` — 7 tablas sincronizadas |
| DW / DataMart | PostgreSQL 16 (Docker, puerto 15432) | Contenedor `canaza-dw-pg` — base `canaza_dw` (schemas: raw, staging, marts) |
| Transformación | dbt Core + dbt-postgres 1.8 | Contenedor `canaza-dw-dbt` — proyecto `canaza_bi` — 7 modelos staging + 5 modelos marts |
| Modelo semántico | Power BI Desktop | Archivo `canazaPBI v1.pbix` — 4 relaciones, 2 jerarquías, 13 medidas DAX |
| Dashboard | Power BI Desktop | 7 páginas: Análisis General, Resumen General, KPI 1–4, Comparativos |
| Validación | SQL (psql / VS Code) + dbt test + Power BI | 30 tests dbt PASS — ventas S/ 1,369,313.54 coincide en MySQL, PostgreSQL y Power BI |

## Resumen ejecutivo

Distribuciones Canaza E.I.R.L. registra sus operaciones mediante comprobantes
electrónicos del sistema SUNAT. A pesar de contar con datos reales de ventas e
inventario desde 2023, la gerencia no disponía de un sistema integrado para
analizar el desempeño comercial de forma visual e interactiva.

Este proyecto implementó una solución de Business Intelligence end-to-end para el
período 2023–2026: base transaccional MySQL (`canaza_oltp`) con 2,200 clientes,
1,660 productos y más de 1,500 comprobantes reales; ingesta automatizada con
Airbyte hacia PostgreSQL; transformación con dbt en capas raw, staging y marts;
modelo semántico en Power BI con los 4 KPIs definidos desde la Unidad 1.

Los hallazgos principales muestran que las ventas totales del período superan
**S/ 1,300,000** con un margen bruto del **31.8%** (zona Buena), un volumen de
gastos del **53.0%** (zona Eficiente) y un cumplimiento de ventas del **91.3%**
respecto a la meta proyectada. El negocio tiene estacionalidad marcada con picos
en marzo (inicio del ciclo escolar) y diciembre. Los clientes empresa con RUC
generan el 91.7% de las ventas.

La decisión recomendada es priorizar el reabastecimiento en enero–febrero para
aprovechar el pico de marzo, fidelizar a los 10 clientes empresa de mayor
volumen, y revisar precios en la categoría Archivador, que tiene el margen más
bajo (28.3%) frente al objetivo del 30%. Más detalle en
[Hallazgos y decisión recomendada](negocio/hallazgos.md).

## Arquitectura del pipeline

```
MySQL canaza_oltp
   → Airbyte
   → PostgreSQL canaza_dw (raw)
   → dbt staging
   → dbt marts
   → Power BI (modelo semántico)
   → Dashboard interactivo
```

Se separó físicamente la base transaccional (MySQL) de la base analítica
(PostgreSQL), con un pipeline automatizado de ingesta y transformación. Ver el
detalle por componente en el menú: OLTP MySQL, Ingesta Airbyte, Transformación
dbt, DataMart, Power BI y Validación.

## KPIs implementados

| KPI | Resultado | Estado |
|-----|-----------|--------|
| Cumplimiento de Ventas | 91.3% | Zona Buena (>90%) |
| Variación de Ventas | -95.8% último mes (dato parcial, mes en curso) | — |
| Margen Bruto | 31.8% | Zona Buena (>30%) |
| Volumen de Gastos | 53.0% | Zona Eficiente (<60%) |

Definiciones, fórmulas y criterios de interpretación completos en
[KPIs principales](negocio/kpis.md).

## Mapa de la documentación

| Sección | Contenido |
|---------|-----------|
| [Problema de negocio](negocio/problema.md) | Problema heredado de U1, objetivo analítico, preguntas de negocio |
| [KPIs principales](negocio/kpis.md) | Definición, fórmula, criterios de interpretación y resultados de los 4 KPIs |
| [OLTP MySQL](oltp/descripcion.md) | Base transaccional, tablas, cómo levantar el entorno |
| [Ingesta Airbyte](airbyte/instalacion.md) | Instalación, configuración y sincronización |
| [Transformación dbt](dbt/estructura.md) | Estructura del proyecto, staging, marts, tests |
| [DataMart](datamart/modelo.md) | Modelo dimensional en esquema estrella |
| [Power BI](powerbi/modelo.md) | Modelo semántico, medidas DAX, dashboard |
| [Validación](validacion/calidad.md) | Calidad de datos, conciliación SQL vs Power BI |
| [Hallazgos y decisión recomendada](negocio/hallazgos.md) | Interpretación de KPIs y conclusiones del proyecto |
| [Sustentación](sustentacion.md) | Preguntas del docente, evidencias obligatorias, aporte individual |

## Repositorio

[https://github.com/JhendersonAaron/base-de-dato-distribuciones-canaza](https://github.com/JhendersonAaron/base-de-dato-distribuciones-canaza)
