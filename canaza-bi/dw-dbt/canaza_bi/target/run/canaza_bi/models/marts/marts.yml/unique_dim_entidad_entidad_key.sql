
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    entidad_key as unique_field,
    count(*) as n_records

from "canaza_dw"."marts"."dim_entidad"
where entidad_key is not null
group by entidad_key
having count(*) > 1



  
  
      
    ) dbt_internal_test