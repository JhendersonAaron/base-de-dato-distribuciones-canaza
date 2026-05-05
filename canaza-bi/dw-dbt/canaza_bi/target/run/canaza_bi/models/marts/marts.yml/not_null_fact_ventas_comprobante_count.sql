
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select comprobante_count
from "canaza_dw"."marts"."fact_ventas"
where comprobante_count is null



  
  
      
    ) dbt_internal_test