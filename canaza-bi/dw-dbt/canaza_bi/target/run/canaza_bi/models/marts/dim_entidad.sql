
  
    

  create  table "canaza_dw"."marts_marts"."dim_entidad__dbt_tmp"
  
  
    as
  
  (
    select
    row_number() over (order by e.id_entidad) as entidad_key,
    e.id_entidad,
    e.nro_documento,
    e.denominacion,
    td.desc_tipo_doc,
    case when e.cod_tipo_doc = '6' then true else false end as es_empresa
from "canaza_dw"."marts_staging"."stg_entidad" e
left join "canaza_dw"."marts_staging"."stg_tipo_documento" td
    on e.cod_tipo_doc = td.cod_tipo_doc
  );
  