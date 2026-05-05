
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id_producto
from "canaza_dw"."marts"."fact_ventas"
where id_producto is null



  
  
      
    ) dbt_internal_test