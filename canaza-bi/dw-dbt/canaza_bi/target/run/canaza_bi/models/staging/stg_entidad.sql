
  create view "canaza_dw"."marts_staging"."stg_entidad__dbt_tmp"
    
    
  as (
    select
    id_entidad,
    cod_tipo_doc,
    nro_documento,
    denominacion,
    razon_comercial,
    direccion,
    email,
    telefono
from raw.entidad
  );