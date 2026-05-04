
  create view "canaza_dw"."marts_staging"."stg_tipo_comprobante__dbt_tmp"
    
    
  as (
    select
    cod_tipo_cpe,
    desc_tipo_cpe
from raw.tipo_comprobante
  );