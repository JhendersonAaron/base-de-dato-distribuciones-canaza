# Configuración Source y Destination en Airbyte

## Source MySQL

| Campo | Valor |
|-------|-------|
| Source name | mysql-canaza |
| Host | host.docker.internal |
| Port | 13306 |
| Database | canaza_oltp |
| Username | root |
| Password | root |
| Update Method | Scan Changes with User Defined Cursor |

## Destination PostgreSQL

| Campo | Valor |
|-------|-------|
| Destination name | postgres-canaza-raw |
| Host | host.docker.internal |
| Port | 15432 |
| Database Name | canaza_dw |
| Default Schema | raw |
| Username | postgres |
| Password | postgres |
| SSL Modes | disable |

## Tablas sincronizadas

- categoria, comprobante, comprobante_detalle
- entidad, producto, tipo_comprobante, tipo_documento