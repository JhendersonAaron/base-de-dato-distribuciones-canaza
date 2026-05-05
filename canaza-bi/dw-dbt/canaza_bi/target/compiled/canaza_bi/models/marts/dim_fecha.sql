with fechas as (
    select distinct
        fecha_emision::date as fecha
    from "canaza_dw"."staging"."stg_comprobante"
    where fecha_emision is not null
)

select
    cast(to_char(fecha, 'YYYYMMDD') as bigint)  as fecha_key,
    fecha,
    extract(day from fecha)::int                 as dia,
    extract(isodow from fecha)::int              as dia_semana_numero,
    to_char(fecha, 'TMDay')                      as dia_semana_desc,
    extract(month from fecha)::int               as mes_numero,
    to_char(fecha, 'TMMonth')                    as mes_desc,
    extract(quarter from fecha)::int             as trimestre,
    extract(year from fecha)::int                as anio
from fechas