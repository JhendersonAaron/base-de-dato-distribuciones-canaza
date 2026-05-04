
  create view "canaza_dw"."marts_staging"."stg_tipo_documento__dbt_tmp"
    
    
  as (
    select
    cod_tipo_doc,
    desc_tipo_doc
from raw.tipo_documento
  );