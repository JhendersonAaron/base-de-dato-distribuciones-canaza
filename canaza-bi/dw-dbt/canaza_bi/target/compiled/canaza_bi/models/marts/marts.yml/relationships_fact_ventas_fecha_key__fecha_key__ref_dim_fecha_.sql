
    
    

with child as (
    select fecha_key as from_field
    from "canaza_dw"."marts"."fact_ventas"
    where fecha_key is not null
),

parent as (
    select fecha_key as to_field
    from "canaza_dw"."marts"."dim_fecha"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


