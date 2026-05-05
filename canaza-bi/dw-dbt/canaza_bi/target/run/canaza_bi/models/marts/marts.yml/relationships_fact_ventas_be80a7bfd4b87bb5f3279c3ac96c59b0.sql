
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select tipo_cpe_key as from_field
    from "canaza_dw"."marts"."fact_ventas"
    where tipo_cpe_key is not null
),

parent as (
    select tipo_cpe_key as to_field
    from "canaza_dw"."marts"."dim_tipo_cpe"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test