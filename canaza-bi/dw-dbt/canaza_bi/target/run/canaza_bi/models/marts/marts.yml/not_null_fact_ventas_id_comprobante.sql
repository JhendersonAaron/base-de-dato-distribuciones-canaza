
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id_comprobante
from "canaza_dw"."marts"."fact_ventas"
where id_comprobante is null



  
  
      
    ) dbt_internal_test