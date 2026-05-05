
    
    

with child as (
    select entidad_key as from_field
    from "canaza_dw"."marts"."fact_ventas"
    where entidad_key is not null
),

parent as (
    select entidad_key as to_field
    from "canaza_dw"."marts"."dim_entidad"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


