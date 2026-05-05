
  
    

  create  table "canaza_dw"."marts"."dim_tipo_cpe__dbt_tmp"
  
  
    as
  
  (
    select distinct
    dense_rank() over (order by cod_tipo_cpe)    as tipo_cpe_key,
    cod_tipo_cpe,
    desc_tipo_cpe
from "canaza_dw"."staging"."stg_tipo_comprobante"
  );
  