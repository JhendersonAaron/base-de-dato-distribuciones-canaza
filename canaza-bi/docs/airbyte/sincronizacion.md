# Sincronización Airbyte

## Configuración de la conexión

- Connection name: mysql-canaza → postgres-canaza-raw
- Schedule type: Manual
- Destination Namespace: Destination-defined

## Ejecutar sincronización

1. Abrir http://localhost:8010
2. Ir a la conexión mysql-canaza → postgres-canaza-raw
3. Hacer clic en **Sync now**
4. Esperar que todas las tablas digan **Synced**

## Verificar en PostgreSQL

```sql
\dt raw.*
SELECT COUNT(*) FROM raw.comprobante;
SELECT COUNT(*) FROM raw.comprobante_detalle;
```