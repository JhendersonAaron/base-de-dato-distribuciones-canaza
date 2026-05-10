# DW PostgreSQL - Distribuciones Canaza E.I.R.L.

## Propósito

Esta carpeta contiene la base PostgreSQL que aloja el Data Warehouse
y el DataMart del proyecto canaza-bi.

## Rol en la arquitectura

MySQL -> Airbyte -> PostgreSQL (raw, staging, marts) -> dbt -> Power BI

## Configuración clave

- motor: PostgreSQL 16
- contenedor: canaza-dw-pg
- host: localhost
- puerto: 15432
- base: canaza_dw
- usuario: postgres
- password: postgres

Schemas esperados:
- raw
- staging
- marts

Script de inicialización:
- postgres/init/01_create_schemas.sql

## Operación mínima

Levantar el servicio:

```powershell
cd D:\261bi\canaza-bi\dw-pg
docker compose up -d
docker compose ps
```

Acceso opcional al motor:

```powershell
docker exec -it canaza-dw-pg psql -U postgres -d canaza_dw
```

## Validación mínima

Dentro de PostgreSQL:

```sql
\dn
\dt raw.*
\dv staging.*
\dt marts.*
```

## Integración

- ingesta-airbyte/ aterriza datos en raw
- dw-dbt/ transforma raw hacia staging y marts
- powerbi/ consume principalmente marts