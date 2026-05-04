
  
    

  create  table "canaza_dw"."marts_marts"."dim_fecha__dbt_tmp"
  
  
    as
  
  (
    select
    to_char(fecha_emision, 'YYYYMMDD')::int as fecha_key,
    fecha_emision::date                     as fecha,
    extract(day from fecha_emision)::int    as dia,
    to_char(fecha_emision, 'Day')           as dia_semana_desc,
    extract(month from fecha_emision)::int  as mes,
    to_char(fecha_emision, 'Month')         as mes_desc,
    extract(quarter from fecha_emision)::int as trimestre,
    extract(year from fecha_emision)::int   as anio
from (
    select distinct fecha_emision::date as fecha_emision
    from "canaza_dw"."marts_staging"."stg_comprobante"
) fechas
order by fecha_emision
  );
  