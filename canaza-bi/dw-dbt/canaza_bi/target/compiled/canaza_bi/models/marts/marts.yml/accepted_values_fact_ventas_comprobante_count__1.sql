
    
    

with all_values as (

    select
        comprobante_count as value_field,
        count(*) as n_records

    from "canaza_dw"."marts"."fact_ventas"
    group by comprobante_count

)

select *
from all_values
where value_field not in (
    '1'
)


