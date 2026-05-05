
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select producto_key
from "canaza_dw"."marts"."fact_ventas"
where producto_key is null



  
  
      
    ) dbt_internal_test