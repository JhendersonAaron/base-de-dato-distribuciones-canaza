# Sustentación Técnica

## Preguntas y respuestas técnicas

**1. ¿Cómo fluye el dato desde el OLTP hasta el dashboard?**

Los datos se originan en MySQL `canaza_oltp` (comprobantes reales del sistema
SUNAT de Distribuciones Canaza). Airbyte replica las 7 tablas clave hacia el
schema `raw` de PostgreSQL `canaza_dw`. dbt transforma `raw` en 7 vistas de
staging (limpieza, filtros, renombrado) y luego en 5 tablas de marts
(dimensiones y hecho con métricas calculadas). Power BI se conecta al schema
`marts` en modo Importar y construye el modelo semántico con relaciones,
jerarquías y medidas DAX. El usuario final interactúa con el dashboard sin
ver las capas intermedias.

**2. ¿Qué transformaciones principales se aplicaron?**

En staging: filtro `WHERE anulado = false` para excluir comprobantes
cancelados; `LEFT JOIN` entre `producto` y `categoria` para denormalizar
`desc_categoria`; selección de campos clave eliminando columnas irrelevantes.
En marts: cálculo de `venta_neta` (subtotal_sinigv), `costo_total`
(costo_unit × cantidad), `margen_bruto` (venta_neta − costo_total) y
`pct_margen_bruto` (margen / venta_neta) por línea de detalle; generación de
`fecha_key` como entero YYYYMMDD; flag `es_empresa` derivado del
`cod_tipo_doc`.

**3. ¿Por qué se eligió ese modelo dimensional?**

Se eligió un esquema estrella siguiendo la metodología Kimball (bottom-up)
porque Canaza tiene un único proceso analítico central: las ventas por línea
de comprobante. `fact_ventas` al centro con 4 dimensiones (fecha, entidad,
producto, tipo_cpe) cubre todos los KPIs definidos en U1. Se optó por una
sola `dim_entidad` en vez de `dim_cliente` y `dim_vendedor` separadas porque
en Canaza no hay vendedores registrados, solo clientes. `dim_producto` se
denormalizó con categoría porque solo hay un nivel jerárquico.

**4. ¿Cómo se validó que los KPIs son correctos?**

En tres niveles: (1) `dbt test` ejecutó 33 tests automáticos de unicidad,
nulos, relaciones y valores aceptados sobre marts. (2) Comparación directa
MySQL vs PostgreSQL: `SELECT SUM(venta_neta) FROM marts.fact_ventas` =
S/ 1,369,313.54 coincide exactamente con la consulta equivalente en el OLTP
filtrando `anulado = 0`. (3) Validación visual en Power BI: la medida
[Ventas Netas] sin filtros muestra el mismo valor que el SQL del DataMart.

**5. ¿Qué problema técnico se presentó y cómo se resolvió?**

Se presentaron dos problemas principales: (a) el campo `anulado` en
PostgreSQL es boolean y no TINYINT como en MySQL, lo que causaba el error
`operator does not exist: boolean = integer` en dbt. Se corrigió cambiando
`WHERE anulado = 0` a `WHERE anulado = false`. (b) El test de grano en
`fact_ventas` detectó 11 duplicados por `id_comprobante` + `id_producto`,
porque en Canaza un mismo producto puede aparecer dos veces en un comprobante
con precios distintos. Se corrigió el grano a `id_detalle` y los tests
restantes pasaron sin error.

**6. ¿Qué limitaciones tiene la solución actual?**

La meta de ventas proyectadas es un valor fijo en DAX, no proviene de una
tabla de presupuesto del sistema. La carga de Airbyte es Full Refresh, lo que
requiere sincronización completa en cada actualización (no incremental). La
solución no implementó CDC (Change Data Capture) con Debezium/Kafka para
sincronización en tiempo real. Los datos de 2023 y 2024 son ficticios,
generados con patrones realistas de estacionalidad — no son datos reales del
negocio.

**7. ¿Qué mejoras se implementarían en una siguiente versión?**

Implementar CDC con Debezium y Kafka para sincronización en tiempo real desde
MySQL. Agregar una tabla de presupuesto para que la meta de ventas sea
dinámica. Implementar SCD Tipo 2 en `dim_entidad` para rastrear cambios
históricos en clientes. Agregar una dimensión de inventario para visibilizar
productos con stock negativo (hallazgo mencionado en el brief de U1).
Publicar el modelo en Power BI Service para acceso web del gerente de Canaza.

## Preguntas del docente y respuestas

| Pregunta del docente | Respuesta del equipo |
|--------------------------|---------------------------|
| ¿Cómo se conecta el problema de negocio con los KPIs? | El problema es que la gerencia no puede evaluar rentabilidad, tendencias ni cumplimiento de metas. Los 4 KPIs responden directamente: Cumplimiento mide si se llega a la meta, Variación muestra tendencias, Margen evalúa rentabilidad y Volumen de Gastos mide eficiencia en compras. |
| ¿Qué parte del repositorio demuestra el pipeline? | La carpeta `oltp-mysql/` tiene los scripts SQL y docker-compose. La carpeta `dw-dbt/` tiene el proyecto dbt completo con modelos, tests y perfiles. El repositorio GitHub tiene toda la estructura visible. |
| ¿Cómo se valida que el dashboard muestra resultados correctos? | Tres niveles: 33 tests automáticos de dbt PASS, comparación SQL marts vs MySQL OLTP (S/ 0.00 de diferencia), y validación visual Power BI vs SQL de PostgreSQL donde todas las medidas coinciden exactamente. |
| ¿Qué diferencia hay entre OLTP, DataMart y modelo semántico? | OLTP es la base transaccional con datos normalizados para operaciones diarias. El DataMart es el esquema estrella desnormalizado optimizado para análisis (marts). El modelo semántico en Power BI traduce esas tablas a un lenguaje de negocio con relaciones, jerarquías y medidas DAX. |
| ¿Qué hallazgo justifica la decisión recomendada? | El pico de ventas en marzo (S/ 215 mil, el doble de la meta mensual) justifica la gestión de inventario anticipado. El 91.7% de ventas concentradas en clientes empresa justifica el programa de fidelización B2B. El margen de Archivador al 28.3% por debajo del objetivo justifica la revisión de precios. |

## Evidencias obligatorias

| Evidencia | Formato | Estado |
|-----------|---------|--------|
| Link del repositorio GitHub del proyecto | URL: github.com/JhendersonAaron/base-de-dato-distribuciones-canaza | Disponible |
| Sitio MkDocs generado o publicado | URL del sitio publicado | Disponible |
| Guías MkDocs para construir cada componente | Archivos `.md` en carpeta `docs/` del repositorio | Disponible |
| Base OLTP operativa (canaza_oltp) | Captura `docker ps` + `SHOW TABLES` MySQL | Disponible |
| Ingesta Airbyte funcionando | Captura Source, Destination y Job Synced en Airbyte | Disponible |
| Tablas raw en DW PostgreSQL | Captura `\dt raw.*` en psql | Disponible |
| Modelos staging (7 vistas) | Captura `dbt run --select staging` | Disponible |
| Modelos marts (5 tablas) | Captura `dbt run --select +marts` | Disponible |
| Tests dbt ejecutados (33 PASS) | Captura `dbt test --select marts` | Disponible |
| Modelo dimensional (esquema estrella) | Captura Vista de Modelo Power BI | Disponible |
| Modelo semántico Power BI con relaciones | Captura Vista de Modelo con 4 relaciones | Disponible |
| Medidas DAX documentadas (13 medidas) | Tabla de medidas + `medidas_canaza_bi.dax` en repo | Disponible |
| Dashboard interactivo (7 páginas) | Archivo `canazaPBI v1.pbix` | Disponible |
| Comparativo actual vs mismo período año anterior | Página Comparativos Power BI — captura | Disponible |
| Comparativo actual vs período anterior | Página Comparativos + KPI 2 Power BI — captura | Disponible |
| Tabla KPI de variación por dimensión de negocio | Página Comparativos — tabla por año y categoría | Disponible |
| Validación SQL vs Power BI | Tabla de conciliación — diferencia S/ 0.00 | Disponible |
| Trazabilidad de KPIs fuente-modelo-visual | Tabla de trazabilidad | Disponible |
| Presentación PPT de sustentación | Archivo .pptx / Google Slides — 10 slides | Pendiente |
| Aporte individual de cada integrante | Tabla de aporte individual (abajo) | Disponible |

## Aporte individual del equipo

| Integrante | Componentes trabajados | Evidencia | Qué validó | Qué sustentará |
|---------------|----------------------------|-----------|----------------|---------------------|
| Apaza Hilasaca, Celia Patricia | Creación scripts SQL OLTP (`canaza_oltp.sql`, `1_dm.sql`, `2_G_pasos.sql`, `3_poblar.sql`). Configuración `docker-compose.yml` MySQL+PostgreSQL. Construcción modelo semántico Power BI (relaciones, jerarquías, campos ocultos). Creación medidas DAX incluyendo medidas de comparativos. Diseño y construcción de las 7 páginas del dashboard. | Scripts SQL en repo — archivo `.pbix` — capturas Power BI | DataMart manual MySQL — modelo semántico PBI — validación SQL vs PBI — dashboard páginas KPI y Comparativos | Problema y objetivo, arquitectura BI, modelo semántico, medidas DAX, dashboard — Demo Power BI en vivo |
| Machaca Mamani, Jhenderson Aaron | Carga datos reales OLTP (scripts 02–04 del repositorio). Generación datos ficticios 2023–2024 para ampliar período. Configuración e instalación Airbyte (abctl). Creación proyecto dbt completo (`profiles.yml`, `dbt_project.yml`, 7 modelos staging, 5 modelos marts, 33 tests, macro `generate_schema_name`). Validación analítica DataMart (`dbt test`, consultas SQL marts, comparación OLTP vs DM). Configuración ingesta. | Repositorio GitHub — capturas Airbyte — logs `dbt test` — queries SQL PostgreSQL | Pipeline completo Airbyte+dbt — tests PASS — validación S/ 1,369,313.54 — trazabilidad KPIs | Fuente OLTP, pipeline de ingesta y transformación, calidad de datos, validación y trazabilidad — Demo OLTP+PostgreSQL en vivo |

## Conclusiones

Ver el detalle completo en [Hallazgos y decisión recomendada](negocio/hallazgos.md#conclusiones-del-proyecto).

## Repositorio del proyecto

[https://github.com/JhendersonAaron/base-de-dato-distribuciones-canaza](https://github.com/JhendersonAaron/base-de-dato-distribuciones-canaza)
