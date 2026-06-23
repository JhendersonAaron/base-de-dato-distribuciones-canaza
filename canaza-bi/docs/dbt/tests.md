# Tests dbt

## Ejecutar

```bash
dbt test --select marts
```

## Resultado

**PASS=30 WARN=0 ERROR=0 SKIP=0**

## Tipos de tests

| Tipo | Cantidad | Qué valida |
|------|----------|------------|
| not_null | 9 | Campos críticos sin nulos |
| unique | 8 | Claves sin duplicados |
| relationships | 4 | FK válidas entre hecho y dims |
| accepted_values | 1 | comprobante_count = 1 |
| Singular (grain) | 1 | Sin duplicados por id_detalle |
| Singular (métricas) | 1 | Cálculos correctos |

## Hallazgo corregido

Se detectaron 11 duplicados por id_comprobante + id_producto.
El grano correcto es id_detalle. Se corrigió el test singular.