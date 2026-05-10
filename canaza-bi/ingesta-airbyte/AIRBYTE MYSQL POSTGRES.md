# Sesión U2 S2 P1: Airbyte para réplica batch MySQL a PostgreSQL

## Caso: Distribuciones Canaza E.I.R.L.

## Objetivo

Configurar y validar una réplica inicial desde canaza_oltp en MySQL
hacia la capa raw de canaza_dw en PostgreSQL usando Airbyte local.

## Entorno de trabajo

- MySQL fuente: localhost:13306
- PostgreSQL destino: localhost:15432
- Base fuente MySQL: canaza_oltp
- Base destino PostgreSQL: canaza_dw
- Schema de aterrizaje: raw
- Airbyte local: http://localhost:8010

## Credenciales

MySQL:
- usuario: root
- contraseña: root

PostgreSQL:
- usuario: postgres
- contraseña: postgres

## Flujo

MySQL (canaza_oltp) -> Airbyte -> PostgreSQL (canaza_dw.raw)

## Tablas fuente relevantes del OLTP

- tipo_documento: cod_tipo_doc, desc_tipo_doc
- tipo_comprobante: cod_tipo_cpe, desc_tipo_cpe
- categoria: id_categoria, cod_categoria, desc_categoria
- entidad: id_entidad, cod_tipo_doc, nro_documento, denominacion
- producto: id_producto, cod_interno, descripcion, costo_compra, precio_venta
- comprobante: id_comprobante, fecha_emision, cod_tipo_cpe, id_entidad, anulado
- comprobante_detalle: id_detalle, id_comprobante, id_producto, cantidad, subtotal_sinigv

## Configuración de streams

- categoria: Full refresh | Overwrite, primary key: id_categoria
- entidad: Full refresh | Overwrite, primary key: id_entidad
- producto: Full refresh | Overwrite, primary key: id_producto
- comprobante: Full refresh | Overwrite, primary key: id_comprobante
- comprobante_detalle: Full refresh | Overwrite, primary key: id_detalle
- tipo_comprobante: Full refresh | Overwrite, primary key: cod_tipo_cpe
- tipo_documento: Full refresh | Overwrite, primary key: cod_tipo_doc

## Validación final

```sql
\dt raw.*
SELECT COUNT(*) FROM raw.entidad;
SELECT COUNT(*) FROM raw.producto;
SELECT COUNT(*) FROM raw.comprobante;
SELECT COUNT(*) FROM raw.comprobante_detalle;
```

## Evidencias a entregar

- captura de docker compose ps de oltp-mysql
- captura de docker compose ps de dw-pg
- captura de Airbyte con el source MySQL configurado
- captura de Airbyte con el destination PostgreSQL configurado
- captura del job de sincronización en estado exitoso
- captura de PostgreSQL mostrando tablas en raw