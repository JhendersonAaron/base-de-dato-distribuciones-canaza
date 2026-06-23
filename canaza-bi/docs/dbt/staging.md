# Modelos Staging

Los modelos staging leen desde el schema `raw` y producen vistas limpias en el schema `staging`.

## Ejecutar

```bash
dbt run --select staging
```

## Modelos

| Modelo | Origen | Transformación principal |
|--------|--------|--------------------------|
| stg_comprobante | raw.comprobante | WHERE anulado = false |
| stg_comprobante_detalle | raw.comprobante_detalle | Selección directa |
| stg_producto | raw.producto + raw.categoria | LEFT JOIN categoria |
| stg_entidad | raw.entidad | Selección de campos clave |
| stg_tipo_comprobante | raw.tipo_comprobante | Selección directa |
| stg_tipo_documento | raw.tipo_documento | Selección directa |
| stg_categoria | raw.categoria | Selección directa |

## Hallazgo de calidad

El campo `anulado` en PostgreSQL es **boolean**, no TINYINT como en MySQL.
Por eso se usa `WHERE anulado = false` y no `WHERE anulado = 0`.