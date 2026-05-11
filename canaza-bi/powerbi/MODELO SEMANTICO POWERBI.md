# Sesión U2 S3 P1: Modelo semántico en Power BI
## Caso: Distribuciones Canaza E.I.R.L.

## Objetivo

Conectar Power BI al DataMart ya construido y convertir el modelo
estrella físico en un modelo semántico listo para análisis.

## Punto de partida

- base: canaza_dw
- schema: marts
- tablas: dim_entidad, dim_producto, dim_fecha, dim_tipo_cpe, fact_ventas

## Conexión

- Servidor: 127.0.0.1:15432
- Base de datos: canaza_dw
- Modo: Importar
- Usuario: postgres
- Contraseña: postgres

## Relaciones del modelo estrella

dim_fecha[fecha_key]       1 -> * fact_ventas[fecha_key]
dim_entidad[entidad_key]   1 -> * fact_ventas[entidad_key]
dim_producto[producto_key] 1 -> * fact_ventas[producto_key]
dim_tipo_cpe[tipo_cpe_key] 1 -> * fact_ventas[tipo_cpe_key]

Cardinalidad: Uno a varios
Dirección de filtro: Simple

## Jerarquías

Calendario (en dim_fecha):
  anio -> trimestre -> mes_desc -> fecha

Producto Comercial (en dim_producto):
  desc_categoria -> descripcion