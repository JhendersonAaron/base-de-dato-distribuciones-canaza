
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select cod_tipo_cpe
from "canaza_dw"."marts"."dim_tipo_cpe"
where cod_tipo_cpe is null



  
  
      
    ) dbt_internal_test