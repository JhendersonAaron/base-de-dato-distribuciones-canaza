# Conexión Power BI al DataMart

## Datos de conexión

| Campo | Valor |
|-------|-------|
| Servidor | 127.0.0.1:15432 |
| Base de datos | canaza_dw |
| Modo | Importar |
| Usuario | postgres |
| Contraseña | postgres |

## Pasos

1. Abrir Power BI Desktop
2. Obtener datos → Base de datos PostgreSQL
3. Servidor: 127.0.0.1:15432
4. Base de datos: canaza_dw
5. Modo: **Importar**
6. En el Navegador seleccionar SOLO las 5 tablas de `marts`
7. Cargar

## Tablas importadas

- marts.dim_entidad (2,200 filas)
- marts.dim_fecha (219+ filas)
- marts.dim_producto (1,660 filas)
- marts.dim_tipo_cpe (4 filas)
- marts.fact_ventas (1,523+ filas)