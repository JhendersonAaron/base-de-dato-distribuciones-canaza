# Modelo Semántico Power BI

## Relaciones

| Dimensión | Campo | Hecho | Campo | Cardinalidad |
|-----------|-------|-------|-------|--------------|
| dim_fecha | fecha_key | fact_ventas | fecha_key | 1:* Simple |
| dim_entidad | entidad_key | fact_ventas | entidad_key | 1:* Simple |
| dim_producto | producto_key | fact_ventas | producto_key | 1:* Simple |
| dim_tipo_cpe | tipo_cpe_key | fact_ventas | tipo_cpe_key | 1:* Simple |

## Jerarquías

### Calendario (en dim_fecha)
Año → Trimestre → Mes → Fecha

### Producto Comercial (en dim_producto)
Categoría → Producto

## Campos ocultos

Se ocultaron las claves técnicas (fecha_key, entidad_key, etc.) 
para que el usuario final solo vea campos descriptivos.