# Descripción del OLTP

La base transaccional `canaza_oltp` en MySQL 8.4 contiene los datos reales de 
Distribuciones Canaza exportados del sistema SUNAT.

## Tablas principales

| Tabla | Registros | Descripción |
|-------|-----------|-------------|
| entidad | 2,200 | Clientes RUC y DNI |
| producto | 1,660 | Catálogo con costos y precios |
| comprobante | ~1,500 | Facturas FQQ1 y Boletas BQQ1 |
| comprobante_detalle | ~3,900 | Líneas de venta por producto |
| categoria | 3 | SIN CATEGORÍA, Archivador, Papeles |
| tipo_comprobante | 4 | Factura, Boleta, Nota Crédito, Nota Débito |
| tipo_documento | 7 | RUC, DNI y otros |

## Período de datos

- Datos reales: abril 2025 — abril 2026
- Datos ficticios (estacionalidad realista): enero 2023 — diciembre 2024

## Contenedor Docker

- Imagen: MySQL 8.4
- Contenedor: `canaza-oltp-mysql`
- Puerto: 13306
- Base: `canaza_oltp`
- Usuario: root / Contraseña: root