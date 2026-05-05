
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  select
    id_detalle,
    count(*) as repeticiones
from "canaza_dw"."marts"."fact_ventas"
group by id_detalle
having count(*) > 1
  
  
      
    ) dbt_internal_test