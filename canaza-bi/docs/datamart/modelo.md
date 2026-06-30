# Modelo Dimensional

## Esquema estrella

    dim_fecha
              |
dim_entidad — fact_ventas — dim_producto
              |
         dim_tipo_cpe

## Tabla de hechos

- **fact_ventas** — grano: una fila por id_detalle
- Período: 2023–2026
- Filas: 1,523+ líneas de comprobante

## Medidas en fact_ventas

| Campo            | Descripción             |
| ---------------- | ------------------------ |
| venta_bruta      | subtotal_sinigv          |
| venta_neta       | subtotal_conigv          |
| costo_total      | costo_unit × cantidad   |
| margen_bruto     | venta_neta - costo_total |
| pct_margen_bruto | margen / venta_neta      |
