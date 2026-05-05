
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    tipo_cpe_key as unique_field,
    count(*) as n_records

from "canaza_dw"."marts"."dim_tipo_cpe"
where tipo_cpe_key is not null
group by tipo_cpe_key
having count(*) > 1



  
  
      
    ) dbt_internal_test