# Estructura del Proyecto dbt

## Contenedor

- Imagen: Python 3.11-slim + dbt-core + dbt-postgres
- Contenedor: `canaza-dw-dbt`
- Proyecto: `canaza_bi`

## Levantar el contenedor

```powershell
cd D:\261bi\canaza-bi\dw-dbt
docker compose up -d --build
docker exec -it canaza-dw-dbt bash
cd /usr/app/canaza_bi
```

## Archivos clave

| Archivo | Propósito |
|---------|-----------|
| `dbt_project.yml` | Configuración del proyecto |
| `.dbt/profiles.yml` | Conexión a PostgreSQL |
| `macros/generate_schema_name.sql` | Evita concatenar marts_staging |
| `models/staging/*.sql` | 7 vistas de limpieza |
| `models/marts/*.sql` | 5 tablas del DataMart |
| `models/marts/marts.yml` | 31 tests de calidad |