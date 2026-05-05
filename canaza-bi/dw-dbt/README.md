# DW dbt - Distribuciones Canaza E.I.R.L.

## Proposito

Este directorio contiene el proyecto dbt que transforma la capa raw
y construye el modelo estrella final para Canaza.

## Rol en la arquitectura

MySQL canaza_oltp -> Airbyte -> PostgreSQL raw -> dbt staging -> dbt marts

## Prerequisitos

- dw-pg con la base canaza_dw levantado
- raw cargado por Airbyte

## Configuracion clave

- contenedor: canaza-dw-dbt
- proyecto dbt: canaza_bi
- profile: .dbt/profiles.yml
- schema base del target: marts

## Operacion minima

Levantar el contenedor:

```powershell
cd D:\261bi\canaza-bi\dw-dbt
docker compose up -d --build
docker compose ps
```

Ingresar:

```powershell
docker exec -it canaza-dw-dbt bash
```

Dentro del contenedor:

```bash
cd /usr/app/canaza_bi
dbt debug
dbt run --select staging
dbt run --select +marts
dbt test --select marts
```

## Validacion minima en PostgreSQL

```sql
\dv staging.*
\dt marts.*
select * from marts.fact_ventas limit 20;
```