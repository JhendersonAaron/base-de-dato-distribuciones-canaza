
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id_entidad
from "canaza_dw"."marts"."dim_entidad"
where id_entidad is null



  
  
      
    ) dbt_internal_test