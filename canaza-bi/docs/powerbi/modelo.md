# Modelo Semántico Power BI

El modelo semántico se construyó sobre el schema `marts` de PostgreSQL en
modo **Importar**, con 4 relaciones, 2 jerarquías y una tabla de medidas
(`_Medidas`) con 13 medidas DAX.

![Vista de modelo en Power BI: fact_ventas al centro conectado a las 4 dimensiones](img/modelo_semantico.png)

## Relaciones

| Tabla dimensión | Tabla hecho | Campo dimensión | Campo hecho | Cardinalidad | Filtro |
|--------------------|----------------|--------------------|----------------|------------------|--------|
| dim_fecha | fact_ventas | fecha_key | fecha_key | 1:* | Simple |
| dim_entidad | fact_ventas | entidad_key | entidad_key | 1:* | Simple |
| dim_producto | fact_ventas | producto_key | producto_key | 1:* | Simple |
| dim_tipo_cpe | fact_ventas | tipo_cpe_key | tipo_cpe_key | 1:* | Simple |

## Jerarquías y campos de análisis

| Jerarquía | Niveles | Tabla | Uso analítico |
|-----------|---------|-------|------------------|
| Calendario | Año → Trimestre → Mes → Fecha | dim_fecha | Drill-down temporal en gráficos de líneas y barras por período |
| Producto Comercial | Categoría → Producto | dim_producto | Análisis de rentabilidad por categoría y top productos |

## Campos ocultos

Se ocultaron las claves técnicas (`fecha_key`, `entidad_key`, `producto_key`,
`tipo_cpe_key`, etc.) para que el usuario final solo vea campos descriptivos
en los visuales y segmentadores.

Las 13 medidas DAX que se apoyan en este modelo están documentadas en
[Medidas DAX](medidas.md), y su uso en cada página del dashboard en
[Dashboard interactivo](dashboard.md).
