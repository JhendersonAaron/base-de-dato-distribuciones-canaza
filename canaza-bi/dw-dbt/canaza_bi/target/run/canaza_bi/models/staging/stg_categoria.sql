
  create view "canaza_dw"."marts_staging"."stg_categoria__dbt_tmp"
    
    
  as (
    select
    id_categoria,
    cod_categoria,
    desc_categoria
from raw.categoria
  );