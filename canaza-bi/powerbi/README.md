# Power BI - Distribuciones Canaza E.I.R.L.

## Propósito

Esta carpeta contiene la capa de consumo analítico del proyecto canaza-bi.

## Rol en la arquitectura

MySQL -> Airbyte -> PostgreSQL -> dbt -> Power BI

## Fuente principal

Power BI consume el modelo estrella final construido en PostgreSQL:

- base: canaza_dw
- schema principal: marts

Tablas esperadas:
- dim_entidad
- dim_producto
- dim_fecha
- dim_tipo_cpe
- fact_ventas

## Conexión

- Servidor: 127.0.0.1:15432
- Base de datos: canaza_dw
- Modo: Importar
- Usuario: postgres
- Contraseña: postgres