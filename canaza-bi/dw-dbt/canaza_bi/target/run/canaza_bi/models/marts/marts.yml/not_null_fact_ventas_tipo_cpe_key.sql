
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select tipo_cpe_key
from "canaza_dw"."marts"."fact_ventas"
where tipo_cpe_key is null



  
  
      
    ) dbt_internal_test