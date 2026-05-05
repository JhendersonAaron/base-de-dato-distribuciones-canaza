
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  select *
from "canaza_dw"."marts"."fact_ventas"
where margen_bruto <> venta_bruta - costo_total
   or cantidad < 0
   or venta_bruta < 0
   or venta_neta < 0
   or costo_total < 0
  
  
      
    ) dbt_internal_test